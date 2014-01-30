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
.include "charmap.inc"
.include "inventory.inc"
.include "hero_constants.inc"

.segment "CODE"

inventory_screen_palette:
  .byte $0e,$05,$28,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0e,$05,$28,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

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
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

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
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  ;reset tile accumulator
  lda #$00
  sta b3

  ldx #sprite_chr_group_index_inventory
  lda sprite_chr_group_addresses_lo,x
  sta w0
  lda sprite_chr_group_addresses_hi,x
  sta w0+1

  ;store the current chr offset in sprite_chr_groups_chr_offsets array for the inventory sprites
  ldy #sprite_chr_group_index_inventory
  lda b3
  sta sprite_chr_group_offsets,y

  lda sprite_chr_group_bank,y
  tay
  switch_bank_y
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
  sta ppu_2006+1
  upload_ppu_2006

  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005

  lda #0
  sta state_control_params+inventory_state_control::string_address
  sta state_control_params+inventory_state_control::string_address+1
  sta state_control_params+inventory_state_control::string_row
  sta state_control_params+inventory_state_control::string_column

  lda #<rush_tech1_menu_position
  sta state_control_params+inventory_state_control::current_menu_position_address
  lda #>rush_tech1_menu_position
  sta state_control_params+inventory_state_control::current_menu_position_address+1

  far_call #INVENTORY_STATE_BANK, inventory_state_draw

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

  jsr controller_clear

inventory_state_main:

  wait_vblank_flag

  jsr controller_read

  jsr sprite_clear_all

  far_call #INVENTORY_STATE_BANK, inventory_state_update

  ;test start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq inventory_state_exit

  set_vblank_flag

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

  lda state_control_params+inventory_state_control::string_address
  sta w0
  lda state_control_params+inventory_state_control::string_address+1
  beq no_string_to_print
  sta w0+1

  lda state_control_params+inventory_state_control::digits_chr_offset
  sta chr_group_offset

  lda #$20
  sta b0
  lda state_control_params+inventory_state_control::string_row
  sta b1
  lda state_control_params+inventory_state_control::string_column
  sta b2
  jsr print_string_impl

  lda #0
  sta state_control_params+inventory_state_control::string_address
  sta state_control_params+inventory_state_control::string_address+1

  ;reset scroll
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005

no_string_to_print:

  lda #0
  sta vblank_wait_flag

  rts

.endproc

.segment "ROM01"

.proc inventory_state_draw

  ;start at the beginning of the menu labels
  lda #<menu_labels
  sta w10
  lda #>menu_labels
  sta w10+1

  lda #<print_menu_label
  sta w2
  lda #>print_menu_label
  sta w2+1

  jsr draw_all_menu_items

  ;start at the beginning of the menu variables
  lda #<menu_word_variables
  sta w10
  lda #>menu_word_variables
  sta w10+1

  lda #<print_menu_word_variable
  sta w2
  lda #>print_menu_word_variable
  sta w2+1

  jsr draw_all_menu_items

  ;start at the beginning of the menu variables
  lda #<menu_byte_variables
  sta w10
  lda #>menu_byte_variables
  sta w10+1

  lda #<print_menu_byte_variable
  sta w2
  lda #>print_menu_byte_variable
  sta w2+1

  jsr draw_all_menu_items

  jsr draw_cursor

  jsr draw_tech_selectors

  jsr sprite_update_all

  rts

.endproc

.proc inventory_state_update

  jsr update_cursor
  jsr draw_cursor
  jsr draw_tech_selectors

  rts

.endproc

.proc print_menu_label
menu_labels_address = w10

  lda textbox_and_font_chr_offset
  sta chr_group_offset

  ldy #inventory_state_menu_item::item_address
  lda (menu_labels_address),y
  sta w0
  iny
  lda (menu_labels_address),y
  sta w0+1

  lda #$20
  sta b0

  ldy #inventory_state_menu_item::item_row
  lda (menu_labels_address),y
  sta b1
  ldy #inventory_state_menu_item::item_column
  lda (menu_labels_address),y
  sta b2
  jsr print_string_impl

  rts

