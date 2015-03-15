.linecont +
.ifndef CLAM_INC
CLAM_INC = 1

CLAM_STATE_OPEN_LENGTH = 20
CLAM_STATE_REVEAL_TREASURE_LENGTH = 80
CLAM_STATE_CLOSE_LENGTH = 20
CLAM_STATE_RISE_LENGTH = 80

CLAM_RISE_SPEED = 100

CLAM_FLOAT_ACCELERATION = 10
CLAM_FLOAT_ALTITUDE = 40

CLAM_FOLLOW_ACCELERATION = 20

CLAM_MAX_FOLLOW_VELOCITY = 500

CLAM_KNOCKBACK_VELOCITY = 500

CLAM_ATTACKED_LENGTH = 20

CLAM_FLASH_LENGTH = 20

CLAM_INITIAL_HEALTH = 3

CLAM_ITEM_OFFSET_X = 4
CLAM_ITEM_OFFSET_Y = 4

CLAM_ITEM_QUANTITY = 100

CLAM_WIDTH = $0f
CLAM_HEIGHT = $0f

.enum
CLAM_STATE_INIT
CLAM_STATE_OPEN
CLAM_STATE_REVEAL_TREASURE
CLAM_STATE_CLOSE
CLAM_STATE_RISE
CLAM_STATE_FLOAT
.endenum

clam_state_counter = entity_local0
clam_x_lo = entity_local1
clam_x_hi = entity_local2
clam_x_fine = entity_local3
clam_y_lo = entity_local4
clam_y_hi = entity_local5
clam_y_fine = entity_local6
clam_altitude_lo = entity_local7
clam_altitude_hi = entity_local8
clam_altitude_fine = entity_local9
clam_x_velocity_lo = entity_local10
clam_x_velocity_hi = entity_local11
clam_y_velocity_lo = entity_local12
clam_y_velocity_hi = entity_local13
clam_altitude_velocity_lo = entity_local14
clam_altitude_velocity_hi = entity_local15
clam_flash_counter = entity_local16
clam_knockback_counter = entity_local17
clam_health = entity_local18
clam_direction = entity_local19

define_lohi_tables clam_knockback_x_velocity, {CLAM_KNOCKBACK_VELOCITY, -CLAM_KNOCKBACK_VELOCITY, 0, 0}
define_lohi_tables clam_knockback_y_velocity, {0, 0, CLAM_KNOCKBACK_VELOCITY, -CLAM_KNOCKBACK_VELOCITY}

define_lohi_tables clam, \
  {clam_state_init, \
  clam_state_open, \
  clam_state_reveal_treasure, \
  clam_state_close, \
  clam_state_rise, \
  clam_state_float}

clam_update:

  entity_state_switchboard clam_lo, clam_hi

clam_state_init:

  jsr entity_set_drawable

  jsr entity_set_shadow_spot

  lda #<clam
  sta entity_animation_address_lo,x
  lda #>clam
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CLAM_WIDTH
  sta entity_width,x
  lda #CLAM_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_clam
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #CLAM_INITIAL_HEALTH
  sta clam_health,x

  lda #0
  sta clam_flash_counter,x
  sta clam_knockback_counter,x

  lda #ENTITY_DIRECTION_NONE
  sta clam_direction,x

  entity_lda24 clam_x, 0
  entity_move16 entity_x, clam_x

  entity_lda24 clam_y, 0
  entity_move16 entity_y, clam_y

  entity_lda24 clam_altitude, 0

  entity_lda16 clam_x_velocity, 0
  entity_lda16 clam_y_velocity, 0
  entity_lda16 clam_altitude_velocity, 0

  jsr position_clam

  lda #CLAM_STATE_OPEN_LENGTH
  sta clam_state_counter,x

  lda #CLAM_STATE_OPEN
  sta entity_state,x

  rts

