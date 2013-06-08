.linecont +
.include "map.inc"
.include "play_state.inc"
.include "controller.inc"
.include "bg_chr_data.inc"
.include "nametable_data.inc"
.include "inventory_state.inc"
.include "locations.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprite.inc"
.include "sprite_chr_data.inc"
.include "sprites_and_animations_data.inc"
.include "soundengine.inc"
.include "sfx_data.inc"
.include "textbox.inc"
.include "inventory.inc"

.segment "CODE"

inventory_screen_palette:
  .byte $0d,$0d,$18,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0d,$0d,$0d,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

inventory_state_init:

  ;play a sound
  txa
  pha

  lda #<sfx_inventory
  sta sound_param_word_0
  lda #>sfx_inventory
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  ;fade out from current palette
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::palette_address
  lda (location_address),y
  sta palette_address
  iny
  lda (location_address),y
  sta palette_address+1
  jsr ppu_fade_out_palette

  ;set blank nmi routine
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  jsr sprite_update_all

  ;load chr data for inventory screen
  lda #$00
  sta $2006
  sta $2006

  ;reset tile accumulator
  lda #$00
  sta b3

  lda #<inventory_chr
  sta w0
  lda #>inventory_chr
  sta w0+1
  switch_bank_ldy #INVENTORY_STATE_BG_CHR_BANK
  jsr ppu_load_chr_amount

  ;grab tile accumulator to know where the textbox and font group begins
  lda b3
  sta textbox_and_font_chr_offset

  ;load the textbox graphics.
  lda #<textbox_chr
  sta w0
  lda #>textbox_chr
  sta w0+1
  switch_bank_ldy #TEXTBOX_BG_CHR_BANK
  jsr ppu_load_chr_amount

  ;grab tile accumulator to know where the digits group begins
  lda b3
  sta state_control_params+inventory_state_control::digits_chr_offset

  ;load the digits graphics, for displaying numbers of items remaining,
  ;gp, and keys.
  lda #<digits_chr
  sta w0
  lda #>digits_chr
  sta w0+1
  switch_bank_ldy #TEXTBOX_BG_CHR_BANK
  jsr ppu_load_chr_amount

  ;load cursor graphics
  lda #$10
  sta $2006
  lda #$00
  sta $2006

  ;reset tile accumulator
  lda #$00
  sta b3

  lda #<Inventory_chr
  sta w0
  lda #>Inventory_chr
  sta w0+1

  ;store the current chr offset in sprite_chr_groups_chr_offsets array for the inventory sprites
  ldy #sprite_chr_group_index_inventory
  lda b3
  sta sprite_chr_group_offsets,y

  switch_bank_ldy #INVENTORY_STATE_SPRITE_CHR_BANK
  jsr ppu_load_chr_amount

  ;load nametable data for inventory screen
  ;load the nametable and attribute table.
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006
  lda #<inventory_screen
  sta w0
  lda #>inventory_screen
  sta w0+1
  switch_bank_ldy #INVENTORY_STATE_BG_NAMETABLE_BANK
  jsr ppu_load_nametable

  ;reset scroll
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006
  upload_ppu_2006

  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005

  ;initialize and draw initial cursor
  lda #menu_position_tech1_rush
  sta state_control_params+inventory_state_control::menu_position

  ldx state_control_params+inventory_state_control::menu_position
  switch_bank_ldy #INVENTORY_STATE_BANK
  lda menu_position_row,x
  sta state_control_params+inventory_state_control::cursor_row
  lda menu_position_column,x
  sta state_control_params+inventory_state_control::cursor_column

  jsr draw_cursor

  jsr draw_tech_selectors

  jsr sprite_update_all

  ;draw menu layout with strings
  switch_bank_ldy #INVENTORY_STATE_BANK
  jsr draw_inventory_strings

  jsr ppu_safely_enable_graphics

  ;fade in inventory screen palette
  lda #<inventory_screen_palette
  sta palette_address
  lda #>inventory_screen_palette
  sta palette_address+1
  lda #MAX_BRIGHTNESS_LEVEL
  sta b4
  sta b5
  jsr ppu_fade_in_palette

  lda #<ppu_inventory_vblank
  sta vblank_routine
  lda #>ppu_inventory_vblank
  sta vblank_routine+1

