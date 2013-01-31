.linecont +
.include "play_state.inc"
.include "controller.inc"
.include "ppu.inc"
.include "zp.inc"
.include "ram.inc"
.include "actions.inc"
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
.include "familiar.inc"
.include "familiar_constants.inc"
.include "textbox.inc"
.include "conversation_data.inc"

.segment "CODE"

;this routine must be called before using the play state when
;the game boots up. It ensures that all play state specific
;state is in a known state before proceeding (such as clearing
;out the current song address)
.proc play_state_initialize

  ;set up state control struct for the "nop" action
  lda #ACTION_NOP
  sta state_control_params+play_state_control::action
  lda #0
  sta state_control_params+play_state_control::param

  ;clear out song address so first song will get loaded
  lda #0
  sta song_address
  sta song_address+1

  rts
.endproc

;this routine loads all sprite chr groups for the current area, which
;basically just means it will load all chr data for entities into
;VRAM and remember where they were loaded in sprite_chr_group_addresses.
.proc load_sprite_chr_groups
sprite_chr_groups_address = w3
chr_amount = w2
chr_offset = b1
sprite_chr_groups_index = b0

  lda #0
  sta chr_offset

  ;get count for number of entity types in this area
  switch_bank_ldy #AREAS_BANK
  ldy #0
  lda (sprite_chr_groups_address),y
  ;put it in x for counting
  tax

  ;point at the first entry in the entity types array
  iny
  sty sprite_chr_groups_index

next_entity_type:

  ;get next entity type index
  ldy sprite_chr_groups_index
  lda (sprite_chr_groups_address),y

  ;get the address of this entity's chr data
  tay
  lda sprite_chr_group_addresses_lo,y
  sta w0
  lda sprite_chr_group_addresses_hi,y
  sta w0+1

  ;store the current chr offset in sprite_chr_groups_chr_offsets array
  lda chr_offset
  sta sprite_chr_group_offsets,y

  ;load the number of bytes in this chr chunk before loading it. we will use
  ;it to calculate the chr offset for this entity type.
  switch_bank_ldy sprite_chr_bank
  ldy #0
  lda (w0),y
  sta w2
  iny
  lda (w0),y
  sta w2+1

  jsr ppu_load_chr_amount
  switch_bank_ldy #AREAS_BANK

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
  ;sprite_chr_group_offsets array in ram
  clc
  lda chr_offset
  adc w2
  sta chr_offset

  inc sprite_chr_groups_index

  dex
  bne next_entity_type

  rts

.endproc

;this routine spawns all entities for a given area.
.proc spawn_entities
entities_address = w3
entities_index = b1
entities_count = b2
entities_params_count = b3

  switch_bank_ldy #AREAS_BANK

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
  sta b0

  ;get the x coordinate (metatile units)
  iny
  lda (entities_address),y
  sta w0
  lda #0
  sta w0+1
  ;get the y coordinate (metatile units)
  iny
  lda (entities_address),y
  sta w1
  lda #0
  sta w1+1

  sty entities_index

  ;now shift left the entity's x and y coordinates by 4 to multiply by 16
  ;to get correct map coordinates based on initial metatile coordinates.
  lda w0+1
  asl w0
  rol
  asl w0
  rol
  asl w0
  rol
  asl w0
  rol
  sta w0+1

  lda w1+1
  asl w1
  rol
  asl w1
  rol
  asl w1
  rol
  asl w1
  rol
  sta w1+1

  ;spawn the entity
  jsr entity_spawn

  ;get chr offset for this entity
  ldy entities_index
  iny
  lda (entities_address),y
  sty entities_index
  tay
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  jsr get_entity_params

  dec entities_count
  bne next_entity_instance
no_entities:

  rts

get_entity_params:

  ;get params count for the entity
  ldy entities_index
  iny
  lda (entities_address),y
  sta entities_params_count

  beq no_more_params
  ;get the params for the entity (entity specific, often NPC conversation index)

  iny
  lda (entities_address),y
  sta entity_local0,x

  dec entities_params_count
  beq no_more_params

  iny
  lda (entities_address),y
  sta entity_local1,x

  dec entities_params_count
  beq no_more_params

  iny
  lda (entities_address),y
  sta entity_local2,x

  dec entities_params_count
  beq no_more_params

  iny
  lda (entities_address),y
  sta entity_local3,x

  dec entities_params_count
  beq no_more_params

  iny
  lda (entities_address),y
  sta entity_local4,x

  dec entities_params_count
  beq no_more_params

  iny
  lda (entities_address),y
  sta entity_local5,x

