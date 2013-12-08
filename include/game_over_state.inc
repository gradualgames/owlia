.ifndef GAME_OVER_STATE_INC
GAME_OVER_STATE_INC = 1

.include "bg_chr_data.inc"
.include "nametable_data.inc"

GAME_OVER_STATE_BG_CHR_BANK = BG_CHR_DATA_BANK2
GAME_OVER_STATE_BG_NAMETABLE_BANK = NAMETABLE_DATA_BANK1

.global game_over_state_init

.struct game_over_state_control
  ;TODO: Add state variables for game_over state (position of cursors, etc.)
.endstruct

.endif
