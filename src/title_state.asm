.include "map.inc"
.include "play_state.inc"
.include "controller.inc"
.include "bg_chr_data.inc"
.include "nametable_data.inc"
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
.include "inventory.inc"

.segment "CODE"

title_screen_palette:
  .byte $0d,$0d,$0d,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0d,$0d,$0d,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

title_state_init:

  ;set blank nmi routine
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  jsr sprite_update_all

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

title_state_main:

  wait_vblank_flag

  jsr controller_read

  ;test start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq title_state_exit

  set_vblank_flag

  jmp title_state_main

title_state_exit:

  ;fade out title palette
  lda #<title_screen_palette
  sta palette_address
  lda #>title_screen_palette
  sta palette_address+1
  jsr ppu_fade_out_palette

  jsr play_state_initialize

  ;initialize inventory since we're starting a new game
  jsr inventory_max_all

  ;initialize persistent hero state
  lda #3
  sta hero_health
  lda #0
  sta hero_flags

  lda #<sfx_set1
  sta sound_param_word_0
  lda #>sfx_set1
  sta sound_param_word_0+1
  jsr sfx_initialize

  ldx #location_index_meadow1_top_entrance
  lda locations_lo,x
  sta location_address
  lda locations_hi,x
  sta location_address+1
  jmp play_state_load_location
