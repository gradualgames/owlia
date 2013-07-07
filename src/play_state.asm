.linecont +
.include "main.inc"
.include "play_state.inc"
.include "inventory_state.inc"
.include "title_state.inc"
.include "game_over_state.inc"
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
sprite_chr_groups_address = w4
chr_amount = w2
chr_offset = b3
sprite_chr_groups_index = b0

  ;start tile accumulator (modified by ppu_load_chr_amount)
  lda #$00
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

  switch_bank_ldy #AREAS_BANK
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

  jsr ppu_load_chr_amount

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

  dec entities_params_count
  beq no_more_params

  iny
  lda (entities_address),y
  sta entity_local6,x

  dec entities_params_count
  beq no_more_params

  iny
  lda (entities_address),y
  sta entity_local7,x

  dec entities_params_count
  beq no_more_params

  iny
  lda (entities_address),y
  sta entity_local8,x

  dec entities_params_count
  beq no_more_params

  iny
  lda (entities_address),y
  sta entity_local9,x

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

  .scope
  ldy #location::flags
  lda (location_address),y
  and #LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_TEST
  bne disable_x_scrolling
enable_x_scrolling:
  lda #1
  sta camera_x_scrolling_enabled
  jmp done
disable_x_scrolling:
  lda #0
  sta camera_x_scrolling_enabled
done:
  .endscope

  .scope
  lda (location_address),y
  and #LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_TEST
  bne disable_y_scrolling
enable_y_scrolling:
  lda #1
  sta camera_y_scrolling_enabled
  jmp done
disable_y_scrolling:
  lda #0
  sta camera_y_scrolling_enabled
done:
  .endscope

  rts

.endproc

