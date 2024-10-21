
    ;; title: community-hello-world

    ;; description: A simple community billboard contract that provides a simple community billboard , readable by anyone but only updateable by Admin person.
    ;;contract that provides a simple community billboard , readable by anyone
    ;;but only updateable by Admin person.

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;Cons, Vars, and Maps
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;Constant that sets deployer prinicipal as admin
    (define-constant admin tx-sender)

    ;;Error Messages
    (define-constant ERR-TX_SENDER-NOT-NEXT-USER (err u0))
    (define-constant ERR-TX_SENDER-NOT-ADMIN (err u1))
    (define-constant ERR-EMPTY-USERNAME (err u2))
    (define-constant ERR-EMPTY-PRINCIPAL (err u3))
    (define-constant ERR-UPDATED-USER-PRINCIPAL-NOT-EQUAL-TO-NEXT-USER-PRINCIPAL (err u4))



    ;; Variable that keeps track of the *next* user that'll introduce themselves / write to the billboard
    (define-data-var next-user principal tx-sender)

    ;;variable tuple that contains the new member info

    (define-data-var billboard {new-user-principal: principal, new-user-name: (string-ascii 24) } {
        new-user-principal: tx-sender,
        new-user-name: ""
    })

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Read Function
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    ;;get community billboard
    (define-read-only (get-billboard) 
        (var-get billboard)
    )

    ;;get next user
    (define-read-only (get-next-user)
        (var-get next-user)
    )




    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;Write Function
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;Update the billboard with new user info
    ;;@desc- function used by next-usr to update the community billboard
    ;;@param - new-user-name: (string-ascii 24) - the new user name
    (define-public (update-billboard (updated-user-name (string-ascii 24))) 
        (begin
        ;;Assert that the tx-sender is the next user(approved by admin)
        (asserts! (is-eq tx-sender (var-get next-user)) ERR-TX_SENDER-NOT-NEXT-USER)
        ;;Assert that the updated user-name is not empty
        (asserts! (not (is-eq updated-user-name "")) ERR-EMPTY-USERNAME)  
        ;; var-set billboard with the new keys
        (ok (var-set billboard {new-user-principal: tx-sender, new-user-name: updated-user-name}))
        
        )
    )

    ;;Admin set new user
    ;;@desc - function used by admin to set / give permission to next user
    ;;@param - updated-user-principal: principal - the new user principal
    (define-public (admin-set-new-user (updated-user-principal principal)) 
        (begin 
        
        ;;assert that the tx-sender is the admin
        (asserts! (is-eq tx-sender admin) ERR-TX_SENDER-NOT-ADMIN)
        ;;assert that the updated user-principal is not empty
        (asserts! (not (is-eq tx-sender updated-user-principal)) ERR-EMPTY-PRINCIPAL )
        ;;assert that the updated user-principal is not the same as the current next user
        (asserts! (not (is-eq updated-user-principal (var-get next-user))) ERR-UPDATED-USER-PRINCIPAL-NOT-EQUAL-TO-NEXT-USER-PRINCIPAL)
        ;;var-set next-user with the updated-user-principal
        (ok (var-set next-user updated-user-principal))
        
        )
    )