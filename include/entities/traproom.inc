.linecont +
.ifndef TRAPROOM_INC
TRAPROOM_INC = 1

TRAPROOM_STATE_RAISE_MONOLITH_LENGTH = 20
TRAPROOM_STATE_LOWER_MONOLITH_LENGTH = 20

traproom_state_counter = entity_local0
traproom_trigger_rect_west_x_lo = entity_local1
traproom_trigger_rect_west_x_hi = entity_local2
traproom_trigger_rect_north_y_lo = entity_local3
traproom_trigger_rect_north_y_hi = entity_local4
traproom_trigger_rect_east_x_lo = entity_local5
traproom_trigger_rect_east_x_hi = entity_local6
traproom_trigger_rect_south_y_lo = entity_local7
traproom_trigger_rect_south_y_hi = entity_local8

.enum
TRAPROOM_STATE_INIT
TRAPROOM_STATE_WAIT_FOR_HERO_TO_ENTER_ROOM
TRAPROOM_STATE_WAIT_FOR_ENEMIES_TO_BE_KILLED
TRAPROOM_STATE_RAISE_MONOLITHS
TRAPROOM_STATE_LOWER_MONOLITHS
.endenum

.define traproom_states \
  traproom_state_init, \
  traproom_state_wait_for_hero_to_enter_room, \
  traproom_state_wait_for_enemies_to_be_killed, \
  traproom_state_raise_monoliths,\
  traproom_state_lower_monoliths

traproom_lo:
  .lobytes traproom_states

traproom_hi:
  .hibytes traproom_states

traproom_update:

  entity_state_switchboard traproom_lo, traproom_hi

traproom_state_init:

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  lda #$0f
  sta entity_width,x
  sta entity_height,x

  lda #0
  sta traproom_state_counter,x

  jsr traproom_compute_trigger_rect

  lda #TRAPROOM_STATE_WAIT_FOR_HERO_TO_ENTER_ROOM
  sta entity_state,x

  rts

traproom_state_wait_for_hero_to_enter_room:

  ;load traproom trigger rectangle
  lda traproom_trigger_rect_west_x_lo,x
  sta w2
  lda traproom_trigger_rect_west_x_hi,x
  sta w2+1

  lda traproom_trigger_rect_north_y_lo,x
  sta w3
  lda traproom_trigger_rect_north_y_hi,x
  sta w3+1

  ;load hero rectangle
  lda traproom_trigger_rect_east_x_lo,x
  sta w6
  lda traproom_trigger_rect_east_x_hi,x
  sta w6+1

  lda traproom_trigger_rect_south_y_lo,x
  sta w7
  lda traproom_trigger_rect_south_y_hi,x
  sta w7+1

  lda hero_x
  sta w4
  lda hero_x+1
  sta w4+1

  lda hero_y
  sta w5
  lda hero_y+1
  sta w5+1

  clc
  lda hero_x
  adc hero_width
  sta w8
  lda hero_x+1
  adc #0
  sta w8+1

  clc
  lda hero_y
  adc hero_height
  sta w9
  lda hero_y+1
  adc #0
  sta w9+1

  jsr geotests_rect_inside_rect
  bne traproom_not_triggered

  lda #TRAPROOM_STATE_RAISE_MONOLITH_LENGTH
  sta b0
  far_call #HERO_BANK, hero_wait_frames

  lda #TRAPROOM_STATE_RAISE_MONOLITH_LENGTH
  sta traproom_state_counter,x

  lda #TRAPROOM_STATE_RAISE_MONOLITHS
  sta entity_state,x

traproom_not_triggered:

  rts

traproom_state_raise_monoliths:

  .scope
  dec traproom_state_counter,x
  bne do_not_transition_yet

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_monolith
  bne skip_entity

  lda #MONOLITH_STATE_RISE_INIT
  sta entity_state,y
skip_entity:

  dey
  bpl next_entity
  .endscope

  lda #TRAPROOM_STATE_WAIT_FOR_ENEMIES_TO_BE_KILLED
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

