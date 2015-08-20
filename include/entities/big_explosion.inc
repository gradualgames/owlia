.linecont +
.ifndef BIG_EXPLOSION_INC
BIG_EXPLOSION_INC = 1

.include "big_explosion_constants.inc"

define_lohi_tables big_explosion, \
 {big_explosion_state_init, \
  big_explosion_state_main}

big_explosion_update:

  entity_state_switchboard big_explosion_lo, big_explosion_hi

big_explosion_state_init:

  lda big_explosion_time_between_explosions,x
  sta big_explosion_state_counter,x

  lda #BIG_EXPLOSION_STATE_MAIN
  sta entity_state,x

  rts

big_explosion_state_main:

  .scope
  dec big_explosion_length,x
  beq die

  dec big_explosion_state_counter,x
  bne do_not_spawn_explosion

  jsr next_rand
  lda rand
  and #%00000011
  clc
  adc big_explosion_time_between_explosions,x
  sta big_explosion_state_counter,x

  jsr next_rand
  lda rand
  and #%00011111
  sta w1
  lda #0
  sta w1+1

  jsr next_rand
  lda rand
  and #%00011111
  sta w2
  lda #0
  sta w2+1

  lda entity_width,x
  sta w3
  lda #0
  sta w3+1

  lda entity_height,x
  sta w4
  lda #0
  sta w4+1

  sec
  lda w3
  sbc w1
  lda w3+1
  sbc w1+1
  bmi do_not_spawn_explosion

  sec
  lda w4
  sbc w2
  lda w4+1
  sbc w2+1
  bmi do_not_spawn_explosion

  clc
  lda entity_x_lo,x
  adc w1
  sta w0
  lda entity_x_hi,x
  adc w1+1
  sta w0+1

  clc
  lda entity_y_lo,x
  adc w2
  sta w1
  lda entity_y_hi,x
  adc w2+1
  sta w1+1

  lda #entity_index_explosion
  sta b0

  jsr entity_spawn

do_not_spawn_explosion:
  rts

die:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts
  .endscope

.endif
