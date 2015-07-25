.linecont +
.ifndef PROJECTILE_INC
PROJECTILE_INC = 1

.include "projectile_constants.inc"

define_lohi_tables projectile_x_velocity_table, \
  {0, PROJECTILE_DIAGONAL_VELOCITY, PROJECTILE_ORTHOGONAL_VELOCITY, PROJECTILE_DIAGONAL_VELOCITY, 0, -PROJECTILE_DIAGONAL_VELOCITY, -PROJECTILE_ORTHOGONAL_VELOCITY, -PROJECTILE_DIAGONAL_VELOCITY, \
   0, PROJECTILE_DIAGONAL_FAST_VELOCITY, PROJECTILE_ORTHOGONAL_FAST_VELOCITY, PROJECTILE_DIAGONAL_FAST_VELOCITY, 0, -PROJECTILE_DIAGONAL_FAST_VELOCITY, -PROJECTILE_ORTHOGONAL_FAST_VELOCITY, -PROJECTILE_DIAGONAL_FAST_VELOCITY}

define_lohi_tables projectile_y_velocity_table, \
  {-PROJECTILE_ORTHOGONAL_VELOCITY, -PROJECTILE_DIAGONAL_VELOCITY, 0, PROJECTILE_DIAGONAL_VELOCITY, PROJECTILE_ORTHOGONAL_VELOCITY, PROJECTILE_DIAGONAL_VELOCITY, 0, -PROJECTILE_DIAGONAL_VELOCITY, \
   -PROJECTILE_ORTHOGONAL_FAST_VELOCITY, -PROJECTILE_DIAGONAL_FAST_VELOCITY, 0, PROJECTILE_DIAGONAL_FAST_VELOCITY, PROJECTILE_ORTHOGONAL_FAST_VELOCITY, PROJECTILE_DIAGONAL_FAST_VELOCITY, 0, -PROJECTILE_DIAGONAL_FAST_VELOCITY}

define_lohi_tables projectile, \
 {projectile_state_init, \
  projectile_state_main}

projectile_update:

  entity_state_switchboard projectile_lo, projectile_hi

projectile_state_init:

  jsr entity_set_drawable

  lda #<explosion
  sta entity_animation_address_lo,x
  lda #>explosion
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #PROJECTILE_WIDTH
  sta entity_width,x
  lda #PROJECTILE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_explosion
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  entity_lda16 projectile_life, PROJECTILE_INITIAL_LIFE

  lda #0
  sta projectile_x_fine,x
  sta projectile_y_fine,x

  lda #PROJECTILE_STATE_MAIN
  sta entity_state,x

  rts

projectile_state_main:

  .scope
  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  jsr entity_hurt_hero

entity_not_hitting_hero:
  .endscope

  .scope
  sec
  lda projectile_life_lo,x
  sbc #<1
  sta projectile_life_lo,x
  lda projectile_life_hi,x
  sbc #>1
  sta projectile_life_hi,x

  lda projectile_life_lo,x
  ora projectile_life_hi,x
  bne not_dead

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

not_dead:
  .endscope

  clc
  lda projectile_direction,x
  adc projectile_mode,x
  tay
  lda projectile_x_velocity_table_lo,y
  sta projectile_x_velocity_lo,x
  lda projectile_x_velocity_table_hi,y
  sta projectile_x_velocity_hi,x

  lda projectile_y_velocity_table_lo,y
  sta projectile_y_velocity_lo,x
  lda projectile_y_velocity_table_hi,y
  sta projectile_y_velocity_hi,x

  entity_add_velocity projectile_x, projectile_x_velocity
  entity_add_velocity projectile_y, projectile_y_velocity

  lda projectile_life_lo,x
  and #%00000011
  sta b0

  lda entity_sprite_flags,x
  and #%11111100
  ora b0
  sta entity_sprite_flags,x

  jsr entity_update_animation

  rts

.endif
