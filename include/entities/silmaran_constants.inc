.ifndef SILMARAN_CONSTANTS_INC
SILMARAN_CONSTANTS_INC = 1

SILMARAN_EARNED_TECH = tech_unlock

SILMARAN_FLAGS_CHECK_SUMMON_RECT_SET   = %00000001
SILMARAN_FLAGS_CHECK_SUMMON_RECT_TEST  = %00000001
SILMARAN_FLAGS_EARN_UNLOCK_TECH_SET    = %00000010
SILMARAN_FLAGS_EARN_UNLOCK_TECH_TEST   = %00000010
SILMARAN_FLAGS_FINAL_ENCOUNTER_SET     = %00000100
SILMARAN_FLAGS_FINAL_ENCOUNTER_TEST    = %00000100

SILMARAN_SUMMON_RECT_X = (1 * 16)
SILMARAN_SUMMON_RECT_Y = (24 * 16)
SILMARAN_SUMMON_RECT_WIDTH = (16 - 1)
SILMARAN_SUMMON_RECT_HEIGHT = (16 * 2 - 1)

SILMARAN_OFFSCREEN_X_OFFSET = 16
SILMARAN_OFFSCREEN_Y_OFFSET = 200

SILMARAN_PERCH_X_OFFSET = 8

SILMARAN_WIDTH = $0f
SILMARAN_HEIGHT = $0f

SILMARAN_PARAMS = 9

define_entity_properties silmaran_flags,\
                         silmaran_initial_state,\
                         silmaran_conversation,\
                         silmaran_top_left_screen_x_lo,\
                         silmaran_top_left_screen_x_hi,\
                         silmaran_top_left_screen_y_lo,\
                         silmaran_top_left_screen_y_hi,\
                         silmaran_perch_y_lo,\
                         silmaran_perch_y_hi,\
                         silmaran_state_counter,\
                         silmaran_x_fine,\
                         silmaran_y_fine,\
                         silmaran_velocity_x_lo,\
                         silmaran_velocity_x_hi,\
                         silmaran_velocity_y_lo,\
                         silmaran_velocity_y_hi

SILMARAN_STATE_ASCEND_LENGTH = 200
SILMARAN_STATE_SUMMON_ADLANNIEL_LENGTH = 8
SILMARAN_FLY_AWAY_SPEED = 1
SILMARAN_STATE_LOWER_ALL_MONOLITHS_AND_DIE_LENGTH = 50
SILMARAN_STATE_FLY_TO_HERO_LENGTH = 50
SILMARAN_HERO_OFFSET_X = 16
SILMARAN_HERO_OFFSET_Y = 16

.enum
SILMARAN_STATE_INIT
SILMARAN_STATE_WAIT
SILMARAN_STATE_ALIGN_CAMERA_HORIZ
SILMARAN_STATE_ALIGN_CAMERA_VERT
SILMARAN_STATE_DESCEND
SILMARAN_STATE_PERCH
SILMARAN_STATE_ASCEND
SILMARAN_STATE_SUMMON_ADLANNIEL
SILMARAN_STATE_FLY_TO_HERO_INIT
SILMARAN_STATE_FLY_TO_HERO
SILMARAN_STATE_FLY_AWAY_INIT
SILMARAN_STATE_FLY_AWAY
SILMARAN_STATE_LEAVE_DUNGEON
.endenum

.endif
