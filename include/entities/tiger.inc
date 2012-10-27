.linecont +
.ifndef TIGER_INC
TIGER_INC = 1

.enum
TIGER_STATE_INIT
TIGER_STATE_MAIN
.endenum

.define tiger_states \
  tiger_state_init, \
  tiger_state_main

tiger_lo:
  .lobytes tiger_states

tiger_hi:
  .hibytes tiger_states

tiger_update:

  entity_state_switchboard tiger_lo, tiger_hi

tiger_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #<TigerWalkSide
  sta entity_animation_address_lo,x
  lda #>TigerWalkSide
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda entity_type,x
  tay
  lda entity_type_chr_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #TIGER_STATE_MAIN
  sta entity_state,x

  rts

tiger_state_main:

  lda #<TigerWalkSide
  sta w2
  lda #>TigerWalkSide
  sta w2+1
  jsr entity_update_animation

  rts

.endif
