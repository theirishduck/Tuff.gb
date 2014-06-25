SECTION "SoundLogic",ROM0


; Sound Control ---------------------------------------------------------------
sound_enable:
    ld      a,%11111111
    ld      [$ff24],a 

    ld      a,%11111111
    ld      [$ff25],a ; output all channels to both speakers
    ld      a,%10000000
    ld      [$ff26],a ; enable sound circuits
    ret

sound_disable:
    ld      a,%00000000
    ld      [$ff25],a ; output all channels to both speakers
    ld      [$ff26],a ; dis-able sound circuits
    ret

sound_play: ; a = sound ID to play
    push    af
    push    hl
    push    de
    push    bc

    ; store sound to play
    ld      b,a

    ; check if the sound is already in the queue, if so do nothing
    ld      hl,soundEffectQueue
    ld      a,[hl]
    cp      b
    jr      z,.done
            
    ld      hl,soundEffectQueue + 8
    ld      a,[hl]
    cp      b
    jr      z,.done

    ld      hl,soundEffectQueue + 16
    ld      a,[hl]
    cp      b
    jr      z,.done

    ld      hl,soundEffectQueue + 24
    ld      a,[hl]
    cp      b
    jr      z,.done


    ; if the sound is not yet in the queue, find a free spot to put it in
    ld      hl,soundEffectQueue
    ld      a,[hl] 
    cp      0 
    jr      nz,.spot2 ; if the spot is not empty check the next one

    call    _sound_play_instance
    jr      .done

.spot2:

    ld      hl,soundEffectQueue + 8
    ld      a,[hl] 
    cp      0 
    jr      nz,.spot3 ; if the spot is not empty check the next one

    call    _sound_play_instance
    jr      .done

.spot3:

    ld      hl,soundEffectQueue + 16
    ld      a,[hl] 
    cp      0 
    jr      nz,.spot4 ; if the spot is not empty check the next one

    call    _sound_play_instance
    jr      .done


.spot4:

    ld      hl,soundEffectQueue + 24
    ld      a,[hl] 
    cp      0 
    jr      nz,.done ; if the spot is not empty check the next one

    call    _sound_play_instance
    jr      .done

.done:
    
    ; force a channel update to reduce delay
    ld      a,1
    ld      [soundForceUpdate],a
    call    sound_update
    ld      a,0
    ld      [soundForceUpdate],a

    pop     bc
    pop     de
    pop     hl
    pop     af

    ret


sound_stop: ; a = sound ID to stop
    push    af
    push    hl
    push    de
    push    bc

    ld      b,a

    ld      hl,soundEffectQueue
    call    _sound_stop_instance

    ld      hl,soundEffectQueue + 8
    call    _sound_stop_instance

    ld      hl,soundEffectQueue + 16
    call    _sound_stop_instance

    ld      hl,soundEffectQueue + 24
    call    _sound_stop_instance

    ; force a channel update to reduce delay
    ld      a,1
    ld      [soundForceUpdate],a
    call    sound_update
    ld      a,0
    ld      [soundForceUpdate],a

    pop     bc
    pop     de
    pop     hl
    pop     af

    ret


; Internals -------------------------------------------------------------------
_sound_play_instance: ; hl = soundEffectQueue, b = sound id to play

    ; set sound id for the queue spot
    ld      a,b
    ld      [hli],a

    ; set up queue spot data with the sound effect data
    call    _sound_get_effect_data; de now points to the sound data

    ; mode
    ld      a,[de]
    ld      b,a; mode and priority are combined 
    and     %00000011
    ld      [hli],a
    inc     de

    ; length
    ld      a,[de]
    ld      [hli],a
    inc     de

    ; channel
    ld      a,[de]
    ld      [hli],a
    inc     de

    ; priortiy
    ld      a,b
    and     %11111100
    srl     a
    srl     a
    ld      [hl],a

    ret


_sound_stop_instance: ; hl = soundEffectQueue, b = sound id to stop

    ; check if the queue spot sound id matches the sound id to stop
    ld      a,[hl] 
    cp      b
    ret     nz

    ; set mode flag of the sound effect queue entry to stop
    inc     hl ; skip id
    ld      a,3
    ld      [hl],a

    ret


