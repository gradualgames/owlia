.linecont +
.ifndef BOMB_INC
BOMB_INC = 1

.enum
BOMB_STATE_INIT
BOMB_STATE_MAIN
.endenum

.define bomb_states \
  bomb_state_init, \
  bomb_state_main

bomb_lo:
  .lobytes bomb_states

bomb_hi:
  .hibytes bomb_states

bomb_update:

  entity_state_switchboard bomb_lo, bomb_hi

bomb_state_init:

  jsr entity_set_drawable_unsorted

  lda #<Bomb
  sta entity_animation_address_lo,x
  lda #>Bomb
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_bomb
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #BOMB_STATE_MAIN
  sta entity_state,x

  rts

bomb_state_main:

  jsr entity_update_animation

  rts

.endif
