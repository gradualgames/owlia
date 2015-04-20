.linecont +
.ifndef MONOLITH_PUZZLE_CONSTANTS_INC
MONOLITH_PUZZLE_CONSTANTS_INC = 1

MONOLITH_PUZZLE_STATE_PAUSE = 50
MONOLITH_PUZZLE_TREASURE_CHEST_PAUSE = 150

.enum
MONOLITH_PUZZLE_STATE_INIT
MONOLITH_PUZZLE_STATE_MAIN
MONOLITH_PUZZLE_STATE_ERROR_INIT
MONOLITH_PUZZLE_STATE_ERROR
MONOLITH_PUZZLE_STATE_RESET
MONOLITH_PUZZLE_STATE_SOLVED
MONOLITH_PUZZLE_STATE_SPAWN_TREASURE_CHEST
MONOLITH_PUZZLE_STATE_LOWER_ALL_MONOLITHS_AND_DIE
.endenum

MONOLITH_PUZZLE_PARAMS = 5

define_entity_properties monolith_puzzle_dungeon_flags_mask,\
                         monolith_puzzle_solution,\
                         monolith_puzzle_treasure_chest_type,\
                         monolith_puzzle_treasure_chest_quantity_lo,\
                         monolith_puzzle_treasure_chest_quantity_hi,\
                         monolith_puzzle_monolith0,\
                         monolith_puzzle_monolith1,\
                         monolith_puzzle_monolith2,\
                         monolith_puzzle_monolith3,\
                         monolith_puzzle_solution_buffer,\
                         monolith_puzzle_solution_flags,\
                         monolith_puzzle_state_counter

.endif
