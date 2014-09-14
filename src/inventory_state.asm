.linecont +
.include "map.inc"
.include "play_state.inc"
.include "current_password_state.inc"
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

.segment "ROM01"

inventory_screen_palette:
  .byte $0e,$05,$28,$38,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$05,$28,$38,$0e,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

inventory_state_init:

  ;set blank nmi routine
  safely_set_vblank_routine ppu_vblank_nop

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

  lda #<inventory_bg_chr
  sta w0
  lda #>inventory_bg_chr
  sta w0+1
  far_call #INVENTORY_STATE_BG_CHR_BANK, ppu_load_chr_amount

  ;grab tile accumulator to know where the textbox group begins
  lda b3
  sta textbox_chr_offset

  ;load the textbox graphics.
  lda #<textbox_chr
  sta w0
  lda #>textbox_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;grab tile accumulator to know where the font group begins
  lda b3
  sta font_chr_offset

  ;load the font graphics.
  lda #<font_chr
  sta w0
  lda #>font_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;load the punctuation graphics.
  lda #<punctuation_chr
  sta w0
  lda #>punctuation_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;grab tile accumulator to know where the digits group begins
  lda b3
  sta state_control_params+inventory_state_control::digits_chr_offset

  ;load the digits graphics, for displaying numbers of items remaining,
  ;gp, and keys.
  lda #<digits_chr
  sta w0
  lda #>digits_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;load cursor graphics
  lda #$10
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  ;reset tile accumulator
  lda #$00
  sta b3

  ldx #sprite_chr_group_index_cursor
  lda sprite_chr_group_addresses_lo,x
  sta w0
  lda sprite_chr_group_addresses_hi,x
  sta w0+1

  ;store the current chr offset for cursor sprites
  lda b3
  sta state_control_params+inventory_state_control::cursor_chr_offset

  far_call {sprite_chr_group_bank,x}, ppu_load_chr_amount

  ;load all tech icon chr data
  lda b3
  sta state_control_params+inventory_state_control::techs_chr_offset

  ldx #sprite_chr_group_index_rushtech
next_tech:
  lda sprite_chr_group_addresses_lo,x
  sta w0
  lda sprite_chr_group_addresses_hi,x
  sta w0+1

  far_call {sprite_chr_group_bank,x}, ppu_load_chr_amount

  inx
  cpx #(sprite_chr_group_index_homingtech+1)
  bne next_tech

  ;load nametable data for inventory screen on opposite nametable from
  ;camera. This won't matter for overworld, since we never use nametable
  ;patching, but for dungeons which are always done at the top left of
  ;one of the two nametables, this will help preserve any nametable
  ;patching that had been previously performed.
  lda camera_nametable_hibyte
  eor #$04
  sta state_control_params+inventory_state_control::nametable_hi

  lda state_control_params+inventory_state_control::nametable_hi
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  lda #<inventory_screen
  sta w0
  lda #>inventory_screen
  sta w0+1
  far_call #INVENTORY_STATE_BG_NAMETABLE_BANK, ppu_load_nametable

  lda #0
  sta state_control_params+inventory_state_control::string_address
  sta state_control_params+inventory_state_control::string_address+1
  sta state_control_params+inventory_state_control::string_row
  sta state_control_params+inventory_state_control::string_column

  lda #<rush_tech1_menu_position
  sta state_control_params+inventory_state_control::current_menu_position_address
  lda #>rush_tech1_menu_position
  sta state_control_params+inventory_state_control::current_menu_position_address+1

  jsr inventory_state_draw

  ;reset scroll
  lda state_control_params+inventory_state_control::nametable_hi
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005

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

  safely_set_vblank_routine ppu_inventory_vblank

  jsr controller_clear
  lda #$ff
  sta buffer_controller+buttons::_start

inventory_state_main:

  clear_vblank_done
  wait_vblank_done

  jsr controller_read

  jsr sprite_clear_all

  far_call #INVENTORY_STATE_BANK, inventory_state_update

  ;test start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq inventory_state_exit

  ;test select button
  lda buffer_controller+buttons::_select
  and #%00000011
  cmp #%00000001
  beq transition_to_current_password_state

  jmp inventory_state_main

transition_to_current_password_state:

  ;play a sound
  lda #<sfx_inventory
  sta sound_param_word_0
  lda #>sfx_inventory
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  jsr ppu_fade_out_palette

  jmp current_password_state_init

inventory_state_exit:

  ;play a sound
  lda #<sfx_inventory
  sta sound_param_word_0
  lda #>sfx_inventory
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  safely_set_vblank_routine ppu_vblank_nop

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

  lda state_control_params+inventory_state_control::nametable_hi
  sta b0
  lda state_control_params+inventory_state_control::string_row
  sta b1
  lda state_control_params+inventory_state_control::string_column
  sta b2
  jsr print_string_impl

  lda #0
  sta state_control_params+inventory_state_control::string_address
  sta state_control_params+inventory_state_control::string_address+1

  upload_ppu_2006
  upload_ppu_2005

