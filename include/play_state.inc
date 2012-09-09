.ifndef PLAY_STATE_INC
PLAY_STATE_INC = 1

.global play_state_load_area
.global play_state

.struct play_state_control
  action .byte
  param  .byte
.endstruct

.endif
