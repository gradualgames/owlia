.ifndef TITLE_STATE_INC
TITLE_STATE_INC = 1

.include "bg_chr_data.inc"

TITLE_STATE_BG_CHR_BANK = BG_CHR_DATA_BANK2
TITLE_STATE_BG_NAMETABLE_BANK = 2
TITLE_STATE_SPRITES_AND_ANIMATIONS_BANK = 6

.global title_state_init

.struct title_state_control
  ;TODO: Add state variables for title state (position of cursors, etc.)
.endstruct

.endif
