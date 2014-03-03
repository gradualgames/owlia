.linecont +
.include "ndxdebug.h"
.include "main.inc"
.include "cut_scene_state.inc"
.include "slide_data.inc"
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
.include "monolith_constants.inc"
.include "textbox.inc"
.include "conversation_data.inc"

.segment "CODE"

;This LUT can be used to determine the opposite direction
;from which we are scrolling to a new location (probably in
;a single screen dungeon environment). This is needed for
;searching for monoliths that may be in the hero's way.
scroll_direction_opposite:
  .byte SCROLL_DIRECTION_WEST
  .byte SCROLL_DIRECTION_EAST
  .byte SCROLL_DIRECTION_NORTH
  .byte SCROLL_DIRECTION_SOUTH

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

;This routine loads all chr data for bg and sprites for the
;current location. It is used from both play_state_load_location
;and play_state_reload.
.proc load_chr_data

  lda #$00
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

  ;begin chr tile accumulator at 0
  lda #$00
  sta b3

  jsr load_bg_chr_groups

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
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  switch_bank_ldy #LOCATIONS_BANK
  lda entity_set_address
  sta w4
  lda entity_set_address+1
  sta w4+1
  jsr load_sprite_chr_groups

  ;individually load graphics for currently selected techs 1 and 2.
  ;compute the correct sprite_chr_group_index relative to
  ;sprite_chr_group_index_rushtech.
  lda b3
  sta tech1_chr_offset

  clc
  lda #sprite_chr_group_index_rushtech
  adc inventory_tech1
  tax
  lda sprite_chr_group_addresses_lo,x
  sta w0
  lda sprite_chr_group_addresses_hi,x
  sta w0+1
  ldy sprite_chr_group_bank,x
  switch_bank_y
  jsr ppu_load_chr_amount

  lda b3
  sta tech2_chr_offset

  clc
  lda #sprite_chr_group_index_rushtech
  adc inventory_tech2
  tax
  lda sprite_chr_group_addresses_lo,x
  sta w0
  lda sprite_chr_group_addresses_hi,x
  sta w0+1
  ldy sprite_chr_group_bank,x
  switch_bank_y
  jsr ppu_load_chr_amount

  ;load the shadow spot graphic; this is always present so it is
  ;hard coded
  lda b3
  sta shadow_spot_chr_offset

  ldx #sprite_chr_group_index_shadowspot
  lda sprite_chr_group_addresses_lo,x
  sta w0
  lda sprite_chr_group_addresses_hi,x
  sta w0+1
  ldy sprite_chr_group_bank,x
  switch_bank_y
  jsr ppu_load_chr_amount

  rts

.endproc

;this routine loads all bg chr groups for the current area.
.proc load_bg_chr_groups
count = b0
index = b1

  ;make sure we're in the areas bank
  switch_bank_ldy #AREAS_BANK
  ;load address of bg chr groups
  ldy #area::bg_chr_groups
  sty index
  lda (area_address),y
  sta w4
  iny
  lda (area_address),y
  sta w4+1

  ;load count
  ldy #0
  sty index
  lda (w4),y
  sta count
next_bg_chr_group:
  ;make sure we're in the areas bank
  switch_bank_ldy #AREAS_BANK

  ;load bank number of this bg chr group
  ldy index
  iny
  lda (w4),y
  tax

  ;load address of this bg chr group
  iny
  lda (w4),y
  sta w0
  iny
  lda (w4),y
  sta w0+1

  sty index

  switch_bank_x
  jsr ppu_load_chr_amount

  dec count
  bne next_bg_chr_group

  rts
.endproc

;this routine loads all sprite chr groups for the current location, which
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

  ;get count for number of entity types in this location
  switch_bank_ldy #LOCATIONS_BANK
  ldy #0
  lda (sprite_chr_groups_address),y
  ;put it in x for counting
  tax

  ;point at the first entry in the entity types array
  iny
  sty sprite_chr_groups_index

