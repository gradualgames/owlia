.ifndef URCHIN_CONSTANTS_INC
URCHIN_CONSTANTS_INC = 1

URCHIN_INITIAL_HEALTH = 5
URCHIN_ATTACKED_LENGTH = 30
URCHIN_FLASH_LENGTH = 30
URCHIN_KNOCKBACK_LENGTH = 30

URCHIN_WIDTH = $0f
URCHIN_HEIGHT = $0f

.enum
URCHIN_STATE_INIT
URCHIN_STATE_PAUSE
URCHIN_STATE_SLIDE
.endenum

URCHIN_PARAMS = 6

urchin_slide_length = entity_local0
urchin_pause_length = entity_local1
urchin_x_velocity_lo = entity_local2
urchin_x_velocity_hi = entity_local3
urchin_y_velocity_lo = entity_local4
urchin_y_velocity_hi = entity_local5

urchin_frame_counter = entity_local6
urchin_x_fine = entity_local7
urchin_y_fine = entity_local8
urchin_flash_counter = entity_local9
urchin_attacked_counter = entity_local10
urchin_knockback_counter = entity_local11
urchin_direction = entity_local12
urchin_health = entity_local13

.endif
