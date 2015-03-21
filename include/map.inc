.ifndef MAP_INC
MAP_INC = 1

;used to test pit and solid flags on metatiles
FLAG_PIT  = $20
FLAG_SOLID = $10

ISOLATE_ACTION_MASK = $0f

.global map_module_init
.global mod15lut
.global clear_dynamic_single_screen_collision_field
.global set_dynamic_single_screen_collision_field_bit
.global clear_dynamic_single_screen_collision_field_bit
.global map_test_collision
.global nametable_and_attribute_update_ppu
.global nametable_and_attribute_update_ppu_direct
.global map_process_intermediate_attribute_row_buffer
.global map_decode_row
.global map_process_intermediate_attribute_column_buffer
.global map_decode_column

.endif
