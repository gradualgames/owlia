.include "ndxdebug.h"
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
.include "map_data.inc"
.include "title_state.inc"
.include "sprite_chr_data.inc"
.include "soundengine.inc"
.include "music_data.inc"

.segment "CODE"

play_cut_scene:

  far_call #CUT_SCENE_STATE_BANK, load_blank_map

  set_controller_routine controller_read

  far_call #CUT_SCENE_STATE_BANK, load_slide

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
  switch_bank_ldy #SLIDE_DATA_BANK
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

.segment "ROM01"

.proc load_blank_map

  lda #MAP_DATA_BANK1
  sta map_bank

  ldy #<blank_metatile_table_properties
  sta metatile_table_properties_address
  lda #>blank_metatile_table_properties
  sta metatile_table_properties_address+1

  lda #<blank_metatile_table_params
  sta metatile_table_params_address
  lda #>blank_metatile_table_params
  sta metatile_table_params_address+1

  lda #<blank_metatile_table_attributes
  sta metatile_table_attributes_address
  lda #>blank_metatile_table_attributes
  sta metatile_table_attributes_address+1

  lda #<blank_metatile_table_top_left_tiles
  sta metatile_table_top_left_tiles_address
  lda #>blank_metatile_table_top_left_tiles
  sta metatile_table_top_left_tiles_address+1

  lda #<blank_metatile_table_top_right_tiles
  sta metatile_table_top_right_tiles_address
  lda #>blank_metatile_table_top_right_tiles
  sta metatile_table_top_right_tiles_address+1

  lda #<blank_metatile_table_bottom_left_tiles
  sta metatile_table_bottom_left_tiles_address
  lda #>blank_metatile_table_bottom_left_tiles
  sta metatile_table_bottom_left_tiles_address+1

  lda #<blank_metatile_table_bottom_right_tiles
  sta metatile_table_bottom_right_tiles_address
  lda #>blank_metatile_table_bottom_right_tiles
  sta metatile_table_bottom_right_tiles_address+1

  lda #<blank_big_metatile_table_top_left
  sta big_metatile_table_top_left_address
  lda #>blank_big_metatile_table_top_left
  sta big_metatile_table_top_left_address+1

  lda #<blank_big_metatile_table_top_right
  sta big_metatile_table_top_right_address
  lda #>blank_big_metatile_table_top_right
  sta big_metatile_table_top_right_address+1

  lda #<blank_big_metatile_table_bottom_left
  sta big_metatile_table_bottom_left_address
  lda #>blank_big_metatile_table_bottom_left
  sta big_metatile_table_bottom_left_address+1

  lda #<blank_big_metatile_table_bottom_right
  sta big_metatile_table_bottom_right_address
  lda #>blank_big_metatile_table_bottom_right
  sta big_metatile_table_bottom_right_address+1

  lda #<blank_map
  sta map_address
  lda #>blank_map
  sta map_address+1

  rts

.endproc

.proc load_slide_sprite_chr_groups
slide_address = w10
sprite_chr_groups_address = w11
sprite_chr_groups_count = b10
sprite_chr_groups_index = b11  ;? Is this ever initialized?

  lda #$10
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  ;get address of sprite chr groups for this slide
  ldy #slide::sprite_chr_groups_address
  far_load #SLIDE_DATA_BANK, slide_address, slide_address+1
  lda far_load_result
  sta sprite_chr_groups_address
  iny
  far_load #SLIDE_DATA_BANK, slide_address, slide_address+1
  lda far_load_result
  sta sprite_chr_groups_address+1

  ;check if this address is zero and bail if so
  lda sprite_chr_groups_address
  bne nonzero_address
  lda sprite_chr_groups_address+1
  bne nonzero_address
  rts
nonzero_address:

  ;get count
  lda #0
  sta sprite_chr_groups_index

  ldy sprite_chr_groups_index
  far_load #SLIDE_DATA_BANK, sprite_chr_groups_address, sprite_chr_groups_address+1
  lda far_load_result
  sta sprite_chr_groups_count

  inc sprite_chr_groups_index

