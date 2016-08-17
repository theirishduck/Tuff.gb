SECTION "EffectRam",WRAM0[$CC60]; must be aligned at 32 bytes for effectState

EFFECT_MAX_COUNT              EQU 2
EFFECT_BG_SPRITE_INDEX        EQU 0; start index to use for effect sprites that are in the background
EFFECT_FG_SPRITE_INDEX        EQU 32; start index to use for effect sprites that are in the foreground
EFFECT_MAX_TILE_QUADS         EQU 4
EFFECT_BYTES                  EQU 9


; RAM storage for effect positions / states -----------------------------------
effectScreenState:      DS  EFFECT_MAX_COUNT * EFFECT_BYTES ; 9 bytes per effect
                               ; flags: [active][-][-][fg/bg] 0-2: [palette]
                               ; [ypos][dy]
                               ; [xpos]
                               ; [animation delay offset]
                               ; [animation delay]
                               ; [animation loops left]
                               ; [animation index]
                               ; [animation tile]

effectQuadsUsed:        DS EFFECT_MAX_TILE_QUADS * 2; [usage count][index]
