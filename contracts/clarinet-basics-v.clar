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