inventory_state_main:

  wait_vblank_data_ready

  jsr controller_read

  jsr sprite_clear_all

  switch_bank_ldy #INVENTORY_STATE_BANK
  jsr update_cursor

  jsr draw_cursor

  jsr draw_tech_selectors

  ;test start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq inventory_state_exit

  set_vblank_data_ready

  jmp inventory_state_main

inventory_state_exit:

  ;play a sound
  txa
  pha

  lda #<sfx_inventory
  sta sound_param_word_0
  lda #>sfx_inventory
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  ;fade out inventory palette
  lda #<inventory_screen_palette
  sta palette_address
  lda #>inventory_screen_palette
  sta palette_address+1
  jsr ppu_fade_out_palette

  jmp play_state_reload

.proc ppu_inventory_vblank

  jsr sprite_update_all

  lda #0
  sta vblank_data_ready

  rts

.endproc

.proc draw_cursor
  ldy #sprite_chr_group_index_inventory
  lda sprite_chr_group_offsets,y
  sta chr_group_offset

  switch_bank_ldy #INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK
  lda #<Cursor0
  sta w0
  lda #>Cursor0
  sta w0+1

  lda state_control_params+inventory_state_control::cursor_column
  sta w3
  lda #0
  sta w3+1

  lda state_control_params+inventory_state_control::cursor_row
  sta w4
  lda #0
  sta w4+1

  lda #0
  sta b2

  jsr sprite_draw_metasprite

  rts

.endproc

.proc draw_tech_selectors

  ;draw the tech1 radio button
  switch_bank_ldy #INVENTORY_STATE_BANK
  clc
  lda inventory_tech1
  adc #menu_position_tech1_rush
  tax
  lda menu_position_column,x
  sta w3
  lda #0
  sta w3+1

  lda menu_position_row,x
  sta w4
  lda #0
  sta w4+1

  lda #0
  sta b2

  lda #<Tech1_Selector
  sta w0
  lda #>Tech1_Selector
  sta w0+1

  switch_bank_ldy #INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_draw_metasprite

  ;draw the tech2 radio button
  switch_bank_ldy #INVENTORY_STATE_BANK
  clc
  lda inventory_tech2
  adc #menu_position_tech2_rush
  tax
  lda menu_position_column,x
  sta w3
  lda #0
  sta w3+1

  lda menu_position_row,x
  sta w4
  lda #0
  sta w4+1

  lda #0
  sta b2

  lda #<Tech2_Selector
  sta w0
  lda #>Tech2_Selector
  sta w0+1

  switch_bank_ldy #INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_draw_metasprite

  rts

.endproc

.segment "ROM03"

;****************************************************************
;This data comprises all the strings visible on the inventory
;screen.
;****************************************************************

;inventory title string
inventory_string: .byte I,N,V,E,N,T,O,R,_Y,ES

;stat strings
gp_string: .byte G,P,ES
keys_string: .byte K,E,_Y,S,ES

;use item menu strings
use_item_string: .byte U,S,E,ES
health_string: .byte H,E,_A,L,T,H,ES
rope_string: .byte R,O,P,E,ES

;carry item menu strings
carry_string: .byte C,_A,R,R,_Y,ES
bomb_string: .byte B,O,M,B,ES
lantern_string: .byte L,_A,N,T,E,R,N,ES

;tech menu strings
tech_string: .byte T,E,C,H,ES
rush_string: .byte R,U,S,H,ES
fetch_string: .byte F,E,T,C,H,ES
carry_bomb_string: .byte C,_A,R,R,_Y,SP,B,O,M,B,ES
carry_lantern_string: .byte C,_A,R,R,_Y,SP,L,_A,N,T,E,R,N,ES
carry_adlanniel_string: .byte C,_A,R,R,_Y,SP,_A,D,L,_A,N,N,I,E,L,ES
shield_string: .byte S,H,I,E,L,D,ES
homing_string: .byte H,O,M,I,N,G,ES