next_set:

  ;get index of next group
  ldy sprite_chr_groups_index
  far_load #SLIDE_DATA_BANK, sprite_chr_groups_address, sprite_chr_groups_address+1
  lda far_load_result
  sta b0

  ;get lo byte of group
  ldy b0
  far_load #SPRITE_CHR_DATA_BANK, #<sprite_chr_group_addresses_lo, #>sprite_chr_group_addresses_lo
  lda far_load_result
  sta w0

  ;get hi byte of group
  far_load #SPRITE_CHR_DATA_BANK, #<sprite_chr_group_addresses_hi, #>sprite_chr_group_addresses_hi
  lda far_load_result
  sta w0+1

  ;get bank of group
  far_load #SPRITE_CHR_DATA_BANK, #<sprite_chr_group_bank, #>sprite_chr_group_bank
  lda far_load_result
  sta b0

  ;load the group
  far_call b0, ppu_load_chr_amount

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

  ;get address of sprite overlays for this slide
  ldy #slide::sprite_overlays_address
  far_load #SLIDE_DATA_BANK, slide_address, slide_address+1
  lda far_load_result
  sta sprite_overlays_address
  iny
  far_load #SLIDE_DATA_BANK, slide_address, slide_address+1
  lda far_load_result
  sta sprite_overlays_address+1

  ;check if this address is zero and bail if so
  lda sprite_overlays_address
  bne nonzero_address
  lda sprite_overlays_address+1
  bne nonzero_address
  rts
nonzero_address:

  ;get count
  lda #0
  sta sprite_overlays_index

  ldy sprite_overlays_index
  far_load #SLIDE_DATA_BANK, sprite_overlays_address, sprite_overlays_address+1
  lda far_load_result
  sta sprite_overlays_count

  inc sprite_overlays_index

next_overlay:

  jsr load_sprite_overlay

  dec sprite_overlays_count
  bne next_overlay

  rts

load_sprite_overlay:

  ;load bank of overlay
  ldy sprite_overlays_index
  far_load #SLIDE_DATA_BANK, sprite_overlays_address, sprite_overlays_address+1
  lda far_load_result
  sta sprite_overlay_bank

  inc sprite_overlays_index

  ;load address of overlay
  ldy sprite_overlays_index
  far_load #SLIDE_DATA_BANK, sprite_overlays_address, sprite_overlays_address+1
  lda far_load_result
  sta w0
  iny
  far_load #SLIDE_DATA_BANK, sprite_overlays_address, sprite_overlays_address+1
  lda far_load_result
  sta w0+1

  inc sprite_overlays_index
  inc sprite_overlays_index
  inc sprite_overlays_index
  inc sprite_overlays_index

  ;assume chr group is at 0 for now
  lda #0
  sta chr_group_offset

  far_call sprite_overlay_bank, sprite_draw_overlay

  rts

.endproc

.proc load_strings
strings_address = w1

  ldy #slide::strings_address
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta strings_address
  iny
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta strings_address+1

  .scope
  lda font_chr_offset
  sta chr_group_offset

  ;load string count
  ldy #0
  far_load #SLIDE_DATA_BANK, strings_address, strings_address+1
  lda far_load_result
  sta b10
next_string:

  ;load row
  iny
  far_load #SLIDE_DATA_BANK, strings_address, strings_address+1
  lda far_load_result
  sta b1

  ;load column
  iny
  far_load #SLIDE_DATA_BANK, strings_address, strings_address+1
  lda far_load_result
  sta b2

  ;load string address
  iny
  far_load #SLIDE_DATA_BANK, strings_address, strings_address+1
  lda far_load_result
  sta w0

  iny
  far_load #SLIDE_DATA_BANK, strings_address, strings_address+1
  lda far_load_result
  sta w0+1

  lda #$20
  sta b0

  far_call #SLIDE_DATA_BANK, print_string_impl

  dec b10
  bne next_string
  .endscope

  rts