clam_state_open:

  jsr clam_combat

  .scope
  dec clam_state_counter,x
  bne do_not_transition_yet

  .scope
  jsr clam_search_for_gp_item
  bpl do_not_spawn_item

  lda #entity_index_item
  sta b0

  clc
  lda entity_x_lo,x
  adc #<CLAM_ITEM_OFFSET_X
  sta w0
  lda entity_x_hi,x
  adc #>CLAM_ITEM_OFFSET_X
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<CLAM_ITEM_OFFSET_Y
  sta w1
  lda entity_y_hi,x
  adc #>CLAM_ITEM_OFFSET_Y
  sta w1+1

  jsr entity_spawn

  lda spawned_entity

  ldy spawned_entity
  lda #ITEM_STATE_PICKUP_INIT
  sta item_initial_state,y
  lda #ITEM_TYPE_GP
  sta item_type,y
  lda #<CLAM_ITEM_QUANTITY
  sta item_quantity_lo,y
  lda #>CLAM_ITEM_QUANTITY
  sta item_quantity_hi,y
  lda #0
  sta item_dungeon_flags_mask,y

do_not_spawn_item:
  .endscope

  lda #CLAM_STATE_REVEAL_TREASURE_LENGTH
  sta clam_state_counter,x

  lda #CLAM_STATE_REVEAL_TREASURE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr position_clam

  jsr entity_update_animation

  rts

clam_state_reveal_treasure:

  jsr clam_combat

  .scope
  jsr clam_search_for_gp_item
  bpl clam_not_angered

  jsr entity_set_not_pausable

  lda #CLAM_STATE_RISE_LENGTH
  sta clam_state_counter,x

  lda #CLAM_STATE_RISE
  sta entity_state,x

  rts
clam_not_angered:
  .endscope

  .scope
  dec clam_state_counter,x
  bne do_not_transition_yet

  .scope
  jsr clam_search_for_gp_item
  bmi do_not_kill_item

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y

do_not_kill_item:
  .endscope

  lda #CLAM_STATE_CLOSE_LENGTH
  sta clam_state_counter,x

  lda #CLAM_STATE_CLOSE
  sta entity_state,x

  jsr position_clam

  rts

do_not_transition_yet:
  .endscope

  jsr position_clam

  rts

clam_state_close:

  jsr clam_combat

  .scope
  dec clam_state_counter,x
  bne do_not_transition_yet

  lda #CLAM_STATE_OPEN_LENGTH
  sta clam_state_counter,x

  lda #CLAM_STATE_OPEN
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr position_clam

  jsr entity_update_animation

  rts

clam_state_rise:

  jsr clam_combat

  .scope
  dec clam_state_counter,x
  bne do_not_transition_yet

  lda #0
  sta clam_flash_counter,x
  sta clam_knockback_counter,x

  lda #CLAM_STATE_FLOAT
  sta entity_state,x

do_not_transition_yet:
  .endscope

  clc
  lda clam_altitude_fine,x
  adc #<CLAM_RISE_SPEED
  sta clam_altitude_fine,x
  lda clam_altitude_lo,x
  adc #>CLAM_RISE_SPEED
  sta clam_altitude_lo,x
  lda clam_altitude_hi,x
  adc #^CLAM_RISE_SPEED
  sta clam_altitude_hi,x

  jsr move_clam

  jsr position_clam

  jsr entity_update_animation

  rts

clam_state_float:

  jsr clam_combat

  .scope
  lda clam_knockback_counter,x
  cmp #CLAM_ATTACKED_LENGTH
  bne not_just_attacked

  ldy clam_direction,x
  lda clam_knockback_x_velocity_lo,y
  sta clam_x_velocity_lo,x
  lda clam_knockback_x_velocity_hi,y
  sta clam_x_velocity_hi,x

  lda clam_knockback_y_velocity_lo,y
  sta clam_y_velocity_lo,x
  lda clam_knockback_y_velocity_hi,y
  sta clam_y_velocity_hi,x

not_just_attacked:
  .endscope

  .scope
  sec
  lda hero_x
  sbc entity_x_lo,x
  lda hero_x+1
  sbc entity_x_hi,x
  bmi accelerate_left
accelerate_right:

  entity_add_acceleration clam_x_velocity, CLAM_FOLLOW_ACCELERATION

  jmp done
accelerate_left:

  entity_add_acceleration clam_x_velocity, (-CLAM_FOLLOW_ACCELERATION)

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

  entity_add_acceleration clam_y_velocity, CLAM_FOLLOW_ACCELERATION

  jmp done
accelerate_up:

  entity_add_acceleration clam_y_velocity, (-CLAM_FOLLOW_ACCELERATION)

done:
  .endscope

  .scope
  lda clam_x_velocity_lo,x
  sta w0
  lda clam_x_velocity_hi,x
  sta w0+1

  lda w0+1
  bmi negative
