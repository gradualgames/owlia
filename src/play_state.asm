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
.include "locations.inc"
.include "entities.inc"
.include "hero.inc"
.include "hero_constants.inc"

.segment "CODE"

.proc load_entity_types
entity_types_address = w3
chr_amount = w2
chr_offset = b1
entity_types_index = b0

  lda #0
  sta chr_offset

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

  ;get the address of this entity's chr data
  tay
  lda entity_defs_chr_address_lo,y
  sta w0
  lda entity_defs_chr_address_hi,y
  sta w0+1

  ;store the current chr offset in entity_types_chr_offsets array
  lda chr_offset
  sta entity_type_chr_offsets,y

  ;load the number of bytes in this chr chunk before loading it. we will use
  ;it to calculate the chr offset for this entity type.
  ldy #0
  lda (w0),y
  sta w2
  iny
  lda (w0),y
  sta w2+1

  jsr ppu_load_chr_amount

  ;shift right the number of bytes that was in the chr chunk by 4 to divide
  ;by 16 (number of bytes in a chr tile) to get the count in chr tile units.
  lda w2
  lsr w2+1
  ror
  lsr w2+1
  ror
  lsr w2+1
  ror
  lsr w2+1
  ror
  sta w2

  ;add lo byte to chr_offset so the next entity can store its offset in the
  ;entity_type_chr_offsets array in ram
  clc
  lda chr_offset
  adc w2
  sta chr_offset

  inc entity_types_index

  dex
  bne next_entity_type

  rts

.endproc

.proc spawn_entities
entities_address = w3
entities_index = b1
entities_count = b2

  ;get count for number of entity instances in this area
  ldy #0
  lda (entities_address),y
  sta entities_count
  beq no_entities

  ;store the index into the entities array
  sty entities_index

next_entity_instance:

  ;point at next entity
  inc entities_index

  ;get next entity index
  ldy entities_index
  lda (entities_address),y

  ;spawn the entity
  sta b0
  jsr entity_spawn

  ;get the x coordinate (metatile units)
  iny
  lda (entities_address),y
  sta entity_x_lo,x
  lda #0
  sta entity_x_hi,x
  ;get the y coordinate (metatile units)
  iny
  lda (entities_address),y
  sta entity_y_lo,x
  lda #0
  sta entity_y_hi,x

  sty entities_index

  ;now shift left the entity's x and y coordinates by 4 to multiply by 16
  ;to get correct map coordinates based on initial metatile coordinates.
  lda entity_x_hi,x
  asl entity_x_lo,x
  rol
  asl entity_x_lo,x
  rol
  asl entity_x_lo,x
  rol
  asl entity_x_lo,x
  rol
  sta entity_x_hi,x

  lda entity_y_hi,x
  asl entity_y_lo,x
  rol
  asl entity_y_lo,x
  rol
  asl entity_y_lo,x
  rol
  asl entity_y_lo,x
  rol
  sta entity_y_hi,x

  dec entities_count
  bne next_entity_instance
no_entities:

  rts

.endproc

.proc load_area_camera_vars

  ldy #location::nametable_start_hibyte
  lda (location_address),y
  sta camera_nametable_hibyte

  ldy #location::camera_start_x
  lda (location_address),y
  sta camera_x

  iny
  lda (location_address),y
  sta camera_x+1

  ldy #location::camera_start_y
  lda (location_address),y
  sta camera_y

  iny
  lda (location_address),y
  sta camera_y+1

  ldy #location::camera_start_scroll_x
  lda (location_address),y
  sta camera_scroll_x

  ldy #location::camera_start_scroll_y
  lda (location_address),y
  sta camera_scroll_y

  rts

.endproc