sound_update:
    push    hl
    push    de
    push    bc


    ; update the state of all queued sounds
    ld      hl,soundEffectQueue
    call    sound_update_state

    ld      hl,soundEffectQueue + 8
    call    sound_update_state

    ld      hl,soundEffectQueue + 16
    call    sound_update_state

    ld      hl,soundEffectQueue + 24
    call    sound_update_state


    ; apply the queued sounds to the channels
    ld      hl,soundEffectQueue
    call    _sound_update_apply

    ld      hl,soundEffectQueue + 8
    call    _sound_update_apply

    ld      hl,soundEffectQueue + 16
    call    _sound_update_apply

    ld      hl,soundEffectQueue + 24
    call    _sound_update_apply


    ; clean up empty sounds channles
    ld      hl,soundChannelState
    ld      a,1
    call    _sound_update_channel

    ld      hl,soundChannelState + 4
    ld      a,2
    call    _sound_update_channel

    ld      hl,soundChannelState + 8
    ld      a,3
    call    _sound_update_channel

    ld      hl,soundChannelState + 12
    ld      a,4
    call    _sound_update_channel

    pop     bc
    pop     de
    pop     hl

    ret


; Individual sound and channel updaters ---------------------------------------
sound_update_state: ; hl = soundEffectQueue address of sound
    
    ld      a,[hli]; store sound id into b
    ld      b,a
    cp      0
    ret     z; exit if there's no sound in this queue spot

    ; check mode
    ld      a,[hli]
    cp      2
    jr      z,.looping
    cp      1
    jr      z,.playing
    cp      3
    jr      z,.stopped

    ; this should normally not happen 
    ret

.looping:
    ; do nothing
    ret

.playing:
    ; check if we forcing a channel update and skip play time reduction
    ld      a,[soundForceUpdate]
    cp      1
    ret     z

    ld      a,[hl] ; load sound length
    dec     a ; decrease
    ld      [hl],a; store
    cp      0
    ret     nz; do nothing if length > 0

    ; otherwise disable the sound
    dec     hl; go back to the mode byte
    ld      [hl],0
    inc     hl; go to length

.stopped:
    inc     hl; skip length
    ld      a,[hl]; load target channel of the sound effect and store it
    
    ; check to see if the target channel is currently playing this effect
    call    _sound_get_channel
    ld      a,[de]
    cp      b
    jr      nz,.clear

    ; if the match up, clear the channel sound id
    ld      a,0
    ld      [de],a
    inc     de; skip sound id
    inc     de; skip sound priority
    ld      a,2 ; set action flag to stop TODO set this depending on the mode
    ld      [de],a
    
    ; set the sound ID of the current queue spot to 0 to clear it
.clear:
    dec     hl; back to length
    dec     hl; back to mode
    dec     hl; back to id
    ld      [hl],0
    ret


_sound_update_apply: ; hl = soundEffectQueue address of sound

    ; get the sound id of the current queue spot
    ld      a,[hl]
    cp      0
    ret     z; 0 means the queue spot is not used

    ; check if the target channel for this queue spot is available
    inc     hl; skip id
    inc     hl; skip mode
    inc     hl; skip length
    ld      a,[hl]
    ld      c,a; store channel ???? FIXME used? Needed?
    call    _sound_get_channel
    dec     hl
    dec     hl
    dec     hl

    ; load the sound id that is currently playing on the target channel
    ld      a,[de]
    cp      0
    jr      nz,.in_use

    ; if the channel is not used, place the current sound id on it
    jr      .set_channel

.in_use:
    ; if the sound is already playing on the target channel do nothing
    ld      a,[hl]
    ld      b,a
    ld      a,[de]
    cp      b
    ret     z

    ; if it is used check if the current sound effect's priority is higher
    ; than the one that is currently playing on the channel
    inc     hl; skip id
    inc     hl; skip mode
    inc     hl; skip length
    inc     hl; skip channel

    ; load priority of the current sound effect
    ld      a,[hl]
    ld      b,a

    ; load priority of the sound that is currently on the channel
    inc     de
    ld      a,[de]
    
    cp      b
    ret     z; do nothing if b == a
    ret     nc; do nothing if b < a

    ; if the priority of the current sound effect is higher set it on the channel
    dec     de; back to channel sound id
    dec     hl; back to channel
    dec     hl; back to length
    dec     hl; back to mode
    dec     hl; back to id
            

.set_channel:

    ; set channel sound ID (hl = soundEffectQueue, de = soundChannelState)
    ld      a,[hli]
    ld      [de],a ; set sound id
    ld      a,[hli]; store mode
    ld      c,a
    inc     hl; skip length
    inc     hl; skip channel

    ; set priority
    inc     de
    ld      a,[hl]
    ld      [de],a

    ; set action flag to reload
    inc     de
    ld      a,1
    ld      [de],a
    inc     de

    ; store mode to channel data
    ld      a,c
    ld      [de],a

    ret
    

