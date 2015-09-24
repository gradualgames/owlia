.linecont +
.ifndef SWITCH_PUZZLE_CONSTANTS_INC
SWITCH_PUZZLE_CONSTANTS_INC = 1

.enum
SWITCH_PUZZLE_STATE_INIT
SWITCH_PUZZLE_STATE_MAIN
SWITCH_PUZZLE_STATE_VICTORY
SWITCH_PUZZLE_STATE_SPAWN_TREASURE_CHEST
.endenum

SWITCH_PUZZLE_PARAMS = 4

define_entity_properties switch_puzzle_entity_dungeon_flags_mask,\
                         switch_puzzle_treasure_chest_type,\
                         switch_puzzle_treasure_chest_quantity_lo,\
                         switch_puzzle_treasure_chest_quantity_hi,\
                         \
                         switch_puzzle_state_counter

.endif
