;; Offspring Will
;; Smart contrac that allows parents to create and fund wallets unlocakble only by 18th birthday
;; Written by Anil K Tiwari

;;Offspring wallet
;;This is our main map that is created and funded by parents and only unlockkable by assigned offspring(principal)
;;Principal -> {offspring-principal: principal, offspring-dob: uint, balance: uint, is-unlocked: bool}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Cons, Vars & Maps ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Parents Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Offspring Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Admin Functions ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


