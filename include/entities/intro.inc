.linecont +
.ifndef INTRO_INC
INTRO_INC = 1

INTRO_WIDTH = $0f
INTRO_HEIGHT = $0f

intro_state_counter = entity_local0
intro_script_index = entity_local1

.enum
INTRO_STATE_INIT
INTRO_STATE_WALK_TO_TYTO
INTRO_STATE_CALL_TYTO
INTRO_STATE_TYTO_AWAKEN
INTRO_STATE_TYTO_TO_ME
INTRO_STATE_FLY_TO_ADLANNIEL
.endenum

;These LUTs are used to move Adlanniel until she is
;facing Tyto
walk_to_tyto_frames:
  .byte 50
  .byte 32
  .byte 44
  .byte 0

walk_to_tyto_down_button:
  .byte 1
  .byte 0
  .byte 0

walk_to_tyto_right_button:
  .byte 0
  .byte 1
  .byte 0

walk_to_tyto_up_button:
  .byte 0
  .byte 0
  .byte 1

.define intro_states \
  intro_state_init, \
  intro_state_walk_to_tyto, \
  intro_state_call_tyto, \
  intro_state_tyto_awaken, \
  intro_state_tyto_to_me, \
  intro_state_fly_to_adlanniel

intro_lo:
  .lobytes intro_states

intro_hi:
  .hibytes intro_states

intro_update:

  entity_state_switchboard intro_lo, intro_hi

intro_state_init:

  jsr entity_set_drawable

  lda #<TytoWake
  sta entity_animation_address_lo,x
  lda #>TytoWake
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #INTRO_WIDTH
  sta entity_width,x
  lda #INTRO_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_tyto
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  ;take over the controller. This is the intro cut scene and we
  ;don't want the player trying to do anything while it completes.
  jsr controller_clear
  set_controller_routine controller_nop

  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_house_intro_scene_window
  sta state_control_params+play_state_control::param

  lda #0
  sta intro_script_index,x
  tay
  lda walk_to_tyto_frames,y
  sta intro_state_counter,x

  lda #INTRO_STATE_WALK_TO_TYTO
  sta entity_state,x

  rts

intro_state_walk_to_tyto:

  ldy intro_script_index,x

  lda walk_to_tyto_up_button,y
  sta buffer_controller+buttons::_up

  lda walk_to_tyto_down_button,y
  sta buffer_controller+buttons::_down

  lda walk_to_tyto_right_button,y
  sta buffer_controller+buttons::_right

  dec intro_state_counter,x
  bne do_not_get_next_walk_to_tyto_step

  inc intro_script_index,x
  ldy intro_script_index,x
  lda walk_to_tyto_frames,y
  sta intro_state_counter,x
  bne do_not_switch_to_call_tyto_state

  lda #0
  sta buffer_controller+buttons::_up
  sta buffer_controller+buttons::_down
  sta buffer_controller+buttons::_right

  lda #INTRO_STATE_CALL_TYTO
  sta entity_state,x

do_not_switch_to_call_tyto_state:

do_not_get_next_walk_to_tyto_step:

  rts

intro_state_call_tyto:

  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_house_intro_scene_call_tyto1
  sta state_control_params+play_state_control::param

  lda #64
  sta intro_state_counter,x

  lda #INTRO_STATE_TYTO_AWAKEN
  sta entity_state,x

  rts

intro_state_tyto_awaken:

  jsr entity_update_animation

  dec intro_state_counter,x
  bne do_not_switch_to_to_me_state

  lda #INTRO_STATE_TYTO_TO_ME
  sta entity_state,x

do_not_switch_to_to_me_state:

  rts

intro_state_tyto_to_me:

  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_house_intro_scene_call_tyto2
  sta state_control_params+play_state_control::param

  lda #INTRO_STATE_FLY_TO_ADLANNIEL
  sta entity_state,x

  rts

intro_state_fly_to_adlanniel:

  jsr entity_clear_drawable

  lda entity_x_lo,x
  sta familiar_x
  lda entity_x_hi,x
  sta familiar_x+1

  lda entity_y_lo,x
  sta familiar_y
  lda entity_y_hi,x
  sta familiar_y+1

  lda #FAMILIAR_DIRECTION_DOWN
  sta familiar_direction

  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_state

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  far_call #FAMILIAR_BANK, familiar_common_init

  far_call #FAMILIAR_BANK, familiar_play_flap_sound

  ;restore control to the player
  lda #$ff
  jsr controller_fill_buffer_with_accumulator
  set_controller_routine controller_read

  ;but wait some frames before really taking control
  lda #50
  sta b0
  far_call #HERO_BANK, hero_wait_frames

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

.endif
