.ifndef INVENTORY_STATE_INC
INVENTORY_STATE_INC = 1

INVENTORY_STATE_BG_CHR_BANK = 2
INVENTORY_STATE_BG_NAMETABLE_BANK = 2
INVENTORY_STATE_SPRITE_CHR_BANK = 1
INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK = 0
INVENTORY_STATE_BANK = 3

USE_ITEM_ROW = 13
CARRY_ITEM_ROW = 10
TECH_MENU_ROW = 17

.global inventory_state_init

.struct inventory_state_control
  cursor_row .byte
  cursor_column .byte
  menu_position .byte
  digits_chr_offset .byte
.endstruct

;menu position enumeration
.enum
menu_position_health
menu_position_owl_health
menu_position_rope
menu_position_tech1_rush
menu_position_tech1_fetch
menu_position_tech1_sonar
menu_position_tech1_carry_item
menu_position_tech1_carry_adlanniel
menu_position_tech1_confuse
menu_position_tech1_homing
menu_position_tech1_multi_homing
menu_position_tech2_rush
menu_position_tech2_fetch
menu_position_tech2_sonar
menu_position_tech2_carry_item
menu_position_tech2_carry_adlanniel
menu_position_tech2_confuse
menu_position_tech2_homing
menu_position_tech2_multi_homing
.endenum

.endif
