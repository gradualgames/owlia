.ifndef RAM_INC
RAM_INC = 1

.global sprite
.global next_sprite_address
.global sprite_group_offset

.global animation_object
.global current_animation_definition
.global current_sprite_flags

.global ppu_2000
.global ppu_2001
.global ppu_2002
.global ppu_2005
.global ppu_2006

.global buffer_controller

.global map_address
.global metatile_table_attributes_address
.global metatile_table_top_left_tiles_address
.global metatile_table_top_right_tiles_address
.global metatile_table_bottom_left_tiles_address
.global metatile_table_bottom_right_tiles_address
.global big_metatile_table_top_left_address
.global big_metatile_table_top_right_address
.global big_metatile_table_bottom_left_address
.global big_metatile_table_bottom_right_address
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
