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
    (ok true)
)

;; Transfer Token

;; Get Owner



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Non-Custodial Functions ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; List in ustx

;; Unlist in ustx

;; Buy in ustx

;; Check listing


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; Mint Functions ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mint 1

;; Mint 2

;; Mint 5


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