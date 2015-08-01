.linecont +
.ifndef MERMON_HEAD_INC
MERMON_HEAD_INC = 1

MERMON_HEAD_EARS_FLAP_LENGTH = 14
MERMON_HEAD_STATE_PAUSE_LENGTH = 50
MERMON_HEAD_STATE_HOME_IN_TO_RANDOM_SPOT_LENGTH = 50

MERMON_HEAD_FOLLOW_ACCELERATION = 20
MERMON_HEAD_MAX_FOLLOW_VELOCITY = 500

MERMON_HEAD_WIDTH = $0f
MERMON_HEAD_HEIGHT = $0f

mermon_head_x_lo = entity_x_lo
mermon_head_x_hi = entity_x_hi
mermon_head_y_lo = entity_y_lo
mermon_head_y_hi = entity_y_hi

define_entity_properties mermon_head_ear_animation_counter, \
                         mermon_head_ear_animation_index, \
                         mermon_head_state_counter, \
                         mermon_head_x_fine, \
                         mermon_head_y_fine, \
                         mermon_head_x_velocity_lo, \
                         mermon_head_x_velocity_hi, \
                         mermon_head_y_velocity_lo, \
                         mermon_head_y_velocity_hi

.enum
MERMON_HEAD_STATE_INIT
MERMON_HEAD_STATE_PAUSE
MERMON_HEAD_STATE_HOME_IN_TO_RANDOM_SPOT
.endenum

define_lohi_tables mermon_head_ear_animations, \
  {mermon_head_ears_forward, \
   mermon_head_ears_back}

define_lohi_tables mermon_head, \
 {mermon_head_state_init, \
  mermon_head_state_pause, \
  mermon_head_state_home_in_to_random_spot}

mermon_head_update:

  entity_state_switchboard mermon_head_lo, mermon_head_hi

mermon_head_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  jsr entity_set_not_pausable

  jsr entity_set_shadow_spot

  entity_lda16 entity_shadow_spot_x, 20
  entity_lda16 entity_shadow_spot_y, 32

  lda #<mermon_head_ears_forward
  sta entity_animation_address_lo,x
  lda #>mermon_head_ears_forward
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #MERMON_HEAD_WIDTH
  sta entity_width,x
  lda #MERMON_HEAD_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_mermon_head
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #0
  sta mermon_head_x_fine,x
  sta mermon_head_y_fine,x

  entity_lda16 mermon_head_x_velocity, 0
  entity_lda16 mermon_head_y_velocity, 0

  lda #MERMON_HEAD_EARS_FLAP_LENGTH
  sta mermon_head_ear_animation_counter,x

  lda #0
  sta mermon_head_ear_animation_index,x

  lda #MERMON_HEAD_STATE_PAUSE_LENGTH
  sta mermon_head_state_counter,x

  lda #MERMON_HEAD_STATE_PAUSE
  sta entity_state,x

  rts

mermon_head_state_pause:

  jsr mermon_head_update_ear_animation

  jsr entity_update_animation

  .scope
  dec mermon_head_state_counter,x
  bne do_not_transition_yet

  lda #MERMON_HEAD_STATE_HOME_IN_TO_RANDOM_SPOT_LENGTH
  sta mermon_head_state_counter,x

  lda #MERMON_HEAD_STATE_HOME_IN_TO_RANDOM_SPOT
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

mermon_head_state_home_in_to_random_spot:

  jsr mermon_head_float

  jsr mermon_head_update_ear_animation

  ;jsr entity_update_animation

  .scope
  dec mermon_head_state_counter,x
  bne do_not_transition_yet

  lda #MERMON_HEAD_STATE_PAUSE_LENGTH
  sta mermon_head_state_counter,x

  lda #MERMON_HEAD_STATE_PAUSE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

.proc mermon_head_update_ear_animation

  dec mermon_head_ear_animation_counter,x
  beq advance_ear_animation

  rts

advance_ear_animation:

  lda #MERMON_HEAD_EARS_FLAP_LENGTH
  sta mermon_head_ear_animation_counter,x

  clc
  lda mermon_head_ear_animation_index,x
  adc #1
  and #%00000001
  sta mermon_head_ear_animation_index,x

  ldy mermon_head_ear_animation_index,x
  lda mermon_head_ear_animations_lo,y
  sta entity_animation_address_lo,x
  lda mermon_head_ear_animations_hi,y
  sta entity_animation_address_hi,x

  rts

.endproc

.proc mermon_head_float

  .scope
  sec
  lda hero_x
  sbc entity_x_lo,x
  lda hero_x+1
  sbc entity_x_hi,x
  bmi accelerate_left
accelerate_right:

  entity_add_acceleration mermon_head_x_velocity, MERMON_HEAD_FOLLOW_ACCELERATION

  jmp done
accelerate_left:

  entity_add_acceleration mermon_head_x_velocity, (-MERMON_HEAD_FOLLOW_ACCELERATION)

done:
  .endscope

  .scope
  sec
  lda hero_y
  sbc entity_y_lo,x
  lda hero_y+1
  sbc entity_y_hi,x
  bmi accelerate_up
accelerate_down:

  entity_add_acceleration mermon_head_y_velocity, MERMON_HEAD_FOLLOW_ACCELERATION

  jmp done
accelerate_up:

  entity_add_acceleration mermon_head_y_velocity, (-MERMON_HEAD_FOLLOW_ACCELERATION)

done:
  .endscope

  .scope
  lda mermon_head_x_velocity_lo,x
  sta w0
  lda mermon_head_x_velocity_hi,x
  sta w0+1

  lda w0+1
  bmi negative
positive:

  .scope
  sec
  lda #<MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 mermon_head_x_velocity, MERMON_HEAD_MAX_FOLLOW_VELOCITY

do_not_cap:
  .endscope

  jmp done
negative:

  neg16 w0

  .scope
  sec
  lda #<MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 mermon_head_x_velocity, (-MERMON_HEAD_MAX_FOLLOW_VELOCITY)

do_not_cap:
  .endscope

done:
  .endscope

  .scope
  lda mermon_head_y_velocity_lo,x
  sta w0
  lda mermon_head_y_velocity_hi,x
  sta w0+1

  lda w0+1
  bmi negative
positive:

  .scope
  sec
  lda #<MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 mermon_head_y_velocity, MERMON_HEAD_MAX_FOLLOW_VELOCITY

do_not_cap:
  .endscope

  jmp done
negative:

  neg16 w0

  .scope
  sec
  lda #<MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 mermon_head_y_velocity, (-MERMON_HEAD_MAX_FOLLOW_VELOCITY)

do_not_cap:
  .endscope

done:
  .endscope

  entity_add_velocity mermon_head_x, mermon_head_x_velocity
  entity_add_velocity mermon_head_y, mermon_head_y_velocity

  rts

.endproc

.endif
