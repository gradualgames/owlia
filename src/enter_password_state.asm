.feature force_range
.include "enter_password_state.inc"
.include "textbox.inc"
.include "charmap_password.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "sprite.inc"
.include "zp.inc"
.include "ram.inc"
.include "nametable_data.inc"
.include "controller.inc"
.include "play_state.inc"
.include "locations.inc"
.include "inventory.inc"
.include "password.inc"
.include "soundengine.inc"
.include "music_data.inc"
.include "sfx_data.inc"
.include "sprite_chr_data.inc"
.include "sprites_and_animations_data.inc"
.include "controller.inc"
.include "ppu.inc"
.include "start_game_state.inc"

.segment "ROM01"

overworld_start_locations:
  .byte $ff
  .byte location_index_village_house1_entrance
  .byte location_index_meadow1_top_entrance
  .byte location_index_tundra1_entrance
  .byte location_index_mountain1_south_entrance
  .byte location_index_island1_entrance
  .byte $ff
  .byte $ff
  .byte $ff

dungeon_start_locations:
  .byte $ff
  .byte $ff
  .byte location_index_dungeon_0_3_s
  .byte location_index_dungeon2_2_3_s
  .byte location_index_dungeon3_entrance
  .byte location_index_dungeon4_entrance
  .byte $ff
  .byte $ff

enter_password_state_palette:
  .byte $0e,$0e,$18,$20,$0e,$04,$14,$24,$0e,$17,$28,$38,$0e,$0e,$0e,$0e
  .byte $0e,$05,$28,$38,$0e,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

box_top_string:
  .byte TOP_LEFT_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_TILE_OFFSET
  .byte TOP_RIGHT_TILE_OFFSET
  .byte ES

box_bottom_string:
  .byte BOTTOM_LEFT_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_TILE_OFFSET
  .byte BOTTOM_RIGHT_TILE_OFFSET
  .byte ES

box_left_string:
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte ES

box_right_string:
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte ES

password_chars_row1: .byte "A B C D E F",ES
password_chars_row2: .byte "G H I J K L",ES
password_chars_row3: .byte "M N O P Q R",ES
password_chars_row4: .byte "S T U V W X",ES
password_chars_row5: .byte "Y Z 0 1 2 3",ES
password_chars_row6: .byte "4 5 6 7 8 9",ES

password_chars: .byte "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

enter_password_string: .byte "ENTER PASSWORD",ES

clear_string: .byte "          ",ES

press_start_to_confirm_string: .byte "PRESS START TO CONFIRM",ES

cursor_meta_sprite:
  .byte $01
  .byte $00,$09,$00,$00,$00

cursor_position_x:
  .byte 10*8+4,10*8+4

cursor_position_y:
  .byte 13*8, 15*8

