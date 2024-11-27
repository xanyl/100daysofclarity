;; Marketplace contract
;; Simple NFT Marketplace
;; Written by Anil Kumar Tiwari

;; Unique properties and features
;; All Custodial
;; Multiple admins
;; Collections *Have* to be whitelisted  By Admins
;; Only STX (no FT)

;; Selling an NFT lifecycle
;; Collection is submitted for whitelisting
;; Collection is whitelisted or rejected
;; NFTs are listed
;; NFT is purchased
;; STX/NFT are transferred
;; Listing(s) are deleted






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Cons, Vars & Maps ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define the NFT trait we will be using throughout 
(use-trait nft .sip-09.nft-trait)

;; ALl admins 
(define-data-var admins (list 10 principal) (list tx-sender))

;; Whitelist collections map
;; (define-map whitelisted-collections principal bool)

;; Whitelist collection
;; three states
;; 1. is-none -> collection is not whitelisted
;; 2. false -> collection has not been approved
;; 3. true -> collection has been pproved by admin
(define-map collection principal {
    name: (string-ascii 64),
    royality-percent: uint,
    royality-address: principal,
    whitelisted: bool,
})

;; List of all for sale in collection
(define-map collection-listing principal (list 10000 uint) )

;; Item status 
(define-map item-status {collection:principal, item:uint} {
    owner:  principal,
    price: uint,

})

;; Helper uint
(define-data-var helper-uint uint u0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Read Functions ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get all whitelisted collections
(define-read-only (is-collection-whitelisted (nft-collection principal)) 
  (map-get? collection nft-collection)
)

;; Get all listed items in a collection
(define-read-only (listed (nft-collection principal))
   (map-get? collection-listing nft-collection)
)

;; Get item status
(define-read-only (item (nft-collection principal) (nft-item uint))
    (map-get? item-status {collection: nft-collection, item: nft-item})
)

;; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Buyer Functions ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Buy item
;; @desc - function that allow a principal to buy an NFT listed
;; @param - nft-collection: nft-trait, nft-item: uint

(define-public (buy-item (nft-collection <nft>) (nft-item uint)) 

    (let 
        (
        (current-collection (unwrap! (map-get? collection (contract-of nft-collection)) (err "err-collection-not-whitelisted")))
        (current-royality-percent (get royality-percent current-collection))
        (current-royality-address (get royality-address current-collection))
        (current-listing (unwrap! (map-get? item-status {collection: (contract-of nft-collection), item: nft-item}) (err "err-item-not-listed")))
        (current-collection-listings (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "err-collection-has-no-listing")))
        (current-listing-price (get price current-listing))
        (current-listing-royalty (/ (* current-listing-price current-royality-percent)))
        (current-listing-owner (get owner current-listing))
        
        )

    ;; Assert that item is listed
    (asserts! (is-some (index-of current-collection-listings nft-item)) (err "err-item-not-listed"))

    ;; Assert tx sender is not the owner of the NFT
    (asserts! (not (is-eq tx-sender current-listing-owner)) (err "err-buyer-is-owner"))

    ;; Send STX (price ) to owner
    (unwrap! (stx-transfer? current-listing-price tx-sender current-listing-owner) (err "err-stx-transfer-price"))

    ;; Send STX (royality) to royality/artist address
    (unwrap! (stx-transfer? current-listing-royalty tx-sender current-royality-address) (err "err-stx-transfer-royality"))

    ;; Transfer NFT from custodial/contract to buyer()
    (unwrap! (contract-call? nft-collection transfer nft-item (as-contract tx-sender) tx-sender) (err "err-nft-transfer"))
    ;; Map-delete item-listing
    (map-delete item-status {collection: (contract-of nft-collection), item: nft-item})

    ;; Filter out nft-item from collection-listing
    ;; (filter remove-uint collection-listing)
    (var-set helper-uint nft-item)
    (ok (map-set collection-listing (contract-of nft-collection) (filter remove-uint-from-list current-collection-listings)))
   
  
    )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Owner Functions ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; List item
;; @desc - function that allow an owner to list an NFT
;; @param - collection: <nft-trait>, item: uint
(define-public (list-item (nft-collection <nft>) (nft-item uint) (nft-price uint))
    (let (

        (test true)
         (current-nft-owner (unwrap! (contract-call? nft-collection get-owner nft-item) (err "err-nft-owner-not-found")))
        (current-collection-listing (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "err-collection-has-no-listing")))
    )
    ;; Assert that tx sender is the current owner of the NFT
    (asserts! (is-eq (some tx-sender) current-nft-owner) (err "err-tx-sender-not-owner"))
    ;; Assert that collection is whitelisted
    (asserts! (is-some (map-get? collection (contract-of nft-collection ))) (err "err-collection-not-whitelisted"))

    ;; Assert item-status is-none
    (asserts! (is-none (map-get? item-status {collection: (contract-of nft-collection), item: nft-item})) (err "err-item-already-listed"))

    ;; Transfer NFT from tx-sender to contract
    (unwrap! (contract-call? nft-collection transfer nft-item tx-sender (as-contract tx-sender) ) (err "err-nft-transfer"))

    ;; Map-set item-status w/ new price AND owner (tx-sender)
    (map-set item-status {collection: (contract-of nft-collection), item: nft-item}
     {
        owner: tx-sender,
         price: nft-price
     })

    ;; map-set collection-listing 
   (ok (map-set collection-listing (contract-of nft-collection) (unwrap! (as-max-len? (append current-collection-listing  nft-item) u10000) (err " err-collection-listing-overflow"))))

    
    )
)

