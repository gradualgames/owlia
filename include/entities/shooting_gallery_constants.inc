.ifndef SHOOTING_GALLERY_CONSTANTS_INC
SHOOTING_GALLERY_CONSTANTS_INC = 1

SHOOTING_GALLERY_MAX_TARGETS = 4
SHOOTING_GALLERY_PRICE = 10000
SHOOTING_GALLERY_REWARD = 20000
SHOOTING_GALLERY_GAME_TIME = 60 * 30
SHOOTING_GALLERY_WINNING_POINTS = 20
SHOOTING_GALLERY_POINTS_DISPLAY_X = 128
SHOOTING_GALLERY_POINTS_DISPLAY_Y = 8

define_entity_properties shooting_gallery_state_counter,\
                         shooting_gallery_npc_index,\
                         shooting_gallery_timer_lo,\
                         shooting_gallery_timer_hi,\
                         shooting_gallery_earned_points

.enum
SHOOTING_GALLERY_STATE_INIT
SHOOTING_GALLERY_STATE_WAIT_FOR_TEXTBOX_CONFIRM
SHOOTING_GALLERY_STATE_MAIN
.endenum

.endif
