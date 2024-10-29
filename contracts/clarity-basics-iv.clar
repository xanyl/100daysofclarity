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
