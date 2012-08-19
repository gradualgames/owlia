.include "play_state.inc"
.include "controller.inc"
.include "ppu.inc"
.include "zp.inc"
.include "ram.inc"
.include "map.inc"
.include "map_data.inc"
.include "sprite.inc"
.include "entity.inc"
.include "soundengine.inc"
.include "camera.inc"
.include "sprites_and_animations_data.inc"
.include "sprite_chr_data.inc"
.include "music_data.inc"
.include "bg_chr_data.inc"
.include "mapper.inc"
.include "areas.inc"
.include "entities.inc"

.segment "CODE"

.proc load_entity_types_chr
entity_types_address = w3
entity_types_index = b0

  ;get count for number of entity types in this area
  ldy #0
  lda (entity_types_address),y
  ;put it in x for counting
  tax

  ;point at the first entry in the entity types array
  iny
  sty entity_types_index
  
next_entity_type:

  ;get next entity type index
  ldy entity_types_index
  lda (entity_types_address),y

  tay
  lda entity_defs_chr_address_lo,y
  sta w0
  lda entity_defs_chr_address_hi,y
  sta w0+1
  jsr ppu_load_chr_amount
  
  inc entity_types_index
  
  dex
  bne next_entity_type

  rts

.endproc

.proc load_area_camera_vars

  lda #$20
  sta camera_nametable_hibyte
  
  ldy #area::camera_start_x
  lda (area_address),y
  sta camera_x
  
  iny
  lda (area_address),y
  sta camera_x+1

  ldy #area::camera_start_y
  lda (area_address),y
  sta camera_y
  
  iny
  lda (area_address),y
  sta camera_y+1
  
  ldy #area::camera_start_scroll_x
  lda (area_address),y
  sta camera_scroll_x
  
  ldy #area::camera_start_scroll_y
  lda (area_address),y
  sta camera_scroll_y

  rts

.endproc

