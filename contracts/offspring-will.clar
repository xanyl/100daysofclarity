;; Offspring Will
;; Smart contrac that allows parents to create and fund wallets unlocakble only by 18th birthday
;; Written by Anil K Tiwari

;;Offspring wallet
;;This is our main map that is created and funded by parents and only unlockkable by assigned offspring(principal)
;;Principal -> {offspring-principal: principal, offspring-dob: uint, balance: uint, is-unlocked: bool}

;;1. Create wallet
;;2. Add funds to wallet
;;3. Claim wallet
    ;;A. Offspring
    ;;B. Parent/Admin



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Cons, Vars & Maps ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Deployer
(define-constant deployer tx-sender)

;;Contract
(define-constant contract (as-contract tx-sender))


;; Create Offspring wallet fee
(define-constant create-wallet-fee u5000000)


;; Add Offspring wallet Funds fee
(define-constant add-wallet-funds-fee u2000000)

;; Min add  Offspring wallet fee
(define-constant min-add-wallet-amount u5000000)

;;Early Withdrawal fee(10%)
(define-constant early-withdrawal-fee u10)

;; Normal Withdrawal fee(2%)
(define-constant normal-withdrawal-fee u2)

;;18 year in block height
(define-constant eighteen-years-in-block-height (* u18 (* u365 u144)))

;;Admin list of principals
(define-data-var admins (list 10 principal) (list tx-sender))

;; Totals fees earned
(define-data-var total-fees-earned uint u0)

;;Offspring wallet
(define-map offspring-wallet principal {
    offspring-principal: principal,
    offspring-dob: uint,
    balance: uint,
})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Read Functions ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get offspring wallet
(define-read-only (get-offspring-wallet (parent principal))
    (map-get? offspring-wallet parent)
)

;;Get Offspring Principal
(define-read-only (get-offspring-wallet-principal (parent principal))
    (get offspring-principal (map-get? offspring-wallet parent))
)



;; Get Offspring wallet balance
;; (define-read-only (get-offspring-wallet-balance-i (parent principal))
;;     (get balance (map-get? offspring-wallet parent))
;; )

(define-read-only (get-offspring-wallet-balance (parent principal))
    (default-to u0  (get balance (map-get? offspring-wallet parent)))
)


;;Get Offspring DOB
(define-read-only (get-offspring-wallet-dob (parent principal))
    (get offspring-dob (map-get? offspring-wallet parent))
)

;; Get offspring wallet unlock Height
(define-read-only (get-offspring-wallet-unlock-height (parent principal)) 
    (let 
    (

        ;;local vars
        (offspring-dob (unwrap! (get-offspring-wallet-dob parent) (err u1))) 
    )
    
    ;;function body
   (ok (+ offspring-dob eighteen-years-in-block-height))
    )
) 
;; Get Earned Fees
(define-read-only (get-earned-fees) 
    (var-get total-fees-earned)
    )

