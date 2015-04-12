.ifndef TARGET_CONSTANTS_INC
TARGET_CONSTANTS_INC = 1

.enum
TARGET_MODE_NORMAL
TARGET_MODE_RANDOM_SPEED
.endenum

.enum
TARGET_TYPE_SHIP
TARGET_TYPE_KRAKEN
TARGET_TYPE_OWL
TARGET_TYPE_TURTLE
.endenum

TARGET_WIDTH = $0f
TARGET_HEIGHT = $0f

TARGET_PARAMS = 5

target_mode = entity_local0
target_type = entity_local1
target_direction = entity_local2
target_speed = entity_local3
target_random_speed_mask = entity_local4

.enum
TARGET_STATE_INIT
TARGET_STATE_MAIN
.endenum

.endif
