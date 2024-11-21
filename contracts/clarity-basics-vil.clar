;; Clarity-basics-vi
;; Reviewing more clarity fundamentals
;; Written by Anil Kumar Tiwari

;; Day 57 - Minting Whitelist Logic

(define-non-fungible-token test-nft uint)
(define-constant collection-limit u10)
(define-constant admin tx-sender)
(define-data-var collection-index uint u1)
(define-map whitelist-map principal uint)

;;Minting Logic
(define-public (mint)
    (let (
        (current-index (var-get collection-index))
        (next-index (+ current-index u1))
        (current-whitelist-mints (unwrap! (map-get? whitelist-map tx-sender) (err "err-whitelist-none")))
        (next-whitelist-mints (- current-whitelist-mints u1))
    )
        ;; Assert that current index < limit
        (asserts! (< current-index collection-limit) (err "no-mints-left "))

        ;; Assert that tx-sender has mints allocated remaining
        (asserts! (> current-whitelist-mints u0) (err "err-whitelist-mints-all-used"))

        ;;Mint
        (unwrap! (nft-mint? test-nft current-index tx-sender) (err "mint-failed"))

        
        ;; update allocated whitelist mints
        (map-set whitelist-map tx-sender (- current-whitelist-mints u1))

        ;; Increase current index
        (ok (var-set collection-index next-index))
    )
)

;; Add Principal to Whitelist

(define-public (whitelist-principal (whitelist-address principal) (mints-allocated uint)) 
    (begin 

        ;;Assert that txsender is admin
        (asserts! (is-eq tx-sender admin) (err "not-admin"))

        ;; Map-set  whitelist-map
        (ok (map-set whitelist-map whitelist-address mints-allocated))
    )
)

;;Day -58  - Non-custodiak functions

(define-map market uint {price:uint, owner:principal})

(define-public (list-in-ustx (item uint) (price uint)) 
    (let 
        (
            (nft-owner (unwrap! (nft-get-owner? test-nft item) (err "err-nft-doesnt-exist"))
        ))
        ;;Assert that tx-sender is-eq to NFT owner
        (asserts! (is-eq tx-sender nft-owner) (err "err-not-owner"))

        ;;Map-set market with new NFT
        (ok (map-set market item {price: price, owner:tx-sender}))
    ) 
)

(define-read-only (get-list-in-ustx (item uint)) 
    (map-get? market item)
)

(define-public (unlist-in-stx (item uint)) 
    (let (
        (current-listing (unwrap! (map-get? market item) (err "err-listing-not-found")))
        (current-price (get price current-listing))
        (current-owner (get owner current-listing))
    )
    ;;Assert that tx-sender is-eq to NFT owner
    (asserts! (is-eq tx-sender current-owner) (err "err-not-owner"))

    ;;Map Delete existing listing
    (ok (map-delete market item))
    ;; (ok true)    
    )
)


(define-public (buy-in-ustx (item uint)) 
    (let (
        (current-listing (unwrap! (map-get? market item) (err "err-listing-not-found")))
        (current-price (get price current-listing))
        (current-owner (get owner current-listing))

    )
    ;; Tx-sender buys by transfering STX 
    (unwrap! (stx-transfer? current-price tx-sender current-owner) (err "err-stx-transfer"))
    
    ;; Transfer NFT to new Buyer
    (unwrap! (nft-transfer? test-nft item current-owner tx-sender) (err " err-nft-transfer"))
   
    ;; Map-Delete the listing
    (ok (map-delete market item))
    )
)

