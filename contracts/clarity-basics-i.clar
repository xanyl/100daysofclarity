;; Clarity Basics I
;;Day-3 -Booleans & Read-only
;;Day-4 -Uints , Ints, & Simple Operators
;;here we are to review the basics of clarity

(define-read-only (show-true-i) 
    true
)

(define-read-only (show-false-i) 
    false
)

(define-read-only (show-true-ii) 
    (not false)
)

(define-read-only (show-false-ii) 
    (not true)
)

;;Day 4

(define-read-only (add)
    (+ u1 u2)
)

(define-read-only (sub) 
    (- 1 2)
)

(define-read-only (multiply) 
    (* u3 u4)
)

(define-read-only (divide) 
    (/ u5 u6)
)

(define-read-only (uint-to-int) 
    (to-int u4)
)

(define-read-only (int-to-uint) 
    (to-uint -2)
)

;; Day 5 - Advance Operators

(define-read-only (exponent)  
    (pow u3 u3)
)

(define-read-only (square-root) ;; return the square root of a number
    (sqrti (pow u2 u3))
)

(define-read-only (modulo) ;;return the remainder of a division
    (mod u20 u3)
)

(define-read-only (log-two) ;;return the log base 2 of a number
    (log2 u20)
)

;; Day 6 - Strings and concatenation

(define-read-only (hello-world) ;;return Hello World
    "Hello World!"
)

(define-read-only (concat-words) ;;return Hello world
    (concat "Hello" " world")
)

(define-read-only (say-hello-world-name) ;;return Hello Anil World
    (concat 
        "Hello" 
        (concat " Anil" " World")
    )
)

;;Day 7 - Logical Operators - And/or
(define-read-only (and-i) ;;return true
    (and true true)
)
(define-read-only (and-ii) ;;return false
    (and true false)
)
(define-read-only (and-iii) ;;return false
    (and false true)
)
(define-read-only (and-iv) ;;return false
    (and false false)
)
(define-read-only (or-i) ;;return true
    (or true true)
)
(define-read-only (or-ii) ;;return true
    (or true false)
)
(define-read-only (or-iii)
    (or false true)
    ;;return true
)
(define-read-only (or-iv) ;;return false
    (or false false)
)

(define-read-only (new-and) 
    (and (> u2 u1) false)
) 

(define-read-only (or-v) 
    (or (not true) true)
)
