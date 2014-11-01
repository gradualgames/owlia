.linecont +
.ifndef EEL_INC
EEL_INC = 1

.include "eel_constants.inc"

eel_width:
  .byte 8, 16, 24, 32, 40, 48, 40, 32, 24, 16

.define eel_states \
  eel_state_init, \
  eel_state_left_init, \
  eel_state_left_wait, \
  eel_state_left, \
  eel_state_right_init, \
  eel_state_right_wait, \
  eel_state_right

eel_lo:
  .lobytes eel_states

eel_hi:
  .hibytes eel_states

eel_update:

  entity_state_switchboard eel_lo, eel_hi

eel_state_init:

  jsr entity_set_drawable

  lda #<eel
  sta entity_animation_address_lo,x
  lda #>eel
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #0
  sta entity_width,x
  lda #EEL_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_eel
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda eel_initial_state,x
  sta entity_state,x

  ;run the initial state before next frame to ensure eel is on the screen when fading in
  ;a level
  tay
  lda eel_lo,y
  sta w0
  lda eel_hi,y
  sta w0+1
  jsr indirect_jsr_w0

  rts

eel_state_left_init:

  lda #%00000000
  sta entity_sprite_flags,x

  lda #0
  sta eel_width_index,x

  lda #EEL_WIDTH_INDEX_DELAY
  sta eel_width_index_counter,x

  ;adjust initial x position to account for desired map placement (next to a rock
  ;that the eel lives in) to be consistent with right-configured eels
  clc
  lda entity_x_lo,x
  adc #<16
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>16
  sta entity_x_hi,x

  ;store initial x location, we subtract the cycling widths above from
  ;this coordinate to move the hitbox as well as adjust its width.
  ;Note this is only needed for left configured eels.
  lda entity_x_lo,x
  sta eel_initial_x_lo,x
  lda entity_x_hi,x
  sta eel_initial_x_hi,x

  ;use width index for current hitbox width
  ldy eel_width_index,x

  lda eel_width,y
  sta entity_width,x

  ;adjust position of eel against initial position, using the width
  sec
  lda eel_initial_x_lo,x
  sbc eel_width,y
  sta entity_x_lo,x
  lda eel_initial_x_hi,x
  sbc #0
  sta entity_x_hi,x
  sta entity_x_hi,x

  lda #EEL_STATE_LEFT_WAIT
  sta entity_state,x

  rts

eel_state_left_wait:

  ;test eel's line of sight as a rectangle against the hero's rectangle.
  .scope
  sec
  lda eel_initial_x_lo,x
  sbc #<EEL_LINE_OF_SIGHT_WIDTH
  sta w2
  lda eel_initial_x_hi,x
  sbc #>EEL_LINE_OF_SIGHT_WIDTH
  sta w2+1

  lda entity_y_lo,x
  sta w3
  lda entity_y_hi,x
  sta w3+1

  lda #EEL_LINE_OF_SIGHT_WIDTH
  sta b2
  lda #EEL_LINE_OF_SIGHT_HEIGHT
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
  bne hero_not_in_line_of_sight

  lda #EEL_LASH_OUT_LENGTH
  sta eel_lash_out_counter,x

  lda #EEL_STATE_LEFT
  sta entity_state,x

hero_not_in_line_of_sight:
  .endscope

  rts

eel_state_left:

  ;advance width index every few frames
  .scope
  dec eel_width_index_counter,x
  bne :+

  lda #EEL_WIDTH_INDEX_DELAY
  sta eel_width_index_counter,x

  inc eel_width_index,x
  lda eel_width_index,x
  cmp #EEL_WIDTH_INDEX_COUNT
  bne :+
  lda #0
  sta eel_width_index,x
:
  .endscope

  ;use width index for current hitbox width
  ldy eel_width_index,x

  lda eel_width,y
  sta entity_width,x

  ;adjust position of eel against initial position, using the width
  sec
  lda eel_initial_x_lo,x
  sbc eel_width,y
  sta entity_x_lo,x
  lda eel_initial_x_hi,x
  sbc #0
  sta entity_x_hi,x
  sta entity_x_hi,x

  .scope
  jsr entity_test_hero_rect
  bne :+
  lda #HERO_DIRECTION_LEFT
  sta b0
  far_call #HERO_BANK, hero_hurt
:
  .endscope

  jsr entity_update_animation

  ;count down the lash-out counter and then transition back to wait state
  dec eel_lash_out_counter,x
  bne :+
  lda #EEL_STATE_LEFT_WAIT
  sta entity_state,x
:

  rts

eel_state_right_init:

  lda #%01000000
  sta entity_sprite_flags,x

  lda #0
  sta eel_width_index,x

  lda #EEL_WIDTH_INDEX_DELAY
  sta eel_width_index_counter,x

  lda #EEL_STATE_RIGHT_WAIT
  sta entity_state,x

  rts

eel_state_right_wait:

  ;test eel's line of sight as a rectangle against the hero's rectangle.
  .scope
  lda entity_x_lo,x
  sta w2
  lda entity_x_hi,x
  sta w2+1

  lda entity_y_lo,x
  sta w3
  lda entity_y_hi,x
  sta w3+1

  lda #EEL_LINE_OF_SIGHT_WIDTH
  sta b2
  lda #EEL_LINE_OF_SIGHT_HEIGHT
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
  bne hero_not_in_line_of_sight

  lda #EEL_LASH_OUT_LENGTH
  sta eel_lash_out_counter,x

  lda #EEL_STATE_RIGHT
  sta entity_state,x

hero_not_in_line_of_sight:
  .endscope

  rts

eel_state_right:

  ;advance width index every few frames
  .scope
  dec eel_width_index_counter,x
  bne :+

  lda #EEL_WIDTH_INDEX_DELAY
  sta eel_width_index_counter,x

  inc eel_width_index,x
  lda eel_width_index,x
  cmp #EEL_WIDTH_INDEX_COUNT
  bne :+
  lda #0
  sta eel_width_index,x
:
  .endscope

  ;use width index for current hitbox width
  ldy eel_width_index,x

  lda eel_width,y
  sta entity_width,x

  .scope
  jsr entity_test_hero_rect
  bne :+
  lda #HERO_DIRECTION_RIGHT
  sta b0
  far_call #HERO_BANK, hero_hurt
:
  .endscope

  ;count down the lash-out counter and then transition back to wait state
  dec eel_lash_out_counter,x
  bne :+
  lda #EEL_STATE_RIGHT_WAIT
  sta entity_state,x
:

  jsr entity_update_animation

  rts

.endif
