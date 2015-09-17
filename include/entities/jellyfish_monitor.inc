.linecont +
.ifndef JELLYFISH_MONITOR_INC
JELLYFISH_MONITOR_INC = 1

.include "jellyfish_constants.inc"

.enum
JELLYFISH_MONITOR_STATE_INIT
JELLYFISH_MONITOR_STATE_MAIN
.endenum

define_lohi_tables jellyfish_monitor, \
 {jellyfish_monitor_state_init, \
  jellyfish_monitor_state_main}

jellyfish_monitor_update:

  entity_state_switchboard jellyfish_monitor_lo, jellyfish_monitor_hi

jellyfish_monitor_state_init:

  jsr entity_set_not_pausable

  lda #JELLYFISH_MONITOR_STATE_MAIN
  sta entity_state,x

  rts

jellyfish_monitor_state_main:

  ;count unpaused jellyfish and make some recede when too many are onscreen
  .scope
  lda #0
  sta b0
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_flags,y
  and #ENTITY_FLAGS_PAUSED_TEST
  bne skip_entity
  lda entity_type,y
  cmp #entity_index_jellyfish
  bne skip_entity
  tya
  sta b1
  txa
  cmp b1
  beq skip_entity

  inc b0

  lda b0
  cmp #4
  bmi :+

  lda jellyfish_knockback_counter,y
  bne :+
  lda #20
  sta jellyfish_knockback_counter,y
:

skip_entity:
  dey
  bpl next_entity
  .endscope

  rts

.endif