;****************************************************************
;These routines are used for drawing the inventory screen. Some
;are used for drawing the entire screen when graphics are off,
;others are used for one-off updates of individual menu items
;when an action has been performed.
;****************************************************************
.macro print_string_if_menu_item_enabled is_enabled_callback, string_address, nametable_hibyte, row, column

  jsr is_enabled_callback
  beq :+
  print_string string_address, nametable_hibyte, row, column
:

.endmacro

.proc draw_inventory_strings

  lda state_control_params+inventory_state_control::digits_chr_offset
  sta chr_group_offset

  print_decimal_string inventory_gp, inventory_gp+1, #$20, #7, #9
  print_decimal_string inventory_keys, #0, #$20, #8, #9
  print_decimal_string inventory_healths, #0, #$20, #USE_ITEM_ROW, #24
  print_decimal_string inventory_ropes, #0, #$20, #USE_ITEM_ROW+1, #24

  print_decimal_string inventory_bombs, #0, #$20, #CARRY_LANTERN_ROW, #24
  print_decimal_string inventory_lanterns, #0, #$20, #CARRY_LANTERN_ROW+1, #24

  lda textbox_and_font_chr_offset
  sta chr_group_offset
  print_string inventory_string, #$20, #4, #11

  print_string gp_string, #$20, #7, #4
  print_string keys_string, #$20, #8, #4

  print_string use_item_string, #$20, #USE_ITEM_ROW, #4
  print_string_if_menu_item_enabled health_is_enabled, health_string, #$20, #USE_ITEM_ROW, #13
  print_string_if_menu_item_enabled rope_is_enabled, rope_string, #$20, #USE_ITEM_ROW+1, #13

  print_string carry_string, #$20, #CARRY_LANTERN_ROW, #4
  print_string_if_menu_item_enabled bomb_is_enabled, bomb_string, #$20, #CARRY_LANTERN_ROW, #13
  print_string_if_menu_item_enabled lantern_is_enabled, lantern_string, #$20, #CARRY_LANTERN_ROW+1, #13

  print_string tech_string, #$20, #TECH_MENU_ROW, #4
  print_string_if_menu_item_enabled tech_rush_is_enabled, rush_string, #$20, #TECH_MENU_ROW, #13
  print_string_if_menu_item_enabled tech_fetch_is_enabled, fetch_string, #$20, #TECH_MENU_ROW+1, #13
  print_string_if_menu_item_enabled tech_carry_bomb_is_enabled, carry_bomb_string, #$20, #TECH_MENU_ROW+2, #13
  print_string_if_menu_item_enabled tech_carry_lantern_is_enabled, carry_lantern_string, #$20, #TECH_MENU_ROW+3, #13
  print_string_if_menu_item_enabled tech_carry_adlanniel_is_enabled, carry_adlanniel_string, #$20, #TECH_MENU_ROW+4, #13
  print_string_if_menu_item_enabled tech_shield_is_enabled, shield_string, #$20, #TECH_MENU_ROW+5, #13
  print_string_if_menu_item_enabled tech_homing_is_enabled, homing_string, #$20, #TECH_MENU_ROW+6, #13

  rts

.endproc

.proc play_dpad_sound

  ;play a sound
  txa
  pha

  lda #<sfx_move_cursor
  sta sound_param_word_0
  lda #>sfx_move_cursor
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  rts

.endproc

.proc play_action_sound
  ;play a sound
  txa
  pha

  lda #<sfx_select
  sta sound_param_word_0
  lda #>sfx_select
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  rts

.endproc

