.linecont +
.ifndef EEL_INC
EEL_INC = 1

.include "eel_constants.inc"

.define eel_states \
  eel_state_init, \
  eel_state_main

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

  lda #EEL_WIDTH
  sta entity_width,x
  lda #EEL_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_eel
  sta b0
  jsr entity_lookup_sprite_chr_offset

  .scope
  lda eel_direction_initial,x
  cmp #EEL_DIRECTION_LEFT
  beq eel_direction_left
eel_direction_right:
  lda #%01000000
  sta entity_sprite_flags,x
  jmp done
eel_direction_left:
  lda #%00000000
  sta entity_sprite_flags,x
done:
  .endscope

  lda #EEL_STATE_MAIN
  sta entity_state,x

  rts

eel_state_main:

  jsr entity_update_animation

  rts

.endif
