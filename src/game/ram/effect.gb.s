SECTION "EffectRam",WRAM0[$CC60]; must be aligned at 32 bytes for effectState

EFFECT_MAX_COUNT              EQU 8
EFFECT_BG_SPRITE_INDEX        EQU 0; start index to use for effect sprites that are in the background
EFFECT_FG_SPRITE_INDEX        EQU 32; start index to use for effect sprites that are in the foreground
EFFECT_MAX_TILE_QUADS         EQU 4
EFFECT_BYTES                  EQU 10

EFFECT_AIR_BUBBLE             EQU 0
EFFECT_FIRE_FLARE             EQU 1
EFFECT_DUST_CLOUD             EQU 2
EFFECT_DUST_CLOUD_SMALL       EQU 3; also used for splashing out of water
EFFECT_WATER_SPLASH_IN_LEFT   EQU 4
EFFECT_WATER_SPLASH_IN_RIGHT  EQU 5
EFFECT_DUST_CLOUD_FAST        EQU 6
EFFECT_WATER_SPLASH_OUT_LEFT  EQU 7
EFFECT_WATER_SPLASH_OUT_RIGHT EQU 8
EFFECT_DUST_SIDE_LEFT         EQU 9
EFFECT_DUST_SIDE_RIGHT        EQU 10
EFFECT_PUFF_CLOUD             EQU 11
EFFECT_WALL_DUST_LEFT         EQU 12
EFFECT_WALL_DUST_RIGHT        EQU 13
EFFECT_RUN_DASH_RIGHT         EQU 14
EFFECT_RUN_DASH_LEFT          EQU 15

EFFECT_WATER_IN_OFFSET        EQU 0
EFFECT_WATER_OUT_OFFSET       EQU 3

EFFECT_MAP_DEFINITION_OFFSET  EQU 16


; RAM storage for effect positions / states -----------------------------------
effectScreenState:      DS  EFFECT_MAX_COUNT * EFFECT_BYTES ; 9 bytes per effect
                               ; flags: [active][-][-][fg/bg] 0-2: [palette]
                               ; [ypos][dy]
                               ; [xpos]
                               ; [animation delay offset]
                               ; [animation delay]
                               ; [animation loops left]
                               ; [animation max index]
                               ; [animation current index]
                               ; [animation tile]

effectQuadsUsed:        DS EFFECT_MAX_TILE_QUADS * 2; [usage count][index]

