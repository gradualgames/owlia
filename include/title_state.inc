.ifndef TITLE_STATE_INC
TITLE_STATE_INC = 1

.include "bg_chr_data.inc"
.include "nametable_data.inc"
.include "sprites_and_animations_data.inc"

TITLE_STATE_BG_CHR_BANK = BG_CHR_DATA_BANK2
TITLE_STATE_BG_NAMETABLE_BANK = NAMETABLE_DATA_BANK1
TITLE_STATE_SPRITES_AND_ANIMATIONS_BANK = SPRITES_AND_ANIMATIONS_DATA_BANK1

.global title_state_init

.struct title_state_control
  ;TODO: Add state variables for title state (position of cursors, etc.)
.endstruct

.endif