positive:

  .scope
  sec
  lda #<CLAM_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>CLAM_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 clam_x_velocity, CLAM_MAX_FOLLOW_VELOCITY

do_not_cap:
  .endscope

  jmp done
negative:

  neg16 w0

  .scope
  sec
  lda #<CLAM_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>CLAM_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 clam_x_velocity, (-CLAM_MAX_FOLLOW_VELOCITY)

do_not_cap:
  .endscope

done:
  .endscope

  .scope
  lda clam_y_velocity_lo,x
  sta w0
  lda clam_y_velocity_hi,x
  sta w0+1

  lda w0+1
  bmi negative
positive:

  .scope
  sec
  lda #<CLAM_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>CLAM_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 clam_y_velocity, CLAM_MAX_FOLLOW_VELOCITY

do_not_cap:
  .endscope

  jmp done
negative:

  neg16 w0

  .scope
  sec
  lda #<CLAM_MAX_FOLLOW_VELOCITY
  sbc w0
  lda #>CLAM_MAX_FOLLOW_VELOCITY
  sbc w0+1
  bpl do_not_cap

  entity_lda16 clam_y_velocity, (-CLAM_MAX_FOLLOW_VELOCITY)

do_not_cap:
  .endscope

done:
  .endscope

  .scope
  sec
  lda #<CLAM_FLOAT_ALTITUDE
  sbc clam_altitude_lo,x
  lda #>CLAM_FLOAT_ALTITUDE
  sbc clam_altitude_hi,x
  bpl float_up
float_down:
  entity_add_acceleration clam_altitude_velocity, (-CLAM_FLOAT_ACCELERATION)
  jmp done
float_up:
  entity_add_acceleration clam_altitude_velocity, CLAM_FLOAT_ACCELERATION
done:
  .endscope

  jsr move_clam

  jsr position_clam

  jsr entity_update_animation

  rts

;searches for a gp item at an offset from the clam.
;returns with negative flag clear if one is found, set if not.
.proc clam_search_for_gp_item

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_item
  bne skip_entity

  lda item_type,y
  cmp #ITEM_TYPE_GP
  bne skip_entity

  cpy familiar_carried_entity_index
  beq skip_entity

  clc
  lda entity_x_lo,x
  adc #<CLAM_ITEM_OFFSET_X
  sta w0
  lda entity_x_hi,x
  adc #>CLAM_ITEM_OFFSET_X
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<CLAM_ITEM_OFFSET_Y
  sta w1
  lda entity_y_hi,x
  adc #>CLAM_ITEM_OFFSET_Y
  sta w1+1

  sec
  lda w0
  sbc entity_x_lo,y
  sta w0
  lda w0+1
  sbc entity_x_hi,y
  sta w0+1

  sec
  lda w1
  sbc entity_y_lo,y
  sta w1
  lda w1+1
  sbc entity_y_hi,y
  sta w1+1

  lda w0
  ora w0+1
  ora w1
  ora w1+1
  beq found_entity

skip_entity:
  dey
  bpl next_entity
found_entity:
  .endscope

  rts

.endproc

.proc clam_combat

  entity_combat #CLAM_FLASH_LENGTH, #CLAM_ATTACKED_LENGTH, clam_flash_counter, clam_knockback_counter, clam_health, clam_direction

  .scope
  lda clam_health,x
  bne clam_not_dead

  jsr clam_search_for_gp_item
  bmi do_not_kill_item

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y

do_not_kill_item:

clam_not_dead:
  .endscope

  rts

.endproc

.proc move_clam

  entity_add_velocity clam_x, clam_x_velocity
  entity_add_velocity clam_y, clam_y_velocity
  entity_add_velocity clam_altitude, clam_altitude_velocity

  rts

.endproc

.proc position_clam

  entity_move16 clam_x, entity_x

  sec
  lda clam_y_lo,x
  sbc clam_altitude_lo,x
  sta entity_y_lo,x
  lda clam_y_hi,x
  sbc clam_altitude_hi,x
  sta entity_y_hi,x

  entity_lda16 entity_shadow_spot_x, 4

  entity_move16 clam_altitude, entity_shadow_spot_y

  clc
  lda entity_shadow_spot_y_lo,x
  adc #<8
  sta entity_shadow_spot_y_lo,x
  lda entity_shadow_spot_y_hi,x
  adc #>8
  sta entity_shadow_spot_y_hi,x

  rts

.endproc

.endif
