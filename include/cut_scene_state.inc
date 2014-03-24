.ifndef CUT_SCENE_STATE_INC
CUT_SCENE_STATE_INC = 1

CUT_SCENE_STATE_BANK = 1

.global play_cut_scene

.struct cut_scene_state_control
  slide_address .word
.endstruct

.endif
