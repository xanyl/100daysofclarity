;; NFT advance
;; An advance NFT contract that has all modern functions required for a high-quality NFT project
;; Written by Anil Kumar Tiwari

;;Day - 60

;;Unique properties and features

;;1. Implements non-custodial marketplace functions
;;2. Implements a whitelist minting system
;;3. Options to mint 1, 2 or 5
;;4. Multiple admin systems 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Cons, Vars & Maps ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define NFT
(define-non-fungible-token advance-nft uint)

;; Adhere to SIP-09
;;(impl-trait .sip-09.nft-trait)

;; Collection Limit
(define-constant collection-limit u10)

;; Collection Index
(define-data-var collection-index uint u1)

;; Admin deployer
 (define-constant deployer  tx-sender)

;; Root URI
(define-constant collection-root-uri "ipfs://ipfs/QmXhJzF3A7Whh6cW3m11m81a6q3zp3vZH36YwL18Lu3a8/" )

;; NFT price
(define-constant advance-nft-price u10000000)

;; Marketplace map
(define-map market uint {
    price: uint,
    owner: principal
})

;;Admin list
(define-data-var admins (list 10 principal) (list tx-sender))

;; Whitelist map
(define-map whitelist-map principal uint)

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
    (ok (nft-get-owner? advance-nft id))
)

;; Transfer
(define-public (transfer (id uint) (sender principal) (recipient principal))
    (begin 
        (asserts! (is-eq tx-sender sender) (err u1))
        (if (is-some (map-get?  market id))
          (map-delete market id)
          false
        )
         (nft-transfer? advance-nft id sender recipient)
    
     )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Non-Custodial Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; List in ustx
(define-public (list-in-ustx (item uint) (owner principal)) 
    (let (
        (nft-owner (unwrap! (nft-get-owner? advance-nft item) (err "err-nft-doesnot-exists")))
        
    )

    ;;Assert that tx-sender is the current owner
    (asserts! (is-eq nft-owner owner) (err "err-not-owner"))

    ;; Map-set and update market
    (ok (map-set market item {price: advance-nft-price, owner: owner}))

    )
)

;; Unlist in ustx

(define-public (unlist-in-ustx (item uint)) 
    (let (
        (current-listing (unwrap! (map-get? market item) (err "err-listing-not-found")))
        (current-price (get price current-listing))
        (current-owner (get owner current-listing))

    )
        ;;Assert that tx-sender is the current owner
         (asserts! (is-eq tx-sender current-owner) (err "err-not-owner"))

        ;; Delete listing
        (ok (map-delete market item))

    )
)

;; Buy in ustx
(define-public (buy-in-ustx (item uint)) 
    (let (

        (current-listing (unwrap! (map-get? market item) (err "err-listing-not-found")))
        (current-price (get price current-listing))
        (current-owner (get owner current-listing))
    )
        ;;send stx to start purchases
        (unwrap! (stx-transfer? current-price  tx-sender current-owner) (err "err-stx-transfer"))

        ;; Send NFT to Purchaser
        (unwrap! (nft-transfer? advance-nft item current-owner tx-sender) (err "err-nft-transfer"))

        ;; Delete listing
        (ok (map-delete market item))
    )
)

;; Check listing
(define-read-only (check-listing (item uint)) 
    (map-get? market item)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Mint Functions ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mint 1
(define-public (mint-one) 
    (let (
        (current-index (var-get collection-index))
        (next-index (+ current-index u1))
        (whitelist-mints (unwrap! (map-get? whitelist-map tx-sender) (err "err-not-whitelisted")))

    )
        ;; Assert that collection is not minted out (Current-index < collection-limit)
        (asserts! (< current-index (var-get collection-index)) (err "err-collection-minted-out"))


        ;; Assert that user has mints left (Whitelist-mints > 0)
        (asserts! (> whitelist-mints u0) (err "err-whitelist-mint-limit-reached"))


        ;; STX transfer / pay for the mint
        (unwrap! (stx-transfer? advance-nft-price tx-sender deployer) (err "err-stx-transfer"))

        ;; Mint NFT to tx-sender
        (unwrap! (nft-mint? advance-nft current-index tx-sender) (err "err-nft-mint"))

        ;; Var-set collection-index to next-index
       (var-set collection-index next-index)


        ;; map-set Whitelist-mints to whitelist-mints - 1
        (ok (map-set whitelist-map tx-sender (- whitelist-mints u1)))
        
        ;; (ok true)
    )
)

;; Mint 2
(define-public (mint-two) 
    (begin 
        (unwrap! (mint-one) (err "err-mint-one"))
        (ok (unwrap! (mint-one) (err "err-mint-two")))
     )

)

;; Mint 5
(define-public (mint-five) 
    (begin 
        
        (unwrap! (mint-one) (err "err-mint-one"))
        (unwrap! (mint-one) (err "err-mint-two"))
        (unwrap! (mint-one) (err "err-mint-three"))
        (unwrap! (mint-one) (err "err-mint-four"))
        (ok (unwrap! (mint-one) (err "err-mint-five")))
     )

)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Whitelist Funcs ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add Whitelist

;; Check Whitelist status



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Admin Functions ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add Admin

;; Remove Admin

;; Remove admin helper


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; helper functions ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;