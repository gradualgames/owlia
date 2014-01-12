.ifndef INVENTORY_STATE_INC
INVENTORY_STATE_INC = 1

.include "bg_chr_data.inc"
.include "nametable_data.inc"
.include "sprites_and_animations_data.inc"

INVENTORY_STATE_BG_CHR_BANK = BG_CHR_DATA_BANK1
INVENTORY_STATE_BG_NAMETABLE_BANK = NAMETABLE_DATA_BANK1
INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK = SPRITES_AND_ANIMATIONS_DATA_BANK1
INVENTORY_STATE_BANK = 1

USE_ITEM_ROW = 13
CARRY_LANTERN_ROW = 10

TECH_MENU_ROW = 17
TECH_MENU_COLUMN = 13
TECH1_OFFSET = -4
TECH2_OFFSET = -2

.global inventory_state_init

.struct inventory_state_control
  current_menu_position_address .word
  digits_chr_offset .byte
  string_address .word
  string_row .byte
  string_column .byte
.endstruct

.struct inventory_state_menu_position
  is_enabled_callback_address .word
  a_button_callback_address .word
  a_button_callback_param .byte
  next_menu_item_up_address .word
  next_menu_item_right_address .word
  next_menu_item_left_address .word
  next_menu_item_down_address .word
  cursor_metasprite .word
  cursor_row .byte
  cursor_column .byte
.endstruct

.macro a_button_callback_param value
  .byte value
.endmacro

.macro next_up menu_item_address
  .word menu_item_address
.endmacro

.macro next_right menu_item_address
  .word menu_item_address
.endmacro

.macro next_left menu_item_address
  .word menu_item_address
.endmacro

.macro next_down menu_item_address
  .word menu_item_address
.endmacro

.struct inventory_state_menu_item
  item_address .word
  item_row .byte
  item_column .byte
.endstruct

LAST_MENU_ITEM = 0

.endif
