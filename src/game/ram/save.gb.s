SECTION "SaveRam",RAM[$A000]

; Constants -------------------------------------------------------------------
SAVE_GAME_VERSION          EQU 10

SAVE_HEADER_SIZE           EQU 3
SAVE_VERSION_SIZE          EQU 1
SAVE_CHECKSUM_SIZE         EQU 2
SAVE_PLAYER_DATA_SIZE      EQU 12
SAVE_ENTITY_HEADER_SIZE    EQU 1
SAVE_ENTITY_DATA_SIZE      EQU ENTITY_STORED_STATE_SIZE
SAVE_COMPLETE_SIZE         EQU SAVE_HEADER_SIZE + SAVE_VERSION_SIZE + SAVE_PLAYER_DATA_SIZE + SAVE_ENTITY_HEADER_SIZE + SAVE_ENTITY_DATA_SIZE + SCRIPT_TABLE_MAX_ENTRIES

SAVE_DEFAULT_PLAYER_X      EQU 46
SAVE_DEFAULT_PLAYER_Y      EQU 24
SAVE_DEFAULT_ROOM_X        EQU 2
SAVE_DEFAULT_ROOM_Y        EQU 3
SAVE_RAM_BANK              EQU 0


; Placeholder for save data ---------------------------------------------------
saveData:           DS SAVE_COMPLETE_SIZE

