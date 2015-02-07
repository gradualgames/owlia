.linecont +
.ifndef HORSESHOE_CRAB_INC
HORSESHOE_CRAB_INC = 1

HORSESHOE_CRAB_WIDTH = $0f
HORSESHOE_CRAB_HEIGHT = $0f
HORSESHOE_CRAB_HALF_WIDTH = (HORSESHOE_CRAB_WIDTH >> 1)
HORSESHOE_CRAB_HALF_HEIGHT = (HORSESHOE_CRAB_HEIGHT >> 1)
HORSESHOE_CRAB_SPEED = 1
HORSESHOE_CRAB_INITIAL_HEALTH = 3
HORSESHOE_CRAB_KNOCKBACK_LENGTH = 20
HORSESHOE_CRAB_ATTACKED_LENGTH = 20

horseshoe_crab_state_counter = entity_local0
horseshoe_crab_flash_counter = entity_local1
horseshoe_crab_knockback_counter = entity_local2
horseshoe_crab_health = entity_local3
horseshoe_crab_direction = entity_local4

.enum
HORSESHOE_CRAB_STATE_INIT
HORSESHOE_CRAB_STATE_PAUSE
HORSESHOE_CRAB_STATE_MOVE_RIGHT
HORSESHOE_CRAB_STATE_MOVE_LEFT
HORSESHOE_CRAB_STATE_MOVE_UP
HORSESHOE_CRAB_STATE_MOVE_DOWN
.endenum

.define horseshoe_crab_states \
  horseshoe_crab_state_init, \
  horseshoe_crab_state_pause, \
  horseshoe_crab_state_move_right, \
  horseshoe_crab_state_move_left, \
  horseshoe_crab_state_move_up, \
  horseshoe_crab_state_move_down

horseshoe_crab_lo:
  .lobytes horseshoe_crab_states

horseshoe_crab_hi:
  .hibytes horseshoe_crab_states

horseshoe_crab_update:

  entity_state_switchboard horseshoe_crab_lo, horseshoe_crab_hi

horseshoe_crab_state_init:

  jsr entity_set_drawable

  lda #<horseshoe_crab_walk_side
  sta entity_animation_address_lo,x
  lda #>horseshoe_crab_walk_side
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #HORSESHOE_CRAB_WIDTH
  sta entity_width,x
  lda #HORSESHOE_CRAB_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_horseshoe_crab
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #HORSESHOE_CRAB_INITIAL_HEALTH
  sta horseshoe_crab_health,x
  lda #0
  sta horseshoe_crab_knockback_counter,x
  sta horseshoe_crab_flash_counter,x

  lda rand
  and #%00001111
  sta horseshoe_crab_state_counter,x

  lda #HORSESHOE_CRAB_STATE_PAUSE
  sta entity_state,x

  rts

horseshoe_crab_state_pause:

  jsr horseshoe_crab_combat

  .scope
  dec horseshoe_crab_state_counter,x
  bne do_not_change_state

  jsr randomly_find_a_blank_tile_near_horseshoe_and_change_state

do_not_change_state:
  .endscope

  jsr entity_update_animation

  rts

horseshoe_crab_state_move_right:

  jsr horseshoe_crab_combat

  .scope
  dec horseshoe_crab_state_counter,x
  bne do_not_change_state

  jsr randomly_find_a_blank_tile_near_horseshoe_and_change_state

do_not_change_state:
  .endscope

  clc
  lda entity_x_lo,x
  adc #<HORSESHOE_CRAB_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>HORSESHOE_CRAB_SPEED
  sta entity_x_hi,x

  jsr entity_update_animation

  rts

horseshoe_crab_state_move_left:

  jsr horseshoe_crab_combat

  .scope
  dec horseshoe_crab_state_counter,x
  bne do_not_change_state

  jsr randomly_find_a_blank_tile_near_horseshoe_and_change_state

do_not_change_state:
  .endscope

  sec
  lda entity_x_lo,x
  sbc #<HORSESHOE_CRAB_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>HORSESHOE_CRAB_SPEED
  sta entity_x_hi,x

  jsr entity_update_animation

  rts

horseshoe_crab_state_move_up:

  jsr horseshoe_crab_combat

  .scope
  dec horseshoe_crab_state_counter,x
  bne do_not_change_state

  jsr randomly_find_a_blank_tile_near_horseshoe_and_change_state

do_not_change_state:
  .endscope

  sec
  lda entity_y_lo,x
  sbc #<HORSESHOE_CRAB_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #>HORSESHOE_CRAB_SPEED
  sta entity_y_hi,x

  jsr entity_update_animation

  rts

horseshoe_crab_state_move_down:

  jsr horseshoe_crab_combat

  .scope
  dec horseshoe_crab_state_counter,x
  bne do_not_change_state

  jsr randomly_find_a_blank_tile_near_horseshoe_and_change_state

