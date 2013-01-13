.linecont +
.ifndef EXPLOSION_INC
EXPLOSION_INC = 1

.enum
EXPLOSION_STATE_INIT
EXPLOSION_STATE_MAIN
.endenum

EXPLOSION_COUNT = 5
EXPLOSION_DELAY = 6

explosion_counter = entity_local0
explosion_frame_counter = entity_local1
explosion_random_offset_x = entity_local2
explosion_random_offset_x_masked = entity_local3
explosion_random_offset_y = entity_local4
explosion_random_offset_y_masked = entity_local5

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

  ldy #sprite_chr_group_index_explosion
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #EXPLOSION_COUNT
  sta explosion_counter,x

  lda #EXPLOSION_DELAY
  sta explosion_frame_counter,x

  lda #EXPLOSION_STATE_MAIN
  sta entity_state,x

  ;start the pseudo random number with a variable that is
  ;frequently influenced by the human player
  lda hero_x
  sta explosion_random_offset_x,x
  lda hero_y
  sta explosion_random_offset_y,x

  ;play a sound
  txa
  pha

  lda #<sfx_explosion
  sta sound_param_word_0
  lda #>sfx_explosion
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  rts

explosion_state_main:

  dec explosion_frame_counter,x
  bne frame_counter_not_zero

  ;reset frame counter
  lda #EXPLOSION_DELAY
  sta explosion_frame_counter,x

  ;update the pseudo random number
  lda explosion_random_offset_x,x
  ror
  eor #$ff
  sta explosion_random_offset_x,x
  and #%00001111
  sta explosion_random_offset_x_masked,x

  lda explosion_random_offset_y,x
  ror
  eor #$ff
  sta explosion_random_offset_y,x
  and #%00001111
  sta explosion_random_offset_y_masked,x

  ;use spawn position and pseudo random number to determine x and y coordinates this frame
  lda entity_spawn_x_lo,x
  sta entity_x_lo,x
  lda entity_spawn_x_hi,x
  sta entity_x_hi,x
  clc
  lda entity_spawn_x_lo,x
  adc explosion_random_offset_x_masked,x
  sta entity_x_lo,x
  lda entity_spawn_x_hi,x
  adc #$00
  sta entity_x_hi,x

  clc
  lda entity_spawn_y_lo,x
  adc explosion_random_offset_y_masked,x
  sta entity_y_lo,x
  lda entity_spawn_y_hi,x
  adc #$00
  sta entity_y_hi,x

  dec explosion_counter,x
  bne explosion_counter_not_zero

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
frame_counter_not_zero:
explosion_counter_not_zero:

  jsr entity_update_animation

  rts

.endif
