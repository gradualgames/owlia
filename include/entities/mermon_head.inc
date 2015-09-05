.linecont +
.ifndef MERMON_HEAD_INC
MERMON_HEAD_INC = 1

MERMON_HEAD_PROJECTILE_LIFE = 50

MERMON_HEAD_EARS_FLAP_LENGTH = 14
MERMON_HEAD_STATE_PAUSE_LENGTH = 50
MERMON_HEAD_STATE_HOME_IN_TO_RANDOM_SPOT_LENGTH = 100
MERMON_HEAD_STATE_TRANSITION_TO_FINAL_SCENE_LENGTH = 200
MERMON_HEAD_STATE_EXPLODE_LENGTH = 255

MERMON_HEAD_FOLLOW_ACCELERATION = 20
MERMON_HEAD_MAX_FOLLOW_VELOCITY = 500

MERMON_HEAD_INITIAL_HEALTH = 30
MERMON_HEAD_ATTACKED_LENGTH = 30
MERMON_HEAD_FLASH_LENGTH = 20

MERMON_HEAD_PROJECTILE_X_OFFSET = 10
MERMON_HEAD_PROJECTILE_Y_OFFSET = 24

MERMON_HEAD_WIDTH = $1f
MERMON_HEAD_HEIGHT = $1f

mermon_head_x_lo = entity_x_lo
mermon_head_x_hi = entity_x_hi
mermon_head_y_lo = entity_y_lo
mermon_head_y_hi = entity_y_hi

define_entity_properties mermon_head_ear_animation_counter, \
                         mermon_head_ear_animation_index, \
                         mermon_head_state_counter, \
                         mermon_head_x_fine, \
                         mermon_head_y_fine, \
                         mermon_head_x_velocity_lo, \
                         mermon_head_x_velocity_hi, \
                         mermon_head_y_velocity_lo, \
                         mermon_head_y_velocity_hi, \
                         mermon_head_health, \
                         mermon_head_attacked_counter, \
                         mermon_head_flash_counter, \
                         mermon_head_knockback_counter, \
                         mermon_head_direction, \
                         mermon_head_projectile_direction_counter

.enum
MERMON_HEAD_STATE_INIT
MERMON_HEAD_STATE_PAUSE
MERMON_HEAD_STATE_HOME_IN_TO_RANDOM_SPOT
MERMON_HEAD_STATE_EXPLODE
MERMON_HEAD_STATE_TRANSITION_TO_FINAL_SCENE
.endenum

define_lohi_tables mermon_head_ear_animations, \
  {mermon_head_ears_forward, \
   mermon_head_ears_back}

define_lohi_tables mermon_head_blow_ear_animations, \
  {mermon_head_blow_ears_forward, \
   mermon_head_blow_ears_back}

define_lohi_tables mermon_head, \
 {mermon_head_state_init, \
  mermon_head_state_pause, \
  mermon_head_state_home_in_to_random_spot, \
  mermon_head_state_explode, \
  mermon_head_state_transition_to_final_scene}

mermon_head_update:

  entity_state_switchboard mermon_head_lo, mermon_head_hi

mermon_head_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  jsr entity_set_not_pausable

  jsr entity_set_shadow_spot

  lda #<final_boss_theme
  sta song_address
  lda #>final_boss_theme
  sta song_address+1
  far_call #SOUND_BANK, song_initialize
  
  entity_lda16 entity_shadow_spot_x, 10
  entity_lda16 entity_shadow_spot_y, 32

  lda #<mermon_head_ears_forward
  sta entity_animation_address_lo,x
  lda #>mermon_head_ears_forward
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #MERMON_HEAD_WIDTH
  sta entity_width,x
  lda #MERMON_HEAD_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_mermon_head
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #0
  sta mermon_head_x_fine,x
  sta mermon_head_y_fine,x

  entity_lda16 mermon_head_x_velocity, 0
  entity_lda16 mermon_head_y_velocity, 0

  lda #MERMON_HEAD_EARS_FLAP_LENGTH
  sta mermon_head_ear_animation_counter,x

  lda #0
  sta mermon_head_ear_animation_index,x

  lda #0
  sta mermon_head_attacked_counter,x
  sta mermon_head_flash_counter,x
  sta mermon_head_direction,x

  lda #MERMON_HEAD_INITIAL_HEALTH
  sta mermon_head_health,x

  lda #MERMON_HEAD_STATE_PAUSE_LENGTH
  sta mermon_head_state_counter,x

  lda #MERMON_HEAD_STATE_PAUSE
  sta entity_state,x

  rts

