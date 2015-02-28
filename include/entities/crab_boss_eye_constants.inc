.ifndef CRAB_BOSS_EYE_CONSTANTS_INC
CRAB_BOSS_EYE_CONSTANTS_INC = 1

CRAB_BOSS_EYE_WIDTH = $07
CRAB_BOSS_EYE_HEIGHT = $07
CRAB_BOSS_EYE_FETCH_X_OFFSET = 4
CRAB_BOSS_EYE_FETCH_Y_OFFSET = 16

.enum
CRAB_BOSS_EYE_STATE_INIT
CRAB_BOSS_EYE_STATE_MAIN
CRAB_BOSS_EYE_STATE_WAIT_TIL_NOT_FETCHED
.endenum

crab_boss_eye_body = entity_local0
crab_boss_eye_x_offset = entity_local1
crab_boss_eye_y_offset = entity_local2

.endif
