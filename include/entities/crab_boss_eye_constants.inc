.ifndef CRAB_BOSS_EYE_CONSTANTS_INC
CRAB_BOSS_EYE_CONSTANTS_INC = 1

CRAB_BOSS_EYE_WIDTH = $07
CRAB_BOSS_EYE_HEIGHT = $07
CRAB_BOSS_EYE_FETCH_X_OFFSET = 4
CRAB_BOSS_EYE_FETCH_Y_OFFSET = 16

.enum
CRAB_BOSS_EYE_STATE_INIT
CRAB_BOSS_EYE_STATE_WAIT_TIL_FETCHED
CRAB_BOSS_EYE_STATE_WAIT_TIL_NOT_FETCHED
.endenum

crab_boss_eye_body = entity_local0
crab_boss_eye_x_offset = entity_local1
crab_boss_eye_y_offset = entity_local2
crab_boss_eye_x_fine = entity_local3
crab_boss_eye_y_fine = entity_local4
crab_boss_eye_x_velocity_lo = entity_local5
crab_boss_eye_x_velocity_hi = entity_local6
crab_boss_eye_y_velocity_lo = entity_local7
crab_boss_eye_y_velocity_hi = entity_local8

.endif
