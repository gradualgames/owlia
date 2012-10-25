.linecont +
.ifndef ENTITY_INC
ENTITY_INC = 1

.enum
ENTITY_STATE_INIT
ENTITY_STATE_MAIN
.endenum

.define entity_states \
  entity_state_init, \
  entity_state_main

entity_lo:
  .lobytes entity_states

entity_hi:
  .hibytes entity_states

entity_update:

  entity_state_switchboard entity_lo, entity_hi

entity_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  jsr entity_reset_animation

  lda #0
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #ENTITY_STATE_MAIN
  sta entity_state,x

  rts

entity_state_main:

  rts

.endif
