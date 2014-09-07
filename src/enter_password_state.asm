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
.include "soundengine.inc"
.include "music_data.inc"
.include "sfx_data.inc"
.include "sprite_chr_data.inc"
.include "sprites_and_animations_data.inc"
.include "controller.inc"

.segment "ROM01"

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

cursor_meta_sprite:
  .byte $01
  .byte $00,$09,$00,$00,$00

cursor_position_x:
  .byte 10*8+4,10*8+4

cursor_position_y:
  .byte 13*8, 15*8

enter_password_state_init:

  lda #<enter_password_theme
  sta song_address
  lda #>enter_password_theme
  sta song_address+1
  far_call #MUSIC_BANK, song_initialize

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

  ldx #sprite_chr_group_index_cursor
  lda sprite_chr_group_addresses_lo,x
  sta w0
  lda sprite_chr_group_addresses_hi,x
  sta w0+1
  far_call {sprite_chr_group_bank,x}, ppu_load_chr_amount

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

  ROW = 8
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

  ;setup the cursor
  lda #0
  sta state_control_params+enter_password_state_control::cursor_position_x
  sta state_control_params+enter_password_state_control::cursor_position_y

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

  jsr draw_cursor

  jmp enter_password_state_main

.proc update_cursor
DPAD_TEST = %10000000
cursor_x = state_control_params+enter_password_state_control::cursor_position_x
cursor_y = state_control_params+enter_password_state_control::cursor_position_y

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

.segment "CODE"

.proc ppu_enter_password_state_vblank

  jsr sprite_update_all

  upload_ppu_2006
  upload_ppu_2005

  set_vblank_done

  rts

.endproc
