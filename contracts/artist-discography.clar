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

;;Admin list of principals
(define-data-var admins (list 10 principal) (list tx-sender))

;;Map that keeps track od a single album
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
(define-public (add-a-track (artist principal) (title (string-ascii 24)) (duration uint) (featured (optional principal)) (album-id uint)) 
    (let 
        (
            (current-discography (unwrap! (map-get? discography artist) (err u0)))
            (current-album (unwrap! (index-of current-discography album-id) (err u2)))
            (current-album-data (unwrap! (map-get? album {artist: artist, album-id:album-id}) (err u3)))
            (current-album-tracks (get tracks current-album-data))
            (current-album-track-id (len current-album-tracks))
            (next-album-track-id (+ current-album-track-id u1))
         ) 
    ;;Assert that tx-sender is either artist or admin
    (asserts! (or (is-eq tx-sender artist) (is-some (index-of? (var-get admins) tx-sender))) (err u1))
    ;;assert tht album exists in discography
   ;; (asserts! (is-some current-album) (err u2))
    ;;Assert that duration is less than 600 (10 mins)
    (asserts! (< duration u600) (err u3))
    ;;Map-set new track
    (map-set track {artist: artist, album-id:album-id, track-id:next-album-track-id} 
        {title: title, duration: duration, featured: featured}
    )
    ;;Map-set append track to album
    (ok (map-set album {artist: artist, album-id:album-id} 
        (merge 
            current-album-data 
            {tracks: (unwrap! (as-max-len? (append current-album-tracks next-album-track-id) u20) (err u4))}
        )
    )
    )
    )
    )
;; Add an album to the discography
;;@desc - function that allows a user or admin to add an album to the discography or start a new discography amd then add an album to the discography   
;;@param - title (string-ascii 24) - the title of the album
;;@param - tracks (list 20 uint) - the list of tracks in the album
;;@param - height-published uint - the height at which the album was published
(define-public (add-album-or-create-discography-and-add-album (artist  principal) (album-title (string-ascii 24)) )
    (let 
    (
            (current-discography (default-to (list ) (map-get? discography artist)))
            (current-album-id (len current-discography))
            (next-album-id (+ current-album-id u1))
    )
    ;; Check whether the discography exists / if discography is-some
    (
        if (is-eq current-album-id u0)
        (begin  
        ;;empty discography
        (map-set discography artist (list current-album-id))
        (map-set album {artist: artist, album-id: current-album-id} {
            title: album-title,
            tracks: (list u0),
            height-published: block-height
        })
        )
        
        ;;discography does exist
        (begin 

        (map-set discography artist (unwrap! (as-max-len? (append current-discography next-album-id) u10) (err u4)))
        (map-set album {artist: artist, album-id: next-album-id} {
            title: album-title,
            tracks: (list u0),
            height-published: block-height
        })
        )
        
        
    )
        ;;Discography exists
            ;;Map-set new album to discography

            ;;append new album to discography
        
        ;;Discography does not exist
            ;;Map-set new discography

            ;;Map-set new album to discography

            ;;append new album to discography

            
    ;;this is where the body goes

;;     (define-map album { artist:principal, album-id:uint } { 
;;     title: (string-ascii 24),
;;     tracks: (list 20 uint),
;;     height-published: uint
;;  })

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