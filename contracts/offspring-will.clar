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
(define-constant early-withdrawal-fee u2)

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Parents Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Offspring Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Admin Functions ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