mermon_head_state_pause:

  jsr mermon_head_combat

  jsr mermon_head_update_blow_animation

  jsr entity_update_animation

  .scope
  dec mermon_head_state_counter,x
  bne do_not_transition_yet

  jsr entity_reset_animation

  lda #MERMON_HEAD_STATE_HOME_IN_TO_RANDOM_SPOT_LENGTH
  sta mermon_head_state_counter,x

  lda #MERMON_HEAD_STATE_HOME_IN_TO_RANDOM_SPOT
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

mermon_head_state_home_in_to_random_spot:

  jsr mermon_head_combat

  jsr mermon_head_float

  jsr mermon_head_update_ear_animation

  .scope
  dec mermon_head_state_counter,x
  bne do_not_transition_yet

  jsr mermon_head_fire_projectiles

  jsr entity_reset_animation

  lda #MERMON_HEAD_STATE_PAUSE_LENGTH
  sta mermon_head_state_counter,x

  lda #MERMON_HEAD_STATE_PAUSE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

mermon_head_state_transition_to_final_scene:

  .scope
  dec mermon_head_state_counter,x
  bne do_not_transition_yet

  lda #ACTION_GOTO_LOCATION_GROUP1
  sta state_control_params+play_state_control::action
  lda #location_index_dungeon5_final_silmaran_encounter
  sta state_control_params+play_state_control::param

do_not_transition_yet:
  .endscope

  rts

mermon_head_state_explode:

  .scope
  dec mermon_head_state_counter,x
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

  jsr entity_clear_shadow_spot

  ;keep entity alive because we're going to transition to the final scene in the next state
  ;but make it not drawable as though it died
  lda entity_flags,x
  and #ENTITY_FLAGS_DRAWABLE_CLEAR
  ora #ENTITY_FLAGS_ALIVE_SET
  sta entity_flags,x

  ;transition to the state which will count down and then transition to the final scene
  lda #MERMON_HEAD_STATE_TRANSITION_TO_FINAL_SCENE_LENGTH
  sta mermon_state_counter,x

  lda #MERMON_HEAD_STATE_TRANSITION_TO_FINAL_SCENE
  sta entity_state,x

  rts
  .endscope

.proc mermon_head_update_ear_animation

  dec mermon_head_ear_animation_counter,x
  beq advance_ear_animation

  rts

advance_ear_animation:

  lda #MERMON_HEAD_EARS_FLAP_LENGTH
  sta mermon_head_ear_animation_counter,x

  clc
  lda mermon_head_ear_animation_index,x
  adc #1
  and #%00000001
  sta mermon_head_ear_animation_index,x

  ldy mermon_head_ear_animation_index,x
  lda mermon_head_ear_animations_lo,y
  sta entity_animation_address_lo,x
  lda mermon_head_ear_animations_hi,y
  sta entity_animation_address_hi,x

  rts

.endproc

.proc mermon_head_update_blow_animation

  dec mermon_head_ear_animation_counter,x
  beq advance_blow_animation

  rts

advance_blow_animation:

  lda #MERMON_HEAD_EARS_FLAP_LENGTH
  sta mermon_head_ear_animation_counter,x

  clc
  lda mermon_head_ear_animation_index,x
  adc #1
  and #%00000001
  sta mermon_head_ear_animation_index,x

  ldy mermon_head_ear_animation_index,x
  lda mermon_head_blow_ear_animations_lo,y
  sta entity_animation_address_lo,x
  lda mermon_head_blow_ear_animations_hi,y
  sta entity_animation_address_hi,x

  rts

.endproc

.proc mermon_head_float

  .scope
  sec
  lda hero_x
  sbc entity_x_lo,x
  lda hero_x+1
  sbc entity_x_hi,x
  bmi accelerate_left
accelerate_right:

  entity_add_acceleration mermon_head_x_velocity, MERMON_HEAD_FOLLOW_ACCELERATION

  jmp done
accelerate_left:

  entity_add_acceleration mermon_head_x_velocity, (-MERMON_HEAD_FOLLOW_ACCELERATION)

done:
  .endscope

  .scope
  sec
  lda hero_y
  sbc entity_y_lo,x
  lda hero_y+1
  sbc entity_y_hi,x
  bmi accelerate_up