do_not_change_state:
  .endscope

  clc
  lda entity_y_lo,x
  adc #<HORSESHOE_CRAB_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #>HORSESHOE_CRAB_SPEED
  sta entity_y_hi,x

  jsr entity_update_animation

  rts

.proc horseshoe_crab_combat

  entity_combat #HORSESHOE_CRAB_ATTACKED_LENGTH, #HORSESHOE_CRAB_KNOCKBACK_LENGTH, horseshoe_crab_flash_counter, horseshoe_crab_knockback_counter, horseshoe_crab_health, horseshoe_crab_direction

  rts

.endproc

.proc randomly_find_a_blank_tile_near_horseshoe_and_change_state

  clc
  lda entity_x_lo,x
  adc #<HORSESHOE_CRAB_HALF_WIDTH
  sta w0
  lda entity_x_hi,x
  adc #>HORSESHOE_CRAB_HALF_WIDTH
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<HORSESHOE_CRAB_HALF_HEIGHT
  sta w1
  lda entity_y_hi,x
  adc #>HORSESHOE_CRAB_HALF_HEIGHT
  sta w1+1

  lda rand
  and #%00000011
  cmp #ENTITY_DIRECTION_LEFT
  beq try_left
  cmp #ENTITY_DIRECTION_RIGHT
  beq try_right
  cmp #ENTITY_DIRECTION_UP
  beq try_up
  cmp #ENTITY_DIRECTION_DOWN
  bne :+
  jmp try_down
:
try_left:

  sec
  lda w0
  sbc #<16
  sta w0
  lda w0+1
  sbc #>16
  sta w0+1

  jsr map_test_collision
  lda b0
  and #FLAG_SOLID
  beq :+
  jmp pause_again
:

  jsr load_left_animation

  lda #16
  sta horseshoe_crab_state_counter,x

  lda #ENTITY_DIRECTION_LEFT
  sta horseshoe_crab_direction,x

  lda #HORSESHOE_CRAB_STATE_MOVE_LEFT
  sta entity_state,x

  rts
try_right:

  clc
  lda w0
  adc #<16
  sta w0
  lda w0+1
  adc #>16
  sta w0+1

  jsr map_test_collision
  lda b0
  and #FLAG_SOLID
  beq :+
  jmp pause_again
:

  jsr load_right_animation

  lda #16
  sta horseshoe_crab_state_counter,x

  lda #ENTITY_DIRECTION_RIGHT
  sta horseshoe_crab_direction,x

  lda #HORSESHOE_CRAB_STATE_MOVE_RIGHT
  sta entity_state,x

  rts
try_up:

  sec
  lda w1
  sbc #<16
  sta w1
  lda w1+1
  sbc #>16
  sta w1+1

  jsr map_test_collision
  lda b0
  and #FLAG_SOLID
  beq :+
  jmp pause_again
:

  jsr load_up_animation

  lda #16
  sta horseshoe_crab_state_counter,x

  lda #ENTITY_DIRECTION_UP
  sta horseshoe_crab_direction,x

  lda #HORSESHOE_CRAB_STATE_MOVE_UP
  sta entity_state,x

  rts
try_down:

  clc
  lda w1
  adc #<16
  sta w1
  lda w1+1
  adc #>16
  sta w1+1

  jsr map_test_collision
  lda b0
  and #FLAG_SOLID
  beq :+
  jmp pause_again
:

  jsr load_down_animation

  lda #16
  sta horseshoe_crab_state_counter,x

  lda #ENTITY_DIRECTION_DOWN
  sta horseshoe_crab_direction,x

  lda #HORSESHOE_CRAB_STATE_MOVE_DOWN
  sta entity_state,x

  rts

pause_again:

  jsr next_rand
  lda rand
  sta horseshoe_crab_state_counter,x
  lda #HORSESHOE_CRAB_STATE_PAUSE
  sta entity_state,x

  rts

load_left_animation:

  lda #<horseshoe_crab_walk_side
  sta entity_animation_address_lo,x
  lda #>horseshoe_crab_walk_side
  sta entity_animation_address_hi,x

  lda entity_sprite_flags,x
  ora #%01000000
  sta entity_sprite_flags,x

  rts

load_right_animation:

  lda #<horseshoe_crab_walk_side
  sta entity_animation_address_lo,x
  lda #>horseshoe_crab_walk_side
  sta entity_animation_address_hi,x

  lda entity_sprite_flags,x
  and #%10111111
  sta entity_sprite_flags,x

  rts

load_up_animation:

  lda #<horseshoe_crab_walk_up
  sta entity_animation_address_lo,x
  lda #>horseshoe_crab_walk_up
  sta entity_animation_address_hi,x

  rts

load_down_animation:

  lda #<horseshoe_crab_walk_down
  sta entity_animation_address_lo,x
  lda #>horseshoe_crab_walk_down
  sta entity_animation_address_hi,x

  rts

.endproc

.endif