;a list of action handlers for the play state. This
;must exactly reflect the actions enum in actions.inc.
;Note that some actions are never handled by the play
;state, such as ACTION_CARRY_TO. This action only affects
;the player and familiar entities. For these actions, the
;play_state_action_nop handler is specified (but it should
;never get called anyway)
.define play_state_action_handlers \
  play_state_action_nop, \
  play_state_action_goto_location_group1, \
  play_state_action_start_conversation, \
  play_state_action_nop, \
  play_state_action_game_over

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

  ;****************************************************************
  ;Setup bank numbers for different types of data
  ;****************************************************************
  switch_bank_ldy #AREAS_BANK
  ldy #area::music_bank
  lda (area_address),y
  sta music_bank

  ldy #area::map_bank
  lda (area_address),y
  sta map_bank

  ldy #area::bg_chr_bank
  lda (area_address),y
  sta bg_chr_bank

  ldy #area::conversations_bank
  lda (area_address),y
  sta conversations_bank

  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::entity_set_address
  lda (location_address),y
  sta entity_set_address
  iny
  lda (location_address),y
  sta entity_set_address+1

  ldy #entity_set::entities_bank
  lda (entity_set_address),y
  sta entities_bank

  ldy #entity_set::sprites_and_animations_bank
  lda (entity_set_address),y
  sta sprites_and_animations_bank

  ldy #entity_set::sprite_chr_bank
  lda (entity_set_address),y
  sta sprite_chr_bank

  ;load other variables we need
  ldy #area::textbox_attribute
  lda (area_address),y
  sta textbox_attribute

  ;****************************************************************
  ;Turn off graphics and then load all CHR data for this area.
  ;Graphics will be off while we load everything: chr data for bg
  ;and sprites, loading a full screen of the current area and
  ;location, and running all entity update logic for a single frame
  ;so everything is in the correct initial state before turning
  ;graphics back on and fading in the current palette. This allows
  ;us to call ppu upload routines without relying on the vblank
  ;interrupt, greatly speeding up load times for locations and
  ;state transitions (such as to the inventory screen)
  ;****************************************************************
  jsr ppu_safely_disable_graphics

  lda #$00
  sta $2006
  sta $2006

  ;begin chr tile accumulator at 0
  lda #$00
  sta b3

  ldy #area::bg_chr_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy bg_chr_bank
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

  lda #$10
  sta $2006
  lda #$00
  sta $2006

  switch_bank_ldy #LOCATIONS_BANK
  lda entity_set_address
  adc #entity_set::sprite_chr_groups
  sta w4
  lda entity_set_address+1
  adc #$00
  sta w4+1
  jsr load_sprite_chr_groups

  ;load the shadow spot graphic; this is always present so it is
  ;hard coded
  lda b3
  sta shadow_spot_chr_offset

  lda #<ShadowSpot_chr
  sta w0
  lda #>ShadowSpot_chr
  sta w0+1
  switch_bank_ldy #SHADOWSPOT_SPR_CHR_BANK
  jsr ppu_load_chr_amount

  ;****************************************************************
  ;Load all map addresses
  ;****************************************************************
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

  ;****************************************************************
  ;Fill the nametable with graphics from the newly loaded area,
  ;at the current location
  ;****************************************************************
  jsr load_area_camera_vars

  switch_bank_ldy map_bank
  jsr map_decode_full_screen

  ;****************************************************************
  ;Initialize hard coded hero and familiar entities as well as
  ;all non-hard coded entities resident in this area
  ;****************************************************************
  jsr entity_init_all

  ;initialize the hero entity
  lda #HERO_STATE_INIT
  sta hero_state

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
  lda #$00
  sta familiar_flags

  ;spawn all non-hero entities in area
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::entity_instances_address
  lda (location_address),y
  sta w3
  iny
  lda (location_address),y
  sta w3+1

  jsr spawn_entities

  ;****************************************************************
  ;Run all frame logic for a single frame except taking user input
  ;to get all entities onscreen before fading in
  ;****************************************************************
  .scope execute_single_frame
  wait_vblank_flag

  jsr sprite_clear_all

  jsr entity_clear_shadow_spots

  jsr entity_update_all

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  jsr entity_draw_shadow_spots

  jsr hero_draw_status

  set_vblank_flag
  .endscope

  ;****************************************************************
  ;Load song for the current area if different from the already
  ;playing song
  ;****************************************************************
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

  ;****************************************************************
  ;Now that all graphics are loaded safely, we can turn graphics
  ;back on, fade in the palette gracefully, set the vblank routine
  ;to the main play state nmi routine, and transfer control to
  ;the play state
  ;****************************************************************
  jsr ppu_safely_enable_graphics

  ;retrieve brightness level from current location
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::flags
  lda (location_address),y
  and #LOCATION_FLAGS_BRIGHTNESS_LEVEL_ISOLATE
  lsr
  lsr
  sta b4

  ;always fade in to max for sprites
  lda #MAX_BRIGHTNESS_LEVEL
  sta b5

  ;fade in to current palette
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::palette_address
  lda (location_address),y
  sta palette_address
  iny
  lda (location_address),y
  sta palette_address+1
  jsr ppu_fade_in_palette

  ;initialize vblank routine
  lda #0
  sta vblank_wait_flag

  lda #0
  sta row_ready
  lda #0
  sta column_ready

  lda #1
  sta hide_graphics_top

  lda #<nametable_and_attribute_update_ppu
  sta vblank_routine
  lda #>nametable_and_attribute_update_ppu
  sta vblank_routine+1

  lda #<sprite_partial_clear_all_graphics_hiding_routine
  sta graphics_hiding_routine
  lda #>sprite_partial_clear_all_graphics_hiding_routine
  sta graphics_hiding_routine+1

;****************************************************************
;This branch location is the main game loop. It handles map
;updates, entity updates, and hero and familiar updates. It also
;handles state transitions to other locations, inventory screen,
;store screen, etc. These transitions are usually triggered by
;an entity setting an action and param combination in the play
;state control params.
;****************************************************************
play_state:

  wait_vblank_flag

  jsr controller_indirect

  .ifdef CPU_USAGE
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  jsr sprite_partial_clear_all_remaining

  jsr entity_clear_shadow_spots

  jsr entity_update_all

  switch_bank_ldy #HERO_BANK
  jsr hero_eject_from_solid_tiles

  switch_bank_ldy map_bank
  jsr update_camera

  jsr entity_calculate_screen_coordinates_all

  ;make sure if the frame is running long that the sprite-clearing
  ;graphics hiding bar does not clear sprites for the next frame
  ;because they haven't been drawn yet.
  lda #1
  sta forward_to_default_graphics_hiding_routine

  jsr entity_draw_all

  jsr entity_draw_shadow_spots

  jsr hero_draw_status

  lda #0
  sta forward_to_default_graphics_hiding_routine

  .ifdef CPU_USAGE
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  set_vblank_flag

  ;switchboard for controlling the play state logic
  lda state_control_params+play_state_control::action
  tay
  lda play_state_action_handlers_lo,y
  sta w0
  lda play_state_action_handlers_hi,y
  sta w0+1
  jmp (w0)