;assumes location_address contains address of location to load
;transitions directly to play state by spilling into it, this is NOT a routine
play_state_load_location:

  ;figure out what area to look at from the current location
  ldy #location::area_index
  lda (location_address),y
  tax
  lda areas_lo,x
  sta area_address
  lda areas_hi,x
  sta area_address+1

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

  ldy #area::bg_chr_bank
  lda (area_address),y
  sta bg_chr_bank

  ldy #area::sprite_chr_bank
  lda (area_address),y
  sta sprite_chr_bank

  ;initialize
  jsr ppu_safely_disable_graphics

  lda #$00
  sta $2006
  sta $2006

  ldy bg_chr_bank
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

  ldy sprite_chr_bank
  switch_bank_y

  ldy #area::entity_types_address
  lda (area_address),y
  sta w3
  iny
  lda (area_address),y
  sta w3+1

  jsr load_entity_types

  switch_bank_ldy map_bank

  ;load dynamic palette faded out so that fade in doesn't cause funkiness
  set_vblank_data_ready
  wait_vblank_data_ready
  lda #0
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

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

  ldy #area::metatile_table_properties_address
  lda (area_address),y
  sta metatile_table_properties_address
  iny
  lda (area_address),y
  sta metatile_table_properties_address+1

  ldy #area::metatile_table_params_address
  lda (area_address),y
  sta metatile_table_params_address
  iny
  lda (area_address),y
  sta metatile_table_params_address+1

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

  jsr load_area_camera_vars

  jsr fill_nametable_rows

  switch_bank_ldy entities_bank

  jsr entity_init_all

  ;initialize the hero entity
  jsr hero_init
  ;load her initial location
  ldy #location::hero_start_x
  lda (location_address),y
  sta hero_x_lo
  iny
  lda (location_address),y
  sta hero_x_hi

  ldy #location::hero_start_y
  lda (location_address),y
  sta hero_y_lo
  iny
  lda (location_address),y
  sta hero_y_hi

  ;load her initial direction
  ldy #location::hero_direction
  lda (location_address),y
  sta hero_previous_direction

  ;spawn all non-hero entities in area
  ldy #area::entity_instances_address
  lda (area_address),y
  sta w3
  iny
  lda (area_address),y
  sta w3+1

  jsr spawn_entities

  ;execute a single frame to get entities onscreen before palette fade in and music
  .scope execute_single_frame
  wait_vblank_data_ready

  jsr sprite_clear_all

  switch_bank_ldy entities_bank
  jsr hero_update
  jsr entity_update_all

  switch_bank_ldy map_bank
  jsr update_camera

  switch_bank_ldy sprites_and_animations_bank
  jsr hero_draw
  jsr entity_draw_all

  set_vblank_data_ready
  .endscope

  switch_bank_ldy map_bank
  ldy #area::palette_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  jsr ppu_fade_in_palette

  ;load area song if different from current song
  ldy #area::song_address
  lda (area_address),y
  sbc song_address
  iny
  lda (area_address),y
  sbc song_address+1
  beq same_song

  switch_bank_ldy music_bank
  ldy #area::song_address
  lda (area_address),y
  sta song_address
  iny
  lda (area_address),y
  sta song_address+1
  jsr song_initialize
same_song:

play_state:

  .scope play_frame
  wait_vblank_data_ready

  lda state_control_params+play_state_control::action
  cmp #ACTION_GOTO_LOCATION_GROUP1
  beq execute_goto_location_group1_action

  .ifdef CPU_USAGE
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  jsr sprite_clear_all

  jsr controller_read

  switch_bank_ldy entities_bank
  jsr hero_update
  jsr entity_update_all

  switch_bank_ldy map_bank
  jsr update_camera

  switch_bank_ldy sprites_and_animations_bank
  jsr hero_draw
  jsr entity_draw_all

  .ifdef CPU_USAGE
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  set_vblank_data_ready
  .endscope

  jmp play_state

execute_goto_location_group1_action:

  ;load the location to transition to
  ldx state_control_params+play_state_control::param
  lda locations_lo,x
  sta location_address
  lda locations_hi,x
  sta location_address+1

  ;play associated sound effect with this location
  ldy #location::on_enter_sfx_address
  lda (location_address),y
  sta sound_param_word_0
  iny
  lda (location_address),y
  sta sound_param_word_0+1

  ldy #location::on_enter_sfx_channel
  lda (location_address),y
  sta sound_param_byte_0

  ldy #location::on_enter_sfx_stream
  lda (location_address),y
  tax
  jsr stream_initialize

  ;fade out from current palette
  switch_bank_ldy map_bank
  ldy #area::palette_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  jsr ppu_fade_out_palette

  ;now that we know the area, make sure the state control
  ;param is nop again
  lda #ACTION_NOP
  sta state_control_params+play_state_control::action
  lda #0
  sta state_control_params+play_state_control::param

  jmp play_state_load_location

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

  set_vblank_data_ready

  wait_vblank_data_ready

  rts
not_finished:

  set_vblank_data_ready

  jmp loop

.endproc

.proc fill_nametable_rows

  lda camera_x
  sta w0

  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1

  lda camera_y+1
  sta w1+1

  lda #30
  sta b0

fill_nametable_loop:
  wait_vblank_data_ready

  ;prepare data

  lda w0
  pha
  lda w0+1
  pha
  lda w1
  pha
  lda w1+1
  pha
  lda b0
  pha

  switch_bank_ldy map_bank
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready

  pla
  sta b0
  pla
  sta w1+1
  pla
  sta w1
  pla
  sta w0+1
  pla
  sta w0

  clc
  lda w1
  adc #$08
  sta w1
  lda w1+1
  adc #$00
  sta w1+1

  set_vblank_data_ready

  dec b0
  bne fill_nametable_loop

  wait_vblank_data_ready

  rts

.endproc
