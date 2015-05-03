.include "ndxdebug.h"
.include "map.inc"
.include "play_state.inc"
.include "controller.inc"
.include "bg_chr_data.inc"
.include "nametable_data.inc"
.include "sprite_chr_data.inc"
.include "sprites_and_animations_data.inc"
.include "title_state.inc"
.include "areas.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprite.inc"
.include "soundengine.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "music_data.inc"
.include "inventory.inc"
.include "cut_scene_state.inc"
.include "slide_data.inc"
.include "start_game_state.inc"

.segment "ROM01"

gradual_games_logo_palette:
  .byte $0e,$08,$1a,$18,$0e,$12,$24,$20,$0e,$1a,$18,$20,$0e,$0e,$0e,$0e
  .byte $0e,$08,$1a,$18,$0e,$12,$24,$20,$0e,$1a,$18,$20,$0e,$0e,$0e,$0e

title_screen_palette:
  .byte $0e,$18,$00,$20,$0e,$04,$14,$24,$0e,$17,$28,$38,$0e,$0e,$0e,$0e
  .byte $0e,$18,$00,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

title_state_logo:

  ;set blank nmi routine
  safely_set_vblank_routine ppu_vblank_nop

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  ;load chr data for the logo
  lda #$00
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

  lda #<gradual_games_logo_chr
  sta w0
  lda #>gradual_games_logo_chr
  sta w0+1
  far_call #TITLE_STATE_BG_CHR_BANK, ppu_load_chr_amount

  ;load nametable data for title screen
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006
  lda #<gradual_games_logo_screen
  sta w0
  lda #>gradual_games_logo_screen
  sta w0+1
  far_call #TITLE_STATE_BG_NAMETABLE_BANK, ppu_load_nametable

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

  ;fade in logo palette
  lda #<gradual_games_logo_palette
  sta palette_address
  lda #>gradual_games_logo_palette
  sta palette_address+1
  lda #MAX_BRIGHTNESS_LEVEL
  sta b4
  sta b5
  jsr ppu_fade_in_palette

  lda #<logo_theme
  sta song_address
  lda #>logo_theme
  sta song_address+1
  far_call #SOUND_BANK, song_initialize

  ldx #120
: wait_vblank
  dex
  bne :-

  ;fade out logo palette
  lda #<gradual_games_logo_palette
  sta palette_address
  lda #>gradual_games_logo_palette
  sta palette_address+1
  jsr ppu_fade_out_palette

title_state_init:

  ;set blank nmi routine
  safely_set_vblank_routine ppu_vblank_nop

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  ;load chr data for title screen
  lda #$00
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

  lda #<title_chr
  sta w0
  lda #>title_chr
  sta w0+1
  far_call #TITLE_STATE_BG_CHR_BANK, ppu_load_chr_amount

  lda #$10
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  ldy #sprite_chr_group_index_title
  far_load #SPRITE_CHR_DATA_BANK, #<sprite_chr_group_addresses_lo, #>sprite_chr_group_addresses_lo
  lda far_load_result
  sta w0

  far_load #SPRITE_CHR_DATA_BANK, #<sprite_chr_group_addresses_hi, #>sprite_chr_group_addresses_hi
  lda far_load_result
  sta w0+1

  far_load #SPRITE_CHR_DATA_BANK, #<sprite_chr_group_bank, #>sprite_chr_group_bank
  lda far_load_result
  sta b0

  far_call b0, ppu_load_chr_amount

  ;load nametable data for title screen
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006
  lda #<title_screen
  sta w0
  lda #>title_screen
  sta w0+1
  far_call #TITLE_STATE_BG_NAMETABLE_BANK, ppu_load_nametable

  ;draw overlay sprites
  lda #$00
  sta chr_group_offset

  lda #<owliatitle_spr_overlay
  sta w0
  lda #>owliatitle_spr_overlay
  sta w0+1

  far_call #TITLE_STATE_SPRITES_AND_ANIMATIONS_BANK, sprite_draw_overlay

  jsr sprite_update_all

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

  ;fade in title screen palette
  lda #<title_screen_palette
  sta palette_address
  lda #>title_screen_palette
  sta palette_address+1
  lda #MAX_BRIGHTNESS_LEVEL
  sta b4
  sta b5
  jsr ppu_fade_in_palette

  ;load sfx
  lda #<sfx_set1
  sta sound_param_word_0
  lda #>sfx_set1
  sta sound_param_word_0+1
  far_call #SOUND_BANK, sfx_initialize

  ;load title theme if not already playing
  lda song_address
  cmp #<title_theme
  bne :+
  lda song_address+1
  cmp #>title_theme
  beq already_playing_title_theme
:
  lda #<title_theme
  sta song_address
  lda #>title_theme
  sta song_address+1
  far_call #SOUND_BANK, song_initialize
already_playing_title_theme:

  lda #<TITLE_STATE_TIME_TIL_CUT_SCENE
  sta state_control_params+title_state_control::title_state_counter
  lda #>TITLE_STATE_TIME_TIL_CUT_SCENE
  sta state_control_params+title_state_control::title_state_counter+1

title_state_main:

  wait_vblank_done

  sec
  lda state_control_params+title_state_control::title_state_counter
  sbc #$01
  sta state_control_params+title_state_control::title_state_counter
  lda state_control_params+title_state_control::title_state_counter+1
  sbc #$00
  sta state_control_params+title_state_control::title_state_counter+1
  beq title_state_show_cut_scene

  jsr controller_read

  ;test start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  bne :+
  jmp title_state_start_game
:

  clear_vblank_done

  jmp title_state_main

title_state_show_cut_scene:

  ;fade out title palette
  lda #<title_screen_palette
  sta palette_address
  lda #>title_screen_palette
  sta palette_address+1
  jsr ppu_fade_out_palette

  lda #<intro_cut_scene_great_owls
  sta state_control_params+cut_scene_state_control::slide_address
  lda #>intro_cut_scene_great_owls
  sta state_control_params+cut_scene_state_control::slide_address+1
  jmp play_cut_scene

.segment "CODE"

title_state_start_game:

  ;transfer title state counter to random number to seed random number generation
  lda state_control_params+title_state_control::title_state_counter
  sta rand

  ;fade out title palette
  lda #<title_screen_palette
  sta palette_address
  lda #>title_screen_palette
  sta palette_address+1
  jsr ppu_fade_out_palette

  switch_bank_ldy #START_GAME_STATE_BANK
  jmp start_game_state_init
