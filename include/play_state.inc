.ifndef PLAY_STATE_INC
PLAY_STATE_INC = 1

.global play_state_initialize
.global play_state_load_location
.global play_state
.global play_state_reload

.struct play_state_control
  action .byte
  param  .word
  monolith_index .byte
  palette_cycling_disabled .byte
.endstruct

.enum
SCROLL_DIRECTION_EAST
SCROLL_DIRECTION_WEST
SCROLL_DIRECTION_SOUTH
SCROLL_DIRECTION_NORTH
.endenum

.endif
