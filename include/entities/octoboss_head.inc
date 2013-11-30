.linecont +
.ifndef OCTOBOSS_HEAD_INC
OCTOBOSS_HEAD_INC = 1

.include "octoboss_legs_constants.inc"
.include "splash_constants.inc"

OCTOBOSS_HEAD_WIDTH = $0f
OCTOBOSS_HEAD_HEIGHT = $0f

OCTOBOSS_RISE_SPEED = 1

OCTOBOSS_HEAD_STATE_RISE_LENGTH = 48

octoboss_head_state_counter = entity_local0
octoboss_head_legs_entity_index = entity_local1
octoboss_head_splash_entity_index = entity_local2

.enum
OCTOBOSS_HEAD_STATE_INIT
OCTOBOSS_HEAD_STATE_RISE
OCTOBOSS_HEAD_STATE_FLOAT
.endenum

.define octoboss_head_states \
  octoboss_head_state_init, \
  octoboss_head_state_rise, \
  octoboss_head_state_float

octoboss_head_lo:
  .lobytes octoboss_head_states

octoboss_head_hi:
  .hibytes octoboss_head_states

octoboss_head_update:

  entity_state_switchboard octoboss_head_lo, octoboss_head_hi

octoboss_head_state_init:

  jsr entity_set_drawable

  lda #<OctobossRise
  sta entity_animation_address_lo,x
  lda #>OctobossRise
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #OCTOBOSS_HEAD_WIDTH
  sta entity_width,x
  lda #OCTOBOSS_HEAD_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_octoboss
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  ;spawn the legs
  txa
  pha

  lda #entity_index_octoboss_legs
  sta b0

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

  ;remember index of the legs entity
  stx b0

  pla
  tax

  lda b0
  sta octoboss_head_legs_entity_index,x

  ;spawn the splash
  txa
  pha

  lda #entity_index_splash
  sta b0

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

  ;remember index of the splash entity
  stx b0

  pla
  tax

  lda b0
  sta octoboss_head_splash_entity_index,x

  ;move the splash according to its offset
  ldy octoboss_head_splash_entity_index,x
  clc
  lda entity_y_lo,y
  adc #<SPLASH_Y_OFFSET
  sta entity_y_lo,y
  lda entity_y_hi,y
  adc #>SPLASH_Y_OFFSET
  sta entity_y_hi,y

  lda #OCTOBOSS_HEAD_STATE_RISE_LENGTH
  sta octoboss_head_state_counter,x

  lda #OCTOBOSS_HEAD_STATE_RISE
  sta entity_state,x

  rts

octoboss_head_state_rise:

  sec
  lda entity_y_lo,x
  sbc #<OCTOBOSS_RISE_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #>OCTOBOSS_RISE_SPEED
  sta entity_y_hi,x

  jsr entity_update_animation

  dec octoboss_head_state_counter,x
  bne do_not_switch_to_float_state

  ;tell the splash entity to hide itself
  ldy octoboss_head_splash_entity_index,x
  lda #SPLASH_STATE_HIDE
  sta entity_state,y

  ;tell the legs to start drawing themselves and dangle
  ldy octoboss_head_legs_entity_index,x
  lda #OCTOBOSS_LEGS_STATE_DANGLE_INIT
  sta entity_state,y

  ;move the legs to beneath the head
  clc
  lda entity_y_lo,x
  adc #<OCTOBOSS_LEGS_Y_OFFSET
  sta entity_y_lo,y
  lda entity_y_hi,x
  adc #>OCTOBOSS_LEGS_Y_OFFSET
  sta entity_y_hi,y

  lda #<OctobossHead
  sta entity_animation_address_lo,x
  lda #>OctobossHead
  sta entity_animation_address_hi,x

  lda #OCTOBOSS_HEAD_STATE_FLOAT
  sta entity_state,x

do_not_switch_to_float_state:

  rts

octoboss_head_state_float:

  jsr entity_update_animation

  rts

.endif