;; Get STX In Contract
(define-read-only (get-contract-stx-balance)
    (stx-get-balance contract)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Parents Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Create wallet
;;@desc - creates new offspring wallet with new parent (no initial deposits)
;;@param - parent: principal - parent principal
;;@param - new-offspring-principal: principal - offspring principal
;;@param - new-offspring-dob: uint - offspring dob

(define-public (create-wallet (new-offspring-principal principal) (new-offspring-dob uint)) 
    (let (
            (current-total-fees (var-get total-fees-earned))
            (new-total-fees (+ current-total-fees create-wallet-fee))
            ;; (test true)
        ) 
    ;; Assert that map-get? offspring-wallet is-none
    (asserts! (is-none (map-get? offspring-wallet tx-sender)) (err "err-wallet-aready-exists"))

    ;; Assert that new-offspring-principal is at least higher than block-height - 18 Years of Blocks
    ;; (asserts! (> new-offspring-dob (- block-height eighteen-years-in-block-height)) (err "err-past-18-years"))
    
    ;; Assert that new-offspring principal is NOT an admin or the tx-sender
    (asserts! (or (not (is-eq tx-sender new-offspring-principal)) (is-none (index-of? (var-get admins) new-offspring-principal))) (err "err-invalid-offspring-principal"))

    ;; Pay  create-wallet-fee in stx (5stx)
    (unwrap! (stx-transfer? create-wallet-fee tx-sender deployer ) (err "err-stx-transfer"))

    ;; Var-set total-fees
    (var-set total-fees-earned new-total-fees )
    ;; Map-set offspring-wallet
    (ok (map-set offspring-wallet tx-sender {
        offspring-principal: new-offspring-principal,
        offspring-dob: new-offspring-dob,
        balance: u0
    })) 

    ;; ;;Body function here
    ;; (ok true)
    )
)

;; Fund Wallet 
;;@desc - allows anyone to fund an existing wallet
;;@param - parent: principal - parent principal, amount: uint - amount to fund, 

(define-public (fund-wallet (parent principal) (amount uint))
    (let
        (
        ;; Local vars here
        (current-offspring-wallet (unwrap! (map-get? offspring-wallet parent) (err "err-no-offspring-wallet")) )
        (current-offspring-wallet-balance  ( get balance current-offspring-wallet))
        (new-offspring-wallet-balance (+ current-offspring-wallet-balance (- amount add-wallet-funds-fee)))
        (current-total-fees (var-get total-fees-earned))
        (new-total-fees (+ current-total-fees min-add-wallet-amount))
        )
       

        ;; Assert that amount is greater than min-add-wallet-amount (5 STX)
        (asserts! (> amount min-add-wallet-amount) (err "err-amount-too-low"))

        ;; Send stx (amount - fee) to contract
        (unwrap! (stx-transfer? (- amount add-wallet-funds-fee) tx-sender contract ) (err "err-sending-stx-to-contract"))

        ;; Send stx (fee) to deployer
        (unwrap! (stx-transfer? add-wallet-funds-fee tx-sender deployer ) (err "err-sending-stx-to-deployer"))

        ;; Var-set total-fees-earned 
        (var-set total-fees-earned new-total-fees)

        ;; Map-set current offspring wallet by merging with old balance + amount
        (ok (map-set offspring-wallet parent 
        (merge 
            current-offspring-wallet 
                {
                    balance: new-offspring-wallet-balance
                }
        )
        ))
       
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Offspring Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Claim Wallet
;;@desc - allows an offspring to claim their wallet once and once only
;;@param - parent: principal - parent principal

(define-public (claim-wallet (parent principal))
    (let
        (
            (test true)
            (current-offspring-wallet (unwrap! (map-get? offspring-wallet parent) (err "err-no-offspring-wallet")) )
            (current-offspring (get offspring-principal current-offspring-wallet))
            (current-dob (get offspring-dob current-offspring-wallet))
            (current-balance (get balance current-offspring-wallet))
            (current-withdrawal-fee (/ (* current-balance u2) u100))
            (current-total-fees (var-get total-fees-earned))
            (new-total-fees ( + current-total-fees current-withdrawal-fee))

        )
    ;; Assert that tx-sender is offspring principal
    (asserts! (is-eq tx-sender current-offspring) (err "err-not-offspring"))

    ;; Assert that block-height is 18 years in block later than offspring dob
    (asserts! (> block-height (+ current-dob eighteen-years-in-block-height)) (err "err-not-18-years-old"))
    ;; Send stx (amount - withdrawal fee) to offspring
    (unwrap! (as-contract (stx-transfer? (- current-balance current-withdrawal-fee) tx-sender current-offspring ) ) (err "err-sending-stx-transfer"))
    ;; Send stx withdrawal to deployer
    (unwrap! (as-contract (stx-transfer?  current-withdrawal-fee tx-sender deployer )) (err "err-sending-withdrawal-fee-to-deployer"))
    ;; Delete offspring wallet map
    (map-delete offspring-wallet parent)
    ;; Update total-fees-earned
    (ok (var-set total-fees-earned new-total-fees))

       
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Emergency Withdrawal ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Emergency claim
;;@desc - allows an admin or parent to withdraw all stx (minus emergency withdrawal fee) back to parent and remove offspring wallet
;;@param - parent: principal - parent principal

(define-public (emergency-claim (parent principal))
    (let
        (
        (test true)
        (current-offspring-wallet (unwrap! (map-get? offspring-wallet parent) (err "err-no-offspring-wallet")) )
        (current-offspring-dob (get offspring-dob current-offspring-wallet))
        (current-balance (get balance current-offspring-wallet))
        (current-withdrawal-fee (/ (* current-balance early-withdrawal-fee) u100))
        (current-total-fees (var-get total-fees-earned))
        (new-total-fees ( + current-total-fees current-withdrawal-fee))
        )
        ;; Assert that tx-sender is either parent or one of the admins
        (asserts! (or (is-eq tx-sender parent) (is-some (index-of? (var-get admins) tx-sender))) (err "err-unauthorized"))
        ;; Assert that block-height is 18 years from the DOB
        (asserts! (> block-height (+ current-offspring-dob eighteen-years-in-block-height)) (err "err-too-late"))
       
        ;; Send stx (amount - withdrawal fee) to offspring   
        (unwrap! (as-contract (stx-transfer? (- current-balance current-withdrawal-fee) tx-sender parent ) ) (err "err-sending-stx-transfer"))
        ;; Send stx emergency withdrawal fee to deployer
        (unwrap! (as-contract (stx-transfer?  current-withdrawal-fee tx-sender deployer )) (err "err-sending-withdrawal-fee-to-deployer"))
       
        ;;Delete offspring-wallet map
        (map-delete offspring-wallet parent)
        ;; Update total-fees-earned
        (ok (var-set total-fees-earned new-total-fees))
        
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Admin Functions ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add admin
;;@desc - allows an admin to add another admin
;;@param - new-admin: principal - new admin principal
(define-public (add-admin (new-admin principal))
    (let 
    (
        (current-admins (var-get admins))
    )
    ;; Assert that tx-sender is an current admin
    (asserts! (is-some (index-of current-admins tx-sender)) (err "not-authorized"))
    ;; Assert that new-admin does not exist in the list of admins
    (asserts! (is-some (index-of current-admins new-admin)) (err "err-admin-already-exists"))
    
    ;; Append new-admin to list of admins
    (ok (var-set admins
     (unwrap! (as-max-len? (append current-admins new-admin)
     u10) (err "err-admin-list-overflow"))))
   
    )
)

;;Remove admin
;;@desc - allows an admin to remove an admin
;;@param - removed-admin: principal - admin principal
(define-public (remove-admin (removed-admin principal))
    (let 
        (
           
        )
        ;; Assert that tx-sender is an current admin
       
        ;; Filter remove removed-admin

        (ok true)
    )
)