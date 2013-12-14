.include "play_state.inc"
.include "inventory.inc"
.include "locations.inc"
.include "conversation_data.inc"
.include "cut_scene_state.inc"
.include "slide_data.inc"
.include "mapper.inc"
.include "ppu.inc"
.include "sprite.inc"
.include "ram.inc"
.include "zp.inc"
.include "textbox.inc"
.include "map.inc"

.segment "CODE"

play_cut_scene:

  jsr load_slide

  ;advance slide address
  clc
  lda state_control_params+cut_scene_state_control::slide_address
  adc #<(.sizeof(slide))
  sta state_control_params+cut_scene_state_control::slide_address
  lda state_control_params+cut_scene_state_control::slide_address+1
  adc #>(.sizeof(slide))
  sta state_control_params+cut_scene_state_control::slide_address+1

  ;check to see if this is the end of the cut scene and exit if so (marked with a $ff)
  lda state_control_params+cut_scene_state_control::slide_address
  sta w0
  lda state_control_params+cut_scene_state_control::slide_address+1
  sta w0+1
  ldy #0
  lda (w0),y
  cmp #LAST_SLIDE
  bne play_cut_scene

exit_cut_scene_state:

  jsr play_state_initialize

  ;initialize inventory since we're starting a new game
  jsr inventory_max_all

  ;initialize persistent hero state
  lda #3
  sta hero_health
  lda #0
  sta hero_flags

  ldx #location_index_village_house1_entrance
  switch_bank_ldy #LOCATIONS_BANK
  lda locations_lo,x
  sta location_address
  lda locations_hi,x
  sta location_address+1
  jmp play_state_load_location

.proc load_slide

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

  ;grab tile accumulator to know where the textbox and font group begins
  lda b3
  sta textbox_and_font_chr_offset

  ;load the textbox graphics. This is hardcoded because it is the same
  ;for the entire game. The assumption here is that the background
  ;graphics we use will never occupy so many tiles that we cannot
  ;display a textbox or font.
  lda #<textbox_chr
  sta w0
  lda #>textbox_chr
  sta w0+1
  switch_bank_ldy #TEXTBOX_BG_CHR_BANK
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

  ;set camera to top left for slides
  lda #0
  sta camera_x
  sta camera_x+1
  sta camera_y
  sta camera_y+1
  sta camera_scroll_x
  sta camera_scroll_y

  lda #$20
  sta camera_nametable_hibyte

  ;initialize vblank routine
  lda #0
  sta vblank_wait_flag

  lda #0
  sta row_ready
  lda #0
  sta column_ready

  lda #<nametable_and_attribute_update_ppu
  sta vblank_routine
  lda #>nametable_and_attribute_update_ppu
  sta vblank_routine+1

  lda #0
  sta textbox_attribute

  lda #TEXTBOX_CUT_SCENE_ROW
  sta textbox_row

  switch_bank_ldy #TEXTBOX_BANK
  jsr draw_textbox

  switch_bank_ldy #SLIDE_DATA_BANK
  ldy #slide::conversation_index
  lda (w10),y
  tax
  lda conversations_lo,x
  sta w0
  lda conversations_hi,x
  sta w0+1
  jsr run_conversation

  ;fade out from current slide palette
  switch_bank_ldy #SLIDE_DATA_BANK
  ldy #slide::palette_address
  lda (w10),y
  sta palette_address
  iny
  lda (w10),y
  sta palette_address+1
  jsr ppu_fade_out_palette

  rts

.endproc