enter_password_state_init:

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

  sta textbox_chr_offset

  ;load the textbox graphics.
  lda #<textbox_chr
  sta w0
  lda #>textbox_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;grab tile accumulator to know where font group begins
  lda b3
  sta font_chr_offset

  ;load the font graphics.
  lda #<font_chr
  sta w0
  lda #>font_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;load the digit graphics.
  lda #<digits_chr
  sta w0
  lda #>digits_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;load the punctuation graphics.
  lda #<punctuation_chr
  sta w0
  lda #>punctuation_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  lda b3
  sta state_control_params+enter_password_state_control::underscore_bg_chr_offset

  ;load the underscore graphic.
  lda #<underscore_chr
  sta w0
  lda #>underscore_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;load textbox graphics into sprite chr ram so we can show a flipped cursor
  lda #$10
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  ;reset tile accumulator
  lda #$00
  sta b3

  ;remember where we load the textbox chr in sprite vram
  sta state_control_params+enter_password_state_control::textbox_spr_chr_offset

  lda #<textbox_chr
  sta w0
  lda #>textbox_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;remember where we load the cursor chr in sprite ram
  lda b3
  sta state_control_params+enter_password_state_control::cursor_spr_chr_offset

  ;get lo byte of group
  ldy #sprite_chr_group_index_cursor
  far_load #SPRITE_CHR_DATA_BANK, #<sprite_chr_group_addresses_lo, #>sprite_chr_group_addresses_lo
  lda far_load_result
  sta w0

  ;get hi byte of group
  far_load #SPRITE_CHR_DATA_BANK, #<sprite_chr_group_addresses_hi, #>sprite_chr_group_addresses_hi
  lda far_load_result
  sta w0+1

  ;get bank of group
  far_load #SPRITE_CHR_DATA_BANK, #<sprite_chr_group_bank, #>sprite_chr_group_bank
  lda far_load_result
  sta b0

  ;load the group
  far_call b0, ppu_load_chr_amount

  ;draw start game screen nametable
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  lda font_chr_offset
  adc #' '
  sta b0
  lda #$00
  sta b1

  jsr ppu_fill_nametable

  ROW = 7
  COLUMN = 9

  ;draw box top and bottom
  lda textbox_chr_offset
  sta chr_group_offset
  print_string box_top_string, #$20, #ROW, #COLUMN
  print_string box_bottom_string, #$20, #ROW+12, #COLUMN

  ;draw box sides
  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  lda textbox_chr_offset
  sta chr_group_offset
  print_string box_left_string, #$20, #ROW+1, #COLUMN
  print_string box_right_string, #$20, #ROW+1, #COLUMN+12

  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  ;draw strings inside box
  lda font_chr_offset
  sta chr_group_offset
  print_string password_chars_row1, #$20, #ROW+1, #COLUMN+1
  print_string password_chars_row2, #$20, #ROW+3, #COLUMN+1
  print_string password_chars_row3, #$20, #ROW+5, #COLUMN+1
  print_string password_chars_row4, #$20, #ROW+7, #COLUMN+1
  print_string password_chars_row5, #$20, #ROW+9, #COLUMN+1
  print_string password_chars_row6, #$20, #ROW+11, #COLUMN+1

  print_string enter_password_string, #$20, #ROW-2, #COLUMN

  print_string press_start_to_confirm_string, #$20, #ROW+16, #COLUMN-4

  ;setup the cursor
  lda #0
  sta state_control_params+enter_password_state_control::cursor_position_x
  sta state_control_params+enter_password_state_control::cursor_position_y

  ;initialize the entered password string
  lda #$ff
  sta state_control_params+enter_password_state_control::entered_character_index

  lda #ES
  sta string_buffer

  ;check the last earned password and load it as the current password string if present
  jsr load_last_earned_password

  ;initialize blinking cursor
  lda #0
  sta state_control_params+enter_password_state_control::underscore_blink_counter

  ;clear the flag that tells the vblank routine to print strings
  lda #0
  sta state_control_params+enter_password_state_control::print_string

  ;clear the exit state flag
  lda #0
  sta state_control_params+enter_password_state_control::exit_enter_password_state

  jsr print_entered_password

  jsr draw_cursor

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

  jsr ppu_safely_enable_graphics

  ;fade in palette
  lda #<enter_password_state_palette
  sta palette_address
  lda #>enter_password_state_palette
  sta palette_address+1
  lda #MAX_BRIGHTNESS_LEVEL
  sta b4
  sta b5
  jsr ppu_fade_in_palette

  safely_set_vblank_routine ppu_enter_password_state_vblank

enter_password_state_main:

  clear_vblank_done
  wait_vblank_done

  jsr controller_read

  jsr update_cursor

  .scope
  lda state_control_params+enter_password_state_control::exit_enter_password_state
  beq do_not_exit_enter_password_state

  safely_set_vblank_routine ppu_vblank_nop

  jsr ppu_fade_out_palette

  jmp start_game_state_init

do_not_exit_enter_password_state:
  .endscope

  .scope
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq :+
  jmp not_start
:

  ;initialize inventory since we're starting a new game
  ;We do this here because we're going to overrite much of
  ;it with the decoded password. But we want all the remaining
  ;default values defined in this routine before starting a game.
  jsr inventory_init

  jsr decode_and_validate_password
  beq :+
  jmp password_invalid
