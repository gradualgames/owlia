.linecont +
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

define_entity_properties target_mode,\
                         target_type,\
                         target_direction,\
                         target_speed,\
                         target_random_speed_mask,\
                         target_health,\
                         target_flash_counter,\
                         target_knockback_counter,\
                         target_points,\
                         target_shooting_gallery_index

.enum
TARGET_STATE_INIT
TARGET_STATE_MAIN
.endenum

.endif
