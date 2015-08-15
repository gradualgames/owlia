.linecont +
.ifndef BUBBLE_INC
BUBBLE_INC = 1

.include "bubble_constants.inc"

define_lohi_tables bubble, \
 {bubble_state_init, \
  bubble_state_main}

bubble_update:

  entity_state_switchboard bubble_lo, bubble_hi

bubble_state_init:

  jsr entity_set_not_pausable

  jsr entity_set_drawable

  lda #<bubble
  sta entity_animation_address_lo,x
  lda #>bubble
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #BUBBLE_WIDTH
  sta entity_width,x
  lda #BUBBLE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_bubbles
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #0
  sta bubble_x_fine,x
  sta bubble_y_fine,x

  lda #$00
  sta entity_sprite_flags,x

  lda #BUBBLE_STATE_MAIN
  sta entity_state,x

  rts

bubble_state_main:

  dec bubble_life,x
  beq bubble_die

  entity_add_velocity bubble_x, bubble_x_velocity
  entity_add_velocity bubble_y, bubble_y_velocity

  jsr entity_update_animation

  rts

bubble_die:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

.endif