:

  ;at this point, we know that the inventory state is valid. Use
  ;inventory_earned_techs in conjunction with inventory_dungeon_flags
  ;to pick the starting location from two LUTs.
  .scope
  lda inventory_dungeon_flags
  cmp #INVENTORY_DUNGEON_FLAGS_NOT_YET_ENTERED
  beq load_overworld_location
load_dungeon_location:

  ldx inventory_earned_techs
  lda dungeon_start_locations,x
  cmp #$ff
  bne :+
  jmp password_invalid
:
  sta b10

  safely_set_vblank_routine ppu_vblank_nop

  jsr ppu_fade_out_palette

  jsr initialize_play_state_and_hero

  ldy b10
  far_load #LOCATIONS_BANK, #<locations_lo, #>locations_lo
  lda far_load_result
  sta location_address
  far_load #LOCATIONS_BANK, #<locations_hi, #>locations_hi
  lda far_load_result
  sta location_address+1

  jmp play_state_load_location

  jmp done
load_overworld_location:

  ldx inventory_earned_techs
  lda overworld_start_locations,x
  cmp #$ff
  beq password_invalid

  sta b10

  safely_set_vblank_routine ppu_vblank_nop

  jsr ppu_fade_out_palette

  jsr initialize_play_state_and_hero

  ldy b10
  far_load #LOCATIONS_BANK, #<locations_lo, #>locations_lo
  lda far_load_result
  sta location_address
  far_load #LOCATIONS_BANK, #<locations_hi, #>locations_hi
  lda far_load_result
  sta location_address+1

  jmp play_state_load_location

done:
  .endscope

  jmp done
password_invalid:
  ;play a sound
  lda #<sfx_error
  sta sound_param_word_0
  lda #>sfx_error
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize
done:
not_start:
  .endscope

  jsr draw_cursor

  lda #1
  sta state_control_params+enter_password_state_control::print_string

  jmp enter_password_state_main

.proc load_last_earned_password

  lda #0
  sta b0
  ldx #5
: lda b0
  ora last_password,x
  sta b0
  dex
  bpl :-
  lda b0
  beq no_last_earned_password

  ;copy last earned password to password bit field
  ldx #5
: lda last_password,x
  sta state_control_params+enter_password_state_control::password_field,x
  dex
  bpl :-

  lda #9
  sta state_control_params+enter_password_state_control::entered_character_index

  ;generate password string from password field
  lda #<state_control_params+enter_password_state_control::password_field
  sta w0
  lda #>state_control_params+enter_password_state_control::password_field
  sta w0+1

  lda #<string_buffer
  sta w1
  lda #>string_buffer
  sta w1+1
  far_call #PASSWORD_BANK, password_bit_field_to_password_string

no_last_earned_password:

  rts

.endproc

;this must be called before transitioning to the play state.
.proc initialize_play_state_and_hero

  jsr play_state_initialize

  ;initialize persistent hero state
  lda #3
  sta hero_health
  lda #0
  sta hero_flags

  rts

.endproc

;decodes and validates the entered password.
;Z is clear when password is invalid.
;Z is set when password is valid.
.proc decode_and_validate_password

  ;validate and decode the entered password.
  ;password is invalid if not at correct length
  lda state_control_params+enter_password_state_control::entered_character_index
  cmp #(PASSWORD_LENGTH-1)
  bne password_invalid

  ;password is invalid if it contains characters 6 through 9
  ldx state_control_params+enter_password_state_control::entered_character_index
: lda string_buffer,x
  cmp #'6'
  beq password_invalid
  cmp #'7'
  beq password_invalid
  cmp #'8'
  beq password_invalid
  cmp #'9'
  beq password_invalid
  dex
  bpl :-
