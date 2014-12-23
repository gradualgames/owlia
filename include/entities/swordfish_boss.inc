.linecont +
.ifndef SWORDFISH_BOSS_INC
SWORDFISH_BOSS_INC = 1

SWORDFISH_BOSS_LEFT_BOUNDARY = -64
SWORDFISH_BOSS_RIGHT_BOUNDARY = 256 + 64

SWORDFISH_BOSS_INITIAL_HEALTH = 10
SWORDFISH_BOSS_ATTACKED_LENGTH = 20
SWORDFISH_BOSS_FLASH_LENGTH = 20
SWORDFISH_BOSS_STATE_LOWER_ALL_MONOLITHS_AND_DIE_LENGTH = 50
SWORDFISH_BOSS_STATE_FLOUNDER_LENGTH = 100
SWORDFISH_BOSS_STATE_VICTORY_LENGTH = 220

SWORDFISH_BOSS_RANDOM_NUMBER_SEED = 10
SWORDFISH_BOSS_SWIM_SPEED = 4
SWORDFISH_BOSS_FALL_SPEED = 1
SWORDFISH_BOSS_FALL_LENGTH = 20
SWORDFISH_BOSS_RISE_LENGTH = 10
SWORDFISH_BOSS_RISE_SPEED = 2
SWORDFISH_BOSS_FIN_LAPS_TIL_CHARGE = 2

SWORDFISH_BOSS_RANDOM_NUMBER_OFFSET_MASK = %00111111
SWORDFISH_BOSS_FIN_SWIM_Y = 30
SWORDFISH_BOSS_CHARGE_Y = 80

SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_X = 24
SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_Y = 32

SWORDFISH_BOSS_WIDTH = 55
SWORDFISH_BOSS_HEIGHT = 23

SWORDFISH_BOSS_FLOUNDER_WIDTH = 47

swordfish_boss_state_counter = entity_local0
swordfish_boss_fin_lap_counter = entity_local1
swordfish_boss_pseudo_random_number = entity_local2
swordfish_boss_flash_counter = entity_local3
swordfish_boss_health = entity_local4
swordfish_boss_direction = entity_local5
swordfish_boss_shadow_spot_offset_y = entity_local6
swordfish_boss_last_charge_state = entity_local7
swordfish_boss_invincible = entity_local8

.enum
SWORDFISH_BOSS_STATE_INIT
SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT
SWORDFISH_BOSS_STATE_CHARGE_RIGHT
SWORDFISH_BOSS_STATE_CHARGE_LEFT
SWORDFISH_BOSS_STATE_FALL
SWORDFISH_BOSS_STATE_FLOUNDER
SWORDFISH_BOSS_STATE_RISE
SWORDFISH_BOSS_STATE_LOWER_ALL_MONOLITHS_AND_DIE
SWORDFISH_BOSS_STATE_VICTORY
.endenum

.define swordfish_boss_states \
  swordfish_boss_state_init, \
  swordfish_boss_state_fin_swim_right, \
  swordfish_boss_state_fin_swim_left, \
  swordfish_boss_state_charge_right, \
  swordfish_boss_state_charge_left, \
  swordfish_boss_state_fall, \
  swordfish_boss_state_flounder, \
  swordfish_boss_state_rise, \
  swordfish_boss_state_lower_all_monoliths_and_die, \
  swordfish_boss_state_victory

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

  lda #0
  sta swordfish_boss_flash_counter,x
  lda #SWORDFISH_BOSS_INITIAL_HEALTH
  sta swordfish_boss_health,x

  lda #SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_Y
  sta swordfish_boss_shadow_spot_offset_y,x

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

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
  sta entity_state,x

  rts

swordfish_boss_state_fin_swim_right:

  jsr swordfish_boss_permute_prn

  jsr swordfish_boss_advance_flash_state

  .scope
  sec
  lda #<SWORDFISH_BOSS_RIGHT_BOUNDARY
  sbc entity_x_lo,x
  lda #>SWORDFISH_BOSS_RIGHT_BOUNDARY
  sbc entity_x_hi,x
  bpl do_not_switch_state

  ;dec swordfish_boss_state_counter,x
  ;bne do_not_switch_state

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

  lda #0
  sta swordfish_boss_flash_counter,x

  lda #0
  sta swordfish_boss_invincible,x

  lda #SWORDFISH_BOSS_STATE_CHARGE_LEFT
  sta swordfish_boss_last_charge_state,x
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  lda #%00000000
  sta entity_sprite_flags,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  jsr swordfish_boss_swim_right

  jsr entity_update_animation

  rts

