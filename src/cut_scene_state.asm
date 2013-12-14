.include "cut_scene_state.inc"
.include "slide_data.inc"
.include "mapper.inc"
.include "ppu.inc"
.include "sprite.inc"
.include "ram.inc"
.include "zp.inc"

.segment "CODE"

play_cut_scene:

  ;set blank nmi routine
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  jsr sprite_update_all

  ;load chr data
  lda #$00
  sta $2006
  sta $2006

  lda state_control_params+cut_scene_state_control::slide_address
  sta w10
  lda state_control_params+cut_scene_state_control::slide_address+1
  sta w10+1

  switch_bank_ldy #SLIDE_DATA_BANK
  ldy #slide::bg_chr_address
  lda (w10),y
  sta w0
  iny
  lda (w10),y
  sta w0+1

  ldy #slide::bg_chr_bank
  lda (w10),y
  tay
  switch_bank_y

  jsr ppu_load_chr_amount

  ;load nametable data for slide
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  switch_bank_ldy #SLIDE_DATA_BANK
  ldy #slide::nametable_address
  lda (w10),y
  sta w0
  iny
  lda (w10),y
  sta w0+1

  ldy #slide::nametable_bank
  lda (w10),y
  tay
  switch_bank_y

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

  ;fade in palette
  switch_bank_ldy #SLIDE_DATA_BANK
  ldy #slide::palette_address
  lda (w10),y
  sta palette_address
  iny
  lda (w10),y
  sta palette_address+1
  lda #MAX_BRIGHTNESS_LEVEL
  sta b4
  sta b5
  jsr ppu_fade_in_palette

:
  jmp :-
