module.exports = [{
    "id": "PLAYER_JUMP",
    "channel": 1,
    "priority": 2,
    "sweepShifts": 6,
    "sweepDir": 0,
    "sweepTime": 3,
    "soundLength": 12,
    "dutyCycle": 2,
    "envStepTime": 3,
    "envStepDir": 0,
    "envInitVol": 11,
    "frequency": 1536

}, {
    "id": "PLAYER_JUMP_DOUBLE",
    "channel": 1,
    "priority": 2,
    "sweepShifts": 6,
    "sweepDir": 0,
    "sweepTime": 6,
    "soundLength": 12,
    "dutyCycle": 2,
    "envStepTime": 3,
    "envStepDir": 0,
    "envInitVol": 0x0B,
    "frequency": 0x06A0

}, {
    "id": "PLAYER_LAND",
    "channel": 4,
    "priority": 1,
    "soundLength": 0,
    "envStepTime": 1,
    "envStepDir": 0,
    "envInitVol": 4,
    "freqRatio": 2,
    "polyStep": 1,
    "shiftFreq": 6

}, {
    "id": "PLAYER_LAND_SOFT",
    "channel": 4,
    "priority": 1,
    "soundLength": 0,
    "envStepTime": 1,
    "envStepDir": 0,
    "envInitVol": 3,
    "freqRatio": 2,
    "polyStep": 1,
    "shiftFreq": 6

}, {
    "id": "PLAYER_LAND_HARD",
    "channel": 4,
    "priority": 1,
    "soundLength": 0,
    "envStepTime": 1,
    "envStepDir": 0,
    "envInitVol": 6,
    "freqRatio": 1,
    "polyStep": 1,
    "shiftFreq": 7

}, {
    "id": "PLAYER_WATER_ENTER",
    "channel": 4,
    "priority": 1,
    "soundLength": 0,
    "envStepTime": 2,
    "envStepDir": 0,
    "envInitVol": 4,
    "freqRatio": 4,
    "polyStep": 0,
    "shiftFreq": 3

}, {
    "id": "PLAYER_WATER_LEAVE",
    "channel": 4,
    "priority": 1,
    "soundLength": 0,
    "envStepTime": 2,
    "envStepDir": 0,
    "envInitVol": 4,
    "freqRatio": 3,
    "polyStep": 0,
    "shiftFreq": 3

},{
    "id": "BG_WATERFALL",
    "channel": 4,
    "priority": 2,
    "looping": true, // loop inside the sound system
    "soundLength": 0,
    "envStepTime": 4,
    "envStepDir": 1,
    "envInitVol": 6,
    "freqRatio": 4,
    "polyStep": 0,
    "shiftFreq": 2

}, {
    "id": "PLAYER_DEATH_LAVA",
    "channel": 4,
    "priority": 10,
    "soundLength": 0,
    "envStepTime": 5,
    "envStepDir": 0,
    "envInitVol": 11,
    "freqRatio": 3,
    "polyStep": 1,
    "shiftFreq": 8

}, {
    "id": "PLAYER_DEATH_ELECTRIC",
    "channel": 1,
    "priority": 10,
    "sweepShifts": 4,
    "sweepDir": 1,
    "sweepTime": 3,
    "soundLength": 1,
    "dutyCycle": 2,
    "envStepTime": 3,
    "envStepDir": 0,
    "envInitVol": 0x0F,
    "frequency": 0x0750

}, {
    "id": "GAME_SAVE_FLASH",
    "channel": 1,
    "priority": 3,
    "sweepShifts": 5,
    "sweepDir": 0,
    "sweepTime": 7,
    "soundLength": 0,
    "dutyCycle": 0,
    "envStepTime": 7,
    "envStepDir": 0,
    "envInitVol": 0x0F,
    "frequency": 0x0650

}, {
    "id": "GAME_SAVE_RESTORE_FLASH",
    "channel": 1,
    "priority": 3,
    "sweepShifts": 5,
    "sweepDir": 0,
    "sweepTime": 3,
    "soundLength": 2,
    "dutyCycle": 3,
    "envStepTime": 2,
    "envStepDir": 0,
    "envInitVol": 0x0F,
    "frequency": 0x0450

}, {
    "id": "PLAYER_WALL_JUMP",
    "channel": 1,
    "priority": 2,
    "sweepShifts": 6,
    "sweepDir": 0,
    "sweepTime": 3,
    "soundLength": 0,
    "dutyCycle": 2,
    "envStepTime": 3,
    "envStepDir": 0,
    "envInitVol": 0x000B,
    "frequency": 0x0630

}, {
    "id": "PLAYER_LAND_POUND",
    "channel": 4,
    "priority": 4,
    "soundLength": 0,
    "envStepTime": 7,
    "endless": true,
    "envStepDir": 0,
    "envInitVol": 9,
    "freqRatio": 2,
    "polyStep": 0,
    "shiftFreq": 7

}, {
    "id": "PLAYER_POUND_UP_HIGH",
    "channel": 1,
    "priority": 5,
    "sweepShifts": 4,
    "sweepDir": 0,
    "sweepTime": 3,
    "soundLength": 7,
    "dutyCycle": 2,
    "envStepTime": 4,
    "envStepDir": 0,
    "envInitVol": 0x000F,
    "frequency": 0x0390

}, {
    "id": "PLAYER_POUND_UP_MED",
    "channel": 1,
    "priority": 4,
    "sweepShifts": 4,
    "sweepDir": 0,
    "sweepTime": 3,
    "soundLength": 7,
    "dutyCycle": 2,
    "envStepTime": 4,
    "envStepDir": 0,
    "envInitVol": 0x000F,
    "frequency": 0x0310

}, {
    "id": "PLAYER_POUND_UP_LOW",
    "channel": 1,
    "priority": 3,
    "sweepShifts": 4,
    "sweepDir": 0,
    "sweepTime": 3,
    "soundLength": 7,
    "dutyCycle": 2,
    "envStepTime": 4,
    "envStepDir": 0,
    "envInitVol": 0x000F,
    "frequency": 0x0230

}, {
    "id": "GAME_LOGO",
    "channel": 1,
    "priority": 1,
    "sweepShifts": 5,
    "sweepDir": 0,
    "sweepTime": 7,
    "soundLength": 0,
    "dutyCycle": 3,
    "envStepTime": 4,
    "envStepDir": 0,
    "envInitVol": 0x000C,
    "frequency": 0x0700,
    "endless": true // don't make the sound stop after the calculated length

}, {
    "id": "GAME_MENU_SELECT",
    "channel": 1,
    "priority": 1,
    "sweepShifts": 3,
    "sweepDir": 0,
    "sweepTime": 3,
    "soundLength": 0,
    "dutyCycle": 2,
    "envStepTime": 1,
    "envStepDir": 0,
    "envInitVol": 0x000C,
    "frequency": 0x0500

}, {
    "id": "PLAYER_POUND_BREAK",
    "channel": 4,
    "priority": 3,
    "soundLength": 0x2A,
    "envStepTime": 2,
    "envStepDir": 0,
    "envInitVol": 0x0D,
    "freqRatio": 2,
    "polyStep": 0,
    "shiftFreq": 6

}, {
    "id": "PLAYER_POUND_CANCEL",
    "channel": 1,
    "priority": 1,
    "sweepShifts": 3,
    "sweepDir": 1,
    "sweepTime": 6,
    "soundLength": 0,
    "dutyCycle": 2,
    "envStepTime": 3,
    "envStepDir": 0,
    "envInitVol": 0x0F,
    "frequency": 0x0600

}, {
    "id": "PLAYER_BOUNCE_WALL",
    "channel": 1,
    "priority": 2,
    "sweepShifts": 2,
    "sweepDir": 0,
    "sweepTime": 7,
    "soundLength": 0,
    "dutyCycle": 2,
    "envStepTime": 0,
    "envStepDir": 0,
    "envInitVol": 0x0F,
    "frequency": 0x0250

}, {
    "id": "MAP_FALLING_BLOCK",
    "channel": 1,
    "priority": 1,
    "sweepShifts": 5,
    "sweepDir": 0,
    "sweepTime": 2,
    "soundLength": 0x0010,
    "dutyCycle": 2,
    "envStepTime": 1,
    "envStepDir": 0,
    "envInitVol": 0x0F,
    "frequency": 0x03A0

}, {
    "id": "GAME_MENU",
    "channel": 1,
    "priority": 1,
    "sweepShifts": 3,
    "sweepDir": 0,
    "sweepTime": 4,
    "soundLength": 0,
    "dutyCycle": 2,
    "envStepTime": 7,
    "envStepDir": 0,
    "envInitVol": 0x000C,
    "frequency": 0x02C0

}, {
    "id": "SINE_WAVE",
    "channel": 3,
    "priority": 1,
    "soundLength": 0,
    "endless": true,
    "outputLevel": 0,
    "frequency": 0x744,
    "sample": [
        15, 0, 15, 0, 15, 0, 15, 0,
        15, 0, 15, 0, 15, 0, 15, 0,
        15, 0, 15, 0, 15, 0, 15, 0,
        15, 0, 15, 0, 15, 0, 15, 0
    ]
}];

