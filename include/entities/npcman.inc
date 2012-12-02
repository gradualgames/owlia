.linecont +
.ifndef NPCMAN_INC
NPCMAN_INC = 1

.enum
NPCMAN_STATE_INIT
NPCMAN_STATE_MAIN
.endenum

.define npcman_states \
  npcman_state_init, \
  npcman_state_main

npcman_lo:
  .lobytes npcman_states

npcman_hi:
  .hibytes npcman_states

npcman_update:

  entity_state_switchboard npcman_lo, npcman_hi

npcman_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #<NpcManWalkSide
  sta entity_animation_address_lo,x
  lda #>NpcManWalkSide
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda entity_type,x
  tay
  lda entity_type_chr_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #NPCMAN_STATE_MAIN
  sta entity_state,x

  rts

npcman_state_main:

  jsr entity_update_animation

  rts

.endif
