.linecont +
.ifndef SWORDFISH_BOSS_INC
SWORDFISH_BOSS_INC = 1

SWORDFISH_BOSS_SWIM_LEFT_LENGTH = 96
SWORDFISH_BOSS_SWIM_RIGHT_LENGTH = 96
SWORDFISH_BOSS_STATE_LOWER_ALL_MONOLITHS_AND_DIE_LENGTH = 50

SWORDFISH_BOSS_RANDOM_NUMBER_SEED = 10
SWORDFISH_BOSS_SWIM_SPEED = 4
SWORDFISH_BOSS_FIN_LAPS_TIL_CHARGE = 2

SWORDFISH_BOSS_RANDOM_NUMBER_OFFSET_MASK = %00111111
SWORDFISH_BOSS_FIN_SWIM_Y = 30
SWORDFISH_BOSS_CHARGE_Y = 80

SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_X = 24
SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_Y = 32

SWORDFISH_BOSS_WIDTH = $0f
SWORDFISH_BOSS_HEIGHT = $0f

swordfish_boss_state_counter = entity_local0
swordfish_boss_fin_lap_counter = entity_local1
swordfish_boss_pseudo_random_number = entity_local2

.enum
SWORDFISH_BOSS_STATE_INIT
SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT
SWORDFISH_BOSS_STATE_CHARGE_RIGHT
SWORDFISH_BOSS_STATE_CHARGE_LEFT
SWORDFISH_BOSS_STATE_LOWER_ALL_MONOLITHS_AND_DIE
.endenum

.define swordfish_boss_states \
  swordfish_boss_state_init, \
  swordfish_boss_state_fin_swim_right, \
  swordfish_boss_state_fin_swim_left, \
  swordfish_boss_state_charge_right, \
  swordfish_boss_state_charge_left, \
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

  lda #SWORDFISH_BOSS_RANDOM_NUMBER_SEED
  sta swordfish_boss_pseudo_random_number,x

  lda #<SWORDFISH_BOSS_FIN_SWIM_Y
  sta entity_y_lo,x
  lda #>SWORDFISH_BOSS_FIN_SWIM_Y
  sta entity_y_hi,x

  sec
  lda entity_x_lo,x
  sbc #<64
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>64
  sta entity_x_hi,x

  lda #%01000000
  sta entity_sprite_flags,x

  lda #SWORDFISH_BOSS_FIN_LAPS_TIL_CHARGE
  sta swordfish_boss_fin_lap_counter,x

  lda #SWORDFISH_BOSS_SWIM_RIGHT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
  sta entity_state,x

  rts

swordfish_boss_state_fin_swim_right:

  jsr swordfish_boss_permute_prn

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_switch_state

  .scope
  dec swordfish_boss_fin_lap_counter,x
  bne do_not_switch_state

  lda swordfish_boss_pseudo_random_number,x
  and #SWORDFISH_BOSS_RANDOM_NUMBER_OFFSET_MASK
  sta b0

  clc
  lda #<SWORDFISH_BOSS_CHARGE_Y
  adc b0
  sta entity_y_lo,x
  lda #>SWORDFISH_BOSS_CHARGE_Y
  adc #0
  sta entity_y_hi,x

  lda #%00000000
  sta entity_sprite_flags,x

  lda #<swordfish_boss_swim
  sta entity_animation_address_lo,x
  lda #>swordfish_boss_swim
  sta entity_animation_address_hi,x

  lda #SWORDFISH_BOSS_SWIM_RIGHT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_CHARGE_LEFT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  lda #%00000000
  sta entity_sprite_flags,x

  lda #SWORDFISH_BOSS_SWIM_LEFT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  jsr swordfish_swim_right

  jsr entity_update_animation

  rts

swordfish_boss_state_fin_swim_left:

  jsr swordfish_boss_permute_prn

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_switch_state

  .scope
  dec swordfish_boss_fin_lap_counter,x
  bne do_not_switch_state

  lda swordfish_boss_pseudo_random_number,x
  and #SWORDFISH_BOSS_RANDOM_NUMBER_OFFSET_MASK
  sta b0

  clc
  lda #<SWORDFISH_BOSS_CHARGE_Y
  adc b0
  sta entity_y_lo,x
  lda #>SWORDFISH_BOSS_CHARGE_Y
  adc #0
  sta entity_y_hi,x

  lda #%01000000
  sta entity_sprite_flags,x

  lda #<swordfish_boss_swim
  sta entity_animation_address_lo,x
  lda #>swordfish_boss_swim
  sta entity_animation_address_hi,x

  lda #SWORDFISH_BOSS_SWIM_RIGHT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_CHARGE_RIGHT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  lda #%01000000
  sta entity_sprite_flags,x

  lda #SWORDFISH_BOSS_SWIM_LEFT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  jsr swordfish_swim_left

  jsr entity_update_animation

  rts

swordfish_boss_state_charge_right:

  jsr swordfish_boss_permute_prn

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_switch_state

  lda #<swordfish_boss_fin
  sta entity_animation_address_lo,x
  lda #>swordfish_boss_fin
  sta entity_animation_address_hi,x

  lda #%00000000
  sta entity_sprite_flags,x

  lda #<SWORDFISH_BOSS_FIN_SWIM_Y
  sta entity_y_lo,x
  lda #>SWORDFISH_BOSS_FIN_SWIM_Y
  sta entity_y_hi,x

  lda #SWORDFISH_BOSS_FIN_LAPS_TIL_CHARGE
  sta swordfish_boss_fin_lap_counter,x

  lda #SWORDFISH_BOSS_SWIM_LEFT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  jsr swordfish_swim_right

  jsr swordfish_add_shadow_spot

  jsr entity_update_animation

  rts

swordfish_boss_state_charge_left:

  jsr swordfish_boss_permute_prn

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_switch_state

  lda #<swordfish_boss_fin
  sta entity_animation_address_lo,x
  lda #>swordfish_boss_fin
  sta entity_animation_address_hi,x

  lda #%01000000
  sta entity_sprite_flags,x

  lda #<SWORDFISH_BOSS_FIN_SWIM_Y
  sta entity_y_lo,x
  lda #>SWORDFISH_BOSS_FIN_SWIM_Y
  sta entity_y_hi,x

  lda #SWORDFISH_BOSS_FIN_LAPS_TIL_CHARGE
  sta swordfish_boss_fin_lap_counter,x

  lda #SWORDFISH_BOSS_SWIM_RIGHT_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  jsr swordfish_swim_left

  jsr swordfish_add_shadow_spot

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

.proc swordfish_boss_permute_prn

  ;permute the pseudo random number
: lda swordfish_boss_pseudo_random_number,x
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor #$1d
noEor:
  sta swordfish_boss_pseudo_random_number,x
  dey
  bne :-

  rts

.endproc

.proc swordfish_swim_right

  clc
  lda entity_x_lo,x
  adc #<SWORDFISH_BOSS_SWIM_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>SWORDFISH_BOSS_SWIM_SPEED
  sta entity_x_hi,x

  rts

.endproc

.proc swordfish_swim_left

  sec
  lda entity_x_lo,x
  sbc #<SWORDFISH_BOSS_SWIM_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>SWORDFISH_BOSS_SWIM_SPEED
  sta entity_x_hi,x

  rts

.endproc

.proc swordfish_add_shadow_spot

  clc
  lda entity_x_lo,x
  adc #<SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_X
  sta w0
  lda entity_x_hi,x
  adc #>SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_X
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_Y
  sta w1
  lda entity_y_hi,x
  adc #>SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_Y
  sta w1+1

  jsr sprite_add_shadow_spot

  rts

.endproc

.endif