no_string_to_print:

  set_vblank_done

  rts

.endproc

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
  lda #<menu_24_bit_variables
  sta w10
  lda #>menu_24_bit_variables
  sta w10+1

  lda #<print_menu_24_bit_variable
  sta w2
  lda #>print_menu_24_bit_variable
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

  lda font_chr_offset
  sta chr_group_offset

  ldy #inventory_state_menu_item::item_address
  lda (menu_labels_address),y
  sta w0
  iny
  lda (menu_labels_address),y
  sta w0+1

  lda state_control_params+inventory_state_control::nametable_hi
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

.proc print_menu_24_bit_variable
menu_labels_address = w10

  lda state_control_params+inventory_state_control::digits_chr_offset
  sta chr_group_offset

  ldy #inventory_state_menu_item::item_address
  lda (menu_labels_address),y
  sta w0
  iny
  lda (menu_labels_address),y
  sta w0+1

  ;transfer value at w0 into b0, b1, b2
  ldy #0
  lda (w0),y
  sta b0
  iny
  lda (w0),y
  sta b1
  iny
  lda (w0),y
  sta b2

  lda #<string_buffer
  sta w1
  lda #>string_buffer
  sta w1+1
  jsr create_decimal_string

  lda state_control_params+inventory_state_control::nametable_hi
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
  sta b0
  lda #0
  sta b1
  sta b2

  lda #<string_buffer
  sta w1
  lda #>string_buffer
  sta w1+1
  jsr create_decimal_string

  lda state_control_params+inventory_state_control::nametable_hi
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

  lda state_control_params+inventory_state_control::cursor_chr_offset
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
  clc
  lda inventory_tech1
  adc state_control_params+inventory_state_control::techs_chr_offset
  sta chr_group_offset

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

  lda #<tech0
  sta w0
  lda #>tech0
  sta w0+1

  far_call #INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK, sprite_draw_metasprite

  ;draw the tech2 radio button
  clc
  lda inventory_tech2
  adc state_control_params+inventory_state_control::techs_chr_offset
  sta chr_group_offset

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

  lda #<tech0
  sta w0
  lda #>tech0
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

  lda #<sfx_move_cursor
  sta sound_param_word_0
  lda #>sfx_move_cursor
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  rts

.endproc

.proc play_action_sound

  lda #<sfx_select
  sta sound_param_word_0
  lda #>sfx_select
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  rts

.endproc

.proc play_use_item_sound

  lda #<sfx_get_item
  sta sound_param_word_0
  lda #>sfx_get_item
  sta sound_param_word_0+1

  lda #1
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  rts

.endproc

.proc play_error_sound

  lda #<sfx_error
  sta sound_param_word_0
  lda #>sfx_error
  sta sound_param_word_0+1

  lda #1
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

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

  ldy #inventory_state_menu_item::callback_param_value

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

  ldy #inventory_state_menu_position::callback_param_value

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
  sta b0
  lda #0
  sta b1
  sta b2
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

  ldy #inventory_state_menu_position::callback_param_value
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

  ldy #inventory_state_menu_position::callback_param_value
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
  next_down  rush_tech2_menu_position
  .word radio0
  .byte (USE_ITEM_ROW * 8)
  .byte (11 * 8)

rush_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_rush
  next_up    health_menu_position
  next_right rush_tech2_menu_position
  next_left  0
  next_down  fetch_tech1_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_rush) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

fetch_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_fetch
  next_up    rush_tech1_menu_position
  next_right fetch_tech2_menu_position
  next_left  0
  next_down  unlock_tech1_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_fetch) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

unlock_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_unlock
  next_up    fetch_tech1_menu_position
  next_right unlock_tech2_menu_position
  next_left  0
  next_down  carry_bomb_tech1_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_unlock) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

carry_bomb_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_carry_bomb
  next_up    unlock_tech1_menu_position
  next_right carry_bomb_tech2_menu_position
  next_left  0
  next_down  carry_lantern_tech1_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_carry_bomb) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

carry_lantern_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_carry_lantern
  next_up    carry_bomb_tech1_menu_position
  next_right carry_lantern_tech2_menu_position
  next_left  0
  next_down  carry_adlanniel_tech1_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_carry_lantern) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

carry_adlanniel_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_carry_adlanniel
  next_up    carry_lantern_tech1_menu_position
  next_right carry_adlanniel_tech2_menu_position
  next_left  0
  next_down  shield_tech1_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_carry_adlanniel) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

