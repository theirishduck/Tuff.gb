SECTION "ScreenLogic",ROM0


; Screen ----------------------------------------------------------------------
screen_timer:
    call    _screen_animate_palette
    call    _screen_shake_timer
    ret


; Screen Shaking --------------------------------------------------------------
screen_shake: ; a = duration in seconds / 8
    ld      [screenShakeTicks],a
    ret


_screen_shake_timer:
    ld      a,[screenShakeTicks]
    cp      0
    ret     z

    dec     a
    ld      [screenShakeTicks],a
    cp      0
    jr      z,.reset

.x:
    call    math_random
    ld      b,a
    and     %01000000 ; negative
    cp      %01000000
    jr      z,.negative_x

.positive_x:
    ld      a,b
    and     %00000011 ; 0-8
    ld      [coreScrollX],a
    jr      .y

.negative_x:
    ld      a,b
    and     %00000011 ; 0-8
    add     254
    ld      [coreScrollX],a

.y:
    call    math_random
    ld      b,a
    and     %01000000 ; negative
    cp      %01000000
    jr      z,.negative_y

.positive_y:
    ld      a,b
    and     %00000011 ; 0-8
    ld      [coreScrollY],a
    jr      .done

.negative_y:
    ld      a,b
    and     %00000011 ; 0-8
    add     254
    ld      [coreScrollY],a

.done:
    ret

.reset:
    xor     a
    ld      [coreScrollX],a
    ld      [coreScrollY],a
    ret



; Screen Fading ---------------------------------------------------------------
screen_animate:; a = animation type
    ld      [screenAnimation],a
    call    _screen_animate_palette
    ret
            

; Color Mixing ----------------------------------------------------------------
_screen_animate_palette:

    ; check if active
    ld      a,[screenAnimation]
    bit     0,a
    ret     z

    ; check whether fade or flash
    bit     1,a
    jr      z,.fade
.flash:
    ld      hl,_screen_flash_map
    jr      .color

.fade:
    ; check whether fade out or in
    bit     2,a
    jr      nz,.fade_in
.fade_out:
    ld      hl,_screen_fade_out_map
    jr      .color

.fade_in:
    ld      hl,_screen_fade_in_map

.color:
    ; check whether dark or light mode
    bit     3,a
    jr      nz,.dark

.light:
    ld      b,5; offset into lighter color table
    jr      .update

.dark:
    ld      b,0; offset into darker color table
    
.update:

    ; load animation index
    ld      a,[screenAnimationIndex]
    
    ; add to table
    ld      d,0
    ld      e,a
    add     hl,de
    
    ; next index
    inc     a
    ld      [screenAnimationIndex],a

    ; load offset value
    ld      a,[hl]

    ; check if end of table and disable animation
    cp      $FF
    jr      z,.done

    ; otherwise combine with color offset
    add     b

    ; and update palette
    call    _screen_update_palette_dmg

    ; flag palette as changed for update during next vblank
    ld      a,$01
    ld      [corePaletteChanged],a

    ret

.done:
    xor     a
    ld      [screenAnimation],a
    ld      [screenAnimationIndex],a
    ret


_screen_update_palette_dmg:; a = fade index

    ; load color fading entry for current index
    ld      hl,_screen_fade_table_dmg
    add     a,l
    ld      l,a
    adc     a,h
    sub     l
    ld      h,a

    ; load color map for the given fade index into d
    ld      d,[hl]

    ld      hl,_screen_palette_bg
    call    _color_from_palette_dmg
    ld      [corePaletteBG],a

    ld      hl,_screen_palette_sprite0
    call    _color_from_palette_dmg
    ld      [corePaletteSprite0],a

    ld      hl,_screen_palette_sprite1
    call    _color_from_palette_dmg
    ld      [corePaletteSprite1],a

    ret

_color_from_palette_dmg:; hl = palette pointer; d = offset
    xor     a
    call    _screen_mix_color_dmg
    call    _screen_mix_color_dmg
    call    _screen_mix_color_dmg
    call    _screen_mix_color_dmg
    ret

_screen_mix_color_dmg:; hl = color pointer, a = current color, d = brigthness to mix with
    
    ; store current color value
    ld      e,a

    ; load mask value and apply to input color
    ld      b,[hl]
    inc     hl

    ; apply color selection mask
    ld      a,d
    and     b
    ld      b,a; b is now the mix color

    ; load shift value and apply to mix color
    ld      a,[hli]
    cp      0
    jr      z,.mix

    ; shift correction
    sla     b
    sla     b

.mix:; b now has the final color to mix with
    ld      a,e
    or      b
    ret


; Fading and Flashing Data ----------------------------------------------------
_screen_flash_map:
    DB      $02,$03,$04,$04,$04,$04,$04,$04,$04,$03,$02,$01,$00,$FF

_screen_fade_out_map:
    DB      $00,$00,$00,$00,$01,$02,$03,$04,$FF

_screen_fade_in_map:
    DB      $04,$04,$04,$04,$03,$02,$01,$00,$FF

_screen_fade_table_dmg:
    ; darker
    ; black, dark, light, white
    DB      %11_10_01_00 
    DB      %11_10_01_01 
    DB      %11_10_10_10 
    DB      %11_11_10_10 
    DB      %11_11_11_11 
                         
    ; lighter            
    ; black, dark, light, white
    DB      %11_10_01_00 
    DB      %11_10_01_00 
    DB      %10_01_01_00 
    DB      %01_01_00_00 
    DB      %00_00_00_00 

_screen_palette_bg:
    ;       mask, shift
    DB      %11000000,0
    DB      %00110000,0
    DB      %00001100,0
    DB      %00000011,0

_screen_palette_sprite0:
    ;       mask, shift
    DB      %11000000,0
    DB      %00001100,2
    DB      %00000011,2
    DB      %00000011,0; not used, always transparent 

_screen_palette_sprite1:
    ;       mask, shift
    DB      %00110000,2
    DB      %00001100,2
    DB      %00000011,2
    DB      %00000011,0; not used, always transparent 