.endproc

.proc print_menu_word_variable
menu_labels_address = w10

  lda state_control_params+inventory_state_control::digits_chr_offset
  sta chr_group_offset

  ldy #inventory_state_menu_item::item_address
  lda (menu_labels_address),y
  sta w0
  iny
  lda (menu_labels_address),y
  sta w0+1

  ;transfer value at w0 into w0 using the stack
  ldy #0
  lda (w0),y
  pha
  iny
  lda (w0),y

  sta w0+1
  pla
  sta w0

  lda #<string_buffer
  sta w1
  lda #>string_buffer
  sta w1+1
  jsr create_decimal_string

  lda #$20
  sta b0

  ldy #inventory_state_menu_item::item_row
  lda (menu_labels_address),y
  sta b1

  ldy #inventory_state_menu_item::item_column
  lda (menu_labels_address),y
  sta b2

  lda #<string_buffer
  sta w0
  lda #>string_buffer
  sta w0+1

  jsr print_string_impl

  rts

.endproc

.proc print_menu_byte_variable
menu_labels_address = w10

  lda state_control_params+inventory_state_control::digits_chr_offset
  sta chr_group_offset

  ldy #inventory_state_menu_item::item_address
  lda (menu_labels_address),y
  sta w0
  iny
  lda (menu_labels_address),y
  sta w0+1

  ;transfer value at w0 into w0. Assume hi byte is 0 since we are
  ;printing a byte variable.
  ldy #0
  lda (w0),y
  sta w0
  lda #0
  sta w0+1

  lda #<string_buffer
  sta w1
  lda #>string_buffer
  sta w1+1
  jsr create_decimal_string

  lda #$20
  sta b0

  ldy #inventory_state_menu_item::item_row
  lda (menu_labels_address),y
  sta b1

  ldy #inventory_state_menu_item::item_column
  lda (menu_labels_address),y
  sta b2

  lda #<string_buffer
  sta w0
  lda #>string_buffer
  sta w0+1

  jsr print_string_impl

  rts

.endproc

;draws all menu items in a list.
;expects w2 to contain a callback for printing each menu item
;expects w10 to point to the first item to begin drawing.
.proc draw_all_menu_items
menu_item_print_callback = w2
menu_items_address = w10

next_menu_item:
  ;exit loop if we have reached the end of all menu labels
  ldy #0
  lda (menu_items_address),y
  iny
  ora (menu_items_address),y
  cmp #LAST_MENU_ITEM
  beq done

  ;test to see if the menu item is enabled
  ldy #inventory_state_menu_item::is_enabled_callback_address
  lda (menu_items_address),y
  sta w3
  iny
  lda (menu_items_address),y
  sta w3+1

  jsr indirect_jsr_w3
  bne not_enabled

  ;draw the menu item
  jsr indirect_jsr_w2
not_enabled:

  ;advance to next menu label
  clc
  lda menu_items_address
  adc #<(.sizeof(inventory_state_menu_item))
  sta menu_items_address
  lda menu_items_address+1
  adc #>(.sizeof(inventory_state_menu_item))
  sta menu_items_address+1

  jmp next_menu_item
done:

  rts

.endproc

.proc draw_cursor
menu_position_address = w10

  ldy #sprite_chr_group_index_inventory
  lda sprite_chr_group_offsets,y
  sta chr_group_offset

  lda state_control_params+inventory_state_control::current_menu_position_address
  sta menu_position_address
  lda state_control_params+inventory_state_control::current_menu_position_address+1
  sta menu_position_address+1

  ldy #inventory_state_menu_position::cursor_metasprite
  lda (menu_position_address),y
  sta w0
  iny
  lda (menu_position_address),y
  sta w0+1

  ;column
  ldy #inventory_state_menu_position::cursor_column
  lda (menu_position_address),y
  sta w3
  lda #0
  sta w3+1

  ;row
  ldy #inventory_state_menu_position::cursor_row
  lda (menu_position_address),y
  sta w4
  lda #0
  sta w4+1

  lda #0
  sta b2

  far_call #INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK, sprite_draw_metasprite

  rts