_sound_update_channel: ; hl = soundChannelState, a = channel number 1-4

    ld      b,a ; store channel number for clear_channel
    ld      a,[hli] ; load active sound ID
    ld      c,a;  store active sound id for load_channel

    cp      0 ; if there is no active sound id on the channel clear it
    jr      z,.clear_channel
    
    inc     hl ; skip priority
    ld      a,[hl] ; load action flag
    cp      1
    jr      z,.load_channel
    
    ret


; channel clearing ------------------------------------------------------------
.clear_channel:

    inc     hl ; skip priority
    ld      a,[hl] ; load action flag
    cp      2; check for clear action
    ret     nz

    ; clear action flag
    ld      a,0
    ld      [hli],a

    ; load initial sound mode
    ld      a,[hl]
    ld      c,a

    ; load channel number
    ld      a,b
    cp      1
    jr      z,.clear_channel_1
    cp      2
    jr      z,.clear_channel_2
    cp      3
    jr      z,.clear_channel_3
    cp      4
    jr      z,.clear_channel_4
    ret

.clear_channel_1:

    ld      a,c
    cp      2
    ret     nz

    ld      a,0
    ld      [$ff10],a
    ld      [$ff11],a
    ld      [$ff12],a
    ld      [$ff13],a
    ret

.clear_channel_2:
    ret

.clear_channel_3:
    ret

.clear_channel_4: 

    ; if the original sound mode was set to loop fade out the sound
    ; otherwise do nothing
    ld      a,c
    cp      2
    ret     nz

    ; limit frames to play
    ld      a,$40
    ld      [$ff20],a

    ; set to dec envelope
    ld      hl,$ff21
    ld      [hl],%11110000

    ; set to limited play mode
    ld      a,%01000000
    ld      [$ff23],a
    ret


; channel loading -------------------------------------------------------------
.load_channel: ; hl = soundChannelState + 2

    ; reset load flag
    ld      a,0
    ld      [hl],a

    ; get sound effect data pointer
    ld      b,c ; restore sound id
    call    _sound_get_effect_data; de now points to the sound configuration data

    ; skip channel config data
    ld      a,[de]; store loop mode
    and     %00000011
    ld      c,a
    inc     de; skip mode / priority
    inc     de; skip length
    ld      a,[de]; load target channel
    inc     de; skip channel

    ; point hl to channel specific sound data
    ld      h,d
    ld      l,e

    ; set specific channel
    cp      1
    jr      z,.load_channel_1
    cp      2  
    jr      z,.load_channel_2
    cp      3  
    jr      z,.load_channel_3
    cp      4  
    jr      z,.load_channel_4
    ret

.load_channel_1:
    ; FF10
    ld      a,[hli]
    ld      [$ff10],a

    ; FF11
    ld      a,[hli]
    ld      [$ff11],a

    ; FF12
    ld      a,[hli]
    ld      [$ff12],a

    ; FF13
    ld      a,[hli]
    ld      [$ff13],a

    ; FF14
    ld      a,[hl]
    ld      [$ff14],a
    ret

.load_channel_2:
    ret

.load_channel_3:
    ret

.load_channel_4:

    ; FF20
    ld      a,[hli]
    ld      [$ff20],a

    ; FF21
    ld      a,[hli]
    ld      [$ff21],a

    ; FF22
    ld      a,[hli]
    ld      [$ff22],a

    ; FF23
    ld      a,[hli]
    ld      [$ff23],a

    ret


; Helpers ----------------------------------------------------------------------
_sound_get_effect_data: ; b = sound id to get -> de = data pointer

    push    hl

    ld      l,b
    ld      h,0
    dec     l; switch to 0 based indexing and multiply by 8 to get the offset 

    add     hl,hl
    add     hl,hl
    add     hl,hl

    ; combine with the base address and move to de register
    ld      de,DataSoundDefinitions
    add     hl,de
    ld      d,h
    ld      e,l

    pop     hl

    ret

_sound_get_channel; a = sound channel id, de -> address of soundChannelState
    dec     a; switch to 0 based indexing and multiply by 4 to get the offset
    sla     a; x2
    sla     a; x4
    ld      d,soundChannelState >> 8
    ld      e,a
    ret
