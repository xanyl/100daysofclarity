;; NFT simple
;; The most basic NFT contract
;; Written by Anil Kumar Tiwari

;;Day - 55

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Cons, Vars & Maps ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define NFT
(define-non-fungible-token simple-nft uint)

;; Adhere to SIP-09
(impl-trait .sip-09.nft-trait)

;; Collection Limit
(define-constant collection-limit u100)

;; Collection Index
(define-data-var collection-index uint u1)

;; Root URI
(define-constant collection-root-uri "ipfs://ipfs/QmXhJzF3A7Whh6cW3m11m81a6q3zp3vZH36YwL18Lu3a8/" )

;; NFT price
(define-constant simple-nft-price u10000000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; SIP-09 Functions  ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get Last Token ID
(define-public (get-last-token-id) 
    (ok (var-get collection-index))
)

;; Get token URI
(define-public (get-token-uri (id uint)) 
    (ok 
        (some (concat 
            collection-root-uri 
            (concat 
                (int-to-ascii id)
                ".json" 
            )
        ))
    )
)

;;Get Token Ownet
(define-public (get-owner (id uint)) 
    (ok (nft-get-owner? simple-nft id))
)

;; Transfer
(define-public (transfer (id uint) (sender principal) (recipient principal))
    (begin 
        (asserts! (is-eq tx-sender sender) (err u1))
         (nft-transfer? simple-nft id sender recipient)
    
     )
)

        ;; ;; Last Token ID
        ;; (get-last-token-id () (response uint uint)) 
        ;; ;; URI metadata
        ;; (get-token-uri (uint) (response (optional (string-ascii 256)) uint))
        ;; ;;Get token owner
        ;; (get-token-owner (uint) (response (optional principal) uint))
        ;; ;; Transfer 
        ;; (transfer (uint principal principal) (response bool uint))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Core Functions ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Core Mint Functions
;;@desc - core function used for minting one nft 
(define-public (mint) 
    (let (
        (current-index (var-get collection-index))
        (next-index (+ current-index u1))
    ) 
    ;;Assert that current-index is lower than collection-limit
    (asserts! (< current-index collection-limit) (err "err-minted-out"))

    ;; Charge tx-sender for Simple-NFT
    (unwrap! (stx-transfer? simple-nft-price tx-sender (as-contract tx-sender)) (err "err-stx-transfer"))

    ;;Mint Simple-NFT 
    (unwrap! (nft-mint? simple-nft current-index tx-sender) (err "err-miniting"))

    ;; Var-set 
    (ok (var-set collection-index next-index))

    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Helper Functions ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;