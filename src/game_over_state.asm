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

.segment "CODE"

game_over_screen_palette:
  .byte $0d,$0d,$0d,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0d,$0d,$0d,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

game_over_state_init:

  ;set blank nmi routine
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  jsr sprite_update_all

  ;load chr data for game_over screen
  lda #$00
  sta $2006
  sta $2006

  lda #<game_over_chr
  sta w0
  lda #>game_over_chr
  sta w0+1
  switch_bank_ldy #GAME_OVER_STATE_BG_CHR_BANK
  jsr ppu_load_chr_amount

  ;load nametable data for game_over screen
  ;load the nametable and attribute table.
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006
  lda #<game_over_screen
  sta w0
  lda #>game_over_screen
  sta w0+1
  switch_bank_ldy #GAME_OVER_STATE_BG_NAMETABLE_BANK
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

  wait_vblank_data_ready

  jsr controller_read

  ;test start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq game_over_state_exit

  set_vblank_data_ready

  jmp game_over_state_main

game_over_state_exit:

  ;fade out game_over palette
  lda #<game_over_screen_palette
  sta palette_address
  lda #>game_over_screen_palette
  sta palette_address+1
  jsr ppu_fade_out_palette

  jmp title_state_init