accelerate_down:

  entity_add_acceleration mermon_head_y_velocity, MERMON_HEAD_FOLLOW_ACCELERATION

  jmp done
accelerate_up:

  entity_add_acceleration mermon_head_y_velocity, (-MERMON_HEAD_FOLLOW_ACCELERATION)

done:
  .endscope

  .scope
  lda mermon_head_x_velocity_lo,x
  sta w0
  lda mermon_head_x_velocity_hi,x
  sta w0+1

  lda w0+1
  bmi negative
positive:

  .scope
  sec
  lda #<MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 mermon_head_x_velocity, MERMON_HEAD_MAX_FOLLOW_VELOCITY

do_not_cap:
  .endscope

  jmp done
negative:

  neg16 w0

  .scope
  sec
  lda #<MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 mermon_head_x_velocity, (-MERMON_HEAD_MAX_FOLLOW_VELOCITY)

do_not_cap:
  .endscope

done:
  .endscope

  .scope
  lda mermon_head_y_velocity_lo,x
  sta w0
  lda mermon_head_y_velocity_hi,x
  sta w0+1

  lda w0+1
  bmi negative
positive:

  .scope
  sec
  lda #<MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 mermon_head_y_velocity, MERMON_HEAD_MAX_FOLLOW_VELOCITY

do_not_cap:
  .endscope

  jmp done
negative:

  neg16 w0

  .scope
  sec
  lda #<MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>MERMON_HEAD_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 mermon_head_y_velocity, (-MERMON_HEAD_MAX_FOLLOW_VELOCITY)

do_not_cap:
  .endscope

done:
  .endscope

  entity_add_velocity mermon_head_x, mermon_head_x_velocity
  entity_add_velocity mermon_head_y, mermon_head_y_velocity

  rts

.endproc

.proc mermon_head_combat

  entity_combat #MERMON_HEAD_FLASH_LENGTH, #MERMON_HEAD_ATTACKED_LENGTH, mermon_head_flash_counter, mermon_head_knockback_counter, mermon_head_health, mermon_head_direction, "entity_drop_nop", "entity_spawn_explosion_nop"

  .scope
  lda mermon_head_health,x
  bne not_dead_yet

  far_call #SOUND_BANK, sound_stop

  ;keep head alive for explode state
  lda entity_flags,x
  ora #ENTITY_FLAGS_ALIVE_SET
  sta entity_flags,x

  lda #entity_index_big_explosion
  sta b0

  sec
  lda entity_x_lo,x
  sbc #<8
  sta w0
  lda entity_x_hi,x
  sbc #>8
  sta w0+1
  sec
  lda entity_y_lo,x
  sbc #<8
  sta w1
  lda entity_y_hi,x
  sbc #>8
  sta w1+1

  jsr entity_spawn

  ldy spawned_entity
  lda #31
  sta entity_width,y
  sta entity_height,y
  lda #4
  sta big_explosion_time_between_explosions,y
  lda #MERMON_HEAD_STATE_EXPLODE_LENGTH
  sta big_explosion_length,y

  lda #MERMON_HEAD_STATE_EXPLODE_LENGTH
  sta mermon_head_state_counter,x

  lda #MERMON_HEAD_STATE_EXPLODE
  sta entity_state,x

not_dead_yet:
  .endscope

  rts

.endproc

.proc mermon_head_fire_projectiles

  lda #7
  sta mermon_head_projectile_direction_counter,x

next_direction:

  jsr perform_spawn

  dec mermon_head_projectile_direction_counter,x
  bpl next_direction

  rts

perform_spawn:

  lda #entity_index_projectile
  sta b0

  entity_to_zp16 entity_x, w0
  entity_to_zp16 entity_y, w1

  zp16_add_im8 w0, MERMON_HEAD_PROJECTILE_X_OFFSET
  zp16_add_im8 w1, MERMON_HEAD_PROJECTILE_Y_OFFSET

  jsr entity_spawn

  ldy spawned_entity
  lda mermon_head_projectile_direction_counter,x
  sta projectile_direction,y

  lda #PROJECTILE_MODE_FAST
  sta projectile_mode,y

  lda #<MERMON_HEAD_PROJECTILE_LIFE
  sta projectile_life_lo,y
  lda #>MERMON_HEAD_PROJECTILE_LIFE
  sta projectile_life_hi,y

  rts

.endproc

.endif
