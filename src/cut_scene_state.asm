.include "controller.inc"
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
.include "title_state.inc"
.include "sprite_chr_data.inc"

.segment "CODE"

play_cut_scene:

  set_controller_routine controller_read

  jsr load_slide

  lda textbox_result
  cmp #TEXTBOX_EXIT
  beq exit_cut_scene_state

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

  switch_bank_ldy #TITLE_STATE_BANK
  jmp title_state_init

.proc load_slide

  ;set blank nmi routine
  safely_set_vblank_routine ppu_vblank_nop

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  jsr sprite_update_all

  ;load chr data
  lda #$00
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

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

  ;load sprite chr data for slide
  jsr load_slide_sprite_chr_groups

  ;draw sprites for the slide
  jsr load_slide_sprite_overlays

  jsr sprite_update_all

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
  sta ppu_2006+1
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
  sta row_ready
  lda #0
  sta column_ready

  safely_set_vblank_routine nametable_and_attribute_update_ppu

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

.proc load_slide_sprite_chr_groups
slide_address = w10
sprite_chr_groups_address = w11
sprite_chr_groups_count = b10
sprite_chr_groups_index = b11

  lda #$10
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  ;get address of sprite chr groups for this slide
  switch_bank_ldy #SLIDE_DATA_BANK
  ldy #slide::sprite_chr_groups_address
  lda (slide_address),y
  sta sprite_chr_groups_address
  iny
  lda (slide_address),y
  sta sprite_chr_groups_address+1

  ;check if this address is zero and bail if so
  lda sprite_chr_groups_address
  bne nonzero_address
  lda sprite_chr_groups_address+1
  bne nonzero_address
  rts
nonzero_address:

  ;get count
  ldy #0
  sty sprite_chr_groups_index
  lda (sprite_chr_groups_address),y
  sta sprite_chr_groups_count
  inc sprite_chr_groups_index

next_set:

  switch_bank_ldy #SLIDE_DATA_BANK
  ;get index of next group
  ldy sprite_chr_groups_index
  lda (sprite_chr_groups_address),y
  tax

  ;get address of group
  lda sprite_chr_group_addresses_lo,x
  sta w0
  lda sprite_chr_group_addresses_hi,x
  sta w0+1

  ldy sprite_chr_group_bank,x
  switch_bank_y

  jsr ppu_load_chr_amount

  inc sprite_chr_groups_index

  dec sprite_chr_groups_count
  bne next_set

  rts

.endproc

.proc load_slide_sprite_overlays
slide_address = w10
sprite_overlays_address = w11
sprite_overlays_count = b9
sprite_overlays_index = b10
sprite_overlay_bank = b11

  ;get address of sprite chr groups for this slide
  switch_bank_ldy #SLIDE_DATA_BANK
  ldy #slide::sprite_overlays_address
  lda (slide_address),y
  sta sprite_overlays_address
  iny
  lda (slide_address),y
  sta sprite_overlays_address+1

  ;check if this address is zero and bail if so
  lda sprite_overlays_address
  bne nonzero_address
  lda sprite_overlays_address+1
  bne nonzero_address
  rts
nonzero_address:

  ;get count
  ldy #0
  sty sprite_overlays_index
  lda (sprite_overlays_address),y
  sta sprite_overlays_count
  inc sprite_overlays_index

next_overlay:

  switch_bank_ldy #SLIDE_DATA_BANK
  ;load bank of overlay
  ldy sprite_overlays_index
  lda (sprite_overlays_address),y
  sta sprite_overlay_bank
  iny

  ;load address of overlay
  lda (sprite_overlays_address),y
  sta w0
  iny
  lda (sprite_overlays_address),y
  sta w0+1
  iny

  ;load x coordinate of overlay
  lda (sprite_overlays_address),y
  sta w3
  lda #0
  sta w3+1
  iny

  ;load y coordinate of overlay
  lda (sprite_overlays_address),y
  sta w4
  lda #0
  sta w4+1
  iny

  sty sprite_overlays_index

  lda #0
  sta b2

  ;assume chr group is at 0 for now
  lda #0
  sta chr_group_offset

  switch_bank_ldx sprite_overlay_bank
  jsr sprite_draw_metasprite

  dec sprite_overlays_count
  bne next_overlay

  rts

.endproc
