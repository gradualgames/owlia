.include "map.inc"
.include "title_state.inc"
.include "controller.inc"
.include "bg_chr_data.inc"
.include "nametable_data.inc"
.include "game_over_state.inc"
.include "areas.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprite.inc"
.include "inventory_state.inc"
.include "textbox.inc"
.include "password.inc"
.include "charmap_password.inc"

.segment "CODE"

game_over_string: .byte "GAME OVER",ES

current_password_string: .byte "CURRENT PASSWORD",ES

game_over_screen_palette:
  .byte $0e,$05,$28,$38,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$05,$28,$38,$0e,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

game_over_state_init:

  ;set blank nmi routine
  safely_set_vblank_routine ppu_vblank_nop

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  jsr sprite_update_all

  ;load chr data for game_over screen
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

  ;load nametable data for game_over screen
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
  far_call #INVENTORY_STATE_BG_NAMETABLE_BANK, ppu_load_nametable

  ;print current password string on the screen
  lda font_chr_offset
  sta chr_group_offset
  print_string game_over_string, #$20, #10, #11
  print_string current_password_string, #$20, #15, #8

  ;generate password bit field from inventory state
  lda #<(state_control_params+game_over_state_control::password_field)
  sta w0
  lda #>(state_control_params+game_over_state_control::password_field)
  sta w0+1
  far_call #PASSWORD_BANK, inventory_state_to_password_bit_field

  ;generate password string from password field
  lda #<string_buffer
  sta w1
  lda #>string_buffer
  sta w1+1
  far_call #PASSWORD_BANK, password_bit_field_to_password_string

  ;print the password underneath the current password string
  print_string string_buffer, #$20, #17, #11

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

  ;fade in game_over screen palette
  lda #<game_over_screen_palette
  sta palette_address
  lda #>game_over_screen_palette
  sta palette_address+1
  lda #MAX_BRIGHTNESS_LEVEL
  sta b4
  sta b5
  jsr ppu_fade_in_palette

game_over_state_main:

  wait_vblank_done

  jsr controller_read

  ;test start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq game_over_state_exit

  clear_vblank_done

  jmp game_over_state_main

game_over_state_exit:

  ;fade out game_over palette
  lda #<game_over_screen_palette
  sta palette_address
  lda #>game_over_screen_palette
  sta palette_address+1
  jsr ppu_fade_out_palette

  switch_bank_ldy #TITLE_STATE_BANK
  jmp title_state_init
