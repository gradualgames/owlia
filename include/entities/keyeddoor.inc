.linecont +
.ifndef KEYEDDOOR_INC
KEYEDDOOR_INC = 1

.enum
KEYEDDOOR_STATE_INIT
KEYEDDOOR_STATE_MAIN
.endenum

.define keyeddoor_states \
  keyeddoor_state_init, \
  keyeddoor_state_main

keyeddoor_lo:
  .lobytes keyeddoor_states

keyeddoor_hi:
  .hibytes keyeddoor_states

keyeddoor_update:

  entity_state_switchboard keyeddoor_lo, keyeddoor_hi

keyeddoor_state_init:

  jsr entity_set_drawable_unsorted

  lda #<KeyedDoor
  sta entity_animation_address_lo,x
  lda #>KeyedDoor
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ;ldy #sprite_chr_group_index_keyeddoor
  ;lda sprite_chr_group_offsets,y
  ;sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #KEYEDDOOR_STATE_MAIN
  sta entity_state,x

  rts

keyeddoor_state_main:

  jsr entity_update_animation

  rts

.endif