password_might_still_be_valid:

  lda #<string_buffer
  sta w0
  lda #>string_buffer
  sta w0+1

  lda #<(state_control_params+enter_password_state_control::password_field)
  sta w1
  lda #>(state_control_params+enter_password_state_control::password_field)
  sta w1+1
  far_call #PASSWORD_BANK, password_string_to_password_bit_field

  lda #<(state_control_params+enter_password_state_control::password_field)
  sta w0
  lda #>(state_control_params+enter_password_state_control::password_field)
  sta w0+1
  far_call #PASSWORD_BANK, password_bit_field_to_inventory_state

  ;use GP to test whether inventory is valid.
  sec
  lda #<INVENTORY_MAX_GP
  sbc inventory_gp
  lda #>INVENTORY_MAX_GP
  sbc inventory_gp+1
  lda #^INVENTORY_MAX_GP
  sbc inventory_gp+2
  bmi password_invalid

  ;also make sure GP is a multiple of 100, the smallest possible increment.
  ;This should weed out a huge number of random password entry attempts.
  jsr gp_is_multiple_of_100
  bmi password_invalid

password_valid:

  ;set zero flag to indicate password is valid.
  lda #$00
  rts

password_invalid:

  ;clear zero flag to indicate password is invalid.
  lda #$ff
  rts

gp_is_multiple_of_100:

  lda inventory_gp
  sta w0
  lda inventory_gp+1
  sta w0+1
  lda inventory_gp+2
  sta b0

  ;subtract 100 repeatedly from the gp value. if we go negative,
  ;the value is not a multiple of 100.
keep_subtracting:
  lda w0
  ora w0+1
  ora b0
  beq done

  sec
  lda w0
  sbc #<100
  sta w0
  lda w0+1
  sbc #>100
  sta w0+1
  lda b0
  sbc #^100
  sta b0
  bmi done

  jmp keep_subtracting
done:

  rts

.endproc

;updates the cursor based on controller state. D-pad selects the
;character to enter in the current cursor position of the password.
;"A" selects a character to enter. "B" erases the last character. "B"
;when no characters have been entered exits the enter password state
;and returns to the start game state.
.proc update_cursor
DPAD_TEST = %10000000
cursor_x = state_control_params+enter_password_state_control::cursor_position_x
cursor_y = state_control_params+enter_password_state_control::cursor_position_y

  .scope
  lda buffer_controller+buttons::_up
  and #DPAD_TEST
  beq not_up

  lda cursor_y
  beq done

  dec cursor_y
  lda #0
  sta buffer_controller+buttons::_up

  jsr play_dpad_sound

  jmp done
not_up:

  lda buffer_controller+buttons::_down
  and #DPAD_TEST
  beq not_down

  lda cursor_y
  cmp #5
  beq done

  inc cursor_y
  lda #0
  sta buffer_controller+buttons::_down

  jsr play_dpad_sound

  jmp done
not_down:

  lda buffer_controller+buttons::_left
  and #DPAD_TEST
  beq not_left

  lda cursor_x
  beq done

  dec cursor_x
  lda #0
  sta buffer_controller+buttons::_left

  jsr play_dpad_sound

  jmp done
not_left:

  lda buffer_controller+buttons::_right
  and #DPAD_TEST
  beq not_right

  lda cursor_x
  cmp #5
  beq done

  inc cursor_x
  lda #0
  sta buffer_controller+buttons::_right

  jsr play_dpad_sound

  jmp done
not_right:
done:
  .endscope

  .scope
  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne not_a

  jsr play_action_sound

  ;increment entered_character_index
  inc state_control_params+enter_password_state_control::entered_character_index

  ;cap it at PASSWORD_LENGTH
  lda state_control_params+enter_password_state_control::entered_character_index
  cmp #PASSWORD_LENGTH
  bne :+
  lda #(PASSWORD_LENGTH-1)
  sta state_control_params+enter_password_state_control::entered_character_index
  jmp done