swordfish_boss_state_fin_swim_left:

  jsr swordfish_boss_permute_prn

  jsr swordfish_boss_advance_flash_state

  .scope
  sec
  lda #<SWORDFISH_BOSS_LEFT_BOUNDARY
  sbc entity_x_lo,x
  lda #>SWORDFISH_BOSS_LEFT_BOUNDARY
  sbc entity_x_hi,x
  bmi do_not_switch_state

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

  lda #0
  sta swordfish_boss_flash_counter,x

  lda #0
  sta swordfish_boss_invincible,x

  lda #SWORDFISH_BOSS_STATE_CHARGE_RIGHT
  sta swordfish_boss_last_charge_state,x
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  lda #%01000000
  sta entity_sprite_flags,x

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  jsr swordfish_boss_swim_left

  jsr entity_update_animation

  rts

swordfish_boss_state_charge_right:

  jsr swordfish_boss_permute_prn

  jsr swordfish_boss_advance_flash_state

  .scope
  sec
  lda #<SWORDFISH_BOSS_RIGHT_BOUNDARY
  sbc entity_x_lo,x
  lda #>SWORDFISH_BOSS_RIGHT_BOUNDARY
  sbc entity_x_hi,x
  bpl do_not_switch_state

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

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_LEFT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  jsr swordfish_boss_swim_right

  jsr swordfish_boss_add_shadow_spot

  jsr swordfish_boss_charge_combat

  jsr entity_update_animation

  rts

swordfish_boss_state_charge_left:

  jsr swordfish_boss_permute_prn

  jsr swordfish_boss_advance_flash_state

  .scope
  sec
  lda #<SWORDFISH_BOSS_LEFT_BOUNDARY
  sbc entity_x_lo,x
  lda #>SWORDFISH_BOSS_LEFT_BOUNDARY
  sbc entity_x_hi,x
  bmi do_not_switch_state

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

  lda #SWORDFISH_BOSS_STATE_FIN_SWIM_RIGHT
  sta entity_state,x

  rts

do_not_switch_state:
  .endscope

  jsr swordfish_boss_swim_left

  jsr swordfish_boss_add_shadow_spot

  jsr swordfish_boss_charge_combat

  jsr entity_update_animation

  rts

swordfish_boss_state_fall:

  jsr swordfish_boss_advance_flash_state

  jsr swordfish_boss_flounder_combat

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_switch_state

  lda #SWORDFISH_BOSS_FLOUNDER_WIDTH
  sta entity_width,x

  lda #SWORDFISH_BOSS_STATE_FLOUNDER_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FLOUNDER
  sta entity_state,x

do_not_switch_state:
  .endscope

  clc
  lda entity_y_lo,x
  adc #<SWORDFISH_BOSS_FALL_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #>SWORDFISH_BOSS_FALL_SPEED
  sta entity_y_hi,x

  dec swordfish_boss_shadow_spot_offset_y,x

  jsr swordfish_boss_add_shadow_spot

  jsr entity_update_animation

  rts

swordfish_boss_state_flounder:

  jsr swordfish_boss_advance_flash_state

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_switch_state

  lda #SWORDFISH_BOSS_WIDTH
  sta entity_width,x

  lda #<swordfish_boss_swim
  sta entity_animation_address_lo,x
  lda #>swordfish_boss_swim
  sta entity_animation_address_hi,x

  lda #SWORDFISH_BOSS_RISE_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_RISE
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr swordfish_boss_flounder_combat

  jsr entity_update_animation

  rts

swordfish_boss_state_rise:

  jsr swordfish_boss_advance_flash_state

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_switch_state

  lda #<swordfish_boss_swim
  sta entity_animation_address_lo,x
  lda #>swordfish_boss_swim
  sta entity_animation_address_hi,x

  ;set invincible for the remainder of the next charge state.
  lda #1
  sta swordfish_boss_invincible,x

  lda swordfish_boss_last_charge_state,x
  sta entity_state,x

do_not_switch_state:
  .endscope

  sec
  lda entity_y_lo,x
  sbc #<SWORDFISH_BOSS_RISE_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #>SWORDFISH_BOSS_RISE_SPEED
  sta entity_y_hi,x

  inc swordfish_boss_shadow_spot_offset_y,x
  inc swordfish_boss_shadow_spot_offset_y,x

  jsr swordfish_boss_add_shadow_spot

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

swordfish_boss_state_victory:

  .scope
  dec swordfish_boss_state_counter,x
  bne do_not_die_yet

  ;stop all sound
  far_call #SOUND_BANK, sound_stop

  .scope
  ;search for monolith entity in boss's arena and make it fall
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith

  lda #MONOLITH_STATE_FALL_USING_COLUMNS_INIT
  sta entity_state,y
  jmp done

not_monolith:

  dey
  bpl next_entity
done:
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_die_yet:
  .endscope

  rts

.proc swordfish_boss_charge_combat

  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  jsr entity_hurt_hero

