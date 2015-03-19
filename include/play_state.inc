.ifndef PLAY_STATE_INC
PLAY_STATE_INC = 1

.global play_state_initialize
.global play_state_load_location
.global play_state_load_location_x
.global play_state
.global play_state_reload

.struct play_state_control
  action .byte
  param  .word
  monolith_index .byte
.endstruct

;actions 0 thru 15 are reserved for use by the map (or anybody else)
;because metatiles only can represent 4 bits for specifying an action
;to run. Actions 16 and up can be used by anybody else.
.enum
ACTION_NOP
ACTION_GOTO_LOCATION_GROUP1
ACTION_SCROLLTO_LOCATION_GROUP1
ACTION_START_CONVERSATION
ACTION_SHOW_INVENTORY_SCREEN
ACTION_GAME_OVER
ACTION_PLAY_CUT_SCENE
ACTION_CARRY_TO
.endenum

.enum
SCROLL_DIRECTION_EAST
SCROLL_DIRECTION_WEST
SCROLL_DIRECTION_SOUTH
SCROLL_DIRECTION_NORTH
.endenum

.endif
