;;Clarity Basics IV
;;Reviewing more clarity fundamentals
;;Written by Anil Kumar 

;;Day-26.5 - Let
(define-data-var counter uint u0)
(define-map counter-history uint { user:principal, count: uint })
(define-public (increase-count-begin (increase-by uint)) 
    (begin 
        ;;Assert that tx-sender is not previous counter-history user
        (asserts! (is-eq  (some tx-sender) (get user (map-get? counter-history (var-get counter)))) (err u0))

        ;;var-set counter-history
        (map-set counter-history (var-get counter) {
            user: tx-sender,
            count: (+ increase-by (get count (unwrap! (map-get? counter-history (var-get counter)) (err u1))))   
        })

        ;; var-set increase the counter
        (ok (var-set  counter (+ (var-get counter) u1)))
        ;;(ok true)
    )
)

;;using let
(define-public (increase-count-let (increase-by uint))
    (let
        (
            ;; Local variables
            (current-counter (var-get counter))
            (current-counter-history (default-to {user: tx-sender, count: u0} (map-get? counter-history current-counter)))
            (previous-counter-user (get user current-counter-history))
            (previous-count-amount (get count current-counter-history))
        )
        (begin
            ;; Assert that tx-sender is not the previous counter-history user
            (asserts! (not (is-eq tx-sender previous-counter-user)) (err u0))

            ;; Update the counter-history map with new values
            (map-set counter-history current-counter
                {
                    user: tx-sender,
                    count: (+ increase-by previous-count-amount)
                }
            )

            ;; Increment the counter variable
            (var-set counter (+ u1 current-counter))

            ;; Return the updated counter value wrapped in (ok)
            (ok (var-get counter))
        )
    )
)


;; Day-32 - Syntax 
;; Trailing (heavy parenthesis that trail)
;; Encapsulated (highights internal function)

(define-public (increase-count-trailing (increase-by uint))
    (begin 
        ;; Assert that tx-sender is not the previous counter-history user  
        (asserts! 
            (not (is-eq (some tx-sender) (get user (map-get? counter-history (var-get counter))))) 
            (err u0)
        )
        (ok 
            (var-set  counter  
                 (+ (var-get counter) u1)))
    )
)
(define-public (increase-count-encapsulation (increase-by uint))
    (begin 
        ;; Assert that tx-sender is not the previous counter-history user  
        (asserts! 
            (not (is-eq 
                    (some tx-sender) 
                    (get user (map-get? counter-history (var-get counter))
                    )
            )) 
            (err u0)
        )
        (ok true) 
    )
)


;;Day 33 - STX Transfer
;;@desc - This function allows a user to transfer stx to another address
;;@param - to-address (principal) - the address to transfer stx to 
;;@param - amount (uint) - the amount of stx to transfer
(define-public (transfer-stx (to-address principal) (amount uint))
    (stx-transfer? amount tx-sender to-address)  
)
;;sending stx to multiple addresses
(define-public (send-stx-double) 
    (begin  
        (unwrap! (stx-transfer? u1000000000 tx-sender  'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5) (err u0))
        (unwrap! (stx-transfer? u1000000000 tx-sender  'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG) (err u1))
        (ok true)
    )
)

;;Day 34 : Stx-get-balance and Burn

;;Get Balance
;;Stx burn

(define-read-only (balance-of) 
    (stx-get-balance tx-sender)
)

(define-public (send-stx-balance (to-address principal))
    (stx-transfer? (balance-of) tx-sender to-address)  
)

(define-public (burn-some (amount uint)) 
    (stx-burn? amount tx-sender)
)

(define-public (burn-half-of-balance) 
    (stx-burn? (/ (stx-get-balance tx-sender) u2) tx-sender)
)

;;Day 35 : block-height

(define-read-only (read-current-height) 
    block-height
)

(define-constant day-in-blocks u144)
(define-read-only (has-a-day-passed) 
    (if (> block-height day-in-blocks)
        true
        false
    )
)

(define-read-only (has-a-week-passed) 
    (if (> block-height (* day-in-blocks u7) )
        true
        false
    )
)

(define-constant admin tx-sender)

(define-constant deploy-height block-height)

;;Day 36: As-contract 
;;Principal to contract

(define-public (send-to-contract-literal) 
    (stx-transfer? u100000 tx-sender 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.clarity-basics-iv)
)
(define-public (send-to-contract-context) 
    (stx-transfer? u100000 tx-sender (as-contract tx-sender))
)

;;Contract to principal
(define-public (send-to-principal-literal)
    (as-contract (stx-transfer? u100000 tx-sender 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM))
)

(define-public (send-to-contract)
    (stx-transfer? u100000 (as-contract tx-sender) tx-sender)
)