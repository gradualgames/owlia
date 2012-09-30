.include "zp.inc"
.include "ram.inc"
.include "sprites_and_animations_data.inc"
.include "entity.inc"
.include "controller.inc"
.include "map.inc"
.include "play_state.inc"

.ifndef HERO_INC
HERO_INC = 1

HERO_WIDTH = $10
HERO_HEIGHT = $18

HERO_STATE_INIT = 0
HERO_STATE_MAIN = 1

HERO_SPEED = $02

hero_previous_direction = entity_local0

.macro test_collision x_offset_lo, x_offset_hi, y_offset_lo, y_offset_hi, destination_if_solid

  clc
  lda entity_x_lo,x
  adc #x_offset_lo
  sta w0
  lda entity_x_hi,x
  adc #x_offset_hi
  sta w0+1
  
  clc
  lda entity_y_lo,x
  adc #y_offset_lo
  sta w1
  lda entity_y_hi,x
  adc #y_offset_hi
  sta w1+1
  
  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  bne destination_if_solid

.endmacro

.macro test_action x_offset_lo, x_offset_hi, y_offset_lo, y_offset_hi

  clc
  lda entity_x_lo,x
  adc #x_offset_lo
  sta w0
  lda entity_x_hi,x
  adc #x_offset_hi
  sta w0+1
  
  clc
  lda entity_y_lo,x
  adc #y_offset_lo
  sta w1
  lda entity_y_hi,x
  adc #y_offset_hi
  sta w1+1
  
  jsr map_test_collision

  .scope
  lda b0
  and #ISOLATE_ACTION_MASK
  cmp #ACTION_GOTO_LOCATION_GROUP1
  bne skip_goto_location
  lda #ACTION_GOTO_LOCATION_GROUP1
  sta state_control_params+play_state_control::action
  lda b1
  sta state_control_params+play_state_control::param
skip_goto_location:
  .endscope

.endmacro

HERO_DIRECTION_NOP = 0
HERO_DIRECTION_RIGHT = 1
HERO_DIRECTION_LEFT = 2
HERO_DIRECTION_DOWN = 4
HERO_DIRECTION_UP = 8

direction_handlers_lo:
  .byte <hero_direction_nop_handler
  .byte <hero_direction_right_handler
  .byte <hero_direction_left_handler
  .byte <hero_direction_nop_handler
  .byte <hero_direction_down_handler
  .byte <hero_direction_down_and_right_handler
  .byte <hero_direction_down_and_left_handler
  .byte <hero_direction_nop_handler
  .byte <hero_direction_up_handler
  .byte <hero_direction_up_and_right_handler
  .byte <hero_direction_up_and_left_handler
  .byte <hero_direction_nop_handler
  .byte <hero_direction_nop_handler
  .byte <hero_direction_nop_handler
  .byte <hero_direction_nop_handler
  .byte <hero_direction_nop_handler

direction_handlers_hi:
  .byte >hero_direction_nop_handler
  .byte >hero_direction_right_handler
  .byte >hero_direction_left_handler
  .byte >hero_direction_nop_handler
  .byte >hero_direction_down_handler
  .byte >hero_direction_down_and_right_handler
  .byte >hero_direction_down_and_left_handler
  .byte >hero_direction_nop_handler
  .byte >hero_direction_up_handler
  .byte >hero_direction_up_and_right_handler
  .byte >hero_direction_up_and_left_handler
  .byte >hero_direction_nop_handler
  .byte >hero_direction_nop_handler
  .byte >hero_direction_nop_handler
  .byte >hero_direction_nop_handler
  .byte >hero_direction_nop_handler
  
hero_lo:
  .byte <hero_state_init
  .byte <hero_state_main

hero_hi:
  .byte >hero_state_init
  .byte >hero_state_main
  
hero_update:

  entity_state_switchboard hero_lo, hero_hi

hero_state_init:

  lda #HERO_STATE_MAIN
  sta entity_state,x

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x
  
  lda #0
  sta entity_animation_frame,x
  lda #1
  sta entity_animation_counter,x
  
  lda #0
  sta entity_sprite_group_offset,x
  sta entity_sprite_flags,x
  
  lda #<WalkSide
  sta entity_animation_address_lo,x
  lda #>WalkSide
  sta entity_animation_address_hi,x
  
  lda #0
  sta hero_previous_direction,x
  
  rts