next_entity_type:

  ;get next entity type index
  switch_bank_ldy #LOCATIONS_BANK
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

  ;switch to the bank that this chunk of chr data resides in
  lda sprite_chr_group_bank,y
  tay
  switch_bank_y

  jsr ppu_load_chr_amount

  inc sprite_chr_groups_index

  dex
  bne next_entity_type

  rts

.endproc

;this routine spawns all entities for a given location.
.proc spawn_entities
entities_address = w3
entities_index = b1
entities_count = b2
entities_params_count = b3

  switch_bank_ldy #LOCATIONS_BANK

  ;get count for number of entity instances in this location
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
  play_state_action_scrollto_location_group1, \
  play_state_action_start_conversation, \
  play_state_action_nop, \
  play_state_action_game_over, \
  play_state_action_cut_scene

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
  switch_bank_ldy #AREAS_BANK
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

  jsr load_chr_data

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
  ;Make sure dynamic single screen collision field is clear.
  ;****************************************************************
  jsr clear_dynamic_single_screen_collision_field

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
  jsr frame_update_no_controller_input

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

  ;turn on graphics hiding bar at top
  lda #1
  sta hide_graphics_top

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
  sta row_ready
  lda #0
  sta column_ready

  safely_set_vblank_routine nametable_and_attribute_update_ppu

;****************************************************************
;This branch location is the main game loop. It handles map
;updates, entity updates, and hero and familiar updates. It also
;handles state transitions to other locations, inventory screen,
;store screen, etc. These transitions are usually triggered by
;an entity setting an action and param combination in the play
;state control params.
;****************************************************************
play_state:

  jsr frame_update_controller_input

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

  clear_vblank_done
  wait_vblank_done

  switch_bank_ldy #INVENTORY_STATE_BANK
  jmp inventory_state_init

;****************************************************************
;This branch location is a sub-state of the play state intended
;to prepare for and transition to the game over state. It plays
;a game over sound, changes the palette to black, erases all
;entities, spins Adlanniel in place, shows an explosion animation
;and sound, and then transitions to the game over state.
;****************************************************************
play_state_action_game_over:

  ;pause a few frames
  ldx #4
: clear_vblank_done
  wait_vblank_done
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
  clear_vblank_done
  wait_vblank_done
  tya
  pha
  switch_bank_ldy #HERO_BANK
  jsr hero_turn_clockwise
  jsr hero_face_in_current_direction
  jsr sprite_clear_all
  jsr hero_draw
  pla
  tay

  ;pause a few frames
  ldx #4
: clear_vblank_done
  wait_vblank_done
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
: clear_vblank_done
  wait_vblank_done

  tya
  pha
  jsr sprite_clear_all

  jsr entity_update_npe

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_npe
  pla
  tay

  dey
  bne :-

  ;fade out from current palette
  switch_bank_ldy #LOCATIONS_BANK
  jsr ppu_fade_out_palette

  jmp game_over_state_init

;****************************************************************
;This branch location is a sub-state of the play state intended
;to prepare for and transition to the cut scene state.
;****************************************************************
play_state_action_cut_scene:

  ;fade out from current palette
  switch_bank_ldy #LOCATIONS_BANK
  jsr ppu_fade_out_palette

  ;transfer address param from ACTION_PLAY_CUT_SCENE action
  ;using the stack, since state_control_params is a union and
  ;we want to guarantee putting data in the right locations
  lda state_control_params+play_state_control::param
  pha
  lda state_control_params+play_state_control::param+1
  pha

  pla
  sta state_control_params+cut_scene_state_control::slide_address+1
  pla
  sta state_control_params+cut_scene_state_control::slide_address

  jmp play_cut_scene

;****************************************************************
;This branch location is a sub-state of the play state intended
;to re-load graphics after coming back from the inventory state.
;****************************************************************
play_state_reload:

  ;Disable graphics while we re-load everything
  jsr ppu_safely_disable_graphics

  jsr load_chr_data

  .scope
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::flags
  lda (location_address),y
  and #(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_TEST | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_TEST)
  cmp #(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_TEST | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_TEST)
  bne decode_full_screen

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

  jmp done