no_more_params:

  sty entities_index

  rts

.endproc

;loads the starting values for the camera from the current location
.proc load_area_camera_vars

  switch_bank_ldy #LOCATIONS_BANK
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

;a list of action handlers for the play state. This
;must exactly reflect the actions enum in actions.inc.
.define play_state_action_handlers \
  play_state_action_nop, \
  play_state_action_goto_location_group1, \
  play_state_action_start_conversation

play_state_action_handlers_lo:
  .lobytes play_state_action_handlers

play_state_action_handlers_hi:
  .hibytes play_state_action_handlers

;****************************************************************
;This is a branch location and not a routine. It is used to
;load all graphics and entities and music for a specific location
;within a specific area definition.
;assumes location_address contains address of location to load
;transitions directly to play state by spilling into it.
;****************************************************************
play_state_load_location:

  ;figure out what area to look at from the current location
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::area_index
  lda (location_address),y
  tax
  lda areas_lo,x
  sta area_address
  lda areas_hi,x
  sta area_address+1

  ;setup bank numbers
  switch_bank_ldy #AREAS_BANK
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

  ldy #area::conversations_bank
  lda (area_address),y
  sta conversations_bank

  ;load other variables we need
  ldy #area::textbox_attribute
  lda (area_address),y
  sta textbox_attribute

  ;initialize
  jsr ppu_safely_disable_graphics

  lda #$00
  sta $2006
  sta $2006

  ldy #area::bg_chr_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy bg_chr_bank
  jsr ppu_load_chr_amount

  ;load the textbox graphics. This is hardcoded because it is the same
  ;for the entire game. The assumption here is that the background
  ;graphics we use will never occupy so many tiles that we cannot
  ;display a textbox or font.
  lda #<textbox_chr
  sta w0
  lda #>textbox_chr
  sta w0+1
  jsr ppu_load_chr_amount

  ;load the bg chr address again so we can pull out the count and intepret
  ;it as the offset at which to find the textbox and font graphics.
  switch_bank_ldy #AREAS_BANK
  ldy #area::bg_chr_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy bg_chr_bank
  ;load the byte count
  ldy #0
  lda (w0),y
  sta w1
  iny
  lda (w0),y
  sta w1+1
  ;shift right this 16 bit value to calculate number of tiles
  lda w1
  lsr w1+1
  ror
  lsr w1+1
  ror
  lsr w1+1
  ror
  lsr w1+1
  ror
  sta w1
  ;lo byte of w1 should now be the correct offset for the textbox and font graphics
  sta textbox_and_font_chr_offset

  lda #$10
  sta $2006
  lda #$00
  sta $2006

  switch_bank_ldy #AREAS_BANK
  ldy #area::sprite_chr_groups_address
  lda (area_address),y
  sta w3
  iny
  lda (area_address),y
  sta w3+1
  jsr load_sprite_chr_groups

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

  switch_bank_ldy #AREAS_BANK
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

  jsr entity_init_all

  ;initialize the hero entity
  jsr hero_init
  ;load her initial location
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::hero_start_x
  lda (location_address),y
  sta hero_x
  iny
  lda (location_address),y
  sta hero_x+1

  ldy #location::hero_start_y
  lda (location_address),y
  sta hero_y
  iny
  lda (location_address),y
  sta hero_y+1

  ;load her initial direction
  ldy #location::hero_direction
  lda (location_address),y
  sta hero_direction

  ;initialize the familiar entity
  jsr familiar_init

  ;spawn all non-hero entities in area
  switch_bank_ldy #AREAS_BANK
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

  jsr entity_update_all

  switch_bank_ldy map_bank
  jsr update_camera

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  set_vblank_data_ready
  .endscope

  ;load area song if different from current song
  switch_bank_ldy #AREAS_BANK
  ldy #area::song_address
  sec
  lda (area_address),y
  sbc song_address
  iny
  lda (area_address),y
  sbc song_address+1
  beq same_song

  ldy #area::song_address
  lda (area_address),y
  sta song_address
  iny
  lda (area_address),y
  sta song_address+1
  switch_bank_ldy music_bank
  jsr song_initialize
