.ifndef TARGET_CONSTANTS_INC
TARGET_CONSTANTS_INC = 1

TARGET_FLASH_LENGTH = 20
TARGET_ATTACKED_LENGTH = 20

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

TARGET_PARAMS = 8

target_mode = entity_local0
target_type = entity_local1
target_direction = entity_local2
target_speed = entity_local3
target_random_speed_mask = entity_local4
target_health = entity_local5
target_gp_lo = entity_local6
target_gp_hi = entity_local7

target_flash_counter = entity_local8
target_knockback_counter = entity_local9

.enum
TARGET_STATE_INIT
TARGET_STATE_MAIN
.endenum

.endif
