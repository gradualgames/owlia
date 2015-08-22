.linecont +
.ifndef KRAKEN_TENTACLE_INC
KRAKEN_TENTACLE_INC = 1

.include "kraken_tentacle_constants.inc"

kraken_tentacle_attack_bent_x_offset:
  .byte 0,0,0,0,0,0,0,16,24,24,16,0,0,0,0,0,0

kraken_tentacle_attack_bent_y_offset:
  .byte 0,0,8,16,24,32,40,40,40,40,40,40,32,24,16,8,0

kraken_tentacle_attack_reverse_direction_indices:
  .byte 2*16
  .byte 2*15
  .byte 2*14
  .byte 2*13
  .byte 2*12
  .byte 2*11
  .byte 2*10
  .byte 2*9
  .byte 2*8
  .byte 2*9
  .byte 2*10
  .byte 2*11
  .byte 2*12
  .byte 2*13
  .byte 2*14
  .byte 2*15
  .byte 2*16

define_lohi_tables kraken_tentacle, \
 {kraken_tentacle_state_init, \
  kraken_tentacle_state_attack_left_init, \
  kraken_tentacle_state_attack_right_init, \
  kraken_tentacle_state_attack, \
  kraken_tentacle_state_idle, \
  kraken_tentacle_state_explode}

kraken_tentacle_update:

  entity_state_switchboard kraken_tentacle_lo, kraken_tentacle_hi

kraken_tentacle_state_init:

  jsr entity_set_is_enemy

  lda #<kraken_tentacle_attack_bent
  sta entity_animation_address_lo,x
  lda #>kraken_tentacle_attack_bent
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_kraken
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #%00000000
  sta entity_sprite_flags,x

  lda #0
  sta kraken_tentacle_direction,x
  sta kraken_tentacle_flash_counter,x
  sta kraken_tentacle_knockback_counter,x

  lda #KRAKEN_TENTACLE_INITIAL_HEALTH
  sta kraken_tentacle_health,x

  entity_move16 entity_x, kraken_tentacle_spawn_x_position
  entity_move16 entity_y, kraken_tentacle_spawn_y_position

  jsr kraken_tentacle_set_position

  lda #KRAKEN_TENTACLE_WIDTH
  sta entity_width,x
  lda #KRAKEN_TENTACLE_HEIGHT
  sta entity_height,x

  lda #KRAKEN_TENTACLE_STATE_IDLE
  sta entity_state,x

  rts

kraken_tentacle_state_attack_left_init:

  jsr entity_set_drawable

  lda #%01000000
  sta entity_sprite_flags,x

  lda #KRAKEN_TENTACLE_STATE_ATTACK
  sta entity_state,x

  rts

kraken_tentacle_state_attack_right_init:

  jsr entity_set_drawable

  lda #%00000000
  sta entity_sprite_flags,x

  lda #KRAKEN_TENTACLE_STATE_ATTACK
  sta entity_state,x

  rts

kraken_tentacle_state_attack:

  .scope
  lda entity_animation_counter,x
  cmp #1
  bne do_not_transition_yet
  lda entity_animation_frame,x
  cmp #32
  bne do_not_transition_yet

  jsr entity_clear_drawable

  jsr entity_reset_animation

  lda #0
  sta entity_x_lo,x
  sta entity_x_hi,x
  sta entity_y_lo,x
  sta entity_y_hi,x

  lda #0
  sta kraken_tentacle_direction,x
  sta kraken_tentacle_flash_counter,x
  sta kraken_tentacle_knockback_counter,x

  lda #KRAKEN_TENTACLE_STATE_IDLE
  sta entity_state,x

  rts

do_not_transition_yet:
  .endscope

  jsr entity_set_sorted

  jsr entity_update_animation

  jsr kraken_tentacle_set_position

  jsr kraken_combat

  entity_move16 kraken_tentacle_spawn_x_position, entity_x
  entity_move16 kraken_tentacle_spawn_y_position, entity_y

  .scope
  lda kraken_tentacle_flash_counter,x
  cmp #KRAKEN_TENTACLE_ATTACKED_LENGTH
  bne do_not_reverse_animation

  lda entity_animation_frame,x
  lsr
  tay
  lda kraken_tentacle_attack_reverse_direction_indices,y
  sta entity_animation_frame,x

do_not_reverse_animation:
  .endscope

  rts

kraken_tentacle_state_idle:

  jsr kraken_combat

  rts

kraken_tentacle_state_explode:

  .scope
  dec kraken_tentacle_state_counter,x
  beq die

  lda entity_sprite_flags,x
  and #%00000011
  sta b0
  inc b0
  lda b0
  and #%00000011
  sta b0
  lda entity_sprite_flags,x
  and #%11111100
  ora b0
  sta entity_sprite_flags,x

  rts
die:

  jsr entity_clear_drawable

  jsr entity_clear_shadow_spot

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts
  .endscope

.proc kraken_tentacle_set_position

  lda entity_animation_frame,x
  lsr
  tay

  .scope
  lda entity_sprite_flags,x
  and #%01000000
  bne sub
add:
  clc
  lda kraken_tentacle_spawn_x_position_lo,x
  adc kraken_tentacle_attack_bent_x_offset,y
  sta entity_x_lo,x
  lda kraken_tentacle_spawn_x_position_hi,x
  adc #0
  sta entity_x_hi,x
  jmp done
sub:
  sec
  lda kraken_tentacle_spawn_x_position_lo,x
  sbc kraken_tentacle_attack_bent_x_offset,y
  sta entity_x_lo,x
  lda kraken_tentacle_spawn_x_position_hi,x
  sbc #0
  sta entity_x_hi,x
done:
  .endscope

  clc
  lda kraken_tentacle_spawn_y_position_lo,x
  adc kraken_tentacle_attack_bent_y_offset,y
  sta entity_y_lo,x
  lda kraken_tentacle_spawn_y_position_hi,x
  adc #0
  sta entity_y_hi,x

  rts

.endproc

.proc kraken_combat

  entity_combat #KRAKEN_TENTACLE_ATTACKED_LENGTH, #KRAKEN_TENTACLE_KNOCKBACK_LENGTH, kraken_tentacle_flash_counter, kraken_tentacle_knockback_counter, kraken_tentacle_health, kraken_tentacle_direction, "entity_drop_random_item", "entity_spawn_explosion"

  .scope
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  bne not_dead

  ;keep tentacle alive so we can enter the explode state
  lda entity_flags,x
  ora #ENTITY_FLAGS_ALIVE_SET
  sta entity_flags,x

  lda #entity_index_big_explosion
  sta b0

  sec
  lda entity_x_lo,x
  sbc #<16
  sta w0
  lda entity_x_hi,x
  sbc #>16
  sta w0+1
  sec
  lda entity_y_lo,x
  sbc #<32
  sta w1
  lda entity_y_hi,x
  sbc #>32
  sta w1+1

  jsr entity_spawn

  ldy spawned_entity
  lda #31
  sta entity_width,y
  sta entity_height,y
  lda #4
  sta big_explosion_time_between_explosions,y
  lda #KRAKEN_TENTACLE_STATE_EXPLODE_LENGTH
  sta big_explosion_length,y

  lda #KRAKEN_TENTACLE_STATE_EXPLODE_LENGTH
  sta kraken_tentacle_state_counter,x

  lda #KRAKEN_TENTACLE_STATE_EXPLODE
  sta entity_state,x

not_dead:
  .endscope

  rts

.endproc

.endif