same_song:

  switch_bank_ldy #AREAS_BANK
  ldy #area::palette_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy map_bank
  jsr ppu_fade_in_palette

;****************************************************************
;This branch location is the main game loop. It handles map
;updates, entity updates, and hero and familiar updates. It also
;handles state transitions to other locations, inventory screen,
;store screen, etc. These transitions are usually triggered by
;an entity setting an action and param combination in the play
;state control params.
;****************************************************************
play_state:

  wait_vblank_data_ready

  ;switchboard for controlling the play state logic
  lda state_control_params+play_state_control::action
  tay
  lda play_state_action_handlers_lo,y
  sta w0
  lda play_state_action_handlers_hi,y
  sta w0+1
  jmp (w0)
play_state_action_nop:

  .ifdef CPU_USAGE
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  jsr sprite_clear_all

  jsr controller_read

  jsr entity_update_all

  switch_bank_ldy map_bank
  jsr update_camera

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  ;test controller for system logic that entities never
  ;need to care about such as the paused state.
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq pause_state_init

  .ifdef CPU_USAGE
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  set_vblank_data_ready

  jmp play_state

;****************************************************************
;This branch location is the pause state. Branch to
;pause_state_init to put the game into a paused state.
;pause_state_init will swap the vblank routine for the paused
;vblank routine, which does nothing. Then, the pause state loop
;will just read the controller and sync with vblank waiting for
;an "off to on" transition on the start button to leave the
;pause state. Upon exiting the loop it will restore the normal
;play state vblank routine and then jump to play_state.
;****************************************************************
pause_state_init:

  set_vblank_data_ready

  wait_vblank_data_ready

  ;switch to pause state vblank routine
  lda #<pause_ppu
  sta vblank_routine
  lda #>pause_ppu
  sta vblank_routine+1

  ;load up the current palette faded to a darker shade for the
  ;duration of the paused state.
  switch_bank_ldy #AREAS_BANK
  ldy #area::palette_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy map_bank
  lda #1
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  set_vblank_data_ready

pause_state:

  wait_vblank_data_ready

  jsr controller_read

  ;test for start button to be hit again to exit the paused state
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq pause_state_exit

  set_vblank_data_ready

  jmp pause_state

pause_state_exit:

  set_vblank_data_ready
  wait_vblank_data_ready

  ;restore the palette to max brightness before exiting the paused state.
  switch_bank_ldy #AREAS_BANK
  ldy #area::palette_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy map_bank
  lda #4
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  set_vblank_data_ready

  ;restore the play state vblank routine
  wait_vblank_data_ready
  lda #<nametable_and_attribute_update_ppu
  sta vblank_routine
  lda #>nametable_and_attribute_update_ppu
  sta vblank_routine+1
  set_vblank_data_ready

  jmp play_state

;this is the vblank routine for the pause state.
.proc pause_ppu

  lda vblank_data_ready
  beq data_not_ready

  ;palette writes must have the 32 byte increment
  ;setting turned off!
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  jsr ppu_load_palette

  ;make sure to update all ppu registers as
  ;they had been in the play state for scrolling
  lda camera_nametable_hibyte
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  lda camera_scroll_x
  sta ppu_2005
  lda camera_scroll_y
  sta ppu_2005+1

  upload_ppu_2006
  upload_ppu_2005

  lda #0
  sta vblank_data_ready

data_not_ready:

  ;does not require music data from another bank. All this
  ;does is upload what is currently in the registers, and then
  ;clears them, ensuring that sound cuts out during the paused state.
  jsr sound_upload

  rts

.endproc

;****************************************************************
;This action handler loads a new location and jumps to the
;play_state_load_location branch when all information about the
;new location is ready. It also plays a sound effect associated
;with the location if specified. This is usually used for going
;through a door. It fades out the current palette. It also
;restores the action and param to ACTION_NOP so the main game
;loop will proceed normally once the new location is loaded.
;****************************************************************
play_state_action_goto_location_group1:

  ;load the location to transition to
  ldx state_control_params+play_state_control::param
  lda locations_lo,x
  sta location_address
  lda locations_hi,x
  sta location_address+1

  ;first check to see if it is locked
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::flags
  lda (location_address),y
  and #LOCATION_FLAGS_IS_LOCKED_TEST
  beq location_not_locked

  ;this location is locked, test to see if the hero has a key
  lda hero_flags
  and #HERO_FLAGS_HAS_KEY_TEST
  ;if the hero has key, continue to load the location
  bne hero_has_key

  ;if the hero does not have a key, we start a conversation
  ;saying the door is locked
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_door_is_locked
  sta state_control_params+play_state_control::param

  jmp play_state_action_start_conversation