decode_full_screen:
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
done:
  .endscope

  ;execute a single frame to get entities onscreen before palette fade in and music
  jsr frame_update_no_controller_input

  jsr ppu_safely_enable_graphics

  ;turn on graphics hiding bar at top
  lda #1
  sta hide_graphics_top

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
  sta row_ready
  lda #0
  sta column_ready

  lda #1
  sta hide_graphics_top

  safely_set_vblank_routine nametable_and_attribute_update_ppu

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

  ;now wait for the current frame to finish so all sprites are in
  ;the correct location
  clear_vblank_done
  wait_vblank_done

  ;load the location to transition to
  ldx state_control_params+play_state_control::param
  switch_bank_ldy #LOCATIONS_BANK
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
  switch_bank_ldy #LOCATIONS_BANK
  jsr ppu_fade_out_palette

  ;now that we know the location, make sure the state control
  ;param is nop again
  lda #ACTION_NOP
  sta state_control_params+play_state_control::action
  lda #0
  sta state_control_params+play_state_control::param

  jmp play_state_load_location

;****************************************************************
;This action handler scrolls to the location specified by the
;action param. It assumes that the entity set specified by the
;new location is the same as the old location. It marks all enti-
;ties in the current location as "marked for kill," then spawns
;all entities in the new location, then scrolls by X and then by
;Y to the new location, then kills all "marked for kill"
;entities. Finally, it moves the hero to the position specified
;by the new location.
;****************************************************************
play_state_action_scrollto_location_group1:

  ;mark all currently living entities to be killed after we scroll
  jsr entity_mark_all_for_kill

  ;load the new location address and spawn the entities from it,
  ;assuming the entity set has not changed.
  ldx state_control_params+play_state_control::param
  switch_bank_ldy #LOCATIONS_BANK
  lda locations_lo,x
  sta location_address
  lda locations_hi,x
  sta location_address+1

  ;spawn all non-hero entities in new location
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
  ;to get all entities onscreen
  ;****************************************************************
  jsr frame_update_no_controller_input

  ;now scroll to the new location
  jsr scroll_to_new_location

  jsr entity_kill_all_marked_for_kill

  ;now search for monoliths that may be in the hero's way configured
  ;for the opposite direction that had been passed into this action
  ;handler.
  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq not_alive
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith

  ;found a monolith. Test to see if its direction is opposite to the
  ;direction that was passed into the scrollto action handler.
  ldx monolith_direction,y
  lda scroll_direction_opposite,x
  cmp state_control_params+play_state_control::param+1
  bne not_opposite_direction

  ;here, we have found a monolith whose direction is opposite to that
  ;in which we scrolled. Now we want to test if it is currently up. If
  ;it is, we need to initialize its falling state, and then update its
  ;state until it is done falling.
  sty state_control_params+play_state_control::monolith_index

  ;turn off this monolith's exit detection until we re-raise it later.
  lda monolith_flags,y
  and #MONOLITH_FLAGS_EXIT_DISABLED_CLEAR
  sta monolith_flags,y

  lda monolith_flags,y
  and #MONOLITH_FLAGS_UP_OR_DOWN_ISOLATE
  beq done

  ;We found a monolith in the hero's way. Tell it to start falling,
  ;and then execute enough frames to allow it to fall all the way
  ;down.
  lda #MONOLITH_STATE_FALL_USING_COLUMNS_INIT
  sta entity_state,y

  ;take over the controller. Once we animate any monoliths in the hero's
  ;way, we will move the hero into the position specified by the new
  ;location.
  jsr controller_clear
  lda #<controller_nop
  sta controller_routine
  lda #>controller_nop
  sta controller_routine+1

  .scope
  lda #20
  sta b10

