.ifndef DOOR_CONSTANTS_INC
DOOR_CONSTANTS_INC = 1

DOOR_FLASH_LENGTH = 20

.enum
DOOR_TYPE_UNLOCKED
DOOR_TYPE_KEYED
DOOR_TYPE_LOCKED
.endenum

door_location_index = entity_local0
door_type = entity_local1
door_flash_counter = entity_local2

.endif