;****************************************************************
;This is the main menu navigation routine. It uses the look up
;tables below to determine where to put the cursor next based
;on which dpad button was pressed, plays a sound for moving the
;cursor, and also calls action callback routines when the action
;(A) button is pressed. It also skips over menu items that are
;currently disabled due to not having any of a certain item or
;not having earned a given technique.
;****************************************************************
.proc update_cursor

  ;test A button and call callback for current menu position if pressed
  .scope
  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne a_not_pressed

  ldx state_control_params+inventory_state_control::menu_position
  lda menu_position_action_callbacks_lo,x
  sta w0
  lda menu_position_action_callbacks_hi,x
  sta w0+1
  jsr indirect_jsr_w0

  jmp done
a_not_pressed:
  ;if A button was not pressed, then figure out where the cursor
  ;should go next
  lda buffer_controller+buttons::_left
  and #%00000011
  cmp #%00000001
  bne left_not_pressed

  jsr play_dpad_sound
  ldx state_control_params+inventory_state_control::menu_position
  lda menu_position_next_left,x
  sta state_control_params+inventory_state_control::menu_position
  tax
  lda menu_position_row,x
  sta state_control_params+inventory_state_control::cursor_row
  lda menu_position_column,x
  sta state_control_params+inventory_state_control::cursor_column

  jmp done
left_not_pressed:
  lda buffer_controller+buttons::_right
  and #%00000011
  cmp #%00000001
  bne right_not_pressed

  jsr play_dpad_sound
  ldx state_control_params+inventory_state_control::menu_position
  lda menu_position_next_right,x
  sta state_control_params+inventory_state_control::menu_position
  tax
  lda menu_position_row,x
  sta state_control_params+inventory_state_control::cursor_row
  lda menu_position_column,x
  sta state_control_params+inventory_state_control::cursor_column

  jmp done
right_not_pressed:
  lda buffer_controller+buttons::_down
  and #%00000011
  cmp #%00000001
  bne down_not_pressed

  jsr play_dpad_sound
  .scope
  ldx state_control_params+inventory_state_control::menu_position
  ldy #menu_position_tech2_homing
try_next_menu_item:
  lda menu_position_next_down,x
  tax
  lda menu_position_is_enabled_callbacks_lo,x
  sta w0
  lda menu_position_is_enabled_callbacks_hi,x
  sta w0+1
  jsr indirect_jsr_w0
  beq menu_item_disabled
  stx state_control_params+inventory_state_control::menu_position
  lda menu_position_row,x
  sta state_control_params+inventory_state_control::cursor_row
  lda menu_position_column,x
  sta state_control_params+inventory_state_control::cursor_column
  jmp done
menu_item_disabled:
  dey
  bne try_next_menu_item
done:
  .endscope

  jmp done
down_not_pressed:
  lda buffer_controller+buttons::_up
  and #%00000011
  cmp #%00000001
  bne up_not_pressed

  jsr play_dpad_sound
  .scope
  ldx state_control_params+inventory_state_control::menu_position
  ldy #menu_position_tech2_homing
try_next_menu_item:
  lda menu_position_next_up,x
  tax
  lda menu_position_is_enabled_callbacks_lo,x
  sta w0
  lda menu_position_is_enabled_callbacks_hi,x
  sta w0+1
  jsr indirect_jsr_w0
  beq menu_item_disabled
  stx state_control_params+inventory_state_control::menu_position
  lda menu_position_row,x
  sta state_control_params+inventory_state_control::cursor_row
  lda menu_position_column,x
  sta state_control_params+inventory_state_control::cursor_column
  jmp done
menu_item_disabled:
  dey
  bne try_next_menu_item
done:
  .endscope

  jmp done
up_not_pressed:

dpad_not_pressed:
done:
  .endscope
  rts

.endproc

;****************************************************************
;These look up tables define menu navigation. They define where
;the cursor should be located for each menu position and also
;where the cursor should go for up, down, left, right for every
;position in the menu.
;****************************************************************
menu_position_row:
  .byte 8 * 13
  .byte 8 * 14
  .byte 8 * 17
  .byte 8 * 18
  .byte 8 * 19
  .byte 8 * 20
  .byte 8 * 21
  .byte 8 * 22
  .byte 8 * 23
  .byte 8 * 17
  .byte 8 * 18
  .byte 8 * 19
  .byte 8 * 20
  .byte 8 * 21
  .byte 8 * 22
  .byte 8 * 23

