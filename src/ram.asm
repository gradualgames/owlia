.include "ram.inc"

.segment "BSS"

;****************************************************************
;Sprite RAM
;****************************************************************
sprite: .res 256
next_sprite_address: .res 1

;****************************************************************
;Bank numbers for currently loaded game data
;****************************************************************
music_bank: .res 1
map_bank: .res 1
entities_bank: .res 1
sprites_and_animations_bank: .res 1
bg_chr_bank: .res 1
sprite_chr_bank: .res 1
conversations_bank: .res 1

;****************************************************************
;Color attribute for the conversation textbox
;****************************************************************
textbox_attribute: .res 1

;****************************************************************
;Generic parameters for the currently active state. A struct can
;be used to describe the data in this buffer and the current
;state can react to the values for changing what is going on, for
;example the play state can switch to a sub-state for displaying
;a conversation based on some information in here.
;****************************************************************
state_control_params: .res 8

;****************************************************************
;This is used by the sprite module to add to the tile offsets
;in each sprite entry inside a metasprite to select the correct
;tiles to display.
;****************************************************************
chr_group_offset: .res 1

;****************************************************************
;These are chr offsets for various types of chr data loaded at
;run time, such as the graphics for the conversation text box and
;also groups of chr data for each type of entity.
;****************************************************************
textbox_and_font_chr_offset: .res 1
sprite_chr_group_offsets: .res 64

;****************************************************************
;A buffer used for any sort of string data that must be decoded
;or computed such as a decimal representation of a number.
;****************************************************************
string_buffer: .res 8

;****************************************************************
;This is used to indicate to the entity_draw_all routine which
;entity is participating in being sorted against the hero and the
;familiar. When it is set to $ff, it is ignored and only the hero
;and familiar are sorted. Any other value is interpreted as an
;index in the entity arrays and that entity is sorted with the
;hero and the familiar.
;****************************************************************
sorted_entity_index: .res 1

;****************************************************************
;These constitute state of all active entities currently in play.
;The numerous "local" arrays below all of the common arrays are
;usually equated to more descriptive names for each entity type,
;and are used for additional logic for more complex behavior than
;what is needed by the most basic entities.
;****************************************************************
entity_type:                 .res MAX_ENTITIES
entity_flags:                .res MAX_ENTITIES
entity_state:                .res MAX_ENTITIES
entity_spawn_x_lo:           .res MAX_ENTITIES
entity_spawn_x_hi:           .res MAX_ENTITIES
entity_spawn_y_lo:           .res MAX_ENTITIES
entity_spawn_y_hi:           .res MAX_ENTITIES
entity_x_lo:                 .res MAX_ENTITIES
entity_x_hi:                 .res MAX_ENTITIES
entity_y_lo:                 .res MAX_ENTITIES
entity_y_hi:                 .res MAX_ENTITIES
entity_screen_x_lo:          .res MAX_ENTITIES
entity_screen_x_hi:          .res MAX_ENTITIES
entity_screen_y_lo:          .res MAX_ENTITIES
entity_screen_y_hi:          .res MAX_ENTITIES
entity_width:                .res MAX_ENTITIES
entity_height:               .res MAX_ENTITIES
entity_sprite_group_offset:  .res MAX_ENTITIES
entity_sprite_flags:         .res MAX_ENTITIES
entity_animation_frame:      .res MAX_ENTITIES
entity_animation_counter:    .res MAX_ENTITIES
entity_animation_address_lo: .res MAX_ENTITIES
entity_animation_address_hi: .res MAX_ENTITIES
entity_local0:               .res MAX_ENTITIES
entity_local1:               .res MAX_ENTITIES
entity_local2:               .res MAX_ENTITIES
entity_local3:               .res MAX_ENTITIES
entity_local4:               .res MAX_ENTITIES
entity_local5:               .res MAX_ENTITIES
entity_local6:               .res MAX_ENTITIES
entity_local7:               .res MAX_ENTITIES
entity_local8:               .res MAX_ENTITIES
entity_local9:               .res MAX_ENTITIES
entity_local10:              .res MAX_ENTITIES
entity_local11:              .res MAX_ENTITIES
entity_local12:              .res MAX_ENTITIES
entity_local13:              .res MAX_ENTITIES
entity_local14:              .res MAX_ENTITIES

;****************************************************************
;These variables constitute inventory state for the player.
;****************************************************************
inventory_gp:             .res 2
inventory_keys:           .res 1
inventory_lanterns:       .res 1
inventory_bombs:          .res 1
inventory_ropes:          .res 1
inventory_healths:        .res 1
inventory_owl_healths:    .res 1
inventory_earned_techs:   .res 1
inventory_selected_tech:  .res 1
inventory_tech1:          .res 1
inventory_tech2:          .res 1

;****************************************************************
;These variables describe the hard coded hero entity state.
;****************************************************************
hero_flags:                       .res 1
hero_health:                      .res 1
hero_state:                       .res 1
hero_x:                           .res 2
hero_y:                           .res 2
hero_screen_x:                    .res 2
hero_screen_y:                    .res 2
hero_width:                       .res 1
hero_height:                      .res 1
hero_speed:                       .res 1
hero_sprite_group_offset:         .res 1
hero_sprite_flags:                .res 1
hero_animation_object:            .res 2
hero_animation_address:           .res 2
hero_direction:                   .res 1
hero_direction_handler:           .res 1
hero_state_counter:               .res 1
hero_invincibility_counter:       .res 1
hero_knockback_counter:           .res 1
hero_knockback_direction_handler: .res 1

