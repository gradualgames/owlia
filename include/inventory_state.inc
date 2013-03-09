.ifndef INVENTORY_STATE_INC
INVENTORY_STATE_INC = 1

INVENTORY_STATE_BG_CHR_BANK = 2
INVENTORY_STATE_BG_NAMETABLE_BANK = 2
INVENTORY_STATE_SPRITE_CHR_BANK = 1
INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK = 0
INVENTORY_STATE_BANK = 3

.global inventory_state_init

.struct inventory_state_control
  cursor_row .byte
  cursor_column .byte
  menu_position .byte
  dpad_direction .byte
.endstruct

.enum
DPAD_NOP
DPAD_RIGHT
DPAD_LEFT
DPAD_DOWN
DPAD_UP
.endenum

.endif