hero_state_main:

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne skip_sfx_test
  
  ;play a sound
  txa
  pha

  lda #<sfx_test
  sta sound_param_word_0
  lda #>sfx_test
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

skip_sfx_test:

  ;get up, down, left, right into a single bit field
  lda #0
  sta b0
  lda buffer_controller+buttons::_up
  ror
  rol b0
  lda buffer_controller+buttons::_down
  ror
  rol b0
  lda buffer_controller+buttons::_left
  ror
  rol b0
  lda buffer_controller+buttons::_right
  ror
  rol b0
  
  ;use this as an index into a direction handlers lut
  ldy b0
  lda direction_handlers_lo,y
  sta w0
  lda direction_handlers_hi,y
  sta w0+1
  jsr indirect_jsr_w0

  ;update the hero's animation. In the future, this will
  ;be based on the current state of attacking or walking
  lda entity_animation_address_lo,x
  sta w2
  lda entity_animation_address_hi,x
  sta w2+1
  jsr entity_update_animation

  rts

indirect_jsr_w0:
  jmp (w0)
  
hero_direction_nop_handler:

  rts
  
hero_direction_right_handler:

  lda #%00000000
  sta entity_sprite_flags,x

  lda #<WalkSide
  sta entity_animation_address_lo,x
  lda #>WalkSide
  sta entity_animation_address_hi,x

  .scope
  test_collision HERO_WIDTH, 0, (HERO_HEIGHT/2), 0, found_collision_right_side
  test_collision HERO_WIDTH, 0, HERO_HEIGHT-1, 0, found_collision_right_side

found_collision_right_side:
  bne skip_direction_right_handler
  
  clc
  lda entity_x_lo,x
  adc #HERO_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x

skip_direction_right_handler:
  .endscope
  
  lda #HERO_DIRECTION_RIGHT
  sta hero_previous_direction,x
  
  rts
  
hero_direction_left_handler:

  lda #%01000000
  sta entity_sprite_flags,x

  lda #<WalkSide
  sta entity_animation_address_lo,x
  lda #>WalkSide
  sta entity_animation_address_hi,x

  .scope
  test_collision $ff, $ff, (HERO_HEIGHT/2), 0, skip_direction_left_handler
  test_collision $ff, $ff, (HERO_HEIGHT-1), 0, skip_direction_left_handler
  
  sec
  lda entity_x_lo,x
  sbc #HERO_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #$00
  sta entity_x_hi,x

skip_direction_left_handler:
  .endscope
  
  lda #HERO_DIRECTION_LEFT
  sta hero_previous_direction,x
  
  rts
  
hero_direction_down_handler:

  lda #<WalkDown
  sta entity_animation_address_lo,x
  lda #>WalkDown
  sta entity_animation_address_hi,x

  .scope
  test_action (HERO_WIDTH/2), 0, (HERO_HEIGHT), 0
  test_collision 0, 0, (HERO_HEIGHT), 0, skip_direction_down_handler
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT), 0, skip_direction_down_handler
  
  clc
  lda entity_y_lo,x
  adc #HERO_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x
skip_direction_down_handler:
  .endscope
  
  lda #HERO_DIRECTION_DOWN
  sta hero_previous_direction,x
  
  rts
  
hero_direction_down_and_right_handler:

  .scope
  ;validate that previous direction was down or right.
  ;if not, the animation is wrong, replace it with default down
  lda hero_previous_direction,x
  cmp #HERO_DIRECTION_DOWN
  beq legal_direction
  cmp #HERO_DIRECTION_RIGHT
  beq legal_direction
illegal_direction:

  lda #<WalkDown
  sta entity_animation_address_lo,x
  lda #>WalkDown
  sta entity_animation_address_hi,x
  
legal_direction:
  
  test_action (HERO_WIDTH/2), 0, (HERO_HEIGHT), 0
  test_collision 0, 0, (HERO_HEIGHT), 0, found_collision_down_side
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT), 0, found_collision_down_side
  
  clc
  lda entity_y_lo,x
  adc #HERO_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x
found_collision_down_side:
  
  test_collision (HERO_WIDTH), 0, (HERO_HEIGHT/2), 0, found_collision_right_side
  test_collision (HERO_WIDTH), 0, (HERO_HEIGHT-1), 0, found_collision_right_side
  
  clc
  lda entity_x_lo,x
  adc #HERO_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x
found_collision_right_side:
  .endscope
  
  rts
  