.endproc

.proc draw_tech_selectors
row_offset = b0

  ;draw the tech1 radio button
  lda #((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)
  sta w3
  lda #0
  sta w3+1

  lda inventory_tech1
  asl
  asl
  asl
  sta row_offset

  clc
  lda #(TECH_MENU_ROW * 8)
  adc row_offset
  sta w4
  lda #0
  adc #0
  sta w4+1

  lda #0
  sta b2

  lda #<Tech1_Selector
  sta w0
  lda #>Tech1_Selector
  sta w0+1

  far_call #INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK, sprite_draw_metasprite

  ;draw the tech2 radio button
  lda #((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)
  sta w3
  lda #0
  sta w3+1

  lda inventory_tech2
  asl
  asl
  asl
  sta row_offset

  clc
  lda #(TECH_MENU_ROW * 8)
  adc row_offset
  sta w4
  lda #0
  adc #0
  sta w4+1

  lda #0
  sta b2

  lda #<Tech2_Selector
  sta w0
  lda #>Tech2_Selector
  sta w0+1

  far_call #INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK, sprite_draw_metasprite

  rts

.endproc

.proc update_cursor
DPAD_TEST = %01000000
menu_position_address = w10
next_menu_position_address = w11

  lda state_control_params+inventory_state_control::current_menu_position_address
  sta menu_position_address
  lda state_control_params+inventory_state_control::current_menu_position_address+1
  sta menu_position_address+1

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne a_not_pressed

  ldy #inventory_state_menu_position::a_button_callback_address
  lda (menu_position_address),y
  sta w0
  iny
  lda (menu_position_address),y
  sta w0+1
  jsr indirect_jsr_w0

  rts

a_not_pressed:

  ;check all dpad buttons one at a time.
  lda buffer_controller+buttons::_down
  and #DPAD_TEST
  bne down
  lda buffer_controller+buttons::_up
  and #DPAD_TEST
  bne up
  lda buffer_controller+buttons::_left
  and #DPAD_TEST
  bne left
  lda buffer_controller+buttons::_right
  and #DPAD_TEST
  bne right
  rts
down:
  lda #0
  sta buffer_controller+buttons::_down
  ldy #inventory_state_menu_position::next_menu_item_down_address
  jmp update_menu_item
up:
  lda #0
  sta buffer_controller+buttons::_up
  ldy #inventory_state_menu_position::next_menu_item_up_address
  jmp update_menu_item
left:
  lda #0
  sta buffer_controller+buttons::_left
  ldy #inventory_state_menu_position::next_menu_item_left_address
  jmp update_menu_item
right:
  lda #0
  sta buffer_controller+buttons::_right
  ldy #inventory_state_menu_position::next_menu_item_right_address
  jmp update_menu_item
update_menu_item:

  ;if the next item is null, bail
  lda (menu_position_address),y
  iny
  ora (menu_position_address),y
  beq item_was_null

  ;the item was not null, update the current menu item address and finish
  dey
  lda (menu_position_address),y
  sta next_menu_position_address
  iny
  lda (menu_position_address),y
  sta next_menu_position_address+1

  ldy #inventory_state_menu_position::is_enabled_callback_address
  lda (next_menu_position_address),y
  sta w0
  iny
  lda (next_menu_position_address),y
  sta w0+1

  jsr indirect_jsr_w0
  bne not_enabled

  ;item is enabled, advance to next_menu_position_address
  lda next_menu_position_address
  sta state_control_params+inventory_state_control::current_menu_position_address
  lda next_menu_position_address+1
  sta state_control_params+inventory_state_control::current_menu_position_address+1

  jsr play_dpad_sound
