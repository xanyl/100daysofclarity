;; Artist Discography: A list of all the albums by an artist and the number of tracks on each album.
;; Contract that provides a list of all the albums by an artist and the number of tracks on each album.
;; Written by Anil Tiwari

;;Discography of an artist
;; The artist or an admin can add an album to the discography and remove an album from the discography.

;;Albumm
;; An album is a list of tracks + some additional info (such as when it was published, the artist, etc.)
;;The artist or an admin can start an album and can add/remove tracks


;; Track
;; A track is made up of a name and a duration,and possible feature (optional feature)
;; The artist or an admin can add a track to an album and remove a track from an album

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Cons,vars, and Maps ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-map track { artist:principal,album-id:uint, track-id:uint } {
    title: (string-ascii 24),
    duration: uint,
    featured: (optional principal)
})

(define-map album { artist:principal, album-id:uint } { 
    title: (string-ascii 24),
    tracks: (list 20 uint),
    height-published: uint
 })

;;Map that keeps track of  a discography
(define-map discography principal ( list 10 uint ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Read Functions ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Get track data
(define-read-only (get-track-data (artist principal) (album-id uint) (track-id uint)) 
    (map-get? track {artist:artist, album-id:album-id, track-id:track-id})
)

;;Get featured artist
(define-read-only (get-featured-artist (artist principal) (album-id uint)  (track-id uint)) 
    (get featured (map-get? track {artist:artist, album-id:album-id, track-id:track-id}))
)
;;Get album data
(define-read-only (get-album-data (artist principal) (album-id uint)) 
    (map-get? album {artist:artist, album-id:album-id})
)


;;Get published
(define-read-only (get-album-published-height (artist principal) (album-id uint)) 
    (get height-published (map-get? album {artist:artist, album-id:album-id}))
)

;;Get discography
(define-read-only (get-discography (artist principal))
    (map-get? discography artist)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Write Functions ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Adding a track to an album
;;@desc - function that allows a user or admin to add a track to an album
;;@param - title (string-ascii 24) - the title of the track, 
;;@param - duration uint - the duration of the track
;;@param - featured (optional principal) - the featured artist
;;@param - album-id uint - the album id
(define-public (add-a-track (artist (optional principal)) (title (string-ascii 24)) (duration uint) (featured (optional principal)) (album-id uint)) 
    (let 
    (
        (test u0)
    ) 
    ;;Assert that tx-sender is either artist or admin
    ;;assert tht album exists in discography
    ;;Assert that duration is less than 600 (10 mins)
    ;;Map-set new track
    ;;Map-set append track to album
        (ok test)
    )
)
;; Add an album to the discography
;;@desc - function that allows a user or admin to add an album to the discography or start a new discography amd then add an album to the discography   
;;@param - title (string-ascii 24) - the title of the album
;;@param - tracks (list 20 uint) - the list of tracks in the album
;;@param - height-published uint - the height at which the album was published
(define-public (add-album-or-create-discography-and-add-album (artist (optional principal)) (album-title (string-ascii 24)) )
    (let 
    (
        ;;this is where local vars are defined

    )
    ;; Check whether the discography exists / if discography is-some
    
        ;;Discography exists
            ;;Map-set new album to discography

            ;;append new album to discography
        
        ;;Discography does not exist
            ;;Map-set new discography

            ;;Map-set new album to discography

            ;;append new album to discography

            
    ;;this is where the body goes
    (ok true)
    ) 
   
    )


 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;; Admin Functions ;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Add admin
;;@desc - function that allows an admin to add an admin and can call to add an admin
;;@param - admin-principal principal - the admin principal
(define-public (add-admin (new-admin principal)) 
    (let (
        (test u0)
    ) 
    ;;Assert that is an existing admin

    ;;assert that new admin does not exist in admin list

    ;;append new-admin to admin list
        (ok test)
    )
)

;;Remove admin
;;@desc - function that allows an admin to remove an admin
;;@param - admin-principal principal - the admin principal

(define-public (remove-admin (removed-admin principal)) 
    (let 
    (
        (test u0)

    ) 
    ;; Assert that tx-sender is an existing admin

    ;;Assert that removed-admin is an existing admin

    ;;Remove admin from the existing admin list


    (ok test)
    )
)