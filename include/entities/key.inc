.linecont +
.ifndef KEY_INC
KEY_INC = 1

.enum
KEY_STATE_INIT
KEY_STATE_MAIN
.endenum

.define key_states \
  key_state_init, \
  key_state_main

key_lo:
  .lobytes key_states

key_hi:
  .hibytes key_states

key_update:

  entity_state_switchboard key_lo, key_hi

key_state_init:

  jsr entity_set_drawable_sorted

  lda #<Key
  sta entity_animation_address_lo,x
  lda #>Key
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ldy #sprite_chr_group_index_key
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #KEY_STATE_MAIN
  sta entity_state,x

  rts

key_state_main:

  jsr entity_update_animation

  rts

.endif
