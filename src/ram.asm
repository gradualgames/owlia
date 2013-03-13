.include "ram.inc"

.segment "BSS"

sprite: .res 256
next_sprite_address: .res 1

music_bank: .res 1
map_bank: .res 1
entities_bank: .res 1
sprites_and_animations_bank: .res 1
bg_chr_bank: .res 1
sprite_chr_bank: .res 1
conversations_bank: .res 1

textbox_attribute: .res 1

state_control_params: .res 8

chr_group_offset: .res 1

string_buffer: .res 8

textbox_and_font_chr_offset: .res 1
sprite_chr_group_offsets: .res 64

sorted_entity_index: .res 1

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

inventory_lanterns:       .res 1
inventory_bombs:          .res 1
inventory_ropes:          .res 1
inventory_healths:        .res 1
inventory_owl_healths:    .res 1
inventory_owl_carry_item: .res 1
inventory_earned_techs:   .res 1
inventory_tech1:          .res 1
inventory_tech2:          .res 1

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
hero_state_counter:               .res 1
hero_invincibility_counter:       .res 1
hero_knockback_counter:           .res 1
hero_knockback_direction_handler: .res 1

hero_attack_rect_x:          .res 2
hero_attack_rect_y:          .res 2
hero_attack_rect_width:      .res 1
hero_attack_rect_height:     .res 1

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
familiar_rect_x:                  .res 2
familiar_rect_y:                  .res 2
familiar_rect_width:              .res 1
familiar_rect_height:             .res 1
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

ppu_2000: .res 1
ppu_2001: .res 1
ppu_2005: .res 2
ppu_2006: .res 2

dynamic_palette: .res 32

buffer_controller: .res 8

map_width: .res 1
map_height: .res 1

camera_x: .res 2
camera_y: .res 2
camera_scroll_x: .res 1
camera_scroll_y: .res 1
camera_nametable_hibyte: .res 1
camera_x_scrolling_enabled: .res 1
camera_y_scrolling_enabled: .res 1

row_ready: .res 1
column_ready: .res 1

intermediate_attribute_row_buffer: .res 17

nametable_row_buffer: .res 34

name_table1_row_start_x: .res 1
name_table1_row_length:  .res 1

name_table2_row_start_x: .res 1
name_table2_row_length:  .res 1

name_table1_row_vram_offset: .res 2
name_table2_row_vram_offset: .res 2

attribute_table1: .res 64
attribute_table2: .res 64

attribute_table1_row_offset:  .res 1
attribute_table1_row_length:  .res 1

attribute_table2_row_offset:  .res 1
attribute_table2_row_length:  .res 1

attribute_table1_row_vram_length: .res 1
attribute_table2_row_vram_length: .res 1

attribute_table1_row_vram_offset: .res 2
attribute_table2_row_vram_offset: .res 2

intermediate_attribute_column_buffer: .res 15

nametable_column_buffer: .res 30

nametable_column_vram_offset: .res 2

attribute_column_vram_offset: .res 2

attribute_column_offset: .res 1