shield_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_shield
  next_up    carry_adlanniel_tech1_menu_position
  next_right shield_tech2_menu_position
  next_left  0
  next_down  homing_tech1_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_shield) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

homing_tech1_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech1_a_button_callback
  callback_param tech_homing
  next_up    shield_tech1_menu_position
  next_right homing_tech2_menu_position
  next_left  0
  next_down  0
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_homing) * 8)
  .byte ((TECH_MENU_COLUMN + TECH1_OFFSET) * 8)

rush_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_rush
  next_up    health_menu_position
  next_right 0
  next_left  rush_tech1_menu_position
  next_down  fetch_tech2_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_rush) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

fetch_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_fetch
  next_up    rush_tech2_menu_position
  next_right 0
  next_left  fetch_tech1_menu_position
  next_down  unlock_tech2_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_fetch) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

unlock_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_unlock
  next_up    fetch_tech2_menu_position
  next_right 0
  next_left  unlock_tech1_menu_position
  next_down  carry_bomb_tech2_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_unlock) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

carry_bomb_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_carry_bomb
  next_up    unlock_tech2_menu_position
  next_right 0
  next_left  carry_bomb_tech1_menu_position
  next_down  carry_lantern_tech2_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_carry_bomb) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

carry_lantern_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_carry_lantern
  next_up    carry_bomb_tech2_menu_position
  next_right 0
  next_left  carry_lantern_tech1_menu_position
  next_down  carry_adlanniel_tech2_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_carry_lantern) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

carry_adlanniel_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_carry_adlanniel
  next_up    carry_lantern_tech2_menu_position
  next_right 0
  next_left  carry_adlanniel_tech1_menu_position
  next_down  shield_tech2_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_carry_adlanniel) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

shield_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_shield
  next_up    carry_adlanniel_tech2_menu_position
  next_right 0
  next_left  shield_tech1_menu_position
  next_down  homing_tech2_menu_position
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_shield) * 8)
  .byte ((TECH_MENU_COLUMN + TECH2_OFFSET) * 8)

homing_tech2_menu_position:
  .word tech_menu_position_is_enabled_callback
  .word tech2_a_button_callback
  callback_param tech_homing
  next_up    shield_tech2_menu_position
  next_right 0
  next_left  homing_tech1_menu_position
  next_down  0
  .word cursor0
  .byte ((TECH_MENU_ROW+tech_homing) * 8)
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

;carry item menu strings
carry_string: .byte "CARRY",ES
bomb_string: .byte "BOMB",ES
lantern_string: .byte "LANTERN",ES

;tech menu strings
tech_string: .byte "TECH",ES
rush_string: .byte "RUSH",ES
fetch_string: .byte "FETCH",ES
unlock_string: .byte "UNLOCK",ES
carry_bomb_string: .byte "CARRY BOMB",ES
carry_lantern_string: .byte "CARRY LANTERN",ES
carry_adlanniel_string: .byte "CARRY ADLANNIEL",ES
shield_string: .byte "SHIELD",ES
homing_string: .byte "HOMING",ES

menu_24_bit_variables:
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
  .byte TECH_MENU_ROW+tech_rush
  .byte TECH_MENU_COLUMN
fetch_menu_label:
  .word fetch_string
  .word tech_label_is_enabled_callback
  callback_param tech_fetch
  .byte TECH_MENU_ROW+tech_fetch
  .byte TECH_MENU_COLUMN
unlock_menu_label:
  .word unlock_string
  .word tech_label_is_enabled_callback
  callback_param tech_unlock
  .byte TECH_MENU_ROW+tech_unlock
  .byte TECH_MENU_COLUMN
carry_bomb_label:
  .word carry_bomb_string
  .word tech_label_is_enabled_callback
  callback_param tech_carry_bomb
  .byte TECH_MENU_ROW+tech_carry_bomb
  .byte TECH_MENU_COLUMN
carry_lantern_label:
  .word carry_lantern_string
  .word tech_label_is_enabled_callback
  callback_param tech_carry_lantern
  .byte TECH_MENU_ROW+tech_carry_lantern
  .byte TECH_MENU_COLUMN
carry_adlanniel_label:
  .word carry_adlanniel_string
  .word tech_label_is_enabled_callback
  callback_param tech_carry_adlanniel
  .byte TECH_MENU_ROW+tech_carry_adlanniel
  .byte TECH_MENU_COLUMN
shield_label:
  .word shield_string
  .word tech_label_is_enabled_callback
  callback_param tech_shield
  .byte TECH_MENU_ROW+tech_shield
  .byte TECH_MENU_COLUMN
homing_label:
  .word homing_string
  .word tech_label_is_enabled_callback
  callback_param tech_homing
  .byte TECH_MENU_ROW+tech_homing
  .byte TECH_MENU_COLUMN
  .word LAST_MENU_ITEM
