.ifndef KRAKEN_EYE_CONSTANTS_INC
KRAKEN_EYE_CONSTANTS_INC = 1

KRAKEN_EYE_PROJECTILE_OFFSET_X = 4
KRAKEN_EYE_PROJECTILE_OFFSET_Y = 0
KRAKEN_EYE_STATE_SLIDE_LENGTH = 8
KRAKEN_EYE_STATE_PAUSE_LENGTH = 64
KRAKEN_EYE_PROJECTILE_LIFE = 75

KRAKEN_EYE_SPEED = 2

KRAKEN_EYE_WIDTH = $0f
KRAKEN_EYE_HEIGHT = $0f

.enum
KRAKEN_EYE_STATE_INIT
KRAKEN_EYE_STATE_PEEK_FROM_LEFT_INIT
KRAKEN_EYE_STATE_PEEK_FROM_RIGHT_INIT
KRAKEN_EYE_STATE_SLIDE
KRAKEN_EYE_STATE_SLIDE_BACK
KRAKEN_EYE_STATE_PAUSE
KRAKEN_EYE_STATE_IDLE
.endenum

define_entity_properties kraken_eye_spawn_position_x_lo,\
                         kraken_eye_spawn_position_x_hi,\
                         kraken_eye_spawn_position_y_lo,\
                         kraken_eye_spawn_position_y_hi,\
                         kraken_eye_state_counter,\
                         kraken_eye_x_speed_lo,\
                         kraken_eye_x_speed_hi

.endif
