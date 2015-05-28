.linecont +
.ifndef KRAKEN_EYE_INC
KRAKEN_EYE_INC = 1

KRAKEN_EYE_STATE_SLIDE_LENGTH = 8
KRAKEN_EYE_STATE_PAUSE_LENGTH = 64

KRAKEN_EYE_SPEED = 2

KRAKEN_EYE_WIDTH = $0f
KRAKEN_EYE_HEIGHT = $0f

define_entity_properties kraken_eye_state_counter,\
                         kraken_eye_x_speed_lo,\
                         kraken_eye_x_speed_hi

.enum
KRAKEN_EYE_STATE_INIT
KRAKEN_EYE_STATE_SLIDE
KRAKEN_EYE_STATE_PAUSE
.endenum

define_lohi_tables kraken_eye, \
 {kraken_eye_state_init, \
  kraken_eye_state_slide, \
  kraken_eye_state_pause}

kraken_eye_update:

  entity_state_switchboard kraken_eye_lo, kraken_eye_hi

kraken_eye_state_init:

  jsr entity_set_drawable

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

  lda #<KRAKEN_EYE_SPEED
  sta kraken_eye_x_speed_lo,x
  lda #>KRAKEN_EYE_SPEED
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

  lda #KRAKEN_EYE_STATE_PAUSE_LENGTH
  sta kraken_eye_state_counter,x

  lda #KRAKEN_EYE_STATE_PAUSE
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

  lda #KRAKEN_EYE_STATE_SLIDE
  sta entity_state,x

do_not_transition_yet:
  .endscope


  rts

.endif
