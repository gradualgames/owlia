.linecont +
.ifndef PROJECTILE_INC
PROJECTILE_INC = 1

.include "projectile_constants.inc"

define_lohi_tables projectile_x_velocity, \
  {0, 1, 1, 1, 0, -1, -1, -1}

define_lohi_tables projectile_y_velocity, \
  {-1, -1, 0, 1, 1, 1, 0, -1}

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

  ldy projectile_direction,x
  entity_x_add_table_y16 entity_x, projectile_x_velocity
  entity_x_add_table_y16 entity_y, projectile_y_velocity

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