play_state_action_nop:

  ;test controller for system logic that entities never
  ;need to care about such as the inventory state.
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq transition_to_inventory_state

  jmp play_state

;****************************************************************
;This branch location is a sub-state of the play state intended
;to prepare for and transition to the inventory state. The
;inventory state is in a separate source file to help remove
;clutter from the play state.
;****************************************************************
transition_to_inventory_state:

  ;Switch out the graphics hiding routine so that sprites are not
  ;prematurely removed before a palette fade out. See sprite.asm
  ;and sprite_partial_clear_all_graphics_hiding_routine for an
  ;explanation.
  lda #<default_graphics_hiding_routine
  sta graphics_hiding_routine
  lda #>default_graphics_hiding_routine
  sta graphics_hiding_routine+1

  jmp inventory_state_init

;****************************************************************
;This branch location is a sub-state of the play state intended
;to prepare for and transition to the game over state. It plays
;a game over sound, changes the palette to black, erases all
;entities, spins Adlanniel in place, shows an explosion animation
;and sound, and then transitions to the game over state.
;****************************************************************
play_state_action_game_over:

  ;Switch out the graphics hiding routine so that sprites are not
  ;prematurely removed before a palette fade out. See sprite.asm
  ;and sprite_partial_clear_all_graphics_hiding_routine for an
  ;explanation.
  lda #<default_graphics_hiding_routine
  sta graphics_hiding_routine
  lda #>default_graphics_hiding_routine
  sta graphics_hiding_routine+1

  ;pause a few frames
  ldx #4
: set_vblank_flag
  wait_vblank_flag
  dex
  bne :-

  ;play game over song
  jsr sound_stop
  lda #<game_over
  sta song_address
  lda #>game_over
  sta song_address+1
  switch_bank_ldy music_bank
  jsr song_initialize

  ;spin the hero around a few times
  .scope
  ldy #28
spin_hero_loop:
  wait_vblank_flag
  tya
  pha
  jsr hero_turn_clockwise
  jsr hero_face_in_current_direction
  jsr sprite_clear_all
  jsr hero_draw
  pla
  tay

  ;pause a few frames
  ldx #4
: set_vblank_flag
  wait_vblank_flag
  dex
  bne :-

  dey
  bne spin_hero_loop
  .endscope

  ;kill all entities that are currently alive
  jsr entity_init_all

  ;spawn an explosion entity at hero's location
  lda #entity_index_explosion
  sta b0

  lda hero_x
  sta w0
  lda hero_x+1
  sta w0+1
  lda hero_y
  sta w1
  lda hero_y+1
  sta w1+1

  jsr entity_spawn

  ;execute a few frames, doing nothing but updating non-player entities
  ;(the explosion entity we just spawned) and drawing non-player entities.
  ldy #32
: wait_vblank_flag

  tya
  pha
  jsr sprite_clear_all

  jsr entity_update_npe

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_npe
  pla
  tay

  set_vblank_flag
  dey
  bne :-

  ;fade out from current palette
  switch_bank_ldy #LOCATIONS_BANK
  jsr ppu_fade_out_palette

  jmp game_over_state_init

