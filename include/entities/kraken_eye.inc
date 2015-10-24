.linecont +
.ifndef KRAKEN_EYE_INC
KRAKEN_EYE_INC = 1

.include "kraken_eye_constants.inc"
.include "projectile_constants.inc"

define_lohi_tables kraken_eye, \
 {kraken_eye_state_init, \
  kraken_eye_state_peek_from_left_init, \
  kraken_eye_state_peek_from_right_init, \
  kraken_eye_state_slide, \
  kraken_eye_state_slide_back, \
  kraken_eye_state_pause, \
  kraken_eye_state_idle}

kraken_eye_update:

  entity_state_switchboard kraken_eye_lo, kraken_eye_hi

kraken_eye_state_init:

  lda #<kraken_eye
  sta entity_animation_address_lo,x
  lda #>kraken_eye
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #KRAKEN_EYE_WIDTH
  sta entity_width,x
  lda #KRAKEN_EYE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_kraken
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #%00100000
  sta entity_sprite_flags,x

  entity_move16 entity_x, kraken_eye_spawn_position_x
  entity_move16 entity_y, kraken_eye_spawn_position_y

  lda #KRAKEN_EYE_STATE_IDLE
  sta entity_state,x

  rts

kraken_eye_state_peek_from_left_init:

  jsr entity_set_drawable

  entity_move16 kraken_eye_spawn_position_x, entity_x
  entity_move16 kraken_eye_spawn_position_y, entity_y

  sec
  lda entity_x_lo,x
  sbc #<16
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>16
  sta entity_x_hi,x

  lda #<KRAKEN_EYE_SPEED
  sta kraken_eye_x_speed_lo,x
  lda #>KRAKEN_EYE_SPEED
  sta kraken_eye_x_speed_hi,x

  lda #KRAKEN_EYE_STATE_SLIDE_LENGTH
  sta kraken_eye_state_counter,x

  lda #KRAKEN_EYE_STATE_SLIDE
  sta entity_state,x

  rts

kraken_eye_state_peek_from_right_init:

  jsr entity_set_drawable

  entity_move16 kraken_eye_spawn_position_x, entity_x
  entity_move16 kraken_eye_spawn_position_y, entity_y

  clc
  lda entity_x_lo,x
  adc #<16
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>16
  sta entity_x_hi,x

  lda #<(-KRAKEN_EYE_SPEED)
  sta kraken_eye_x_speed_lo,x
  lda #>(-KRAKEN_EYE_SPEED)
  sta kraken_eye_x_speed_hi,x

  lda #KRAKEN_EYE_STATE_SLIDE_LENGTH
  sta kraken_eye_state_counter,x

  lda #KRAKEN_EYE_STATE_SLIDE
  sta entity_state,x

  rts

kraken_eye_state_slide:

  clc
  lda entity_x_lo,x
  adc kraken_eye_x_speed_lo,x
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc kraken_eye_x_speed_hi,x
  sta entity_x_hi,x

  .scope
  dec kraken_eye_state_counter,x
  bne do_not_transition_yet

  jsr kraken_eye_fire_projectile

  lda #KRAKEN_EYE_STATE_PAUSE_LENGTH
  sta kraken_eye_state_counter,x

  lda #KRAKEN_EYE_STATE_PAUSE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

kraken_eye_state_slide_back:

  clc
  lda entity_x_lo,x
  adc kraken_eye_x_speed_lo,x
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc kraken_eye_x_speed_hi,x
  sta entity_x_hi,x

  .scope
  dec kraken_eye_state_counter,x
  bne do_not_transition_yet

  lda #KRAKEN_EYE_STATE_IDLE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

kraken_eye_state_pause:

  .scope
  dec kraken_eye_state_counter,x
  bne do_not_transition_yet

  entity_neg16 kraken_eye_x_speed

  lda #KRAKEN_EYE_STATE_SLIDE_LENGTH
  sta kraken_eye_state_counter,x

  lda #KRAKEN_EYE_STATE_SLIDE_BACK
  sta entity_state,x

do_not_transition_yet:
  .endscope


  rts

three_to_five:
  .byte 3,4,5,3,4,5,3,4

kraken_eye_state_idle:

  rts

.proc kraken_eye_fire_projectile

  lda #entity_index_projectile
  sta b0

  clc
  lda entity_x_lo,x
  adc #<KRAKEN_EYE_PROJECTILE_OFFSET_X
  sta w0
  lda entity_x_hi,x
  adc #>KRAKEN_EYE_PROJECTILE_OFFSET_X
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<KRAKEN_EYE_PROJECTILE_OFFSET_Y
  sta w1
  lda entity_y_hi,x
  adc #>KRAKEN_EYE_PROJECTILE_OFFSET_Y
  sta w1+1

  jsr entity_spawn

  ;get a random number from 3 to 5
  lda rand
  and #%00000111
  tay
  lda three_to_five,y
  sta b0

  ldy spawned_entity
  lda b0
  sta projectile_direction,y

  lda #PROJECTILE_MODE_SLOW
  sta projectile_mode,y

  lda #<KRAKEN_EYE_PROJECTILE_LIFE
  sta projectile_life_lo,y
  lda #>KRAKEN_EYE_PROJECTILE_LIFE
  sta projectile_life_hi,y

  rts
.endproc

.endif