: lda b10
  pha

  jsr frame_update_no_controller_input

  pla
  sta b10
  dec b10
  bne :-
  .endscope

  jmp done

not_opposite_direction:
not_alive:
not_monolith:
  dey
  bpl next_entity
done:
  .endscope

  ;based on the direction passed into the scrollto action handler,
  ;move the hero until she matches the newly loaded location.
  .scope
  lda state_control_params+play_state_control::param+1
  cmp #SCROLL_DIRECTION_EAST
  beq walk_east
  cmp #SCROLL_DIRECTION_WEST
  beq walk_west
  cmp #SCROLL_DIRECTION_NORTH
  beq walk_north
  cmp #SCROLL_DIRECTION_SOUTH
  beq walk_south
walk_east:
  jsr walk_east_impl
  jmp done
walk_west:
  jsr walk_west_impl
  jmp done
walk_north:
  jsr walk_north_impl
  jmp done
walk_south:
  jsr walk_south_impl
  jmp done
done:
  .endscope

  ;restore control to the player
  lda #$ff
  jsr controller_fill_buffer_with_accumulator
  lda #<controller_read
  sta controller_routine
  lda #>controller_read
  sta controller_routine+1

  ;now that we know the location, make sure the state control
  ;param is nop again
  lda #ACTION_NOP
  sta state_control_params+play_state_control::action
  lda #0
  sta state_control_params+play_state_control::param

  jmp play_state

.proc walk_east_impl

  lda #1
  sta buffer_controller+buttons::_right

  .scope
: jsr frame_update_no_controller_input

  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::hero_start_x
  lda (location_address),y
  cmp hero_x
  bne not_equal
  iny
  lda (location_address),y
  cmp hero_x+1
  bne not_equal

  jmp done

not_equal:
  jmp :-
done:
  .endscope

  jsr controller_clear

  jsr reraise_monolith

  rts

.endproc

.proc walk_west_impl

  lda #1
  sta buffer_controller+buttons::_left

  .scope
: jsr frame_update_no_controller_input

  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::hero_start_x
  lda (location_address),y
  cmp hero_x
  bne not_equal
  iny
  lda (location_address),y
  cmp hero_x+1
  bne not_equal

  jmp done

not_equal:
  jmp :-
done:
  .endscope

  jsr controller_clear

  jsr reraise_monolith

  rts

.endproc

;makes the hero walk north until she matches the newly loaded
;location.
.proc walk_north_impl

  lda #1
  sta buffer_controller+buttons::_up

  .scope
: jsr frame_update_no_controller_input

  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::hero_start_y
  lda (location_address),y
  cmp hero_y
  bne not_equal
  iny
  lda (location_address),y
  cmp hero_y+1
  bne not_equal

  jmp done

not_equal:
  jmp :-
done:
  .endscope

  jsr controller_clear

  jsr reraise_monolith

  rts

.endproc

;makes the hero walk south until she matches the newly loaded
;location.
.proc walk_south_impl

  lda #1
  sta buffer_controller+buttons::_down

  .scope
: jsr frame_update_no_controller_input

  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::hero_start_y
  lda (location_address),y
  cmp hero_y
  bne not_equal
  iny
  lda (location_address),y
  cmp hero_y+1
  bne not_equal

  jmp done

not_equal:
  jmp :-
done:
  .endscope

  jsr controller_clear

  jsr reraise_monolith

  rts

.endproc

