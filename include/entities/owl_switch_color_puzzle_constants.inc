.linecont +
.ifndef OWL_SWITCH_COLOR_PUZZLE_CONSTANTS_INC
OWL_SWITCH_COLOR_PUZZLE_CONSTANTS_INC = 1

OWL_SWITCH_COLOR_PUZZLE_SOLUTION = %11100100
OWL_SWITCH_COLOR_PUZZLE_STATE_VICTORY_LENGTH = 100

OWL_SWITCH_COLOR_PUZZLE_WIDTH = $0f
OWL_SWITCH_COLOR_PUZZLE_HEIGHT = $0f

OWL_SWITCH_COLOR_PUZZLE_PARAMS = 4

define_entity_properties owl_switch_color_puzzle_dungeon_flags_mask,\
                         owl_switch_color_puzzle_treasure_chest_type,\
                         owl_switch_color_puzzle_treasure_chest_quantity_lo,\
                         owl_switch_color_puzzle_treasure_chest_quantity_hi,\
                         owl_switch_color_puzzle_solution,\
                         owl_switch_color_puzzle_state_counter

.enum
OWL_SWITCH_COLOR_PUZZLE_STATE_INIT
OWL_SWITCH_COLOR_PUZZLE_STATE_MAIN
OWL_SWITCH_COLOR_PUZZLE_STATE_VICTORY
.endenum

.endif