menu_position_column:
  .byte 8 * 11
  .byte 8 * 11
  .byte 8 * 9
  .byte 8 * 9
  .byte 8 * 9
  .byte 8 * 9
  .byte 8 * 9
  .byte 8 * 9
  .byte 8 * 9
  .byte 8 * 11
  .byte 8 * 11
  .byte 8 * 11
  .byte 8 * 11
  .byte 8 * 11
  .byte 8 * 11
  .byte 8 * 11

menu_position_next_left:
  .byte menu_position_health
  .byte menu_position_rope
  .byte menu_position_tech1_rush
  .byte menu_position_tech1_fetch
  .byte menu_position_tech1_carry_bomb
  .byte menu_position_tech1_carry_lantern
  .byte menu_position_tech1_carry_adlanniel
  .byte menu_position_tech1_shield
  .byte menu_position_tech1_homing
  .byte menu_position_tech1_rush
  .byte menu_position_tech1_fetch
  .byte menu_position_tech1_carry_bomb
  .byte menu_position_tech1_carry_lantern
  .byte menu_position_tech1_carry_adlanniel
  .byte menu_position_tech1_shield
  .byte menu_position_tech1_homing

menu_position_next_right:
  .byte menu_position_health
  .byte menu_position_rope
  .byte menu_position_tech2_rush
  .byte menu_position_tech2_fetch
  .byte menu_position_tech2_carry_bomb
  .byte menu_position_tech2_carry_lantern
  .byte menu_position_tech2_carry_adlanniel
  .byte menu_position_tech2_shield
  .byte menu_position_tech2_homing
  .byte menu_position_tech2_rush
  .byte menu_position_tech2_fetch
  .byte menu_position_tech2_carry_bomb
  .byte menu_position_tech2_carry_lantern
  .byte menu_position_tech2_carry_adlanniel
  .byte menu_position_tech2_shield
  .byte menu_position_tech2_homing

menu_position_next_up:
  .byte menu_position_health
  .byte menu_position_health
  .byte menu_position_rope
  .byte menu_position_tech1_rush
  .byte menu_position_tech1_fetch
  .byte menu_position_tech1_carry_bomb
  .byte menu_position_tech1_carry_lantern
  .byte menu_position_tech1_carry_adlanniel
  .byte menu_position_tech1_shield
  .byte menu_position_rope
  .byte menu_position_tech2_rush
  .byte menu_position_tech2_fetch
  .byte menu_position_tech2_carry_bomb
  .byte menu_position_tech2_carry_lantern
  .byte menu_position_tech2_carry_adlanniel
  .byte menu_position_tech2_shield

menu_position_next_down:
  .byte menu_position_rope
  .byte menu_position_tech2_rush
  .byte menu_position_tech1_fetch
  .byte menu_position_tech1_carry_bomb
  .byte menu_position_tech1_carry_lantern
  .byte menu_position_tech1_carry_adlanniel
  .byte menu_position_tech1_shield
  .byte menu_position_tech1_homing
  .byte menu_position_tech1_homing
  .byte menu_position_tech2_fetch
  .byte menu_position_tech2_carry_bomb
  .byte menu_position_tech2_carry_lantern
  .byte menu_position_tech2_carry_adlanniel
  .byte menu_position_tech2_shield
  .byte menu_position_tech2_homing
  .byte menu_position_tech2_homing

;****************************************************************
;These callbacks perform actions for each menu position. They
;use items (health, owl health, rope, etc.), or select which item
;the owl can carry when using the carry item technique, or select
;the two selected techniques.
;****************************************************************
.define menu_position_action_callbacks \
  menu_position_action_callback_test, \
  menu_position_action_callback_test, \
  menu_position_tech1_column_callback, \
  menu_position_tech1_column_callback, \
  menu_position_tech1_column_callback, \
  menu_position_tech1_column_callback, \
  menu_position_tech1_column_callback, \
  menu_position_tech1_column_callback, \
  menu_position_tech1_column_callback, \
  menu_position_tech2_column_callback, \
  menu_position_tech2_column_callback, \
  menu_position_tech2_column_callback, \
  menu_position_tech2_column_callback, \
  menu_position_tech2_column_callback, \
  menu_position_tech2_column_callback, \
  menu_position_tech2_column_callback

