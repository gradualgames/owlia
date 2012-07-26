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

.segment "CODE"

.proc play_state
SPEED = 1

  ;initialize
  jsr ppu_safely_disable_graphics
  
  ;setup bank numbers
  lda #0
  sta music_bank
  
  lda #1
  sta entities_bank
  lda #2
  sta map_bank
  lda #3
  sta sprites_and_animations_bank
  
  switch_bank_yreg music_bank
  lda #<song1
  sta sound_param_word_1
  lda #>song1
  sta sound_param_word_1+1
  jsr song_initialize
  
  lda #$00
  sta $2006
  sta $2006

  switch_bank_yreg #7
  
  lda #<map0_chr
  sta w0
  lda #>map0_chr
  sta w0+1
  jsr ppu_load_chr_amount
  
  lda #$10
  sta $2006
  lda #$00
  sta $2006
  
  switch_bank_yreg #6
  
  lda #<hero_chr
  sta w0
  lda #>hero_chr
  sta w0+1
  jsr ppu_load_chr_amount
  
  switch_bank_yreg map_bank
  lda #<palette
  sta w0
  lda #>palette
  sta w0+1
  wait_vblank
  jsr ppu_load_palette
  
  jsr ppu_safely_enable_graphics
  
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
  
  lda #$20
  sta camera_nametable_hibyte
  
  lda #(16*0)
  sta camera_x
  lda #0
  sta camera_x+1
  lda #(16*0)
  sta camera_y
  lda #0
  sta camera_y+1
  
  lda #(16*0)
  sta camera_scroll_x
  lda #(232)
  sta camera_scroll_y
  
  lda #<metatile_table_attributes
  sta metatile_table_attributes_address
  lda #>metatile_table_attributes
  sta metatile_table_attributes_address+1
  
  lda #<metatile_table_top_left_tiles
  sta metatile_table_top_left_tiles_address
  lda #>metatile_table_top_left_tiles
  sta metatile_table_top_left_tiles_address+1
  
  lda #<metatile_table_top_right_tiles
  sta metatile_table_top_right_tiles_address
  lda #>metatile_table_top_right_tiles
  sta metatile_table_top_right_tiles_address+1
  
  lda #<metatile_table_bottom_left_tiles
  sta metatile_table_bottom_left_tiles_address
  lda #>metatile_table_bottom_left_tiles
  sta metatile_table_bottom_left_tiles_address+1

  lda #<metatile_table_bottom_right_tiles
  sta metatile_table_bottom_right_tiles_address
  lda #>metatile_table_bottom_right_tiles
  sta metatile_table_bottom_right_tiles_address+1
  
  lda #<big_metatile_table_top_left
  sta big_metatile_table_top_left_address
  lda #>big_metatile_table_top_left
  sta big_metatile_table_top_left_address+1
  
  lda #<big_metatile_table_top_right
  sta big_metatile_table_top_right_address
  lda #>big_metatile_table_top_right
  sta big_metatile_table_top_right_address+1

  lda #<big_metatile_table_bottom_left
  sta big_metatile_table_bottom_left_address
  lda #>big_metatile_table_bottom_left
  sta big_metatile_table_bottom_left_address+1
  
  lda #<big_metatile_table_bottom_right
  sta big_metatile_table_bottom_right_address
  lda #>big_metatile_table_bottom_right
  sta big_metatile_table_bottom_right_address+1
  
  lda #<map
  sta map_address
  lda #>map
  sta map_address+1

  switch_bank_yreg map_bank
  jsr fill_nametable_columns

  switch_bank_yreg entities_bank
  
  lda #(16*0)
  sta camera_x
  lda #0
  sta camera_x+1
  lda #(16*0)
  sta camera_y
  lda #0
  sta camera_y+1
  
  jsr entity_init_all
  
  ;spawn the hero entity
  lda #0
  sta b0
  jsr entity_spawn
  
  ;attach the camera to the entity instance at x
  jsr attach_camera_to_entity
  
loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  
  switch_bank_yreg music_bank
  jsr sound_update
  jsr sound_upload
  
  jsr sprite_clear_all
  
  jsr controller_read
  
  switch_bank_yreg entities_bank
  jsr entity_update_all
  
  switch_bank_yreg map_bank
  jsr update_camera
  
  switch_bank_yreg sprites_and_animations_bank
  jsr entity_draw_all
  
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp loop

.endproc

.proc fill_nametable_columns

  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
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
  bne :+
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  rts
:
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp :--

  rts

.endproc
  
.proc fill_nametable_rows

fill_nametable_loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
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

  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready

  rts

done:
  
  ; clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  ; upload_ppu_2001
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready

  jmp fill_nametable_loop

.endproc
