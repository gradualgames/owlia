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

.global inventory_state_init

.struct inventory_state_control
  cursor_row .byte
  cursor_column .byte
  menu_position .byte
  digits_chr_offset .byte
  string_address .word
  string_row .byte
  string_column .byte
.endstruct

;menu position enumeration
.enum
menu_position_health
menu_position_rope
menu_position_tech1_rush
menu_position_tech1_fetch
menu_position_tech1_carry_bomb
menu_position_tech1_carry_lantern
menu_position_tech1_carry_adlanniel
menu_position_tech1_shield
menu_position_tech1_homing
menu_position_tech2_rush
menu_position_tech2_fetch
menu_position_tech2_carry_bomb
menu_position_tech2_carry_lantern
menu_position_tech2_carry_adlanniel
menu_position_tech2_shield
menu_position_tech2_homing
.endenum

.endif
