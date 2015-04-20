.linecont +
.ifndef SIMULTANEOUS_DEFEAT_PUZZLE_CONSTANTS_INC
SIMULTANEOUS_DEFEAT_PUZZLE_CONSTANTS_INC = 1

SIMULTANEOUS_DEFEAT_PUZZLE_TIMER_LENGTH = 65

.enum
SIMULTANEOUS_DEFEAT_PUZZLE_STATE_INIT
SIMULTANEOUS_DEFEAT_PUZZLE_STATE_WAIT_FOR_FIRST_KILL
SIMULTANEOUS_DEFEAT_PUZZLE_STATE_WAIT_FOR_BOTH_DEAD
SIMULTANEOUS_DEFEAT_PUZZLE_STATE_VICTORY
.endenum

SIMULTANEOUS_DEFEAT_PUZZLE_PARAMS = 1

define_entity_properties simultaneous_defeat_puzzle_dungeon_flags_mask,\
                         simultaneous_defeat_puzzle_entity_instance0,\
                         simultaneous_defeat_puzzle_entity_instance1,\
                         simultaneous_defeat_puzzle_entity_timer

.endif