traproom_state_wait_for_enemies_to_be_killed:

  ;count the number of enemies currently alive
  lda #0
  sta b0
  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  lda entity_flags,y
  and #(ENTITY_FLAGS_ALIVE_TEST|ENTITY_FLAGS_IS_ENEMY_TEST)
  cmp #(ENTITY_FLAGS_ALIVE_TEST|ENTITY_FLAGS_IS_ENEMY_TEST)
  bne not_enemy
  inc b0
not_enemy:
  dey
  bpl next_entity
  .endscope

  ;if there are no enemies alive, transition to lower monoliths state
  lda b0
  bne enemies_still_alive

  lda #TRAPROOM_STATE_LOWER_MONOLITH_LENGTH
  sta traproom_state_counter,x

  ;switch to the corresponding "lower" state of this raise state. Assumed
  ;to be +1 from the raise state.
  lda #TRAPROOM_STATE_LOWER_MONOLITHS
  sta entity_state,x

enemies_still_alive:

  rts

traproom_state_lower_monoliths:

  .scope
  dec traproom_state_counter,x
  bne do_not_transition_yet

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_monolith
  bne skip_entity

  lda #MONOLITH_STATE_FALL_INIT
  sta entity_state,y
skip_entity:

  dey
  bpl next_entity
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_transition_yet:
  .endscope

  rts

.proc traproom_compute_trigger_rect

  ;start with the full screen rect, then bring it in based on
  ;current living monoliths
  lda entity_x_lo,x
  sta traproom_trigger_rect_west_x_lo,x
  lda entity_x_hi,x
  sta traproom_trigger_rect_west_x_hi,x

  lda entity_y_lo,x
  sta traproom_trigger_rect_north_y_lo,x
  lda entity_y_hi,x
  sta traproom_trigger_rect_north_y_hi,x

  clc
  lda entity_x_lo,x
  adc #<256
  sta traproom_trigger_rect_east_x_lo,x
  lda entity_x_hi,x
  adc #>256
  sta traproom_trigger_rect_east_x_hi,x

  clc
  lda entity_y_lo,x
  adc #<240
  sta traproom_trigger_rect_south_y_lo,x
  lda entity_y_hi,x
  adc #>240
  sta traproom_trigger_rect_south_y_hi,x

  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  ;ignore dead monoliths
  lda entity_flags,y
  and #(ENTITY_FLAGS_ALIVE_TEST)
  beq not_monolith
  ;ignore monoliths marked for kill after scroll
  lda entity_flags,y
  and #(ENTITY_FLAGS_MARKED_FOR_KILL_TEST)
  bne not_monolith
  ;we only care about monoliths
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith

  lda monolith_direction,y
  cmp #MONOLITH_DIRECTION_EAST
  beq east_monolith
  cmp #MONOLITH_DIRECTION_WEST
  beq west_monolith
  cmp #MONOLITH_DIRECTION_NORTH
  beq north_monolith
  cmp #MONOLITH_DIRECTION_SOUTH
  beq south_monolith
east_monolith:

  ;get the left edge of the monolith as the right edge of the traproom rect
  lda entity_x_lo,y
  sta traproom_trigger_rect_east_x_lo,x
  lda entity_x_hi,y
  sta traproom_trigger_rect_east_x_hi,x

  dey
  bpl next_entity
  rts

west_monolith:

  ;get the right edge of the monolith as the left edge of the traproom rect
  clc
  lda entity_x_lo,y
  adc entity_width,y
  sta traproom_trigger_rect_west_x_lo,x
  lda entity_x_hi,y
  adc #0
  sta traproom_trigger_rect_west_x_hi,x

  dey
  bpl next_entity
  rts

north_monolith:

  ;get the bottom edge of the monolith as the top edge of the traproom rect
  lda entity_y_lo,y
  sta traproom_trigger_rect_north_y_lo,x
  lda entity_y_hi,y
  sta traproom_trigger_rect_north_y_hi,x

  dey
  bpl next_entity
  rts

south_monolith:

  ;get the top edge of the monolith as the bottom edge of the traproom rect
  clc
  lda entity_y_lo,y
  adc #<(-32)
  sta traproom_trigger_rect_south_y_lo,x
  lda entity_y_hi,y
  adc #>(-32)
  sta traproom_trigger_rect_south_y_hi,x

  dey
  bpl next_entity
  rts

not_monolith:
  dey
  bpl next_entity
  rts
  .endscope

.endproc

.endif
