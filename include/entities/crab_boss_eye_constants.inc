.linecont +
.ifndef CRAB_BOSS_EYE_CONSTANTS_INC
CRAB_BOSS_EYE_CONSTANTS_INC = 1

CRAB_BOSS_EYE_WIDTH = $07
CRAB_BOSS_EYE_HEIGHT = $07
CRAB_BOSS_EYE_FETCH_X_OFFSET = 4
CRAB_BOSS_EYE_FETCH_Y_OFFSET = 16
CRAB_BOSS_EYE_ATTACKED_LENGTH = 30
CRAB_BOSS_EYE_KNOCKBACK_LENGTH = 30
CRAB_BOSS_EYE_INITIAL_HEALTH = 1

.enum
CRAB_BOSS_EYE_STATE_INIT
CRAB_BOSS_EYE_STATE_WAIT_TIL_FETCHED
CRAB_BOSS_EYE_STATE_WAIT_TIL_NOT_FETCHED
.endenum

define_entity_properties crab_boss_eye_body,\
                         crab_boss_eye_x_offset,\
                         crab_boss_eye_y_offset,\
                         crab_boss_eye_x_fine,\
                         crab_boss_eye_y_fine,\
                         crab_boss_eye_x_velocity_lo,\
                         crab_boss_eye_x_velocity_hi,\
                         crab_boss_eye_y_velocity_lo,\
                         crab_boss_eye_y_velocity_hi,\
                         crab_boss_eye_flash_counter,\
                         crab_boss_eye_knockback_counter,\
                         crab_boss_eye_health,\
                         crab_boss_eye_direction

.endif