not_enabled:
item_was_null:

  rts

.endproc

.proc play_dpad_sound

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

.proc play_use_item_sound

  txa
  pha

  lda #<sfx_get_item
  sta sound_param_word_0
  lda #>sfx_get_item
  sta sound_param_word_0+1

  lda #1
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  rts

.endproc

.proc play_error_sound

  txa
  pha

  lda #<sfx_error
  sta sound_param_word_0
  lda #>sfx_error
  sta sound_param_word_0+1

  lda #1
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  rts

.endproc

.proc indirect_jsr_w0
  jmp (w0)
.endproc

.proc indirect_jsr_w1
  jmp (w1)
.endproc

.proc indirect_jsr_w2
  jmp (w2)
.endproc

.proc indirect_jsr_w3
  jmp (w3)
.endproc

.proc is_enabled_callback_nop

  lda #0

  rts

.endproc

a_button_callback_nop:
print_callback_nop:
.proc callback_nop

  rts

.endproc

.proc tech_label_is_enabled_callback
menu_item_address = w10

  ldy #inventory_state_menu_item::callback_param

  lda inventory_earned_techs
  cmp (menu_item_address),y
  bpl :+
  lda #1
  rts
:
  lda #0
  rts

.endproc

.proc tech_menu_position_is_enabled_callback
next_menu_position_address = w11

  ldy #inventory_state_menu_position::callback_param

  lda inventory_earned_techs
  cmp (next_menu_position_address),y
  bpl :+
  lda #1
  rts
:
  lda #0
  rts

.endproc

.proc health_a_button_callback
menu_position_address = w10

  lda state_control_params+inventory_state_control::current_menu_position_address
  sta menu_position_address
  lda state_control_params+inventory_state_control::current_menu_position_address+1
  sta menu_position_address+1

  lda #HERO_MAX_HEALTH
  cmp hero_health
  beq do_not_inc_health

  lda inventory_healths
  beq do_not_inc_health

  jsr play_use_item_sound

  dec inventory_healths

  inc hero_health

  lda inventory_healths
  sta w0
  lda #0
  sta w0+1
  lda #<string_buffer
  sta w1
  lda #>string_buffer
  sta w1+1
  jsr create_decimal_string

  lda #<string_buffer
  sta state_control_params+inventory_state_control::string_address
  lda #>string_buffer
  sta state_control_params+inventory_state_control::string_address+1

  lda #USE_ITEM_ROW
  sta state_control_params+inventory_state_control::string_row
  lda #24
  sta state_control_params+inventory_state_control::string_column

  rts

do_not_inc_health:

  jsr play_error_sound

  rts

.endproc

.proc tech1_a_button_callback
menu_position_address = w10

  lda state_control_params+inventory_state_control::current_menu_position_address
  sta menu_position_address
  lda state_control_params+inventory_state_control::current_menu_position_address+1
  sta menu_position_address+1

  ldy #inventory_state_menu_position::callback_param
  lda (menu_position_address),y
  sta inventory_tech1

  jsr play_action_sound

  rts

.endproc

.proc tech2_a_button_callback
menu_position_address = w10

  lda state_control_params+inventory_state_control::current_menu_position_address
  sta menu_position_address
  lda state_control_params+inventory_state_control::current_menu_position_address+1
  sta menu_position_address+1

  ldy #inventory_state_menu_position::callback_param
  lda (menu_position_address),y
  sta inventory_tech2

  jsr play_action_sound

  rts

.endproc

health_menu_position:
  .word is_enabled_callback_nop
  .word health_a_button_callback
  callback_param 0
  next_up    0
  next_right 0
  next_left  0
  next_down  rope_menu_position
  .word Radio0
  .byte (USE_ITEM_ROW * 8)
  .byte (11 * 8)

