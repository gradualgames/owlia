.linecont +
.ifndef OCTOBOSS_LEGS_INC
OCTOBOSS_LEGS_INC = 1

.include "octoboss_legs_constants.inc"

OCTOBOSS_LEGS_WIDTH = $0f
OCTOBOSS_LEGS_HEIGHT = $0f

OCTOBOSS_LEGS_STATE_PUNCH_LENGTH = 52

octoboss_legs_state_counter = entity_local0
octoboss_legs_punch_y_offset = entity_local1
octoboss_legs_punch_y_velocity = entity_local2

.define octoboss_legs_states \
  octoboss_legs_state_init, \
  octoboss_legs_state_nop, \
  octoboss_legs_state_dangle_init, \
  octoboss_legs_state_dangle, \
  octoboss_legs_state_punch_init, \
  octoboss_legs_state_punch, \
  octoboss_legs_state_die

octoboss_legs_lo:
  .lobytes octoboss_legs_states

octoboss_legs_hi:
  .hibytes octoboss_legs_states

octoboss_legs_update:

  entity_state_switchboard octoboss_legs_lo, octoboss_legs_hi

octoboss_legs_state_init:

  jsr entity_clear_drawable

  lda #OCTOBOSS_LEGS_WIDTH
  sta entity_width,x
  lda #OCTOBOSS_LEGS_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_octoboss
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  ;put legs into a passive state til the head tells them what to do
  lda #OCTOBOSS_LEGS_STATE_NOP
  sta entity_state,x

  rts

octoboss_legs_state_nop:

  rts

octoboss_legs_state_dangle_init:

  jsr entity_set_drawable

  lda #<octoboss_legs_dangle
  sta entity_animation_address_lo,x
  lda #>octoboss_legs_dangle
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #OCTOBOSS_LEGS_STATE_DANGLE
  sta entity_state,x

  jmp octoboss_legs_state_dangle

octoboss_legs_state_dangle:

  jsr entity_update_animation

  rts

octoboss_legs_state_punch_init:

  ;play a sound
  txa
  pha

  lda #<sfx_octoboss_punch
  sta sound_param_word_0
  lda #>sfx_octoboss_punch
  sta sound_param_word_0+1

  lda #2
  sta sound_param_byte_0

  ldx #soundeffect_one
  far_call #SFX_BANK, stream_initialize

  pla
  tax

  lda #<octoboss_legs_punch
  sta entity_animation_address_lo,x
  lda #>octoboss_legs_punch
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #(8*3)
  sta octoboss_legs_punch_y_offset,x

  lda #4
  sta octoboss_legs_punch_y_velocity,x

  lda #OCTOBOSS_LEGS_STATE_PUNCH_LENGTH
  sta octoboss_legs_state_counter,x

  lda #OCTOBOSS_LEGS_STATE_PUNCH
  sta entity_state,x
  jmp octoboss_legs_state_punch

octoboss_legs_state_punch:

  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  clc
  lda entity_x_lo,x
  adc #$08
  sta w2
  lda entity_x_hi,x
  adc #$00
  sta w2+1

  lda entity_y_lo,x
  sta w3
  lda entity_y_hi,x
  sta w3+1
  lda #8
  sta b2
  lda octoboss_legs_punch_y_offset,x
  sta b3

  ;transfer hero rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda hero_x
  sta w4
  lda hero_x+1
  sta w4+1
  lda hero_y
  sta w5
  lda hero_y+1
  sta w5+1
  lda hero_width
  sta b4
  lda hero_height
  sta b5

  jsr geotests_rect_in_rect_size

  bne tentacle_not_hitting_hero

  lda #HERO_DIRECTION_DOWN
  sta b0
  far_call #HERO_BANK, hero_hurt

tentacle_not_hitting_hero:

  clc
  lda octoboss_legs_punch_y_offset,x
  adc octoboss_legs_punch_y_velocity,x
  sta octoboss_legs_punch_y_offset,x

  lda octoboss_legs_punch_y_offset,x
  cmp #(8 * 16)
  bne do_not_reverse_punch_velocity

  clc
  lda octoboss_legs_punch_y_velocity,x
  eor #$ff
  adc #$01
  sta octoboss_legs_punch_y_velocity,x

do_not_reverse_punch_velocity:

  .scope
  dec octoboss_legs_state_counter,x
  bne do_not_switch_state

  lda #OCTOBOSS_LEGS_STATE_DANGLE_INIT
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr entity_update_animation

  rts

octoboss_legs_state_die:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  lda #entity_index_explosion
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

  rts

.endif