;****************************************************************
;This branch location is a sub-state of the play state intended
;to re-load graphics after coming back from the inventory state.
;****************************************************************
play_state_reload:

  ;Disable graphics while we re-load everything
  jsr ppu_safely_disable_graphics

  lda #$00
  sta $2006
  sta $2006

  ;start tile accumulator
  lda #$00
  sta b3
  sta b3+1

  switch_bank_ldy #AREAS_BANK
  ldy #area::bg_chr_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy bg_chr_bank
  jsr ppu_load_chr_amount

  ;b3 should now be the correct offset for the textbox and font graphics
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

  lda #$10
  sta $2006
  lda #$00
  sta $2006

  switch_bank_ldy #LOCATIONS_BANK
  lda entity_set_address
  adc #entity_set::sprite_chr_groups
  sta w4
  lda entity_set_address+1
  adc #$00
  sta w4+1
  jsr load_sprite_chr_groups

  ;save camera variables
  lda camera_x
  pha
  lda camera_x+1
  pha
  lda camera_y
  pha
  lda camera_y+1
  pha

  ;reload current location
  switch_bank_ldy map_bank
  jsr map_decode_full_screen

  ;restore camera
  pla
  sta camera_y+1
  pla
  sta camera_y
  pla
  sta camera_x+1
  pla
  sta camera_x

  ;calculate nametable hi-byte from camera variables
  .scope
  lda camera_x+1
  and #$01
  beq even
odd:
  lda #$24
  sta camera_nametable_hibyte
  jmp done
even:
  lda #$20
  sta camera_nametable_hibyte
done:
  .endscope

  ;execute a single frame to get entities onscreen before palette fade in and music
  .scope
  wait_vblank_flag

  jsr sprite_clear_all

  jsr entity_clear_shadow_spots

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  jsr entity_draw_shadow_spots

  jsr hero_draw_status

  set_vblank_flag
  .endscope

  jsr ppu_safely_enable_graphics

  ;retrieve brightness level from current location
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::flags
  lda (location_address),y
  and #LOCATION_FLAGS_BRIGHTNESS_LEVEL_ISOLATE
  lsr
  lsr
  sta b4

  ;always fade in to max for sprites
  lda #MAX_BRIGHTNESS_LEVEL
  sta b5

  ;fade in to current palette
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::palette_address
  lda (location_address),y
  sta palette_address
  iny
  lda (location_address),y
  sta palette_address+1
  jsr ppu_fade_in_palette

  ;initialize vblank routine
  lda #0
  sta vblank_wait_flag

  lda #0
  sta row_ready
  lda #0
  sta column_ready

  lda #1
  sta hide_graphics_top

  lda #<nametable_and_attribute_update_ppu
  sta vblank_routine
  lda #>nametable_and_attribute_update_ppu
  sta vblank_routine+1

  lda #<sprite_partial_clear_all_graphics_hiding_routine
  sta graphics_hiding_routine
  lda #>sprite_partial_clear_all_graphics_hiding_routine
  sta graphics_hiding_routine+1

  ;make sure current action of play state is a no-op
  lda #ACTION_NOP
  sta state_control_params+play_state_control::action
  lda #0
  sta state_control_params+play_state_control::param

  jmp play_state

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

  ;Switch out the graphics hiding routine so that sprites are not
  ;prematurely removed before a palette fade out. See sprite.asm
  ;and sprite_partial_clear_all_graphics_hiding_routine for an
  ;explanation.
  lda #<default_graphics_hiding_routine
  sta graphics_hiding_routine
  lda #>default_graphics_hiding_routine
  sta graphics_hiding_routine+1

  ;now wait for the current frame to finish so all sprites are in
  ;the correct location
  wait_vblank_flag

  ;load the location to transition to
  ldx state_control_params+play_state_control::param
  lda locations_lo,x
  sta location_address
  lda locations_hi,x
  sta location_address+1

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
  switch_bank_ldy #LOCATIONS_BANK
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

  ;Switch out the graphics hiding routine so that sprites are not
  ;prematurely removed before a palette fade out. See sprite.asm
  ;and sprite_partial_clear_all_graphics_hiding_routine for an
  ;explanation.
  lda #<default_graphics_hiding_routine
  sta graphics_hiding_routine
  lda #>default_graphics_hiding_routine
  sta graphics_hiding_routine+1

  jsr align_camera_to_metatile_boundary

  jsr align_entities_if_occluded_by_textbox

  wait_vblank_flag

  jsr sprite_clear_all

  jsr entity_draw_all

  jsr entity_only_draw_shadow_spots

  jsr hero_draw_status

  lda #TEXTBOX_SCREEN_SPRITE_OCCLUDE_Y
  sta b0
  jsr sprite_hide_all_below

  set_vblank_flag

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

  lda #<sprite_partial_clear_all_graphics_hiding_routine
  sta graphics_hiding_routine
  lda #>sprite_partial_clear_all_graphics_hiding_routine
  sta graphics_hiding_routine+1

  ;make sure the controller buffer is cleared out. It is possible an entity
  ;such as the innkeep will want it to be clear at this point.
  jsr controller_clear

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
  wait_vblank_flag

  lda camera_x
  and #%00001111
  beq done

  jsr sprite_clear_all

  lda #1
  sta b0
  jsr increment_camera_x

  .scope
  lda #<(-1)
  sta w0
  lda #>(-1)
  sta w0+1
  lda #0
  sta w1
  sta w1+1

  jsr entity_slide_shadow_spots
  .endscope

  jsr decode_map_column_right

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  jsr entity_only_draw_shadow_spots

  jsr hero_draw_status

  set_vblank_flag

  jmp keep_incrementing_camera_x

  jmp done

