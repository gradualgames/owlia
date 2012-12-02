.ifndef MAP_INC
MAP_INC = 1

;used to test hurt and solid flags on metatiles
FLAG_HURT  = $20
FLAG_SOLID = $10

ISOLATE_ACTION_MASK = $0f

.global map_test_collision
.global nametable_and_attribute_update_ppu
.global map_process_intermediate_attribute_row_buffer
.global map_decode_row
.global map_process_intermediate_attribute_column_buffer
.global map_decode_column

.endif