entity_not_hitting_hero:

  lda swordfish_boss_invincible,x
  beq not_invincible
  rts
not_invincible:

  lda entity_action_rect1_action
  cmp #ENTITY_ACTION_ATTACK
  bne action_rect1_not_deadly

  jsr entity_test_entity_action_rect1
  bne action_rect1_not_deadly

  jmp rect1_attacked_entity

action_rect1_not_deadly:

  lda swordfish_boss_flash_counter,x
  bne action_rect2_not_deadly

  lda entity_action_rect2_action
  cmp #ENTITY_ACTION_ATTACK
  bne action_rect2_not_deadly

  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  jmp rect2_attacked_entity

action_rect2_not_deadly:
  jmp entity_not_attacked

rect2_attacked_entity:
  far_call #FAMILIAR_BANK, familiar_hit_enemy

rect1_attacked_entity:

  lda #SWORDFISH_BOSS_FLASH_LENGTH
  sta swordfish_boss_flash_counter,x

  ;play a sound
  lda #<sfx_hit
  sta sound_param_word_0
  lda #>sfx_hit
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  lda #<swordfish_boss_flounder
  sta entity_animation_address_lo,x
  lda #>swordfish_boss_flounder
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SWORDFISH_BOSS_FALL_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_FALL
  sta entity_state,x

entity_not_attacked:

  rts

.endproc

.proc swordfish_boss_flounder_combat

  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  jsr entity_hurt_hero

entity_not_hitting_hero:

  lda swordfish_boss_flash_counter,x
  bne action_rect1_not_deadly
  lda entity_action_rect1_action
  cmp #ENTITY_ACTION_ATTACK
  bne action_rect1_not_deadly

  jsr entity_test_entity_action_rect1
  bne action_rect1_not_deadly

  jmp rect1_attacked_entity

action_rect1_not_deadly:

  lda swordfish_boss_flash_counter,x
  bne action_rect2_not_deadly
  lda entity_action_rect2_action
  cmp #ENTITY_ACTION_ATTACK
  bne action_rect2_not_deadly

  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  jmp rect2_attacked_entity

action_rect2_not_deadly:
  jmp entity_not_attacked

rect2_attacked_entity:
  far_call #FAMILIAR_BANK, familiar_hit_enemy

rect1_attacked_entity:
  .scope
  ;play a sound
  lda #<sfx_hit
  sta sound_param_word_0
  lda #>sfx_hit
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  .ifndef INVINCIBLE_ENEMIES
  dec swordfish_boss_health,x
  bne entity_not_dead_yet

  jsr entity_spawn_explosion
  jsr entity_drop_random_item

  lda #<defeat_boss
  sta song_address
  lda #>defeat_boss
  sta song_address+1
  far_call #SOUND_BANK, song_initialize

  jsr entity_clear_drawable

  lda #SWORDFISH_BOSS_STATE_VICTORY_LENGTH
  sta swordfish_boss_state_counter,x

  lda #SWORDFISH_BOSS_STATE_VICTORY
  sta entity_state,x

entity_not_dead_yet:
  .endif
  .endscope

  lda #SWORDFISH_BOSS_FLASH_LENGTH
  sta swordfish_boss_flash_counter,x

entity_not_attacked:

  rts

.endproc

.proc swordfish_boss_advance_flash_state

  .scope
  lda swordfish_boss_flash_counter,x
  beq flash_state_machine_not_running

  dec swordfish_boss_flash_counter,x

  lda swordfish_boss_flash_counter,x
  and #%00000011
  sta b10

  lda entity_sprite_flags,x
  and #%11111100
  ora b10
  sta entity_sprite_flags,x

flash_state_machine_not_running:
  .endscope

  rts

.endproc

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

.proc swordfish_boss_swim_right

  clc
  lda entity_x_lo,x
  adc #<SWORDFISH_BOSS_SWIM_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>SWORDFISH_BOSS_SWIM_SPEED
  sta entity_x_hi,x

  rts

.endproc

.proc swordfish_boss_swim_left

  sec
  lda entity_x_lo,x
  sbc #<SWORDFISH_BOSS_SWIM_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>SWORDFISH_BOSS_SWIM_SPEED
  sta entity_x_hi,x

  rts

.endproc

.proc swordfish_boss_add_shadow_spot

  clc
  lda entity_x_lo,x
  adc #<SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_X
  sta w0
  lda entity_x_hi,x
  adc #>SWORDFISH_BOSS_SHADOW_SPOT_OFFSET_X
  sta w0+1

  clc
  lda entity_y_lo,x
  adc swordfish_boss_shadow_spot_offset_y,x
  sta w1
  lda entity_y_hi,x
  adc #0
  sta w1+1

  jsr sprite_add_shadow_spot

  rts

.endproc

.endif
