.linecont +
.ifndef KRAKEN_INC
KRAKEN_INC = 1

KRAKEN_WIDTH = $f
KRAKEN_HEIGHT = $f

KRAKEN_INITIAL_HEALTH = 10
KRAKEN_KNOCKBACK_LENGTH = 20
KRAKEN_ATTACKED_LENGTH = 20

define_entity_properties kraken_spawn_x_position_lo,\
                         kraken_spawn_x_position_hi,\
                         kraken_spawn_y_position_lo,\
                         kraken_spawn_y_position_hi,\
                         kraken_knockback_counter,\
                         kraken_flash_counter,\
                         kraken_health,\
                         kraken_direction

kraken_tentacle_attack_bent_x_offset:
  .byte 0,0,0,0,0,0,16,24,32,24,16,0,0,0,0,0,0

kraken_tentacle_attack_bent_y_offset:
  .byte 0,8,16,24,32,40,40,40,40,40,40,40,32,24,16,8,0

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

  jsr entity_set_is_enemy

  jsr entity_set_drawable

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
  sta kraken_direction,x
  sta kraken_flash_counter,x
  sta kraken_knockback_counter,x

  lda #KRAKEN_INITIAL_HEALTH
  sta kraken_health,x

  entity_move16 entity_x, kraken_spawn_x_position
  entity_move16 entity_y, kraken_spawn_y_position

  jsr kraken_set_position

  lda #KRAKEN_WIDTH
  sta entity_width,x
  lda #KRAKEN_HEIGHT
  sta entity_height,x

  lda #KRAKEN_STATE_MAIN
  sta entity_state,x

  rts

kraken_state_main:

  jsr entity_update_animation

  jsr kraken_set_position

  entity_combat #KRAKEN_ATTACKED_LENGTH, #KRAKEN_KNOCKBACK_LENGTH, kraken_flash_counter, kraken_knockback_counter, kraken_health, kraken_direction, "entity_drop_random_item", "entity_spawn_explosion"

  rts

.proc kraken_set_position

  lda entity_animation_frame,x
  lsr
  tay

  .scope
  lda entity_sprite_flags,x
  and #%01000000
  bne sub
add:
  clc
  lda kraken_spawn_x_position_lo,x
  adc kraken_tentacle_attack_bent_x_offset,y
  sta entity_x_lo,x
  lda kraken_spawn_x_position_hi,x
  adc #0
  sta entity_x_hi,x
  jmp done
sub:
  sec
  lda kraken_spawn_x_position_lo,x
  sbc kraken_tentacle_attack_bent_x_offset,y
  sta entity_x_lo,x
  lda kraken_spawn_x_position_hi,x
  sbc #0
  sta entity_x_hi,x
done:
  .endscope


  clc
  lda kraken_spawn_y_position_lo,x
  adc kraken_tentacle_attack_bent_y_offset,y
  sta entity_y_lo,x
  lda kraken_spawn_y_position_hi,x
  adc #0
  sta entity_y_hi,x

  rts

.endproc

.endif
