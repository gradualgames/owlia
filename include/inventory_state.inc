.ifndef INVENTORY_STATE_INC
INVENTORY_STATE_INC = 1

INVENTORY_STATE_BG_CHR_BANK = 2
INVENTORY_STATE_BG_NAMETABLE_BANK = 2
INVENTORY_STATE_SPRITE_CHR_BANK = 1

.global inventory_state_init

.struct inventory_state_control
  ;TODO: Add state variables for inventory state (position of cursors, etc.)
.endstruct

.endif