.endproc

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

  .scope
  ldy #slide::bg_chr_address
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta w0
  iny
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta w0+1

  ldy #slide::bg_chr_bank
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta b0

  lda w0
  ora w0+1
  beq no_bg_chr_data
  far_call b0, ppu_load_chr_amount
no_bg_chr_data:
  .endscope

  ;grab tile accumulator to know where the textbox group begins
  lda b3
  sta textbox_chr_offset

  .scope
  ldy #slide::slide_type
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  cmp #SLIDE_TYPE_IMAGE_ONLY
  beq skip_textbox
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
skip_textbox:
  .endscope

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

  .scope
  ldy #slide::nametable_address
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta w0
  iny
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta w0+1

  ldy #slide::nametable_bank
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta b0

  lda w0
  ora w0+1
  beq no_nametable_data
  far_call b0, ppu_load_nametable
  jmp done
no_nametable_data:
  clc
  lda font_chr_offset
  adc #' '
  sta b0
  lda #0
  sta b1
  jsr ppu_fill_nametable
done:
  .endscope

  ;print specified list of strings on the screen if specified
  .scope
  ldy #slide::slide_type
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  cmp #SLIDE_TYPE_STRINGS_ONLY
  bne not_strings_slide
  jsr load_strings
not_strings_slide:
  .endscope

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
  ldy #slide::palette_address
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta palette_address
  iny
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta palette_address+1

  lda #MAX_BRIGHTNESS_LEVEL
  sta b4
  sta b5
  far_call #SLIDE_DATA_BANK, ppu_fade_in_palette

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

  ;load song if present
  .scope
  ldy #slide::song_address
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta w11
  ldy #slide::song_address+1
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta w11+1

  lda w11
  ora w11
  beq no_song

  lda w11
  sta song_address
  lda w11+1
  sta song_address+1
  far_call #SOUND_BANK, song_initialize

no_song:
  .endscope

  .scope
  ldy #slide::slide_type
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  cmp #SLIDE_TYPE_IMAGE_ONLY
  beq image_slide
  cmp #SLIDE_TYPE_STRINGS_ONLY
  beq strings_slide
textbox_slide:
  lda #0
  sta textbox_attribute

  lda #TEXTBOX_CUT_SCENE_ROW
  sta textbox_row

  far_call #TEXTBOX_BANK, draw_textbox

  ldy #slide::conversation_index
  far_load #SLIDE_DATA_BANK, w10, w10+1
  ldy far_load_result

  far_load #CONVERSATIONS_LUT_BANK, #<conversations_lo, #>conversations_lo
  lda far_load_result
  sta w0
  far_load #CONVERSATIONS_LUT_BANK, #<conversations_hi, #>conversations_hi
  lda far_load_result
  sta w0+1

  far_call #TEXTBOX_BANK, run_conversation

  jmp done
strings_slide:
image_slide:

  .scope
  ldy #slide::slide_length
  far_load #SLIDE_DATA_BANK, w10, w10+1
  ldx far_load_result
  bne wait_length

  ;if slide_length is 0, this is SLIDE_LENGTH_INFINITE.
  ;It is assumed this is only used for the final slide of the
  ;last cut scene. It will remain on the screen indefinitely until
  ;a reset.
wait_infinitely:
: clear_vblank_done
  wait_vblank_done
  jmp :-

wait_length:
: clear_vblank_done
  wait_vblank_done
  clear_vblank_done
  wait_vblank_done
  dex
  bne :-

  .endscope

done:
  .endscope

  ;fade out from current slide palette
  ldy #slide::palette_address
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta palette_address
  iny
  far_load #SLIDE_DATA_BANK, w10, w10+1
  lda far_load_result
  sta palette_address+1

  far_call #SLIDE_DATA_BANK, ppu_fade_out_palette

  rts

.endproc