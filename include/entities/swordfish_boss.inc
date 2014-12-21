.linecont +
.ifndef SWORDFISH_BOSS_INC
SWORDFISH_BOSS_INC = 1

SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT_LENGTH = 80
SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT_LENGTH = 80
SWORDFISH_BOSS_STATE_LOWER_ALL_MONOLITHS_AND_DIE_LENGTH = 50

SWORDFISH_BOSS_FIN_SWIM_SPEED = 4


SWORDFISH_BOSS_WIDTH = $0f
SWORDFISH_BOSS_HEIGHT = $0f

swordfish_boss_state_counter = entity_local0

.enum
SWORDFISH_BOSS_STATE_INIT
SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT
SWORDFISH_BOSS_STATE_LOWER_ALL_MONOLITHS_AND_DIE
.endenum

.define swordfish_boss_states \
  swordfish_boss_state_init, \
  swordfish_boss_state_fin_swim_right, \
  swordfish_boss_state_fin_swim_left, \
  swordfish_boss_state_lower_all_monoliths_and_die

swordfish_boss_lo:
  .lobytes swordfish_boss_states

swordfish_boss_hi:
  .hibytes swordfish_boss_states

swordfish_boss_update:

  entity_state_switchboard swordfish_boss_lo, swordfish_boss_hi

swordfish_boss_state_init:

  ;make sure that the boss has only been encountered once
  lda inventory_earned_techs
  cmp #tech_carry_lantern
  bmi do_not_skip_swordfish_boss

  lda #SWORDFISH_BOSS_STATE_LOWER_ALL_MONOLITHS_AND_DIE_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_LOWER_ALL_MONOLITHS_AND_DIE
  sta entity_state,x

  rts

do_not_skip_swordfish_boss:

  lda #<octoboss_theme
  sta song_address
  lda #>octoboss_theme
  sta song_address+1
  far_call #SOUND_BANK, song_initialize

  jsr entity_set_not_pausable

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  lda #<swordfish_boss_fin
  sta entity_animation_address_lo,x
  lda #>swordfish_boss_fin
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SWORDFISH_BOSS_WIDTH
  sta entity_width,x
  lda #SWORDFISH_BOSS_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_swordfish_boss
  sta b0
  jsr entity_lookup_sprite_chr_offset

  sec
  lda entity_x_lo,x
  sbc #<32
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>32
  sta entity_x_hi,x

  lda #%01000000
  sta entity_sprite_flags,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
  sta entity_state,x

  rts

swordfish_boss_state_fin_swim_right:

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_switch_state

  lda #%00000000
  sta entity_sprite_flags,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  clc
  lda entity_x_lo,x
  adc #<SWORDFISH_BOSS_FIN_SWIM_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>SWORDFISH_BOSS_FIN_SWIM_SPEED
  sta entity_x_hi,x

  jsr entity_update_animation

  rts

swordfish_boss_state_fin_swim_left:

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_switch_state

  lda #%01000000
  sta entity_sprite_flags,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  sec
  lda entity_x_lo,x
  sbc #<SWORDFISH_BOSS_FIN_SWIM_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>SWORDFISH_BOSS_FIN_SWIM_SPEED
  sta entity_x_hi,x

  jsr entity_update_animation

  rts

swordfish_boss_state_lower_all_monoliths_and_die:

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_lower_monoliths_and_die_yet

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #(ENTITY_FLAGS_ALIVE_TEST)
  beq not_monolith
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith

  lda monolith_direction,y
  cmp #MONOLITH_DIRECTION_EAST
  beq e_w_monolith
  cmp #MONOLITH_DIRECTION_WEST
  beq e_w_monolith
  cmp #MONOLITH_DIRECTION_NORTH
  beq n_s_monolith
  cmp #MONOLITH_DIRECTION_SOUTH
  beq n_s_monolith
n_s_monolith:

  lda #MONOLITH_STATE_FALL_USING_COLUMNS_INIT
  sta entity_state,y

  dey
  bpl next_entity

e_w_monolith:

  lda #MONOLITH_STATE_FALL_USING_ROWS_INIT
  sta entity_state,y

  dey
  bpl next_entity

not_monolith:
  dey
  bpl next_entity
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_lower_monoliths_and_die_yet:
  .endscope

  rts

.endif
