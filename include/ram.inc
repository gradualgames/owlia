.ifndef RAM_INC
RAM_INC = 1

MAX_ENTITIES = 12

.global sprite
.global next_sprite_address

.global music_bank
.global map_bank
.global entities_bank
.global sprites_and_animations_bank
.global bg_chr_bank
.global sprite_chr_bank
.global conversations_bank

.global textbox_attribute

.global state_control_params

.global chr_group_offset

.global string_buffer

.global textbox_and_font_chr_offset
.global sprite_chr_group_offsets

.global sorted_entity_index

.global entity_type
.global entity_flags
.global entity_state
.global entity_spawn_x_lo
.global entity_spawn_x_hi
.global entity_spawn_y_lo
.global entity_spawn_y_hi
.global entity_x_lo
.global entity_x_hi
.global entity_y_lo
.global entity_y_hi
.global entity_screen_x_lo
.global entity_screen_x_hi
.global entity_screen_y_lo
.global entity_screen_y_hi
.global entity_width
.global entity_height
.global entity_sprite_group_offset
.global entity_sprite_flags
.global entity_animation_frame
.global entity_animation_counter
.global entity_animation_address_lo
.global entity_animation_address_hi
.global entity_local0
.global entity_local1
.global entity_local2
.global entity_local3
.global entity_local4
.global entity_local5
.global entity_local6
.global entity_local7
.global entity_local8
.global entity_local9
.global entity_local10
.global entity_local11
.global entity_local12
.global entity_local13
.global entity_local14
.global entity_local15

.global inventory_gp
.global inventory_keys
.global inventory_lanterns
.global inventory_bombs
.global inventory_ropes
.global inventory_healths
.global inventory_owl_healths
.global inventory_earned_techs
.global inventory_selected_tech
.global inventory_tech1
.global inventory_tech2

.global hero_flags
.global hero_health
.global hero_state
.global hero_x
.global hero_y
.global hero_screen_x
.global hero_screen_y
.global hero_width
.global hero_height
.global hero_speed
.global hero_sprite_group_offset
.global hero_sprite_flags
.global hero_animation_object
.global hero_animation_address
.global hero_direction
.global hero_direction_handler
.global hero_state_counter
.global hero_invincibility_counter
.global hero_knockback_counter
.global hero_knockback_direction_handler

.global familiar_flags
.global familiar_state
.global familiar_x_fine
.global familiar_x
.global familiar_y_fine
.global familiar_y
.global familiar_x_velocity
.global familiar_y_velocity
.global familiar_screen_x
.global familiar_screen_y
.global familiar_width
.global familiar_height
.global familiar_sprite_group_offset
.global familiar_sprite_flags
.global familiar_animation_object
.global familiar_animation_address
.global familiar_direction
.global familiar_direction_change
.global familiar_state_counter


.global familiar_param_fetched_entity_x_offset
.global familiar_param_fetched_entity_y_offset
.global familiar_param_fetched_entity_index

.global familiar_param_carry_bomb_x_offset
.global familiar_param_carry_bomb_y_offset
.global familiar_param_carry_bomb_entity_index

.global familiar_param_carry_lantern_x_offset
.global familiar_param_carry_lantern_y_offset
.global familiar_param_carry_lantern_entity_index

.global familiar_param_destination_x
.global familiar_param_destination_y

.global familiar_param_shield_x_axis_state
.global familiar_param_shield_y_axis_state
.global familiar_param_shield_x
.global familiar_param_shield_y

.global entity_action_rect1_action
.global entity_action_rect1_x
.global entity_action_rect1_y
.global entity_action_rect1_width
.global entity_action_rect1_height

.global entity_action_rect2_action
.global entity_action_rect2_x
.global entity_action_rect2_y
.global entity_action_rect2_width
.global entity_action_rect2_height

.global ppu_2000
.global ppu_2001
.global ppu_2002
.global ppu_2005
.global ppu_2006

.global dynamic_palette
.global dynamic_palette_brightness_level_bg
.global dynamic_palette_brightness_level_spr

.global buffer_controller

.global map_width
.global map_height

.global camera_x  ;camera x position relative to top left corner of map
.global camera_y  ;camera y position relative to top left corner of map
.global camera_scroll_x
.global camera_scroll_y
.global camera_nametable_hibyte
.global camera_x_scrolling_enabled
.global camera_y_scrolling_enabled

.global floating_solid_metatile_x
.global floating_solid_metatile_y

.global row_ready
.global column_ready

.global intermediate_attribute_row_buffer ;16 byte buffer to contain attribute data for
                                          ;each metatile in a row. Each byte is assumed
                                          ;to consist of two identical nybbles. This
                                          ;makes it easier to shift the attribute bits
                                          ;into position for ORing back into the attribute
                                          ;table.

.global nametable_row_buffer        ;64 byte row buffer, contains tile data for a screen
                                    ;-wide metatile row

.global name_table1_row_start_x     ;in nametable coordinates within the row buffer
.global name_table1_row_length      ;in nametable coordinates within the row buffer
.global name_table1_row_vram_offset ;actual vram offset to begin writing row buffer to

.global name_table2_row_start_x     ;in nametable coordinates within the row buffer
.global name_table2_row_length      ;in nametable coordinates within the row buffer
.global name_table2_row_vram_offset ;actual vram offset to begin writing row buffer to

.global attribute_table1            ;64 byte buffers which are used to invalidate/update
.global attribute_table2            ;the attribute tables in vram.

.global attribute_table1_row_offset ;offset within intermediate attribute row buffer (attribute units)
.global attribute_table1_row_length ;length within intermediate attribute row buffer (metatile units)

.global attribute_table2_row_offset ;offset within intermediate attribute row buffer (attribute units)
.global attribute_table2_row_length ;length within intermediate attribute row buffer (metatile units)

.global attribute_table1_row_vram_length ;length of data to copy from attribute table 1 (attribute units)
.global attribute_table2_row_vram_length ;length of data to copy from attribute table 2 (attribute units)

.global attribute_table1_row_vram_offset ;vram address to start writing attributes to from attribute table 1
.global attribute_table2_row_vram_offset ;vram address to start writing attributes to from attribute table 2

.global intermediate_attribute_column_buffer ;15 byte buffer to contain attribute data for
                                             ;each metatile in a column.

.global nametable_column_buffer      ;60 byte column buffer, contains tile data for a screen
                                     ;-tall metatile column
.global nametable_column_vram_offset ;vram offset for where to start copying nametable column to

.global attribute_column_vram_offset ;vram offset for invalidated attribute column

.global attribute_column_offset      ;offset within attribute table buffer from which to begin copying column

.endif
