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

.segment "CODE"

title_screen_palette:
  .byte $0e,$04,$14,$24,$0e,$0e,$18,$20,$0e,$17,$28,$38,$0e,$00,$00,$00
  .byte $0e,$04,$14,$24,$0e,$17,$28,$38,$0e,$00,$00,$00,$0e,$00,$00,$00

title_state_init:

  ;set blank nmi routine
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  ;load chr data for title screen
  lda #$00
  sta $2006
  sta $2006

  lda #<title_chr
  sta w0
  lda #>title_chr
  sta w0+1
  switch_bank_ldy #TITLE_STATE_BG_CHR_BANK
  jsr ppu_load_chr_amount

  lda #$10
  sta $2006
  lda #$00
  sta $2006

  ldx #sprite_chr_group_index_title
  lda sprite_chr_group_addresses_lo,x
  sta w0
  lda sprite_chr_group_addresses_hi,x
  sta w0+1

  lda sprite_chr_group_bank,x
  tay
  switch_bank_y

  jsr ppu_load_chr_amount

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
  switch_bank_ldy #TITLE_STATE_BG_NAMETABLE_BANK
  jsr ppu_load_nametable

  ;draw overlay sprites
  lda #$00
  sta chr_group_offset

  switch_bank_ldy #TITLE_STATE_SPRITES_AND_ANIMATIONS_BANK

  lda #<OwliaTitle0
  sta w0
  lda #>OwliaTitle0
  sta w0+1

  lda #(16*8)
  sta w3
  lda #0
  sta w3+1

  lda #(6*8-1)
  sta w4
  lda #0
  sta w4+1

  lda #0
  sta b2

  jsr sprite_draw_metasprite

  lda #<OwliaTitle1
  sta w0
  lda #>OwliaTitle1
  sta w0+1

  lda #(10*8)
  sta w3
  lda #0
  sta w3+1

  lda #(16*8-1)
  sta w4
  lda #0
  sta w4+1

  lda #0
  sta b2

  jsr sprite_draw_metasprite

  jsr sprite_update_all

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
  jsr sfx_initialize

  ;load title theme if not already playing
  lda song_address
  cmp #<title_theme
  bne :+
  lda song_address+1
  cmp #>title_theme
  beq already_playing_title_theme
:
  lda #MUSIC_BANK
  sta music_bank
  lda #<title_theme
  sta song_address
  lda #>title_theme
  sta song_address+1
  switch_bank_ldy music_bank
  jsr song_initialize
already_playing_title_theme:

  lda #<TITLE_STATE_TIME_TIL_CUT_SCENE
  sta state_control_params+title_state_control::title_state_counter
  lda #>TITLE_STATE_TIME_TIL_CUT_SCENE
  sta state_control_params+title_state_control::title_state_counter+1

title_state_main:

  wait_vblank_flag

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
  beq title_state_start_game

  set_vblank_flag

  jmp title_state_main

title_state_show_cut_scene:

  ;fade out title palette
  lda #<title_screen_palette
  sta palette_address
  lda #>title_screen_palette
  sta palette_address+1
  jsr ppu_fade_out_palette

  lda #<intro_cut_scene_slide1
  sta state_control_params+cut_scene_state_control::slide_address
  lda #>intro_cut_scene_slide1
  sta state_control_params+cut_scene_state_control::slide_address+1
  jmp play_cut_scene

title_state_start_game:

  ;fade out title palette
  lda #<title_screen_palette
  sta palette_address
  lda #>title_screen_palette
  sta palette_address+1
  jsr ppu_fade_out_palette

  jsr play_state_initialize

  ;initialize inventory since we're starting a new game
  jsr inventory_init

  ;initialize persistent hero state
  lda #3
  sta hero_health
  lda #0
  sta hero_flags

  ;ldx #location_index_meadow2_east_entrance
  ;ldx #location_index_meadow1_top_entrance
  ;ldx #location_index_village_bottom_entrance
  ;ldx #location_index_house1_intro
  ;ldx #location_index_dungeon_0_3_s
  ldx #location_index_dungeon_0_0_s
  ;ldx #location_index_dungeon1_boss_entrance
  ;ldx #location_index_village_house1_entrance
  switch_bank_ldy #LOCATIONS_BANK
  lda locations_lo,x
  sta location_address
  lda locations_hi,x
  sta location_address+1
  jmp play_state_load_location