:

  ;determine which character the cursor is hovering over

  ;multiply by 4
  lda state_control_params+enter_password_state_control::cursor_position_y
  asl
  asl
  sta b0

  ;multiply by 2
  lda state_control_params+enter_password_state_control::cursor_position_y
  asl
  sta b1

  ;add, now we have row * 6
  clc
  lda b0
  adc b1

  ;add x, now we have the offset of the character within password_chars
  adc state_control_params+enter_password_state_control::cursor_position_x
  tax
  lda password_chars,x

  ;change the character at entered_character_index
  ldy state_control_params+enter_password_state_control::entered_character_index
  sta string_buffer,y

  ;place ES at end of string
  iny
  lda #ES
  sta string_buffer,y

  jmp done
not_a:

  lda buffer_controller+buttons::_b
  and #%00000011
  cmp #%00000001
  bne not_b

  jsr play_action_sound

  ;place ES at entered_character_index
  ldx state_control_params+enter_password_state_control::entered_character_index
  lda #ES
  sta string_buffer,x

  ;set exit state flag if B was hit with the entered character index already negative
  .scope
  lda state_control_params+enter_password_state_control::entered_character_index
  bpl do_not_set_exit_flag

  lda #1
  sta state_control_params+enter_password_state_control::exit_enter_password_state
do_not_set_exit_flag:
  .endscope

  ;decrement entered_character_index.
  dec state_control_params+enter_password_state_control::entered_character_index
not_b:
done:
  .endscope

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

  far_call #SOUND_BANK, stream_initialize

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

  far_call #SOUND_BANK, stream_initialize

  rts

.endproc

.proc draw_cursor

  jsr sprite_clear_all

  lda state_control_params+enter_password_state_control::cursor_spr_chr_offset
  sta chr_group_offset

  lda #<cursor0
  sta w0
  lda #>cursor0
  sta w0+1

  clc
  lda state_control_params+enter_password_state_control::cursor_position_x
  asl
  asl
  asl
  asl
  adc #((COLUMN + 1) * 8)

  sta w3
  lda #0
  sta w3+1

  clc
  lda state_control_params+enter_password_state_control::cursor_position_y
  asl
  asl
  asl
  asl
  adc #((ROW + 1) * 8 - 1)

  sta w4
  lda #0
  sta w4+1

  lda #$00
  sta b2

  far_call #SPRITES_AND_ANIMATIONS_DATA_BANK1, sprite_draw_metasprite

  rts

.endproc

.proc print_entered_password

  print_string clear_string, #$20, #ROW+14, #COLUMN

  lda #<string_buffer
  sta w0
  lda #>string_buffer
  sta w0+1
  lda #$20
  sta b0
  lda #ROW+14
  sta b1
  lda #COLUMN
  sta b2
  jsr print_string_impl

  rts

.endproc

.proc print_underscores

  print_string clear_string, #$20, #ROW+15, #COLUMN

  ;now draw a blinking underscore at current character to be entered
  lda state_control_params+enter_password_state_control::entered_character_index
  cmp #(PASSWORD_LENGTH-1)
  beq :+
  lda state_control_params+enter_password_state_control::underscore_blink_counter
  bmi :+

  lda #$20
  sta b0
  lda #(ROW+15)
  sta b1

  .scope
  lda state_control_params+enter_password_state_control::entered_character_index
  bmi empty_string
not_empty_string:
  clc
  lda #COLUMN
  adc state_control_params+enter_password_state_control::entered_character_index
  adc #1
  sta b2
  jmp done
empty_string:
  lda #COLUMN
  sta b2
  jmp done
done:
  .endscope

  set_ppu_2006_abs b0, b1, b2
  upload_ppu_2006

  lda state_control_params+enter_password_state_control::underscore_bg_chr_offset
  sta $2007
:
  clc
  lda state_control_params+enter_password_state_control::underscore_blink_counter
  adc #8
  sta state_control_params+enter_password_state_control::underscore_blink_counter

  rts

.endproc

.proc ppu_enter_password_state_vblank

  jsr sprite_update_all

  lda state_control_params+enter_password_state_control::print_string
  beq :+
  jsr print_entered_password
  jsr print_underscores
  lda #0
  sta state_control_params+enter_password_state_control::print_string
:

  upload_ppu_2006
  upload_ppu_2005

  set_vblank_done

  rts

.endproc
