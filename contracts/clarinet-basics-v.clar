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

;;Day-52 - Native NFTs Functions
;; (impl-trait .sip-09.nft-trait)

(define-non-fungible-token nft-test uint)
(define-public (test-mint) 
    (nft-mint? nft-test u0 tx-sender)
)

(define-read-only (test-get-owner (id uint)) 
    (nft-get-owner? nft-test id)
)

(define-public (test-burn (id uint) (sender principal))
    (nft-burn? nft-test id sender)
)

(define-public (test-nft-transfer (id uint) (sender principal) (recipient principal)) 
    (nft-transfer? nft-test id sender recipient)
)

;; Day-53 - Basic Minting Logic

(define-non-fungible-token nft-test-2 uint)
(define-data-var nft-index uint u1)
(define-constant nft-limit u6)
(define-constant nft-price u10000000)
(define-constant nft-admin tx-sender)

(define-public (limited-mint (metadata-url (string-ascii 256))) 
    (let (
        ;; Local Vars go here
        (current-index (var-get nft-index))
        (next-index (+ current-index u1))
    ) 

        ;; Assert that index < limit
        (asserts! (< current-index nft-limit) (err "nft limit reached"))

        ;; Charge 10 stx
        (unwrap! (stx-transfer? nft-price tx-sender nft-admin ) (err "stx-transfer-err"))

        ;;Mint nft to tx-sender
        (unwrap! (nft-mint? nft-test-2 current-index tx-sender) (err "nft mint failed"))
        ;;Upadate and store metadata url
        (map-set nft-metadata current-index metadata-url)
        ;; Var-set nft-index by increasing it by 1
        (ok (var-set nft-index next-index)) 
    )
)

;; Day 54 - NFT Metadata Logic
(define-constant static-url "https://ipfs.io/ipfs/QmYXZ8Ef3Q86aN12Q1aMZehGXk7Qau7J378MZxw4rZ2F8")
(define-map nft-metadata uint  (string-ascii 256))
(define-public (get-token-uri-test-1 (id uint)) 
    (ok static-url)
)
;; (define-public (get-token-uri-test-2 (id uint)) 
;;     (ok (concat static-url (concat (uint-to-ascii id) ".json")))
;; )

(define-public (get-token-uri (id uint)) 
   (ok (map-get? nft-metadata id))
)