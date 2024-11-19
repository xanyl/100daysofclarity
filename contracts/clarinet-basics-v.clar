;; Clarity Basics V
;; Reviewing more clarity fundamentals
;; Written by Anil Kumar Tiwari

;;Day 45 - Private functions
(define-read-only (say-hello-read) 
    (say-hello-world)
)

(define-public (say-hello-public) 
    (ok (say-hello-world))
)

(define-private (say-hello-world) 
    "Hello World"
)

;;Day 46 - Filter   

(define-constant test-list (list u1 u2 u3 u4 u5 u6  u7 u8 u9 u10))

(define-read-only (test-filter-remove-smaller-than-five) 
    (filter filter-smaller-than-5 test-list)
)

(define-private (filter-smaller-than-5 (item uint)) 
    (< item u5)
)

(define-read-only (test-filter-remove-evens) 
    (filter remove-evens test-list)
)

(define-private (remove-evens (item uint)) 
    (not (is-eq (mod item u2) u0))
)

;; Day 47 - Map
(define-constant test-list-string (list "one" "two" "three" "four" "five"))
(define-read-only (test-map-increase-by-one) 
    (map increase-by-one test-list)
)

(define-private (increase-by-one (item uint)) 
    (+ item u1)
)

(define-read-only (test-map-square) 
    (map square test-list)
)

(define-private (square (item uint)) 
    (* item item)
)

;; for string
(define-read-only (test-map-string-length)
    (map string-length test-list-string)
)

(define-private (string-length (item (string-ascii 24)))
    (len item)
)

;;Day 48 - Map Revisited
(define-constant test-list-principals (list 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG 'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC 'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND))
(define-constant test-list-tuples (list {user: "Alice", balance:u10 } {user: "Bob", balance:u20 } {user: "Charlie", balance:u30 } {user: "Dave", balance:u40 }))
(define-public (test-send-stx-multiple)
    (ok (map send-stx-multiple test-list-principals))
)
(define-private (send-stx-multiple (item principal)) 
    (stx-transfer? u100000000 tx-sender item)
) 

(define-read-only (test-get-users) 
    (map get-users test-list-tuples)
)
(define-read-only (test-get-balance) 
    (map get-balance test-list-tuples)
)
(define-private (get-users (item {user: (string-ascii 24), balance: uint}))
     (get user  item)
)
(define-private (get-balance (item {user: (string-ascii 24), balance: uint}))
    (get balance item )
)
 

;; Day 49 - Fold

(define-constant test-list-ones (list u1 u1 u1 u1 u1 ))
(define-constant test-list-twos (list u1 u2 u3 u4 u5 ))
(define-constant test-alphabet (list "a" "b" "c" "d" "e"))
(define-read-only (fold-add-start-0) 
    (fold + test-list-ones u0)
)
(define-read-only (fold-add-start-10) 
    (fold + test-list-ones u10)
)

(define-read-only (fold-multiple-start-1) 
    (fold * test-list-twos u1)
)

(define-read-only (fold-multiple-start-2) 
    (fold * test-list-twos u2)
)

(define-read-only (fold-characters) 
    (fold concat-string test-alphabet "")
)

(define-private (concat-string (a (string-ascii 10)) (b (string-ascii 10))) 
    (unwrap-panic (as-max-len? (concat b a) u10))
)

;; Day 50 - Contract-call?

(define-read-only (call-basics-i-multiply) 
    (contract-call? .clarity-basics-i multiply)
)

(define-read-only (call-basics-i-hello-world)
    (contract-call? .clarity-basics-i hello-world)
)

(define-public (call-basics-ii-hello-world (name (string-ascii 48))) 
     (contract-call? .clarity-basics-ii set-and-say-hello name)
)

(define-public (call-basics-iii-set-second-map (new-username (string-ascii 24)) (new-balance uint)) 
    (begin 
        (try! (contract-call? .clarity-basics-ii set-and-say-hello new-username))
        (contract-call? .clarity-basics-iii set-second-map new-username new-balance none)
    )
    
)