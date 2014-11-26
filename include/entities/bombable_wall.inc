.linecont +
.ifndef BOMBABLE_WALL_INC
BOMBABLE_WALL_INC = 1

.include "bombable_wall_constants.inc"

.define bombable_wall_states \
  bombable_wall_state_init, \
  bombable_wall_state_wait_til_bombed, \
  bombable_wall_state_fall, \
  bombable_wall_state_test_exit

bombable_wall_lo:
  .lobytes bombable_wall_states

bombable_wall_hi:
  .hibytes bombable_wall_states

bombable_wall_update:

  entity_state_switchboard bombable_wall_lo, bombable_wall_hi

bombable_wall_state_init:

  jsr entity_clear_drawable

  lda #BOMBABLE_WALL_WIDTH
  sta entity_width,x
  lda #BOMBABLE_WALL_HEIGHT
  sta entity_height,x

  lda #<BOMBABLE_WALL_INITIAL_PATCH_OFFSET_Y
  sta bombable_wall_patch_offset_y_lo,x
  lda #>BOMBABLE_WALL_INITIAL_PATCH_OFFSET_Y
  sta bombable_wall_patch_offset_y_hi,x

  lda #BOMBABLE_WALL_INITIAL_PATCH_ROW
  sta bombable_wall_patch_row,x

  jsr bombable_wall_make_corridor_impassable

  lda #BOMBABLE_WALL_STATE_WAIT_TIL_BOMBED
  sta entity_state,x

  rts

bombable_wall_state_wait_til_bombed:

  .scope
  lda entity_action_rect2_action
  cmp #ACTION_ATTACK
  bne action_rect2_not_deadly
  lda entity_action_rect2_from
  cmp #ACTION_FROM_BOMB
  bne action_rect2_not_deadly
  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  lda #BOMBABLE_WALL_FALL_DELAY
  sta bombable_wall_frame_counter,x

  lda #BOMBABLE_WALL_STATE_FALL
  sta entity_state,x

action_rect2_not_deadly:
  .endscope

  rts

bombable_wall_state_fall:

  ;shake the screen
  .scope
  lda camera_y
  eor #$04
  sta camera_y
  lda camera_scroll_y
  eor #$04
  sta camera_scroll_y
  .endscope

  .scope
  dec bombable_wall_frame_counter,x
  beq done_pausing

  rts

done_pausing:

  lda #BOMBABLE_WALL_FALL_DELAY
  sta bombable_wall_frame_counter,x
  .endscope

  ;patch index
  lda bombable_wall_patch_index,x
  sta b12

  ;patch row
  lda bombable_wall_patch_row,x
  sta b13

  ;patch attribute
  lda bombable_wall_corridor_attribute,x
  sta b14

  ;x offset at which to draw attribute up the corridor
  lda #16
  sta b15

  ;set up parameters for nametable patching and clearing collision field at the same time
  clc
  lda entity_x_lo,x
  sta w0
  adc #<BOMBABLE_WALL_PATCH_OFFSET_X
  sta w8
  lda entity_x_hi,x
  sta w0+1
  adc #>BOMBABLE_WALL_PATCH_OFFSET_X
  sta w8+1

  clc
  lda entity_y_lo,x
  adc bombable_wall_patch_offset_y_lo,x
  sta w1
  sta w9
  lda entity_y_hi,x
  adc bombable_wall_patch_offset_y_hi,x
  sta w1+1
  sta w9+1

  jsr clear_dynamic_single_screen_collision_field_bit

  jsr decode_nametable_patch_row_and_poke_attribute

  .scope
  lda #entity_index_ice_shards_explosion
  sta b0

  clc
  lda entity_x_lo,x
  adc #<4
  sta w0
  lda entity_x_hi,x
  adc #>4
  sta w0+1

  clc
  lda entity_y_lo,x
  adc bombable_wall_patch_offset_y_lo,x
  sta w1
  lda entity_y_hi,x
  adc bombable_wall_patch_offset_y_hi,x
  sta w1+1

  jsr entity_spawn
  .endscope

  dec bombable_wall_patch_row,x
  bmi bombable_wall_transition_to_test_exit

  sec
  lda bombable_wall_patch_offset_y_lo,x
  sbc #<8
  sta bombable_wall_patch_offset_y_lo,x
  lda bombable_wall_patch_offset_y_hi,x
  sbc #>8
  sta bombable_wall_patch_offset_y_hi,x

  rts

bombable_wall_transition_to_test_exit:

  lda #BOMBABLE_WALL_STATE_TEST_EXIT
  sta entity_state,x

  rts

bombable_wall_state_test_exit:

  jsr bombable_wall_test_exit

  rts

.proc bombable_wall_make_corridor_impassable

  ;start at bombable wall's "cursor" coordinates
  lda entity_x_lo,x
  sta w3
  lda entity_x_hi,x
  sta w3+1

  lda entity_y_lo,x
  sta w4
  lda entity_y_hi,x
  sta w4+1

  lda #6
  sta b0

make_next_tile_impassable:
  ;load the current coordinates at which we want to set a solid flag
  lda w3
  sta w0
  lda w3+1
  sta w0+1

  lda w4
  sta w1
  lda w4+1
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  ;move the coordinates up a tile
  sec
  lda w4
  sbc #<16
  sta w4
  lda w4+1
  sbc #>16
  sta w4+1

  dec b0
  bne make_next_tile_impassable

  rts

.endproc

.proc bombable_wall_test_exit

  ;transfer hero rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda hero_x
  sta w4
  lda hero_x+1
  sta w4+1
  lda hero_y
  sta w5
  lda hero_y+1
  sta w5+1
  lda hero_width
  sta b4
  lda hero_height
  sta b5

  ;transfer north screen edge rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda camera_x
  sta w2
  lda camera_x+1
  sta w2+1
  lda camera_y
  sta w3
  lda camera_y+1
  sta w3+1
  lda #255
  sta b2
  lda #1
  sta b3

  jsr geotests_rect_in_rect_size
  bne not_exiting

  ;tell the play state to go to destination location
  lda bombable_wall_goto_location_action,x
  sta state_control_params+play_state_control::action
  lda bombable_wall_location_index,x
  sta state_control_params+play_state_control::param
  ;also tell the play state what direction this monolith's exit is in
  lda #3
  sta state_control_params+play_state_control::param+1

not_exiting:

  rts
.endproc

.endif
