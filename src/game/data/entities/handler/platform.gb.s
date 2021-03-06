entity_handler_load_platform_vertical: ; b = entity index, c = sprite index
    inc     e; skip type
    inc     e; skip flags
    ld      a,[de]; load default direction
    or      %0000_0010
    ld      [de],a
    dec     e; back to flags
    dec     e; back to type

entity_handler_load_platform_bottom: ; b = entity index, c = sprite index
    inc     e; skip type
    inc     e; skip flags
    inc     e; skip direction

    ; check for 8 pixel alignment
    ld      a,[de]
    and     %0000_1000
    cp      0
    jr      nz,entity_handler_load_platform_top

    ; correct Y offset if alignment is 16 pixel
    ld      a,[de]
    add     8
    ld      [de],a

entity_handler_load_platform_top: ; b = entity index, c = sprite index
    ld      a,c
    ld      b,ENTITY_ANIMATION_OFFSET + ENTITY_ANIMATION_PLATFORM
    call    sprite_set_animation
    ret

entity_handler_update_platform: ; generic, b = entity index, c = sprite index, de = screen data

    ld      l,0; flag = 1 if player is on THIS platform

    inc     e; skip type
    inc     e; skip flags
    ld      a,[de]; load direction flag
    ld      h,a
    inc     e

    ; load position
    ld      a,[de]; load y position and store into c
    ld      c,a
    inc     e
    ld      a,[de]; load x position and store into b
    ld      b,a

    ; see if player is standing clipping into platform
    ld      a,[playerY]
    add     17

    ; check overlap within in a certain range to handle higher fall speeds
    cp      c
    jr      c,.no_player
    sub     4; TODO extend range so pound always hits the platform
    cp      c
    jr      nc,.no_player

    ; ignore when jumping upwards
    ld      a,[playerJumpForce]
    cp      0
    jr      nz,.no_player

    ; check if player is on platform
    ld      a,[playerX]
    add     10; center of player sprite
    cp      b; compare with left end of platform
    jr      c,.no_player ; playerX + 8 => platformX

    ; right end of platform
    ld      a,b
    add     12
    ld      b,a

    ; playerX + 8 <= platformX + 16
    ld      a,[playerX]
    cp      b
    jr      nc,.no_player

    ; correct player Y to be exactly on top of platform
    ld      a,c
    sub     16
    ld      [playerPlatformY],a
    ld      [playerY],a

    ; store plaform direction
    ld      a,h
    ld      [playerPlatformDirection],a
    ld      l,1

.no_player:
    ; restore platform x position
    ld      a,[de]
    ld      b,a
    dec     e
    dec     e

    ; check if we should move on this frame
    ld      a,[coreLoopCounter]
    and     %0000_0001
    ret     z

    ; check if player is on this very platform
    ld      a,l
    cp      0
    jr      z,.no_player_speed

    ; if so, set platform speed
    ld      a,1
    ld      [playerPlatformSpeed],a

    ; check platform direction
.no_player_speed:
    ld      a,h
    cp      1
    jr      z,.move_right
    cp      2
    jr      z,.move_up
    cp      3
    jr      z,.move_down

    ; flags = 0
.move_left:
    call    entity_col_left_half
    jr      c,.switch_to_right
    dec     b
    jr      .position

    ; flags = 1
.move_right:
    call    entity_col_right_half
    jr      c,.switch_to_left
    inc     b
    jr      .position

    ; flags = 2
.move_up:
    call    entity_col_up_far
    jr      c,.switch_to_down
    dec     c
    jr      .position

    ; flags = 3
.move_down:
    call    entity_col_down
    jr      c,.switch_to_up
    inc     c

.position:
    inc     e; skip direction
    ld      a,c
    ld      [de],a

    inc     de
    ld      a,b
    ld      [de],a

    ret

.switch_to_right:
    ld      a,PLAYER_PLATFORM_DIR_RIGHT
    ld      [de],a
    ld      b,a
    jr      .switched

.switch_to_left:
    ld      a,PLAYER_PLATFORM_DIR_LEFT
    ld      [de],a
    ld      b,a
    jr      .switched

.switch_to_down:
    ld      a,PLAYER_PLATFORM_DIR_DOWN
    ld      [de],a
    ld      b,a
    jr      .switched

.switch_to_up:
    ld      a,PLAYER_PLATFORM_DIR_UP
    ld      [de],a
    ld      b,a

.switched:

    ; check if player is on this very platform
    ld      a,l
    cp      0
    ret     z

    ; if so apply new direction to avoid notches when platform toggles direction
    ld      a,b
    ld      [playerPlatformDirection],a
    ret

