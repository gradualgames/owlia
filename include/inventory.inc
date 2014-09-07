.ifndef INVENTORY_INC
INVENTORY_INC = 1

INVENTORY_MAX_BOMBS = 7
INVENTORY_MAX_LANTERNS = 7
INVENTORY_MAX_HEALTHS = 7

INVENTORY_MAX_GP = 999999

INVENTORY_DUNGEON_FLAGS_MASK_NOP = 0

PASSWORD_LENGTH = 10

;for selecting which item the owl currently can carry
.enum
carry_bomb
carry_lantern
.endenum

;for selecting whether tech 1 or tech 2 is currently active
.enum
tech1
tech2
.endenum

;for selecting tech 1 and tech 2
.enum
tech_rush
tech_fetch
tech_unlock
tech_carry_bomb
tech_carry_lantern
tech_carry_adlanniel
tech_shield
tech_homing
.endenum

;for representing how many techs have been earned
.enum
tech_rush_earned
tech_fetch_earned
tech_unlock_earned
tech_carry_bomb_earned
tech_carry_lantern_earned
tech_carry_adlanniel_earned
tech_shield_earned
tech_homing_earned
.endenum

.global inventory_init
.global inventory_add_key
.global inventory_use_key
.global inventory_can_add_key
.global inventory_can_use_key
.global inventory_state_to_password_bit_field
.global password_bit_field_to_password_string

.endif
