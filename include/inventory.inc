.ifndef INVENTORY_INC
INVENTORY_INC = 1

;for selecting which item the owl currently can carry
.enum
carry_bomb
carry_lantern
.endenum

;for selecting tech 1 and tech 2
.enum
tech_rush
tech_fetch
tech_sonar
tech_carry_item
tech_carry_adlanniel
tech_confuse
tech_homing
tech_multi_homing
.endenum

;for representing how many techs have been earned
.enum
tech_rush_earned
tech_fetch_earned
tech_sonar_earned
tech_carry_item_earned
tech_carry_adlanniel_earned
tech_confuse_earned
tech_homing_earned
tech_multi_homing_earned
.endenum

.global inventory_max_all

.endif