rope_menu_position:
  .word is_enabled_callback_nop
  .word a_button_callback_nop
  callback_param 0
  next_up    health_menu_position
  next_right 0
  next_left  0
  next_down  rush_tech2_menu_position
  .word Radio0
  .byte ((USE_ITEM_ROW+1) * 8)
  .byte (11 * 8)

rush_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_rush
  next_up    rope_menu_position
  next_right rush_tech2_menu_position
  next_left  0
  next_down  fetch_tech1_menu_position
  .word Cursor0
  .byte (TECH_MENU_ROW * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

fetch_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_fetch
  next_up    rush_tech1_menu_position
  next_right fetch_tech2_menu_position
  next_left  0
  next_down  carry_bomb_tech1_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+1) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

carry_bomb_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_carry_bomb
  next_up    fetch_tech1_menu_position
  next_right carry_bomb_tech2_menu_position
  next_left  0
  next_down  carry_lantern_tech1_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+2) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

carry_lantern_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_carry_lantern
  next_up    carry_bomb_tech1_menu_position
  next_right carry_lantern_tech2_menu_position
  next_left  0
  next_down  carry_adlanniel_tech1_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+3) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

carry_adlanniel_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_carry_adlanniel
  next_up    carry_lantern_tech1_menu_position
  next_right carry_adlanniel_tech2_menu_position
  next_left  0
  next_down  shield_tech1_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+4) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

shield_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_shield
  next_up    carry_adlanniel_tech1_menu_position
  next_right shield_tech2_menu_position
  next_left  0
  next_down  homing_tech1_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+5) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

homing_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_homing
  next_up    shield_tech1_menu_position
  next_right homing_tech2_menu_position
  next_left  0
  next_down  0
  .word Cursor0
  .byte ((TECH_MENU_ROW+6) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

rush_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_rush
  next_up    rope_menu_position
  next_right 0
  next_left  rush_tech1_menu_position
  next_down  fetch_tech2_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

fetch_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_fetch
  next_up    rush_tech2_menu_position
  next_right 0
  next_left  fetch_tech1_menu_position
  next_down  carry_bomb_tech2_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+1) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

carry_bomb_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_carry_bomb
  next_up    fetch_tech2_menu_position
  next_right 0
  next_left  carry_bomb_tech1_menu_position
  next_down  carry_lantern_tech2_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+2) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

carry_lantern_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_carry_lantern
  next_up    carry_bomb_tech2_menu_position
  next_right 0
  next_left  carry_lantern_tech1_menu_position
  next_down  carry_adlanniel_tech2_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+3) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

carry_adlanniel_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_carry_adlanniel
  next_up    carry_lantern_tech2_menu_position
  next_right 0
  next_left  carry_adlanniel_tech1_menu_position
  next_down  shield_tech2_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+4) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

