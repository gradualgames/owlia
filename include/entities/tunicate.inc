.linecont +
.ifndef TUNICATE_INC
TUNICATE_INC = 1

.include "projectile_constants.inc"

TUNICATE_TIME_UNTIL_FIRE_PROJECTILE = 100

TUNICATE_WIDTH = $0f
TUNICATE_HEIGHT = $0f

TUNICATE_PROJECTILE_X_OFFSET = 4
TUNICATE_PROJECTILE_Y_OFFSET = 4

TUNICATE_INITIAL_HEALTH = 3
TUNICATE_ATTACKED_LENGTH = 20
TUNICATE_FLASH_LENGTH = 20

.enum
TUNICATE_STATE_INIT
TUNICATE_STATE_MAIN
.endenum

define_entity_properties tunicate_state_counter,\
                         tunicate_projectile_direction,\
                         tunicate_health,\
                         tunicate_direction,\
                         tunicate_flash_counter,\
                         tunicate_knockback_counter

.define tunicate_states \
  tunicate_state_init, \
  tunicate_state_main

tunicate_lo:
  .lobytes tunicate_states

tunicate_hi:
  .hibytes tunicate_states

tunicate_update:

  entity_state_switchboard tunicate_lo, tunicate_hi

tunicate_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  lda #<tunicate
  sta entity_animation_address_lo,x
  lda #>tunicate
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #TUNICATE_WIDTH
  sta entity_width,x
  lda #TUNICATE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_tunicate
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #TUNICATE_INITIAL_HEALTH
  sta tunicate_health,x

  lda #0
  sta tunicate_flash_counter,x
  sta tunicate_knockback_counter,x
  sta tunicate_direction,x

  lda #TUNICATE_TIME_UNTIL_FIRE_PROJECTILE
  sta tunicate_state_counter,x

  lda #PROJECTILE_NORTH
  sta tunicate_projectile_direction,x

  lda #TUNICATE_STATE_MAIN
  sta entity_state,x

  rts

tunicate_state_main:

  entity_combat #TUNICATE_FLASH_LENGTH, #TUNICATE_ATTACKED_LENGTH, tunicate_flash_counter, tunicate_knockback_counter, tunicate_health, tunicate_direction, "entity_drop_random_item", "entity_spawn_explosion"

  .scope
  dec tunicate_state_counter,x
  bne do_not_spawn_projectile

  lda #entity_index_projectile
  sta b0

  entity_to_zp16 entity_x, w0
  entity_to_zp16 entity_y, w1
  zp16_add_im8 w0, TUNICATE_PROJECTILE_X_OFFSET
  zp16_add_im8 w1, TUNICATE_PROJECTILE_Y_OFFSET

  jsr entity_spawn

  ldy spawned_entity
  lda tunicate_projectile_direction,x
  sta projectile_direction,y

  lda #PROJECTILE_MODE_SLOW
  sta projectile_mode,y

  lda #<PROJECTILE_INITIAL_LIFE
  sta projectile_life_lo,y
  lda #>PROJECTILE_INITIAL_LIFE
  sta projectile_life_hi,y

  inc tunicate_projectile_direction,x
  lda tunicate_projectile_direction,x
  and #%00000111
  sta tunicate_projectile_direction,x

  lda #TUNICATE_TIME_UNTIL_FIRE_PROJECTILE
  sta tunicate_state_counter,x

do_not_spawn_projectile:
  .endscope

  jsr entity_update_animation

  rts

.endif
