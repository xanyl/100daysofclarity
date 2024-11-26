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
    (ok test)
    )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Owner Functions ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; List item

;; Unlist item

;; Change Price



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