;assumes w0 contains address of area to load
;transitions directly to play state by spilling into it, this is NOT a routine
play_state_load_area:
area_address = w2

  ;initialize
  jsr ppu_safely_disable_graphics
  
  ;setup bank numbers
  ldy #area::music_bank
  lda (area_address),y
  sta music_bank
  
  ldy #area::entities_bank
  lda (area_address),y
  sta entities_bank
  
  ldy #area::map_bank
  lda (area_address),y
  sta map_bank
  
  ldy #area::sprites_and_animations_bank
  lda (area_address),y
  sta sprites_and_animations_bank
  
  lda #$00
  sta $2006
  sta $2006

  ldy #area::bg_chr_bank
  lda (area_address),y
  tay
  switch_bank_y

  ldy #area::bg_chr_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  jsr ppu_load_chr_amount
  
  lda #$10
  sta $2006
  lda #$00
  sta $2006
  
  ldy #area::sprite_chr_bank
  lda (area_address),y
  tay
  switch_bank_y

  ldy #area::entity_types_address
  lda (area_address),y
  sta w3
  iny
  lda (area_address),y
  sta w3+1
  
  jsr load_entity_types_chr
  
  switch_bank_ldy map_bank
  
  ;load dynamic palette faded out so that fade in doesn't cause funkiness
  wait_vblank
  lda #0
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  jsr ppu_load_palette
  
  jsr ppu_safely_enable_graphics
  
  switch_bank_ldy music_bank
  lda #<song1
  sta sound_param_word_1
  lda #>song1
  sta sound_param_word_1+1
  jsr song_initialize
  
  ;initialize variables
  lda #0
  sta vblank_data_ready
  
  lda #0
  sta row_ready
  lda #0
  sta column_ready
  
  lda #<nametable_and_attribute_update_ppu
  sta vblank_routine
  lda #>nametable_and_attribute_update_ppu
  sta vblank_routine+1
  
  jsr load_area_camera_vars

  ldy #area::metatile_table_attributes_address
  lda (area_address),y
  sta metatile_table_attributes_address
  iny
  lda (area_address),y
  sta metatile_table_attributes_address+1
  
  ldy #area::metatile_table_top_left_tiles_address
  lda (area_address),y
  sta metatile_table_top_left_tiles_address
  iny
  lda (area_address),y
  sta metatile_table_top_left_tiles_address+1
  
  ldy #area::metatile_table_top_right_tiles_address
  lda (area_address),y
  sta metatile_table_top_right_tiles_address
  iny
  lda (area_address),y
  sta metatile_table_top_right_tiles_address+1
  
  ldy #area::metatile_table_bottom_left_tiles_address
  lda (area_address),y
  sta metatile_table_bottom_left_tiles_address
  iny
  lda (area_address),y
  sta metatile_table_bottom_left_tiles_address+1

  ldy #area::metatile_table_bottom_right_tiles_address
  lda (area_address),y
  sta metatile_table_bottom_right_tiles_address
  iny
  lda (area_address),y
  sta metatile_table_bottom_right_tiles_address+1
  
  ldy #area::big_metatile_table_top_left_address
  lda (area_address),y
  sta big_metatile_table_top_left_address
  iny
  lda (area_address),y
  sta big_metatile_table_top_left_address+1
  
  ldy #area::big_metatile_table_top_right_address
  lda (area_address),y
  sta big_metatile_table_top_right_address
  iny
  lda (area_address),y
  sta big_metatile_table_top_right_address+1

  ldy #area::big_metatile_table_bottom_left_address
  lda (area_address),y
  sta big_metatile_table_bottom_left_address
  iny
  lda (area_address),y
  sta big_metatile_table_bottom_left_address+1
  
  ldy #area::big_metatile_table_bottom_right_address
  lda (area_address),y
  sta big_metatile_table_bottom_right_address
  iny
  lda (area_address),y
  sta big_metatile_table_bottom_right_address+1
  
  ldy #area::map_address
  lda (area_address),y
  sta map_address
  iny
  lda (area_address),y
  sta map_address+1

  switch_bank_ldy map_bank
  
  ;save area address, fill_nametable_columns destroys most local vars
  lda area_address
  pha
  lda area_address+1
  pha

  jsr fill_nametable_columns
  
  ;restore area address so we can re-load camera vars
  pla
  sta area_address+1
  pla
  sta area_address
  
  ldy #area::palette_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  jsr ppu_fade_in_palette
  
  switch_bank_ldy entities_bank
  
  jsr load_area_camera_vars
  
  jsr entity_init_all
  
  ;spawn the hero entity
  lda #0
  sta b0
  jsr entity_spawn
  
  ;attach the camera to the entity instance at x
  jsr attach_camera_to_entity

play_state:

loop:
  wait_vblank_data_ready
  
  .ifdef CPU_USAGE
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif
  
  switch_bank_ldy music_bank
  jsr sound_update
  jsr sound_upload
  
  jsr sprite_clear_all
  
  jsr controller_read
  
  switch_bank_ldy entities_bank
  jsr entity_update_all
  
  switch_bank_ldy map_bank
  jsr update_camera
  
  switch_bank_ldy sprites_and_animations_bank
  jsr entity_draw_all
  
  .ifdef CPU_USAGE
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif
  
  signal_vblank_data_ready
  
  jmp loop
  
.proc fill_nametable_columns

loop:
  wait_vblank_data_ready
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  clc
  lda camera_x
  adc #$08
  sta camera_x
  lda camera_x+1
  adc #$00
  sta camera_x+1

  lda camera_x+1
  cmp #1
  bne not_finished
  
  signal_vblank_data_ready
  
  wait_vblank_data_ready
  
  rts
not_finished:
  
  signal_vblank_data_ready
  
  jmp loop

.endproc
  
.proc fill_nametable_rows

fill_nametable_loop:
  wait_vblank_data_ready

  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  clc
  lda camera_y
  adc #$08
  sta camera_y
  lda camera_y+1
  adc #$00
  sta camera_y+1
  
  lda camera_y
  cmp #240
  beq bottom_row
not_bottom_row:
  
  jmp done
bottom_row:

  signal_vblank_data_ready

  rts

done:
  
  ; clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  ; upload_ppu_2001
  
  signal_vblank_data_ready

  jmp fill_nametable_loop

.endproc