location_not_locked:
hero_has_key:

  ;play associated sound effect with this location
  switch_bank_ldy #LOCATIONS_BANK
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
  switch_bank_ldy #AREAS_BANK
  ldy #area::palette_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy map_bank
  jsr ppu_fade_out_palette

  ;now that we know the area, make sure the state control
  ;param is nop again
  lda #ACTION_NOP
  sta state_control_params+play_state_control::action
  lda #0
  sta state_control_params+play_state_control::param

  jmp play_state_load_location

;****************************************************************
;This action handler starts displaying a conversation in a text
;box near the bottom of the screen. It first calls a routine to
;align the camera to a metatile boundary so that the textbox can
;be drawn to the nametable and be lined up correctly. Then it
;draws the textbox and runs the conversation script (specified
;by the play state control param, loaded by an NPC or other
;entity). Finally it erases the textbox and returns to the play
;state.
;****************************************************************
play_state_action_start_conversation:

  jsr align_camera_to_metatile_boundary

  jsr align_entities_if_occluded_by_textbox

  wait_vblank_data_ready

  jsr sprite_clear_all

  jsr entity_draw_all

  lda #TEXTBOX_SCREEN_Y
  sta b0
  jsr sprite_hide_all_below

  set_vblank_data_ready

  jsr draw_textbox

  ;when an NPC starts a conversation, the NPC specifies the index of a
  ;conversation to load, load it here.
  ldx state_control_params+play_state_control::param
  lda conversations_lo,x
  sta w0
  lda conversations_hi,x
  sta w0+1
  jsr run_conversation

  jsr erase_textbox

  ;the user has finished advancing through the conversation, make
  ;sure the play state control action is a nop as we return to the
  ;regular play state.
  lda #ACTION_NOP
  sta state_control_params+play_state_control::action
  lda #0
  sta state_control_params+play_state_control::param

  jmp play_state

;decrements camera x and y coordinates, updates map rows and columns and
;waits for the vblank data ready flag each frame until the camera is aligned
;on a metatile boundary. This is used by the conversation engine to align the
;map to a metatile boundary so the textbox is lined up on the screen perfectly.
.proc align_camera_to_metatile_boundary

  .scope
  lda camera_x
  and #%00001000
  beq keep_decrementing_camera_x
keep_incrementing_camera_x:
  wait_vblank_data_ready

  lda camera_x
  and #%00001111
  beq done

  jsr sprite_clear_all

  lda #1
  sta b0
  jsr increment_camera_x

  jsr decode_map_column

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  set_vblank_data_ready

  jmp keep_incrementing_camera_x

  jmp done

keep_decrementing_camera_x:
  wait_vblank_data_ready

  lda camera_x
  and #%00001111
  beq done

  jsr sprite_clear_all

  lda #1
  sta b0
  jsr decrement_camera_x

  jsr decode_map_column

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  set_vblank_data_ready

  jmp keep_decrementing_camera_x
done:
  .endscope

  .scope
  lda camera_y
  and #%00001000
  beq keep_decrementing_camera_y
keep_incrementing_camera_y:
  wait_vblank_data_ready

  lda camera_y
  and #%00001111
  beq done

  jsr sprite_clear_all

  lda #1
  sta b0
  jsr increment_camera_y

  jsr decode_map_row

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  set_vblank_data_ready

  jmp keep_incrementing_camera_y
keep_decrementing_camera_y:
  wait_vblank_data_ready

  lda camera_y
  and #%00001111
  beq done

  jsr sprite_clear_all

  lda #1
  sta b0
  jsr decrement_camera_y

  jsr decode_map_row

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  set_vblank_data_ready

  jmp keep_decrementing_camera_y
done:
  .endscope

  rts

decode_map_row:

  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  switch_bank_ldy map_bank
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready

  rts

decode_map_column:

  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  switch_bank_ldy map_bank
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  rts

.endproc

;This routine uses the map decoding system to fill the screen
;at a given location. This is used while loading a new location
;with the palette faded out.
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

;This is an alternative routine for filling the screen. We
;proably won't need to keep both of these so we can discard it
;eventually.
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
