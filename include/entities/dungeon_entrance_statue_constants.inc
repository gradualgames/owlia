.linecont +
.ifndef DUNGEON_ENTRANCE_STATUE_CONSTANTS_INC
DUNGEON_ENTRANCE_STATUE_CONSTANTS_INC = 1

DUNGEON_ENTRANCE_STATUE_WIDTH = $0f
DUNGEON_ENTRANCE_STATUE_HEIGHT = $0f

DUNGEON_ENTRANCE_STATUE_STATE_DENY_ENTRY_LENGTH = 16
DUNGEON_ENTRANCE_STATUE_STATE_ALLOW_ENTRY_LENGTH = 16

.enum
DUNGEON_ENTRANCE_STATUE_STATE_INIT
DUNGEON_ENTRANCE_STATUE_STATE_MAIN
DUNGEON_ENTRANCE_STATUE_STATE_DENY_ENTRY
DUNGEON_ENTRANCE_STATUE_STATE_ALLOW_ENTRY_AND_DIE
.endenum

DUNGEON_ENTRANCE_STATUE_PARAMS = 4

define_entity_properties dungeon_entrance_statue_attribute,\
                         dungeon_entrance_statue_required_gp_lo,\
                         dungeon_entrance_statue_required_gp_hi,\
                         dungeon_entrance_statue_required_gp_hi_hi,\
                         \
                         dungeon_entrance_statue_state_counter,\
                         dungeon_entrance_statue_flash_counter

.endif