menu_position_action_callbacks_lo:
  .lobytes menu_position_action_callbacks

menu_position_action_callbacks_hi:
  .hibytes menu_position_action_callbacks

.proc menu_position_action_callback_test

  jsr play_action_sound

  rts

.endproc

.proc menu_position_tech1_column_callback

  jsr play_action_sound
  sec
  lda state_control_params+inventory_state_control::menu_position
  sbc #menu_position_tech1_rush
  sta inventory_tech1

  rts

.endproc

.proc menu_position_tech2_column_callback

  jsr play_action_sound
  sec
  lda state_control_params+inventory_state_control::menu_position
  sbc #menu_position_tech2_rush
  sta inventory_tech2

  rts

.endproc

;****************************************************************
;These callbacks help the menu system determine whether to skip
;over or even draw individual bits of the menu. They look at
;global inventory state to determine if the player owns any
;of an item type or has earned a given technique type. In
;general, these routines will set the zero flag when not enabled
;and clear the zero flag when enabled.
;****************************************************************
.define menu_position_is_enabled_callbacks \
  health_is_enabled, \
  rope_is_enabled, \
  tech_rush_is_enabled, \
  tech_fetch_is_enabled, \
  tech_carry_bomb_is_enabled, \
  tech_carry_lantern_is_enabled, \
  tech_carry_adlanniel_is_enabled, \
  tech_shield_is_enabled, \
  tech_homing_is_enabled, \
  tech_rush_is_enabled, \
  tech_fetch_is_enabled, \
  tech_carry_bomb_is_enabled, \
  tech_carry_lantern_is_enabled, \
  tech_carry_adlanniel_is_enabled, \
  tech_shield_is_enabled, \
  tech_homing_is_enabled

menu_position_is_enabled_callbacks_lo:
  .lobytes menu_position_is_enabled_callbacks

menu_position_is_enabled_callbacks_hi:
  .hibytes menu_position_is_enabled_callbacks

.proc health_is_enabled
  lda inventory_healths
  rts
.endproc

.proc rope_is_enabled
  lda inventory_ropes
  rts
.endproc

.proc bomb_is_enabled
  lda inventory_bombs
  rts
.endproc

.proc lantern_is_enabled
  lda inventory_lanterns
  rts
.endproc

.macro tech_is_enabled tech
  lda inventory_earned_techs
  cmp #tech
  bpl :+
  ;result was negative, this means inventory_earned_techs was smaller than
  ;the tech we're looking at, which means this tech has not been earned yet,
  ;so it is not enabled, so we want to set the zero flag.
  lda #0
  rts
:
  ;result was positive, this means inventory_earned_techs was greater than
  ;the tech we're looking at, which means this tech is earned, so it is
  ;enabled, so we want to clear the zero flag.
  lda #1
.endmacro

.proc tech_rush_is_enabled
  tech_is_enabled tech_rush_earned
  rts
.endproc

.proc tech_fetch_is_enabled
  tech_is_enabled tech_fetch_earned
  rts
.endproc

.proc tech_carry_bomb_is_enabled
  tech_is_enabled tech_carry_bomb_earned
  rts
.endproc

.proc tech_carry_lantern_is_enabled
  tech_is_enabled tech_carry_lantern_earned
  rts
.endproc

.proc tech_carry_adlanniel_is_enabled
  tech_is_enabled tech_carry_adlanniel_earned
  rts
.endproc

.proc tech_shield_is_enabled
  tech_is_enabled tech_shield_earned
  rts
.endproc

.proc tech_homing_is_enabled
  tech_is_enabled tech_homing_earned
  rts
.endproc

.proc indirect_jsr_w0
  jmp (w0)
.endproc
