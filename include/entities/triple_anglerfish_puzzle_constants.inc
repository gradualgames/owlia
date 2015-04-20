.linecont +
.ifndef TRIPLE_ANGLERFISH_PUZZLE_CONSTANTS_INC
TRIPLE_ANGLERFISH_PUZZLE_CONSTANTS_INC = 1

TRIPLE_ANGLERFISH_PUZZLE_WIDTH = $0f
TRIPLE_ANGLERFISH_PUZZLE_HEIGHT = $0f

TRIPLE_ANGLERFISH_PUZZLE_PARAMS = 7

define_entity_properties triple_anglerfish_puzzle_spot0_x_lo,\
                         triple_anglerfish_puzzle_spot0_y_lo,\
                         triple_anglerfish_puzzle_spot1_x_lo,\
                         triple_anglerfish_puzzle_spot1_y_lo,\
                         triple_anglerfish_puzzle_spot2_x_lo,\
                         triple_anglerfish_puzzle_spot2_y_lo,\
                         triple_anglerfish_puzzle_dungeon_flags_mask,\
                         \
                         triple_anglerfish_puzzle_spot0_x_hi,\
                         triple_anglerfish_puzzle_spot0_y_hi,\
                         triple_anglerfish_puzzle_spot1_x_hi,\
                         triple_anglerfish_puzzle_spot1_y_hi,\
                         triple_anglerfish_puzzle_spot2_x_hi,\
                         triple_anglerfish_puzzle_spot2_y_hi,\
                         \
                         triple_anglerfish_puzzle_spotlight0,\
                         triple_anglerfish_puzzle_spotlight1,\
                         triple_anglerfish_puzzle_spotlight2,\
                         \
                         triple_anglerfish_puzzle_anglerfish0,\
                         triple_anglerfish_puzzle_anglerfish1,\
                         triple_anglerfish_puzzle_anglerfish2,\
                         \
                         triple_anglerfish_puzzle_state_counter

.enum
TRIPLE_ANGLERFISH_PUZZLE_STATE_INIT
TRIPLE_ANGLERFISH_PUZZLE_STATE_MAIN
TRIPLE_ANGLERFISH_PUZZLE_STATE_KILL_ANGLERFISH
TRIPLE_ANGLERFISH_PUZZLE_STATE_SPAWN_TREASURE_CHEST
.endenum

.endif
