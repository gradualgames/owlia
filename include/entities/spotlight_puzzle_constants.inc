.linecont +
.ifndef SPOTLIGHT_PUZZLE_CONSTANTS_INC
SPOTLIGHT_PUZZLE_CONSTANTS_INC = 1

SPOTLIGHT_DISTANCE = 10

SPOTLIGHT_PUZZLE_PARAMS = 4

define_entity_properties spotlight_puzzle_initial_state,\
                         spotlight_dungeon_flags_mask,\
                         spotlight_puzzle_key_meta_tile_x,\
                         spotlight_puzzle_key_meta_tile_y,\
                         \
                         spotlight_index0,\
                         spotlight_index1,\
                         anglerfish_index0,\
                         anglerfish_index1,\
                         spotlight_puzzle_state_counter,\
                         spotlight_puzzle_key_tile_x_lo,\
                         spotlight_puzzle_key_tile_x_hi,\
                         spotlight_puzzle_key_tile_y_lo,\
                         spotlight_puzzle_key_tile_y_hi

.enum
SPOTLIGHT_PUZZLE_STATE_INIT
SPOTLIGHT_PUZZLE_STATE_SINGLE_ANGLERFISH
SPOTLIGHT_PUZZLE_STATE_TWIN_ANGLERFISH
SPOTLIGHT_PUZZLE_STATE_PLAY_SOLVED_MELODY
.endenum

.endif
