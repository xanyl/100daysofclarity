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
 (define-data-var list-day-21 (list 5 uint) (list u1 u2 u3 u5))
 (define-read-only (list-length) 
    (len (var-get list-day-21))
 )

 (define-public (add-to-list (new-num uint)) 
    (ok (var-set list-day-21
        (unwrap! 
            (as-max-len? (append (var-get list-day-21) new-num) u5)
        (err u0)) 
    ))
 )

 ;;Day - 22 - Unwrapping

 (define-public (unwrap-example (new-num uint)) 
    (ok (var-set list-day-21
        (unwrap! 
            (as-max-len? (append (var-get list-day-21) new-num) u5)
        (err "Error list at max-length")) 
    ))
 )

  (define-public (unwrap-panic-example (new-num uint)) 
    (ok (var-set list-day-21
        (unwrap-panic (as-max-len? (append (var-get list-day-21) new-num) u5)) 
    ))
 )

 (define-public (unwrap-err-example (input (response uint uint)))
    (ok (unwrap-err! input (err u10)))
 )

 (define-public (try-example (input (response uint uint))) 
    (ok (try! input))
 )

 ;;Unwrap! : optionals and response
 ;;Unwrap-err! : response
 ;;Unwrap-panic : optionals and response
 ;;Unwrap-err-panic! : optionals and response
 ;;Try! : optionals and response

;; Day 23 - Default-to / Get

(define-constant example-tuple {
    example-bool: true,
    example-num: none,
    example-string:none,
    example-principal: tx-sender
})

(define-read-only (read-example-tuple) 
    example-tuple
)

(define-read-only (read-example-bool) 
    (get example-bool example-tuple)
)

(define-read-only (read-example-num) 
    (get example-num example-tuple)
)
;;provide default value to the number 
(define-read-only (read-example-num-default)
    (default-to  u10 (get example-num example-tuple))
)

(define-read-only (read-example-string) 
    (default-to "anil" (get example-string example-tuple))
)
(define-read-only (read-example-principal)
    (get example-principal example-tuple)
)

(define-public (get-score (user {name: (string-ascii 32), score: (optional uint)}))
  (ok (default-to u50 (get score user)))
)

;; Day-24 - Conditionals continued - Match and If

(define-read-only (if-example (test-bool bool)) 
    (if test-bool
        ;;Evaluates to true
        "evaluates to true"
        ;;evaluates to false
        "evaluates to false"
     )
)

(define-read-only (if-example-num (num uint)) 
    (if (and (> num u0) (<= num u10))
    "greater than 0 and less than 10"
    "other"
    )
)

;;match example
(define-read-only (match-optional-some)
    (match (some u1) 
    ;;some value / threre was some optional
        match-value (+ u1 match-value) 
        ;;None value / there was no optional
        u0
    )
) 

(define-read-only (match-optional (test-value (optional uint))) 
    (match test-value
        match-value (+ u2 match-value)
        u0
    )
)


(define-read-only (match-response (test-value (response uint uint))) 
    (match test-value 
        ok-value ok-value
        err-value u0
    )
)

;;Day-25 -Maps
(define-map map-first-example principal (string-ascii 24) )

(define-public (set-first-map (username (string-ascii 24))) 
    (ok (map-set map-first-example tx-sender username))
)

(define-read-only (read-map (key principal)) 
    (map-get? map-first-example key)
)

;;map with tuple
(define-map second-map principal {
    username: (string-ascii 24),
    balance: uint,
    referral: (optional principal)
})

(define-public (set-second-map (new-username (string-ascii 24)) (new-balance uint) (new-referral (optional principal))) 
    (ok (map-set second-map tx-sender {
        username: new-username,
        balance: new-balance,
        referral: new-referral
    }))
)

(define-read-only (read-second-map (key principal)) 
    (map-get? second-map key)
)

;; Day-26 - Maps Cont.
(define-map insert-first-example principal (string-ascii 24) )

(define-public (insert-first-map (username (string-ascii 24))) 
    (ok (map-insert map-first-example tx-sender username))
)

(define-map third-map { user:principal,cohort:uint }
    {
    username: (string-ascii 24),
    balance: uint,
    referral: (optional principal)
}
)
;;Important : create and update, delete and add
(define-public (set-third-map (new-username (string-ascii 24)) (new-balance uint) (new-referral (optional principal)))
   (ok (map-set third-map { user:tx-sender, cohort:u1 } {
        username: new-username,
        balance: new-balance,
        referral: new-referral
    }))
)

(define-public (delete-third-map)
    (ok (map-delete third-map { user:tx-sender, cohort:u1 }))
)

(define-read-only (read-third-map) 
    (map-get? third-map {user:tx-sender, cohort:u1})
)

;;