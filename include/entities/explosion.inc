.linecont +
.ifndef EXPLOSION_INC
EXPLOSION_INC = 1

.enum
EXPLOSION_STATE_INIT
EXPLOSION_STATE_MAIN
.endenum

explosion_frame_counter = entity_local0

.define explosion_states \
  explosion_state_init, \
  explosion_state_main

explosion_lo:
  .lobytes explosion_states

explosion_hi:
  .hibytes explosion_states

explosion_update:

  entity_state_switchboard explosion_lo, explosion_hi

explosion_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #<Explosion
  sta entity_animation_address_lo,x
  lda #>Explosion
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda entity_type,x
  tay
  lda entity_type_chr_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #6
  sta explosion_frame_counter

  lda #EXPLOSION_STATE_MAIN
  sta entity_state,x

  rts

explosion_state_main:

  dec explosion_frame_counter
  bne frame_counter_not_zero

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

frame_counter_not_zero:

  jsr entity_update_animation

  rts

.endif
