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
(define-constant min-create-wallet-fee u5000000)

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
        (test true)
    ) 
    ;; Assert that map-get? offspring-wallet is-none

    ;; Assert that new-offspring-principal is at least higher than block-height - 18 Years of Blocks

    ;; Map-set offspring-wallet



    ;;Body function here
    (ok test)
    )
)

;; Fund Wallet 
;;@desc - allows anyone to fund an existing wallet
;;@param - parent: principal - parent principal, amount: uint - amount to fund, 

(define-public (add-funds (parent principal) (amount uint))
    (let
        (
        ;; Local vars here
        (test true)
        )
        ;;func body here
        (ok test)
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Offspring Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Admin Functions ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


