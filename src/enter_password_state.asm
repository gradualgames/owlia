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

.segment "ROM01"

enter_password_state_palette:
  .byte $0e,$0e,$18,$20,$0e,$04,$14,$24,$0e,$17,$28,$38,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$18,$20,$0e,$04,$14,$24,$0e,$17,$28,$38,$0e,$0e,$0e,$0e

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

  lda #<textbox_chr
  sta w0
  lda #>textbox_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

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

  .scope
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
  .endscope

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

  jmp enter_password_state_main

.segment "CODE"

.proc ppu_enter_password_state_vblank

  jsr sprite_update_all

  upload_ppu_2006
  upload_ppu_2005

  set_vblank_done

  rts

.endproc