shield_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_shield
  next_up    carry_adlanniel_tech2_menu_position
  next_right 0
  next_left  shield_tech1_menu_position
  next_down  homing_tech2_menu_position
  .word Cursor0
  .byte ((TECH_MENU_ROW+5) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

homing_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_homing
  next_up    shield_tech2_menu_position
  next_right 0
  next_left  homing_tech1_menu_position
  next_down  0
  .word Cursor0
  .byte ((TECH_MENU_ROW+6) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

;****************************************************************
;This data comprises all the strings visible on the inventory
;screen.
;****************************************************************

;inventory title string
inventory_string: .byte "INVENTORY",ES

;stat strings
gp_string: .byte "GP",ES
keys_string: .byte "KEYS",ES

;use item menu strings
use_item_string: .byte "USE",ES
health_string: .byte "HEALTH",ES
rope_string: .byte "ROPE",ES

;carry item menu strings
carry_string: .byte "CARRY",ES
bomb_string: .byte "BOMB",ES
lantern_string: .byte "LANTERN",ES

;tech menu strings
tech_string: .byte "TECH",ES
rush_string: .byte "RUSH",ES
fetch_string: .byte "FETCH",ES
carry_bomb_string: .byte "CARRY BOMB",ES
carry_lantern_string: .byte "CARRY LANTERN",ES
carry_adlanniel_string: .byte "CARRY ADLANNIEL",ES
shield_string: .byte "SHIELD",ES
homing_string: .byte "HOMING",ES

menu_word_variables:
gp_variable:
  .word inventory_gp
  .word is_enabled_callback_nop
  callback_param 0
  .byte 7
  .byte 9
  .word LAST_MENU_ITEM

menu_byte_variables:
  .word inventory_keys
  .word is_enabled_callback_nop
  callback_param 0
  .byte 8
  .byte 9
  .word inventory_healths
  .word is_enabled_callback_nop
  callback_param 0
  .byte USE_ITEM_ROW
  .byte 24
  .word inventory_ropes
  .word is_enabled_callback_nop
  callback_param 0
  .byte USE_ITEM_ROW+1
  .byte 24
  .word inventory_bombs
  .word is_enabled_callback_nop
  callback_param 0
  .byte CARRY_LANTERN_ROW
  .byte 24
  .word inventory_lanterns
  .word is_enabled_callback_nop
  callback_param 0
  .byte CARRY_LANTERN_ROW+1
  .byte 24
  .word LAST_MENU_ITEM

menu_labels:
inventory_label:
  .word inventory_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte 4
  .byte 11
gp_label:
  .word gp_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte 7
  .byte 4
keys_label:
  .word keys_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte 8
  .byte 4
use_item_label:
  .word use_item_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte USE_ITEM_ROW
  .byte 4
health_label:
  .word health_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte USE_ITEM_ROW
  .byte 13
rope_label:
  .word rope_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte USE_ITEM_ROW+1
  .byte 13
carry_label:
  .word carry_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte CARRY_LANTERN_ROW
  .byte 4
bomb_label:
  .word bomb_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte CARRY_LANTERN_ROW
  .byte 13
lantern_label:
  .word lantern_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte CARRY_LANTERN_ROW+1
  .byte 13
tech_label:
  .word tech_string
  .word is_enabled_callback_nop
  callback_param 0
  .byte TECH_MENU_ROW
  .byte 4
rush_menu_label:
  .word rush_string
  .word tech_label_is_enabled_callback
  callback_param tech_rush
  .byte TECH_MENU_ROW
  .byte TECH_MENU_COLUMN
fetch_menu_label:
  .word fetch_string
  .word tech_label_is_enabled_callback
  callback_param tech_fetch
  .byte TECH_MENU_ROW+1
  .byte TECH_MENU_COLUMN
carry_bomb_label:
  .word carry_bomb_string
  .word tech_label_is_enabled_callback
  callback_param tech_carry_bomb
  .byte TECH_MENU_ROW+2
  .byte TECH_MENU_COLUMN
carry_lantern_label:
  .word carry_lantern_string
  .word tech_label_is_enabled_callback
  callback_param tech_carry_lantern
  .byte TECH_MENU_ROW+3
  .byte TECH_MENU_COLUMN
carry_adlanniel_label:
  .word carry_adlanniel_string
  .word tech_label_is_enabled_callback
  callback_param tech_carry_adlanniel
  .byte TECH_MENU_ROW+4
  .byte TECH_MENU_COLUMN
shield_label:
  .word shield_string
  .word tech_label_is_enabled_callback
  callback_param tech_shield
  .byte TECH_MENU_ROW+5
  .byte TECH_MENU_COLUMN
homing_label:
  .word homing_string
  .word tech_label_is_enabled_callback
  callback_param tech_homing
  .byte TECH_MENU_ROW+6
  .byte TECH_MENU_COLUMN
  .word LAST_MENU_ITEM
