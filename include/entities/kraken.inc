.linecont +
.ifndef KRAKEN_INC
KRAKEN_INC = 1

.include "kraken_eye_constants.inc"
.include "kraken_tentacle_constants.inc"

PORTHOLE_Y_LOCATION = 6 * 16

KRAKEN_WIDTH = $0f
KRAKEN_HEIGHT = $0f

define_entity_properties kraken_eye_index,\
                         kraken_tentacle_index,\
                         kraken_tentacle_counter,\
                         kraken_eye_counter

define_lohi_tables porthole_x_locations, \
  {35*16,38*16,41*16,44*16, \
   35*16,38*16,41*16,44*16, \
   35*16,38*16,41*16,44*16, \
   35*16,38*16,41*16,44*16}

.enum
KRAKEN_STATE_INIT
KRAKEN_STATE_MAIN
.endenum

define_lohi_tables kraken, \
 {kraken_state_init, \
  kraken_state_main}

kraken_update:

  entity_state_switchboard kraken_lo, kraken_hi

kraken_state_init:

  ;find eye instance index
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_kraken_eye
  bne skip_entity
  jmp done
skip_entity:

  dey
  bpl next_entity
done:
  tya
  sta kraken_eye_index,x
  .endscope

  ;find tentacle instance index
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_kraken_tentacle
  bne skip_entity
  jmp done
skip_entity:

  dey
  bpl next_entity
done:
  tya
  sta kraken_tentacle_index,x
  .endscope

  lda rand
  ora #1
  sta kraken_tentacle_counter,x
  jsr next_rand
  lda rand
  ora #1
  sta kraken_eye_counter,x

  lda #KRAKEN_STATE_MAIN
  sta entity_state,x

  rts

kraken_state_main:

  .scope
  dec kraken_tentacle_counter,x
  bne do_not_trigger_tentacle

  jsr next_rand
  lda rand
  and #%00001111
  tay
  lda porthole_x_locations_lo,y
  sta w0
  lda porthole_x_locations_hi,y
  sta w0+1

  jsr next_rand
  lda rand
  ora #1
  sta kraken_tentacle_counter,x

  ldy kraken_tentacle_index,x
  lda entity_state,y
  cmp #KRAKEN_TENTACLE_STATE_IDLE
  bne do_not_trigger_tentacle

  lda w0
  sta entity_x_lo,y
  sta kraken_tentacle_spawn_x_position_lo,y
  lda w0+1
  sta entity_x_hi,y
  sta kraken_tentacle_spawn_x_position_hi,y

  .scope
  lda rand
  and #1
  beq even
odd:

  lda #KRAKEN_TENTACLE_STATE_ATTACK_LEFT_INIT
  sta entity_state,y

  jmp done
even:

  lda #KRAKEN_TENTACLE_STATE_ATTACK_RIGHT_INIT
  sta entity_state,y

done:
  .endscope

do_not_trigger_tentacle:
  .endscope

  .scope
  dec kraken_eye_counter,x
  bne do_not_trigger_eye

  jsr next_rand
  lda rand
  and #%00001111
  tay
  lda porthole_x_locations_lo,y
  sta w0
  lda porthole_x_locations_hi,y
  sta w0+1

  jsr next_rand
  lda rand
  ora #1
  sta kraken_eye_counter,x

  ldy kraken_eye_index,x
  lda entity_state,y
  cmp #KRAKEN_EYE_STATE_IDLE
  bne do_not_trigger_eye

  lda w0
  sta kraken_eye_spawn_position_x_lo,y
  lda w0+1
  sta kraken_eye_spawn_position_x_hi,y

  lda #KRAKEN_EYE_STATE_PEEK_FROM_LEFT_INIT
  sta entity_state,y

do_not_trigger_eye:
  .endscope

  rts

.endif
