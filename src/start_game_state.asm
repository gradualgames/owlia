.feature force_range
.include "start_game_state.inc"
.include "enter_password_state.inc"
.include "textbox.inc"
.include "charmap.inc"
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

.segment "ROM01"

start_game_state_palette:
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
  .byte BOTTOM_RIGHT_TILE_OFFSET
  .byte ES

box_left_string:
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte LEFT_TILE_OFFSET
  .byte ES

box_right_string:
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte RIGHT_TILE_OFFSET
  .byte ES

new_game_string: .byte "NEW GAME",ES
continue_string: .byte "CONTINUE",ES

cursor_meta_sprite:
  .byte $01
  .byte $00,$08,$00,$00,$00

cursor_position_x:
  .byte 10*8+4,10*8+4

cursor_position_y:
  .byte 13*8, 15*8

start_game_state_init:

  .scope
  lda song_address
  cmp #<game_menu_theme
  bne load_song

  lda song_address+1
  cmp #>game_menu_theme
  bne load_song

  jmp skip_load_song

load_song:
  lda #<game_menu_theme
  sta song_address
  lda #>game_menu_theme
  sta song_address+1
  far_call #SOUND_BANK, song_initialize
skip_load_song:
  .endscope

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

  ;draw box top and bottom
  lda textbox_chr_offset
  sta chr_group_offset
  print_string box_top_string, #$20, #12, #10
  print_string box_bottom_string, #$20, #16, #10

  ;draw box sides
  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  lda textbox_chr_offset
  sta chr_group_offset
  print_string box_left_string, #$20, #13, #10
  print_string box_right_string, #$20, #13, #20

  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  ;draw strings inside box
  lda font_chr_offset
  sta chr_group_offset
  print_string new_game_string, #$20, #13, #12
  print_string continue_string, #$20, #15, #12

  .scope
  lda #0
  sta b0
  ldx #5
: lda b0
  ora last_password,x
  sta b0
  dex
  bpl :-
  lda b0
  beq new_game
continue:
  lda #CONTINUE
  sta state_control_params+start_game_state_control::menu_position
  jmp done
new_game:
  lda #NEW_GAME
  sta state_control_params+start_game_state_control::menu_position
done:
  .endscope

  jsr start_game_state_draw_cursor

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
  lda #<start_game_state_palette
  sta palette_address
  lda #>start_game_state_palette
  sta palette_address+1
  lda #MAX_BRIGHTNESS_LEVEL
  sta b4
  sta b5
  jsr ppu_fade_in_palette

  safely_set_vblank_routine ppu_start_game_state_vblank

start_game_state_main:

  clear_vblank_done
  wait_vblank_done

  jsr controller_read

  ;test select button
  .scope
  lda buffer_controller+buttons::_select
  and #%00000011
  cmp #%00000001
  bne skip_change_menu_selection

  lda #<sfx_move_cursor
  sta sound_param_word_0
  lda #>sfx_move_cursor
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  inc state_control_params+start_game_state_control::menu_position
  lda state_control_params+start_game_state_control::menu_position
  cmp #2
  bne skip_reset_menu_selection
  lda #0
  sta state_control_params+start_game_state_control::menu_position
skip_reset_menu_selection:
skip_change_menu_selection:
  .endscope

  ;test start button
  .scope
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  bne skip_menu_selection_chosen

  lda #<sfx_select
  sta sound_param_word_0
  lda #>sfx_select
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  lda state_control_params+start_game_state_control::menu_position
  cmp #NEW_GAME
  bne :+
  jmp start_new_game
:
  cmp #CONTINUE
  bne :+
  jmp transition_to_enter_password_state
:
skip_menu_selection_chosen:
  .endscope

  jsr start_game_state_draw_cursor

  jmp start_game_state_main

.proc start_game_state_draw_cursor

  jsr sprite_clear_all

  lda textbox_chr_offset
  sta chr_group_offset

  lda #<cursor_meta_sprite
  sta w0
  lda #>cursor_meta_sprite
  sta w0+1

  ldx state_control_params+start_game_state_control::menu_position
  lda cursor_position_x,x
  sta w3
  lda #0
  sta w3+1

  lda cursor_position_y,x
  sta w4
  lda #0
  sta w4+1

  lda #$00
  sta b2

  jsr sprite_draw_metasprite

  rts

.endproc

.segment "CODE"

start_new_game:

  jsr ppu_fade_out_palette

  jsr play_state_initialize

  ;initialize inventory since we're starting a new game
  jsr inventory_init

  ;initialize persistent hero state
  lda #3
  sta hero_health
  lda #0
  sta hero_flags

  ;this value can be overridden by whatever is in start_location.inc.
  ;if start_location.inc is all commented out, the game will still work.
  ldx #location_index_house1_intro

  ;this file should just contain ldx #location_index_starting_location
  ;and is intended to be svn ignored so we can change it at will and
  ;not worry about modifying the title state source file.
  .include "start_location.inc"

  switch_bank_ldy #LOCATIONS_BANK
  lda locations_lo,x
  sta location_address
  lda locations_hi,x
  sta location_address+1
  jmp play_state_load_location

transition_to_enter_password_state:

  safely_set_vblank_routine ppu_vblank_nop

  jsr ppu_fade_out_palette

  jmp enter_password_state_init

.proc ppu_start_game_state_vblank

  jsr sprite_update_all

  upload_ppu_2006
  upload_ppu_2005

  set_vblank_done

  rts

.endproc