.proc reraise_monolith

  ;now, tell the monolith we found earlier to start rising (if it was
  ;originally set as "up" and wait enough frames for it to rise all the way.
  .scope
  ldy state_control_params+play_state_control::monolith_index
  lda monolith_flags,y
  and #MONOLITH_FLAGS_UP_OR_DOWN_ISOLATE
  beq monolith_not_up

  lda #MONOLITH_STATE_RISE_USING_COLUMNS_INIT
  sta entity_state,y

  .scope
  lda #20
  sta b10

: lda b10
  pha

  jsr frame_update_no_controller_input

  pla
  sta b10
  dec b10
  bne :-
  .endscope

monolith_not_up:
  .endscope

  ldy state_control_params+play_state_control::monolith_index
  lda monolith_flags,y
  ora #MONOLITH_FLAGS_EXIT_ENABLED_SET
  sta monolith_flags,y

  rts

.endproc

;scrolls the camera vertically and then horizontally to align
;with the newly loaded location. This is used with dungeons
;and assumes that the state control params "param" member of
;play_state_control will have a second byte representing the
;direction to scroll in, passed in by a monolith entity and
;being one of four cardinal direction enum values specified
;in the monolith entity constants.
.proc scroll_to_new_location
SCROLL_SPEED = 4
scroll_counter = b10

  ;save old scrolling enable flags
  lda camera_x_scrolling_enabled
  pha
  lda camera_y_scrolling_enabled
  pha

  ;temporarily enable scrolling
  lda #1
  sta camera_x_scrolling_enabled
  sta camera_y_scrolling_enabled

  ;get direction that we were told to scroll in
  lda state_control_params+play_state_control::param+1
  cmp #SCROLL_DIRECTION_EAST
  beq scroll_east
  cmp #SCROLL_DIRECTION_WEST
  beq scroll_west
  cmp #SCROLL_DIRECTION_NORTH
  beq scroll_north
  cmp #SCROLL_DIRECTION_SOUTH
  beq scroll_south
scroll_east:
  jsr scroll_east_impl
  jmp done
scroll_west:
  jsr scroll_west_impl
  jmp done
scroll_north:
  jsr scroll_north_impl
  jmp done
scroll_south:
  jsr scroll_south_impl
  jmp done
done:

no_vertical_scroll:

  ;restore old scrolling enable flags
  pla
  sta camera_y_scrolling_enabled
  pla
  sta camera_x_scrolling_enabled

  rts

scroll_east_impl:

  lda #0
  sta scroll_counter

: clear_vblank_done
  wait_vblank_done

  lda scroll_counter
  pha

  lda #SCROLL_SPEED
  sta b0
  jsr increment_camera_x

  jsr decode_map_column_right

  jsr sprite_clear_all

  jsr draw_sprites

  pla
  sta scroll_counter

  clc
  lda scroll_counter
  adc #SCROLL_SPEED
  sta scroll_counter
  bne :-

  rts

scroll_west_impl:

  lda #0
  sta scroll_counter

: clear_vblank_done
  wait_vblank_done

  lda scroll_counter
  pha

  lda #SCROLL_SPEED
  sta b0
  jsr decrement_camera_x

  jsr decode_map_column_left

  jsr sprite_clear_all

  jsr draw_sprites

  pla
  sta scroll_counter

  clc
  lda scroll_counter
  adc #SCROLL_SPEED
  sta scroll_counter
  bne :-

  rts

scroll_north_impl:

  lda #240
  sta scroll_counter

: clear_vblank_done
  wait_vblank_done

  lda scroll_counter
  pha

  lda #SCROLL_SPEED
  sta b0
  jsr decrement_camera_y

  jsr decode_map_row_top

  jsr sprite_clear_all

  jsr draw_sprites

  pla
  sta scroll_counter

  sec
  lda scroll_counter
  sbc #SCROLL_SPEED
  sta scroll_counter
  bne :-

  rts

scroll_south_impl:

  lda #240
  sta scroll_counter

: clear_vblank_done
  wait_vblank_done

  lda scroll_counter
  pha

  lda #SCROLL_SPEED
  sta b0
  jsr increment_camera_y

  jsr decode_map_row_bottom

  jsr sprite_clear_all

  jsr draw_sprites

  pla
  sta scroll_counter

  sec
  lda scroll_counter
  sbc #SCROLL_SPEED
  sta scroll_counter
  bne :-

  rts

.endproc

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

  jsr sprite_clear_all

  jsr entity_draw_all

  jsr sprite_draw_shadow_spots

  jsr hero_draw_status

  lda #TEXTBOX_SCREEN_SPRITE_OCCLUDE_Y
  sta b0
  jsr sprite_hide_all_below

  clear_vblank_done
  wait_vblank_done

  lda #TEXTBOX_PLAY_STATE_ROW
  sta textbox_row

  switch_bank_ldy #TEXTBOX_BANK
  jsr draw_textbox

  ;save current controller routine
  lda controller_routine
  pha
  lda controller_routine+1
  pha

  ;install normal controller routine
  lda #<controller_read
  sta controller_routine
  lda #>controller_read
  sta controller_routine+1

  ;when an NPC starts a conversation, the NPC specifies the index of a
  ;conversation to load, load it here.
  ldx state_control_params+play_state_control::param
  lda conversations_lo,x
  sta w0
  lda conversations_hi,x
  sta w0+1
  jsr run_conversation

  ;restore old controller routine
  pla
  sta controller_routine+1
  pla
  sta controller_routine

  jsr erase_textbox

  ;make sure the controller buffer is cleared out. It is possible an entity
  ;such as the innkeep will want it to be clear at this point.
  lda #$ff
  jsr controller_fill_buffer_with_accumulator

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
  clear_vblank_done
  wait_vblank_done

  lda camera_x
  and #%00001111
  beq done

  lda #1
  sta b0
  jsr increment_camera_x

  jsr decode_map_column_right

  jsr sprite_clear_all
  jsr draw_sprites

  jmp keep_incrementing_camera_x

  jmp done

keep_decrementing_camera_x:
  clear_vblank_done
  wait_vblank_done

  lda camera_x
  and #%00001111
  beq done

  lda #1
  sta b0
  jsr decrement_camera_x

  jsr decode_map_column_left

  jsr sprite_clear_all
  jsr draw_sprites

  jmp keep_decrementing_camera_x
done:
  .endscope

  .scope
  lda camera_y
  and #%00001000
  beq keep_decrementing_camera_y
keep_incrementing_camera_y:
  clear_vblank_done
  wait_vblank_done

  lda camera_y
  and #%00001111
  beq done

  lda #1
  sta b0
  jsr increment_camera_y

  jsr decode_map_row_bottom

  jsr sprite_clear_all
  jsr draw_sprites

  jmp keep_incrementing_camera_y
keep_decrementing_camera_y:
  clear_vblank_done
  wait_vblank_done

  lda camera_y
  and #%00001111
  beq done

  lda #1
  sta b0
  jsr decrement_camera_y

  jsr decode_map_row_top

  jsr sprite_clear_all
  jsr draw_sprites

  jmp keep_decrementing_camera_y
done:
  .endscope

  rts

.endproc

.proc decode_map_row_top

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

.endproc

.proc decode_map_row_bottom

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

.endproc

.proc decode_map_column_left

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

.proc decode_map_column_right

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

.proc frame_update_controller_input

  clear_vblank_done
  wait_vblank_done

  jsr controller_indirect

  .ifdef CPU_USAGE
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  jsr sprite_reset_next_sprite_address

  jsr sprite_clear_shadow_spots

  jsr entity_update_all

  switch_bank_ldy map_bank
  jsr update_camera

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  jsr sprite_draw_shadow_spots

  jsr hero_draw_status

  jsr sprite_clear_all_remaining

  .ifdef CPU_USAGE
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  .endif

  rts

.endproc

.proc frame_update_no_controller_input

  clear_vblank_done
  wait_vblank_done

  jsr sprite_clear_all

  jsr sprite_clear_shadow_spots

  jsr entity_update_all

  jsr draw_sprites

  rts

.endproc

.proc draw_sprites

  jsr entity_calculate_screen_coordinates_all

  jsr entity_draw_all

  jsr sprite_draw_shadow_spots

  jsr hero_draw_status

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
