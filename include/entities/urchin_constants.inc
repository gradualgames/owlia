.linecont +
.ifndef URCHIN_CONSTANTS_INC
URCHIN_CONSTANTS_INC = 1

URCHIN_INITIAL_HEALTH = 1
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

define_entity_properties urchin_slide_length,\
                         urchin_pause_length,\
                         urchin_x_velocity_lo,\
                         urchin_x_velocity_hi,\
                         urchin_y_velocity_lo,\
                         urchin_y_velocity_hi,\
                         \
                         urchin_frame_counter,\
                         urchin_x_fine,\
                         urchin_y_fine,\
                         urchin_flash_counter,\
                         urchin_attacked_counter,\
                         urchin_knockback_counter,\
                         urchin_direction,\
                         urchin_health

.endif