;; Unlist item

(define-public (unlist-item (nft-collection <nft>) (nft-item uint) ) 
    (let (
        (test true)
    )

    ;; Assert that current NFT owner is contract

    ;; Assert item -status is-some

    ;; Assert that owner property from item-status tuple is tx-sender

    ;; Assert that uint is in collection-listing map 

    ;; Transfer NFT back from contract to tx-sender/original owner

    ;; Map-set collection-listing (remove uint)

    ;; Map-set item-status (delete entry)
    (ok test)
    )
)

;; Change Price

(define-public (change-price (nft-collection <nft>) (nft-item uint) (nft-price uint)) 
    (let
        (
        (current-collection (unwrap! (map-get? collection (contract-of nft-collection)) (err "err-collection-not-whitelisted")))
        (current-royality-percent (get royality-percent current-collection))
        (current-royality-address (get royality-address current-collection))
        (current-listing (unwrap! (map-get? item-status {collection: (contract-of nft-collection), item:nft-item}) (err "err-item-not-listed")))
        (current-collection-listings (unwrap! (map-get? collection-listing (contract-of nft-collection)) (err "err-collection-has-no-listing")))
        (current-listing-price (get price current-listing))
        (current-listing-royalty (/ (* current-listing-price current-royality-percent)))
        (current-listing-owner (get owner current-listing))
        (current-nft-owner (unwrap! (contract-call? nft-collection get-owner nft-item) (err "err-nft-owner-not-found")))
        )

        ;; Assert nft-item is in collection-listing
         (asserts! (is-some (index-of current-collection-listings nft-item)) (err "err-item-not-listed"))

        ;; Assert nft current owner is contract
        (asserts!  (is-eq  (some (as-contract tx-sender)) current-nft-owner) (err "err-nft-owner-not-contract"))
        ;; Assert that tx-sender is owner from item-status tuple
        (asserts! (is-eq tx-sender current-listing-owner) (err "err-tx-sender-not-owner"))
        ;; Map-set item-status (update price)
        (map-set item-status {collection: (contract-of nft-collection), item: nft-item} 
            (merge 
                current-listing
                {price: nft-price}
            )
        )

        ;; 

        (ok true)
    )
)


;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Artists Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Submit Collection

(define-public (submit-collection (nft-collection <nft>) (royality-percent uint)) 
    (let (
        (test true)
    )

    ;; Assert that collection is not already whitelisted by making sure it is is-none

    ;; Assert that tx-sender is deployer of nft parameter 

    ;; Map-set  whitelisted-collections (tx-sender)

        (ok test)
    )
)

;; Change  Royality address

(define-public (change-royality-address (nft-collection principal) (new-royality principal)) 
    (let (
        (test true)
    )
    ;; Assert that collection is whitelisted

    ;; Assert that tx-sender is current royality address

    ;; Map-set / merge existing collection tuple w/ royality-address

    (ok test)
    )
)
;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Admins Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Accept/reject whitelisting
(define-public (whitelisting-approval (nft-collection principal )) 
    (let (
        (test true)
    )
    ;; Assert that whitelisting exists / is-some

    ;; Assert that tx-sender is admin

    ;; Map-set nft-collection with true as whitelisted value


    (ok test)
    )
)

;; Add an admin
(define-public (add-admin (new-admin principal))
    (let (

    )
    
    ;; Assert that tx-sender is an admin

    ;; Assert that new-admin is not already an admin



    ;; Var-set admins to current-admins + new-admin

        (ok true)
    )
)


;; Remove admin

(define-public (remove-admin (admin principal)) 
    (let (
        (test true)

    )
    
    ;;Assert that tx-sender is an admin

    ;; Assert that remove-admin exists

    ;; Var-set helper function

    ;; Filter-out remove admin   
(ok test)
    )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Cons, Vars & Maps ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Helper Functions ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Remove uint from list
(define-private (remove-uint-from-list (item-helper uint)) 
    (not (is-eq item-helper) (var-get helper-uint))
) 