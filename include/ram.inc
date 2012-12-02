.ifndef RAM_INC
RAM_INC = 1

MAX_ENTITIES = 8

.global sprite
.global next_sprite_address
.global sprite_group_offset

.global music_bank
.global map_bank
.global entities_bank
.global sprites_and_animations_bank
.global bg_chr_bank
.global sprite_chr_bank

.global state_control_params

.global textbox_and_font_chr_offset
.global entity_type_chr_offsets

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

.global hero_flags
.global hero_state
.global hero_x
.global hero_y
.global hero_width
.global hero_height
.global hero_speed
.global hero_sprite_group_offset
.global hero_sprite_flags
.global hero_animation_object
.global hero_animation_address
.global hero_direction
.global hero_state_counter
.global hero_invincibility_counter
.global hero_knockback_counter
.global hero_knockback_direction_handler

.global hero_attack_rect_x
.global hero_attack_rect_y
.global hero_attack_rect_width
.global hero_attack_rect_height

.global familiar_flags
.global familiar_state
.global familiar_x_fine
.global familiar_x
.global familiar_y_fine
.global familiar_y
.global familiar_x_velocity
.global familiar_y_velocity
.global familiar_width
.global familiar_height
.global familiar_rect_x
.global familiar_rect_y
.global familiar_rect_width
.global familiar_rect_height
.global familiar_sprite_group_offset
.global familiar_sprite_flags
.global familiar_animation_object
.global familiar_animation_address
.global familiar_direction
.global familiar_state_counter

.global ppu_2000
.global ppu_2001
.global ppu_2002
.global ppu_2005
.global ppu_2006

.global dynamic_palette

.global buffer_controller

.global map_width
.global map_height

.global camera_x  ;camera x position relative to top left corner of map
.global camera_y  ;camera y position relative to top left corner of map
.global camera_scroll_x
.global camera_scroll_y
.global camera_nametable_hibyte

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