keep_decrementing_camera_x:
  wait_vblank_flag

  lda camera_x
  and #%00001111
  beq done

  jsr sprite_clear_all

  lda #1
  sta b0
  jsr decrement_camera_x

  .scope
  lda #<(1)
  sta w0
  lda #>(1)
  sta w0+1
  lda #0
  sta w1
  sta w1+1

  jsr entity_slide_shadow_spots
  .endscope

  jsr decode_map_column_left

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  jsr entity_only_draw_shadow_spots

  jsr hero_draw_status

  set_vblank_flag

  jmp keep_decrementing_camera_x
done:
  .endscope

  .scope
  lda camera_y
  and #%00001000
  beq keep_decrementing_camera_y
keep_incrementing_camera_y:
  wait_vblank_flag

  lda camera_y
  and #%00001111
  beq done

  jsr sprite_clear_all

  lda #1
  sta b0
  jsr increment_camera_y

  .scope
  lda #0
  sta w0
  sta w0+1
  lda #<(-1)
  sta w1
  lda #>(-1)
  sta w1+1

  jsr entity_slide_shadow_spots
  .endscope

  jsr decode_map_row_bottom

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  jsr entity_only_draw_shadow_spots

  jsr hero_draw_status

  set_vblank_flag

  jmp keep_incrementing_camera_y
keep_decrementing_camera_y:
  wait_vblank_flag

  lda camera_y
  and #%00001111
  beq done

  jsr sprite_clear_all

  lda #1
  sta b0
  jsr decrement_camera_y

  .scope
  lda #0
  sta w0
  sta w0+1
  lda #<(1)
  sta w1
  lda #>(1)
  sta w1+1

  jsr entity_slide_shadow_spots
  .endscope

  jsr decode_map_row_top

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  jsr entity_only_draw_shadow_spots

  jsr hero_draw_status

  set_vblank_flag

  jmp keep_decrementing_camera_y
done:
  .endscope

  rts

decode_map_row_top:

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

decode_map_row_bottom:

  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  clc
  lda camera_y
  adc #224
  sta w1
  lda camera_y+1
  adc #$00
  sta w1+1
  switch_bank_ldy map_bank
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready

  rts

decode_map_column_left:

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

decode_map_column_right:

  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$01
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

;This routine fills the whole screen starting at the current
;camera location. It starts slightly higher than the camera
;to get any rows which might be partially scrolled off of the
;screen. Also, it calls the ppu upload routines without synchronizing
;with vblank. This routine ASSUMES THAT GRAPHICS ARE OFF. This allows
;us to load a full screen much more quickly.
.proc map_decode_full_screen

  ;start loading full screen at present camera location
  lda camera_x
  sta w0

  lda camera_x+1
  sta w0+1

  ;start one row higher than the camera in case the location is not
  ;aligned to 16 pixel boundaries (this ensures the attribute table
  ;will be correct when coming back from the inventory state)
  sec
  lda camera_y
  sbc #$08
  sta w1
  lda camera_y+1
  sbc #$00
  sta w1+1

  lda #30
  sta b0

  ;make sure we never upload columns, we're using rows here!
  lda #0
  sta column_ready

fill_nametable_loop:
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

  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  jsr nametable_and_attribute_update_ppu_direct

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

  dec b0
  bne fill_nametable_loop

  rts

.endproc