;****************************************************************
;These variables describe the hard coded familiar entity state.
;****************************************************************
familiar_flags:                   .res 1
familiar_state:                   .res 1
familiar_x_fine:                  .res 1
familiar_x:                       .res 2
familiar_y_fine:                  .res 1
familiar_y:                       .res 2
familiar_x_velocity:              .res 2
familiar_y_velocity:              .res 2
familiar_screen_x:                .res 2
familiar_screen_y:                .res 2
familiar_width:                   .res 1
familiar_height:                  .res 1
familiar_sprite_group_offset:     .res 1
familiar_sprite_flags:            .res 1
familiar_animation_object:        .res 2
familiar_animation_address:       .res 2
familiar_direction:               .res 1
familiar_direction_change:        .res 1
familiar_state_counter:           .res 1

;TODO: eliminate the specific parameter names for the fetch state.
familiar_param_w0:
familiar_fetched_entity_index:    .res 1
familiar_fetched_entity_x_offset: .res 1

familiar_param_w1:
familiar_fetched_entity_y_offset: .res 1
                                  .res 1

;****************************************************************
;These variables describe entity action rects. There are only two
;of these rects, to reduce how many rectangle comparisons are
;performed at run-time.
;****************************************************************
entity_action_rect1_action:     .res 1
entity_action_rect1_x:          .res 2
entity_action_rect1_y:          .res 2
entity_action_rect1_width:      .res 1
entity_action_rect1_height:     .res 1

entity_action_rect2_action:     .res 1
entity_action_rect2_x:          .res 2
entity_action_rect2_y:          .res 2
entity_action_rect2_width:      .res 1
entity_action_rect2_height:     .res 1

;****************************************************************
;These variables keep track of the state of various PPU registers
;at runtime. Using variables in RAM for this make it easier to
;twiddle individual bits and then upload the entire byte
;preserving state of flags we already set.
;****************************************************************
ppu_2000: .res 1
ppu_2001: .res 1
ppu_2005: .res 2
ppu_2006: .res 2

;****************************************************************
;This is used for palette fading. It is a translation of the
;currently loaded area palette based on a fade value from 0 to
;3 I believe (TODO: check this)
;****************************************************************
dynamic_palette: .res 32

;****************************************************************
;This stores the state of all controller buttons. Most of them
;are rotated in from the least significant bit, so on-to-off or
;off-to-on transitions can be easily detected.
;****************************************************************
buffer_controller: .res 8

;****************************************************************
;The following variables describe the current state of the
;camera.
;****************************************************************
camera_x: .res 2
camera_y: .res 2
camera_scroll_x: .res 1
camera_scroll_y: .res 1
camera_nametable_hibyte: .res 1
camera_x_scrolling_enabled: .res 1
camera_y_scrolling_enabled: .res 1

;****************************************************************
;The following variables all describe currently loaded map data
;and state.
;****************************************************************
map_width: .res 1
map_height: .res 1

;these can be set by the entity system to create a fake solid
;block for the hero to run into. Useful for doors and bombable
;blocks.
floating_solid_metatile_x: .res 1
floating_solid_metatile_y: .res 1

;indicates to the map vblank routine that a row or a column has been prepared
;and is ready to be uploaded to the ppu according to the below parameters
row_ready: .res 1
column_ready: .res 1

;stores a row of attributes decoded from the map but before being bit-twiddled
;into the actual attribute tables
intermediate_attribute_row_buffer: .res 17

;stores a row of tiles that will be uploaded to the nametable
nametable_row_buffer: .res 34

;parameters describing how to copy the nametable row buffer to the ppu
name_table1_row_start_x: .res 1
name_table1_row_length:  .res 1

name_table2_row_start_x: .res 1
name_table2_row_length:  .res 1

name_table1_row_vram_offset: .res 2
name_table2_row_vram_offset: .res 2

;copies of the attribute tables in vram. These are intended to hold the current
;state of the attribute table (one row or column at a time) and individual rows or
;columns of 8 bytes are copied to the ppu
attribute_table1: .res 64
attribute_table2: .res 64

;parameters describing how to copy the attribute row to the ppu
attribute_table1_row_offset:  .res 1
attribute_table1_row_length:  .res 1

attribute_table2_row_offset:  .res 1
attribute_table2_row_length:  .res 1

attribute_table1_row_vram_length: .res 1
attribute_table2_row_vram_length: .res 1

attribute_table1_row_vram_offset: .res 2
attribute_table2_row_vram_offset: .res 2

;stores a column of attributes before being bit-twiddled into the attribute tables
intermediate_attribute_column_buffer: .res 15

;stores a column of tiles for being uploaded to the ppu
nametable_column_buffer: .res 30

;the following variables describe how to upload a column of tiles and attribute
;data to the ppu
nametable_column_vram_offset: .res 2

attribute_column_vram_offset: .res 2

attribute_column_offset: .res 1