hero_direction_down_and_left_handler:

  .scope
  ;validate that previous direction was down or left.
  ;if not, the animation is wrong, replace it with default down
  lda hero_previous_direction,x
  cmp #HERO_DIRECTION_DOWN
  beq legal_direction
  cmp #HERO_DIRECTION_LEFT
  beq legal_direction
illegal_direction:

  lda #<WalkDown
  sta entity_animation_address_lo,x
  lda #>WalkDown
  sta entity_animation_address_hi,x
  
legal_direction:
  
  test_action (HERO_WIDTH/2), 0, (HERO_HEIGHT), 0
  test_collision 0, 0, (HERO_HEIGHT), 0, found_collision_down_side
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT), 0, found_collision_down_side
  
  clc
  lda entity_y_lo,x
  adc #HERO_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x
found_collision_down_side:
  
  test_collision $ff, $ff, (HERO_HEIGHT/2-1), 0, found_collision_left_side
  test_collision $ff, $ff, (HERO_HEIGHT-1), 0, found_collision_left_side
  
  sec
  lda entity_x_lo,x
  sbc #HERO_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #$00
  sta entity_x_hi,x
found_collision_left_side:
  .endscope

  rts
  
hero_direction_up_handler:

  lda #<WalkUp
  sta entity_animation_address_lo,x
  lda #>WalkUp
  sta entity_animation_address_hi,x

  .scope
  test_action (HERO_WIDTH/2), 0, $ff, $ff
  test_collision 0, 0, (HERO_HEIGHT/2-1), 0, skip_direction_up_handler
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT/2-1), 0, skip_direction_up_handler

  sec
  lda entity_y_lo,x
  sbc #HERO_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #$00
  sta entity_y_hi,x

skip_direction_up_handler:
  .endscope

  lda #HERO_DIRECTION_UP
  sta hero_previous_direction,x
  
  rts
  
hero_direction_up_and_right_handler:

  .scope
  ;validate that previous direction was up or right.
  ;if not, the animation is wrong, replace it with default up
  lda hero_previous_direction,x
  cmp #HERO_DIRECTION_UP
  beq legal_direction
  cmp #HERO_DIRECTION_RIGHT
  beq legal_direction
illegal_direction:

  lda #<WalkUp
  sta entity_animation_address_lo,x
  lda #>WalkUp
  sta entity_animation_address_hi,x
legal_direction:

  test_action (HERO_WIDTH/2), 0, $ff, $ff
  test_collision 0, 0, (HERO_HEIGHT/2-1), 0, found_collision_up_side
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT/2-1), 0, found_collision_up_side

  sec
  lda entity_y_lo,x
  sbc #HERO_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #$00
  sta entity_y_hi,x
found_collision_up_side:
  
  test_collision (HERO_WIDTH), 0, (HERO_HEIGHT/2), 0, found_collision_right_side
  test_collision (HERO_WIDTH), 0, (HERO_HEIGHT-1), 0, found_collision_right_side

  clc
  lda entity_x_lo,x
  adc #HERO_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x

found_collision_right_side:
  
skip_direction_up_and_right_handler:

  .endscope

  rts
  
hero_direction_up_and_left_handler:

  .scope
  ;validate that previous direction was up or left.
  ;if not, the animation is wrong, replace it with default up
  lda hero_previous_direction,x
  cmp #HERO_DIRECTION_UP
  beq legal_direction
  cmp #HERO_DIRECTION_LEFT
  beq legal_direction
illegal_direction:

  lda #<WalkUp
  sta entity_animation_address_lo,x
  lda #>WalkUp
  sta entity_animation_address_hi,x
legal_direction:

  test_action (HERO_WIDTH/2), 0, $ff, $ff
  test_collision 0, 0, (HERO_HEIGHT/2-1), 0, found_collision_up_side
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT/2-1), 0, found_collision_up_side  
  
  sec
  lda entity_y_lo,x
  sbc #HERO_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #$00
  sta entity_y_hi,x
  
found_collision_up_side:

  test_collision $ff, $ff, (HERO_HEIGHT/2), 0, found_collision_left_side
  test_collision $ff, $ff, (HERO_HEIGHT-1), 0, found_collision_left_side  

  sec
  lda entity_x_lo,x
  sbc #HERO_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #$00
  sta entity_x_hi,x
found_collision_left_side:
  
  .endscope
  
  rts

.endif
