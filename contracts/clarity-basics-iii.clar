;;clarity-basics-iii

(define-read-only (list-bool)
    (list true false true)
)

(define-read-only (list-nums) 
    (list u1 u2 u3)
)
(define-read-only (list-strings)
    (list "Hello" "World")
)
(define-read-only (list-principal)
    (list tx-sender 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) 
)

(define-data-var num-list (list 10 uint) 
    (list u1 u2 u3 u4)
)
(define-data-var principal-list (list 5 principal) (list tx-sender 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM))

;;Element-at - returns the element at the specified index in the list
(define-read-only (element-at-num-list (index uint))
    (element-at (var-get num-list) index)
)

(define-read-only (element-at-principal-list (index uint)) 
    (element-at (var-get principal-list) index)
)

;;Index-Of (value -> index)
(define-read-only (index-of-num-list (value uint)) 
    (index-of (var-get num-list) value)
)

(define-read-only (index-of-principal-list (value principal))  
    (index-of (var-get principal-list) value)
)


;;Day-21 list Cont. and Intro to Unwrapping
 (define-data-var list-day-21 (list 5 uint) (list u1 u2 u3 u4 u5))
 (define-read-only (list-length) 
    (len (var-get list-day-21))
 )

 (define-public (add-to-list (new-num uint)) 
    (ok (var-set list-day-21
        (as-max-len? (var-get list-day-21) u5))
    ))
 )