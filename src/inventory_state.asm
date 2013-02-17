.include "map.inc"
.include "play_state.inc"
.include "controller.inc"
.include "bg_chr_data.inc"
.include "nametable_data.inc"
.include "inventory_state.inc"
.include "areas.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprite.inc"

.segment "CODE"

inventory_screen_palette:
  .byte $0d,$0d,$0d,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0d,$0d,$0d,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

inventory_state_init:

  ;fade out from current palette
  switch_bank_ldy #AREAS_BANK
  ldy #area::palette_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy map_bank
  jsr ppu_fade_out_palette

  ;set blank nmi routine
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  jsr sprite_update_all

  ;load chr data for inventory screen
  lda #$00
  sta $2006
  sta $2006

  lda #<inventory_chr
  sta w0
  lda #>inventory_chr
  sta w0+1
  switch_bank_ldy #INVENTORY_STATE_BG_CHR_BANK
  jsr ppu_load_chr_amount

  ;load nametable data for inventory screen
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
  switch_bank_ldy #INVENTORY_STATE_BG_NAMETABLE_BANK
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

  ;fade in inventory screen palette
  lda #<inventory_screen_palette
  sta w0
  lda #>inventory_screen_palette
  sta w0+1
  jsr ppu_fade_in_palette

inventory_state_main:

  wait_vblank_data_ready

  jsr controller_read

  ;test start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq inventory_state_exit

  set_vblank_data_ready

  jmp inventory_state_main

inventory_state_exit:

  ;fade out inventory palette
  lda #<inventory_screen_palette
  sta w0
  lda #>inventory_screen_palette
  sta w0+1
  jsr ppu_fade_out_palette

  jmp play_state_reload

