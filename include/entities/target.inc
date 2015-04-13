.feature force_range
.linecont +
.ifndef TARGET_INC
TARGET_INC = 1

.include "target_constants.inc"

define_lohi_tables target_metasprites, \
 {ship,\
  kraken,\
  owl,\
  turtle}

define_lohi_tables target, \
 {target_state_init, \
  target_state_main}

target_update:

  entity_state_switchboard target_lo, target_hi

target_state_init:

  jsr entity_set_drawable

  jsr entity_set_not_pausable

  ldy target_type,x
  lda target_metasprites_lo,y
  sta entity_animation_address_lo,x
  lda target_metasprites_hi,y
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #TARGET_WIDTH
  sta entity_width,x
  lda #TARGET_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_minigame
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #0
  sta target_flash_counter,x
  sta target_knockback_counter,x
  lda target_health,x

  lda #TARGET_STATE_MAIN
  sta entity_state,x

  rts

target_state_main:

  entity_combat #TARGET_FLASH_LENGTH, #TARGET_ATTACKED_LENGTH, target_flash_counter, target_knockback_counter, target_health, target_direction, "entity_drop_nop", "entity_spawn_ice_shards_explosion"

  .scope
  lda target_mode,x
  cmp #TARGET_MODE_RANDOM_SPEED
  bne not_random_speed
  lda rand
  and target_random_speed_mask,x
  sta target_speed,x
not_random_speed:
  .endscope

  .scope
  lda target_direction,x
  cmp #ENTITY_DIRECTION_LEFT
  beq left
  cmp #ENTITY_DIRECTION_RIGHT
  beq right
left:

  lda entity_sprite_flags,x
  ora #%01000000
  sta entity_sprite_flags,x

  sec
  lda entity_x_lo,x
  sbc target_speed,x
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #0
  sta entity_x_hi,x

  .scope
  sec
  lda entity_x_lo,x
  sbc #<(-64)
  lda entity_x_hi,x
  sbc #>(-64)
  bpl do_not_kill_target

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
do_not_kill_target:
  .endscope

  jmp done
right:

  lda entity_sprite_flags,x
  and #%10111111
  sta entity_sprite_flags,x

  clc
  lda entity_x_lo,x
  adc target_speed,x
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #0
  sta entity_x_hi,x

  .scope
  sec
  lda #<(256+64)
  sbc entity_x_lo,x
  lda #>(256+64)
  sbc entity_x_hi,x
  bpl do_not_kill_target

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
do_not_kill_target:
  .endscope

done:
  .endscope

  jsr entity_update_animation

  rts

.endif
