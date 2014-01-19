.ifndef DOOR_CONSTANTS_INC
DOOR_CONSTANTS_INC = 1

DOOR_FLASH_LENGTH = 20

DOOR_PARAMS = 3

.enum
DOOR_TYPE_UNLOCKED
DOOR_TYPE_KEYED
DOOR_TYPE_LOCKED
.endenum

.enum
DOOR_DIRECTION_EAST
DOOR_DIRECTION_WEST
DOOR_DIRECTION_SOUTH
DOOR_DIRECTION_NORTH
.endenum

door_location_index = entity_local0
door_type = entity_local1
door_orientation = entity_local2
door_flash_counter = entity_local3

.endif
