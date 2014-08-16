.ifndef SPOTLIGHT_PUZZLE_CONSTANTS_INC
SPOTLIGHT_PUZZLE_CONSTANTS_INC = 1

SPOTLIGHT_DISTANCE = 10

SPOTLIGHT_PUZZLE_STATE_PLAY_SOLVED_MELODY_DELAY = 20

SPOTLIGHT_PUZZLE_PARAMS = 4

spotlight_puzzle_initial_state = entity_local0
spotlight_puzzle_flags_mask = entity_local1
spotlight_puzzle_key_meta_tile_x = entity_local2
spotlight_puzzle_key_meta_tile_y = entity_local3

spotlight_index0 = entity_local4
spotlight_index1 = entity_local5
anglerfish_index0 = entity_local6
anglerfish_index1 = entity_local7
spotlight_puzzle_state_counter = entity_local8

.enum
SPOTLIGHT_PUZZLE_STATE_INIT
SPOTLIGHT_PUZZLE_STATE_SINGLE_ANGLERFISH
SPOTLIGHT_PUZZLE_STATE_TWIN_ANGLERFISH
SPOTLIGHT_PUZZLE_STATE_PLAY_SOLVED_MELODY
.endenum

.endif
