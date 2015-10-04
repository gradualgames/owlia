.linecont +
.ifndef ORDERED_DEFEAT_PUZZLE_CONSTANTS_INC
ORDERED_DEFEAT_PUZZLE_CONSTANTS_INC = 1

.enum
ORDERED_DEFEAT_PUZZLE_STATE_INIT
ORDERED_DEFEAT_PUZZLE_STATE_STEP0
ORDERED_DEFEAT_PUZZLE_STATE_STEP1
ORDERED_DEFEAT_PUZZLE_STATE_STEP2
ORDERED_DEFEAT_PUZZLE_STATE_VICTORY
ORDERED_DEFEAT_PUZZLE_STATE_SPAWN_TREASURE_CHEST
ORDERED_DEFEAT_PUZZLE_STATE_FAIL
.endenum

ORDERED_DEFEAT_PUZZLE_PARAMS = 7

define_entity_properties ordered_defeat_puzzle_entity_type0,\
                         ordered_defeat_puzzle_entity_type1,\
                         ordered_defeat_puzzle_entity_type2,\
                         ordered_defeat_puzzle_entity_dungeon_flags_mask,\
                         ordered_defeat_puzzle_treasure_chest_type,\
                         ordered_defeat_puzzle_treasure_chest_quantity_lo,\
                         ordered_defeat_puzzle_treasure_chest_quantity_hi,\
                         ordered_defeat_puzzle_entity_instance0,\
                         ordered_defeat_puzzle_entity_instance1,\
                         ordered_defeat_puzzle_entity_instance2,\
                         ordered_defeat_puzzle_step,\
                         ordered_defeat_puzzle_state_counter

.endif
