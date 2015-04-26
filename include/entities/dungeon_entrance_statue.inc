.linecont +
.ifndef DUNGEON_ENTRANCE_STATUE_INC
DUNGEON_ENTRANCE_STATUE_INC = 1

.include "dungeon_entrance_statue_constants.inc"

.define dungeon_entrance_statue_states \
  dungeon_entrance_statue_state_init, \
  dungeon_entrance_statue_state_main, \
  dungeon_entrance_statue_state_deny_entry, \
  dungeon_entrance_statue_state_allow_entry_and_die

dungeon_entrance_statue_lo:
  .lobytes dungeon_entrance_statue_states

dungeon_entrance_statue_hi:
  .hibytes dungeon_entrance_statue_states

dungeon_entrance_statue_update:

  entity_state_switchboard dungeon_entrance_statue_lo, dungeon_entrance_statue_hi

dungeon_entrance_statue_state_init:

  ;Check to see if the player has already entered the current dungeon. Die if so.
  .scope
  lda inventory_dungeon_flags
  cmp #$ff
  beq do_not_die

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

do_not_die:
  .endscope

  jsr entity_set_drawable

  lda #<dungeon_entrance_statue
  sta entity_animation_address_lo,x
  lda #>dungeon_entrance_statue
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #DUNGEON_ENTRANCE_STATUE_WIDTH
  sta entity_width,x
  lda #DUNGEON_ENTRANCE_STATUE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_dungeon_entrance_statue
  sta b0
  jsr entity_lookup_sprite_chr_offset

  clc
  lda entity_y_lo,x
  adc #<8
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #>8
  sta entity_y_hi,x

  lda dungeon_entrance_statue_attribute,x
  sta entity_sprite_flags,x

  lda #$00
  sta dungeon_entrance_statue_state_counter,x
  sta dungeon_entrance_statue_flash_counter,x

  lda #DUNGEON_ENTRANCE_STATUE_STATE_MAIN
  sta entity_state,x

  rts

dungeon_entrance_statue_state_main:

  jsr check_statue_rect

  rts

dungeon_entrance_statue_state_deny_entry:

  .scope
  ldy dungeon_entrance_statue_deny_entry_button,x
  lda #1
  sta buffer_controller,y

  dec dungeon_entrance_statue_state_counter,x
  bne do_not_switch_back_to_main_state

  ;restore control to the player
  jsr controller_clear
  set_controller_routine controller_read

  lda #DUNGEON_ENTRANCE_STATUE_STATE_MAIN
  sta entity_state,x

do_not_switch_back_to_main_state:
  .endscope

  rts

dungeon_entrance_statue_state_allow_entry_and_die:

  .scope
  lda dungeon_entrance_statue_state_counter,x
  and #%00000010
  bne do_not_flash

  inc dungeon_entrance_statue_flash_counter,x

  lda dungeon_entrance_statue_flash_counter,x
  and #%00000011
  sta dungeon_entrance_statue_flash_counter,x

  lda entity_sprite_flags,x
  and #%11111100
  ora dungeon_entrance_statue_flash_counter,x
  sta entity_sprite_flags,x

do_not_flash:
  .endscope

  .scope
  dec dungeon_entrance_statue_state_counter,x
  bne do_not_die_yet

  lda #entity_index_explosion
  sta b0

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

  ;restore control to the player
  jsr controller_clear
  set_controller_routine controller_read

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_die_yet:
  .endscope

  rts

.proc check_statue_rect

  ;transfer hero rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda hero_x
  sta w2
  lda hero_x+1
  sta w2+1
  lda hero_y
  sta w3
  lda hero_y+1
  sta w3+1
  lda hero_width
  sta b2
  lda hero_height
  sta b3

  ;transfer statue rect to w4 = left and w5 = top and b4 = width and b5 = height
  lda entity_x_lo,x
  sta w4
  lda entity_x_hi,x
  sta w4+1
  lda entity_y_lo,x
  sta w5
  lda entity_y_hi,x
  sta w5+1
  lda #DUNGEON_ENTRANCE_STATUE_WIDTH
  sta b4
  lda #DUNGEON_ENTRANCE_STATUE_HEIGHT
  sta b5

  jsr geotests_rect_in_rect_size

  bne do_not_deny_entry

  sec
  lda inventory_gp
  sbc dungeon_entrance_statue_required_gp_lo,x
  lda inventory_gp+1
  sbc dungeon_entrance_statue_required_gp_hi,x
  lda inventory_gp+2
  sbc dungeon_entrance_statue_required_gp_hi_hi,x
  bpl transition_to_allow_entry_state

  ;take over the controller.
  jsr controller_clear
  set_controller_routine controller_nop

  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_dungeon_statue_deny_entry
  sta state_control_params+play_state_control::param

  lda #DUNGEON_ENTRANCE_STATUE_STATE_DENY_ENTRY_LENGTH
  sta dungeon_entrance_statue_state_counter,x

  lda #DUNGEON_ENTRANCE_STATUE_STATE_DENY_ENTRY
  sta entity_state,x

do_not_deny_entry:

  rts

transition_to_allow_entry_state:

  ;take over the controller.
  jsr controller_clear
  set_controller_routine controller_nop

  lda #DUNGEON_ENTRANCE_STATUE_STATE_ALLOW_ENTRY_LENGTH
  sta dungeon_entrance_statue_state_counter,x

  lda #DUNGEON_ENTRANCE_STATUE_STATE_ALLOW_ENTRY_AND_DIE
  sta entity_state,x

  rts

.endproc

.endif
