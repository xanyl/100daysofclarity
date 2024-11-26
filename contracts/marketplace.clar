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
(define-map whitelisted-collections principal bool)

;; Whitelist collection
(define-map collection principal {
    name: (string-ascii 64),
    royality-percent: uint,
    royality-address: principal
})

;; List of all for sale in collection
(define-map collection-listing principal (list 10000 uint) )

;; Item status 
(define-map item-status {collection:principal, item:uint} {
    owner:  principal,
    price: uint,

})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Read Functions ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get all whitelisted collections
(define-read-only (is-collection-whitelisted (nft-collection principal)) 
  (map-get? whitelisted-collections nft-collection)
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
        (test true)

        )
    ;; Assert NFT collection is whitelisted

    ;; Assert that item is listed

    ;; Assert tx sender is not the owner of the NFT

    ;; Send STX (price - roayality) to owner

    ;; Send STX (royality) to royality/artist address

    ;; Transfer NFT from custodial/contract to buyer

    ;; Map-delete item-listing


    (ok test)
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
    )
    ;; Assert that tx sender is the current owner of the NFT

    ;; Assert that collection is whitelisted

    ;; Assert NFT item is not in collection-listing

    ;; Assert item-status is-none

    ;; Transfer NFT from tx-sender to contract

    ;; Map-set item-status w/ new price AND owner (tx-sender)

    ;; map-set collection-listing 

    (ok test)
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

(define-public (change-price (nft-collection <nft>)) 
    (let
        (
            (test true)
        )

        ;; Assert nft-item is in collection-listing

        ;; Assert nft-item item-status map-get is-some

        ;; Assert nft current owner is contract

        ;; Assert that tx-sender is owner from item-status tuple

        ;; Map-set item-status (update price)

        ;; 

        (ok test)
    )
)


;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Artists Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Submit Collection

;; Change  Royality address

;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Admins Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Accept/reject whitelisting

;; Add an admin

;; Remove admin


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Cons, Vars & Maps ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;