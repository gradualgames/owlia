.ifndef MAP_INC
MAP_INC = 1

;used to test hurt and solid flags on metatiles
FLAG_HURT  = $20
FLAG_SOLID = $10

;used for a metatile to signify what action it can perform with its associated param
;there can only be 16 of these counting the nop.
ACTION_NOP          = $00
ACTION_GOTO_AREA    = $01
ACTION_SPAWN_ENTITY = $02

.global nametable_and_attribute_update_ppu
.global map_process_intermediate_attribute_row_buffer
.global map_decode_row
.global map_process_intermediate_attribute_column_buffer
.global map_decode_column

.endif
