
;; clarity-basics-ii
;; 

;;Day-8 Optionals: Some & None
(define-read-only (some-i) ;;return 1
    (some "Hello World")
)

(define-read-only (none-i) 
    none
)

(define-read-only (params (num uint) (string (string-ascii 48)) (boolean bool)) 
    (concat "Hello" string)
)

(define-read-only (params-optional (num (optional uint)) (string (optional (string-ascii 48))) (boolean (optional bool)))
    num
)

;;  Day 9 - Optionals Pt.II

(define-read-only (is-some-example (num (optional uint))) 
    (is-some num)
)


(define-read-only (is-none-example (num  (optional uint)))
    (is-none num)
)

(define-read-only (params-optional-and (num  (optional uint)) (string (optional (string-ascii 48))) (boolean (optional bool)))
    (and 
     (is-some num)
     (is-some string)
     (is-some boolean)
     )
)

;; Day10 : constant and intro to variables


(define-constant fav-num u10) ;;constant
(define-constant fav-string "Hi there") ;;
(define-data-var fav-num-var uint u10) ;;variable
(define-data-var your-name (string-ascii 28) " Anil") ;;variable

(define-read-only  (show-constant) 
    fav-string
)

(define-read-only (show-constant-double) 
    (* fav-num fav-num)
)

 (define-read-only (show-fav-num-var) 
    (var-get fav-num-var)
 )

 (define-read-only (show-fav-num-var-double)
    (* (var-get fav-num-var) (var-get fav-num-var))
 )

 (define-read-only (show-anil)
 ;;hello to anil
 (concat "Hello" (var-get your-name))
 )

 ;;Day-11 Public Functions and Responses

(define-read-only (res-example) 
    (ok u10)
)

(define-public (change-name (new-name (string-ascii 28))) 
    (ok (var-set your-name new-name))
    
)
(define-public (change-fav-num (new-num uint)) 
    (ok (var-set fav-num-var new-num))
)

;;Day-12 - Tuples and Merging 

(define-read-only (read-tuple-i) 
    {
        user-principal: 'ST3AM1A56AK2C1XAFJ4115ZSV26EB49BVQ10MGCS0,
        user-name: "Anil",
        user-balance: u10
        
    }
)

(define-public (write-tuple-i (new-user-principal principal) (new-user-name (string-ascii 28)) (new-user-balance uint)) 
    (ok {
        user-principal: new-user-principal,
        user-name: new-user-name,
        user-balance: new-user-balance

    }
    )
)

;;Merge function
(define-data-var original {user-principal: principal, user-name: (string-ascii 24), user-balance: uint} 
  {
        user-principal: 'ST3AM1A56AK2C1XAFJ4115ZSV26EB49BVQ10MGCS0,
        user-name: "aneel",
        user-balance: u10

    }  
)

(define-read-only (read-original) 
    (var-get original)
)

(define-public (merge-principal (new-user-principal principal))
    (ok (merge 
    (var-get original)
     {user-principal: new-user-principal}
     ))
)

(define-public (merge-user-name (new-user-name (string-ascii 24))) 
    (ok (merge
    (var-get original)
    {user-name: new-user-name}
    ))
)

;;Day 13: Tx-sender  & Is-Eq

(define-read-only (show-tx-sender) 
    tx-sender
)

(define-constant admin 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

(define-read-only (is_admin) 
    (is-eq tx-sender admin)
)

;;Day 14: Conditional Statements (asserts)

(define-read-only (show-asserts (num uint))
    (ok (asserts! (> num u10) (err u1)))
 )

 (define-constant err-too-large 
    (err u1)
 )
(define-constant  err-too-small (err u2))
 (define-constant err-not-auth 
    (err u3)
 )

 (define-constant admin-one tx-sender)

 (define-read-only (check-admin) 
    (ok (asserts! (is-eq tx-sender admin-one) err-not-auth))
 )

 ;;Day 15 - Begin 
 ;;  Set and say hello 
 ;; Counter By even


(define-data-var hello-name (string-ascii 48) "Alice")
(define-constant err-empty-name "Empty Name")

;; @desc and this funtion allows a user to provide a name which , if different , change
;;a name variable and return "hello new name"

;;@param - new-name (string-ascii 48) that represents the new name
(define-public (set-and-say-hello (new-name (string-ascii 48))) 
    (begin  
        ;;Assert that name is not empty
        (asserts! (not (is-eq "" new-name)) (err u1))
        ;;Assert that name is not equal to current name
        (asserts! (not (is-eq (var-get hello-name) new-name)) (err u2))
        ;;Var-set new Name
        (var-set hello-name new-name)
        ;;say hello new name
        (ok (concat "Hello " (var-get hello-name))) 
    
    )
)

(define-read-only (read-hello-name) 
    (var-get hello-name)
)

(define-data-var counter uint u0)
(define-read-only (read-counter) 
    (var-get counter)
)

;;@desc - this function increments the counter by even amount
;;@param- add-num: uint that the user submits to add to the counter

(define-public (increment-counter-ever (add-num uint)) 
    (begin 
        ;;Assert that add-num is even
        (asserts! (is-eq u0 (mod add-num u2)) (err u3))
        ;;Increment counter
        (var-set counter (+ (var-get counter) add-num))
        ;;return ok
        (ok (var-get counter))
     )
)