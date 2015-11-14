.feature force_range
.include "map.inc"
.include "ram.inc"
.include "zp.inc"
.include "ppu.inc"
.include "controller.inc"
.include "sprite.inc"
.include "mapper.inc"
.include "ndxdebug.h"

.segment "CODE"

.proc map_module_init

  ;clear attribute tables
  lda #0
  ldx #63
: sta attribute_table1,x
  sta attribute_table2,x
  dex
  bpl :-

  jsr clear_dynamic_single_screen_collision_field

  rts

.endproc

;Clears out the 32 byte structure containing the single screen
;collision field.
.proc clear_dynamic_single_screen_collision_field

  ldx #$1f
  lda #$00
: sta dynamic_single_screen_collision_field,x
  dex
  bpl :-

  rts

.endproc

;This routine marks a bit in the dynamic single screen collision field
;expects w0 to contain map x coordinate
;expects w1 to contain map y coordinate
.proc set_dynamic_single_screen_collision_field_bit
x_coord = w0
y_coord = w1
row_offset = w2

  ;save x, this routine may be called by entities
  txa
  pha

  ;find metatile coordinates from 16 bit x and y
  lda x_coord
  lsr x_coord+1
  ror
  lsr x_coord+1
  ror
  lsr x_coord+1
  ror
  lsr x_coord+1
  ror
  sta x_coord

  lda y_coord
  lsr y_coord+1
  ror
  lsr y_coord+1
  ror
  lsr y_coord+1
  ror
  lsr y_coord+1
  ror
  sta y_coord

  ;wrap the coordinates so that they fit in the single screen collision field
  lda x_coord
  and #%00001111
  sta x_coord
  lda #$00
  sta x_coord+1

  lda y_coord
  tax
  lda mod15lut,x
  sta y_coord
  lda #$00
  sta y_coord+1

  ;-metatile Y * 2 = row to check. This is because we use two bytes per
  ;row.

  lda y_coord
  sta row_offset
  lda y_coord+1
  sta row_offset+1

  lda row_offset+1
  asl row_offset
  rol
  sta row_offset+1

  ldy row_offset

  ;-metatile X, bit 3, (1000), indicates whether to check the first or the
  ;second byte of that row
  lda x_coord
  and #%00001000
  bne test_second_byte
test_first_byte:

  ;-metatile X, lowest 3 bits (bits 0, 1, and 2), indicate which bit to
  ;use in the byte. Probably use a lut to get the right bit rat-
  ;her than a loop for rotating a bit.

  lda x_coord
  and #%00000111
  tax

  lda dynamic_single_screen_collision_field,y
  ora bit_select_lut,x
  sta dynamic_single_screen_collision_field,y

  ;restore x
  pla
  tax

  rts
test_second_byte:

  ;-metatile X, lowest 3 bits (bits 0, 1, and 2), indicate which bit to
  ;use in the byte. Probably use a lut to get the right bit rat-
  ;her than a loop for rotating a bit.

  lda x_coord
  and #%00000111
  tax

  lda dynamic_single_screen_collision_field+1,y
  ora bit_select_lut,x
  sta dynamic_single_screen_collision_field+1,y

  ;restore x
  pla
  tax

  rts

.endproc

;This routine clears a bit in the dynamic single screen collision field
;expects w0 to contain map x coordinate
;expects w1 to contain map y coordinate
.proc clear_dynamic_single_screen_collision_field_bit
x_coord = w0
y_coord = w1
row_offset = w2

  ;save x, this routine may be called by entities
  txa
  pha

  ;find metatile coordinates from 16 bit x and y
  lda x_coord
  lsr x_coord+1
  ror
  lsr x_coord+1
  ror
  lsr x_coord+1
  ror
  lsr x_coord+1
  ror
  sta x_coord

  lda y_coord
  lsr y_coord+1
  ror
  lsr y_coord+1
  ror
  lsr y_coord+1
  ror
  lsr y_coord+1
  ror
  sta y_coord

  ;wrap the coordinates so that they fit in the single screen collision field
  lda x_coord
  and #%00001111
  sta x_coord
  lda #$00
  sta x_coord+1

  lda y_coord
  tax
  lda mod15lut,x
  sta y_coord
  lda #$00
  sta y_coord+1

  ;-metatile Y * 2 = row to check. This is because we use two bytes per
  ;row.

  lda y_coord
  sta row_offset
  lda y_coord+1
  sta row_offset+1

  lda row_offset+1
  asl row_offset
  rol
  sta row_offset+1

  ldy row_offset

  ;-metatile X, bit 3, (1000), indicates whether to check the first or the
  ;second byte of that row
  lda x_coord
  and #%00001000
  bne test_second_byte
test_first_byte:

  ;-metatile X, lowest 3 bits (bits 0, 1, and 2), indicate which bit to
  ;use in the byte. Probably use a lut to get the right bit rat-
  ;her than a loop for rotating a bit.

  lda x_coord
  and #%00000111
  tax

  lda dynamic_single_screen_collision_field,y
  and bit_clear_lut,x
  sta dynamic_single_screen_collision_field,y

  ;restore x
  pla
  tax

  rts
test_second_byte:

  ;-metatile X, lowest 3 bits (bits 0, 1, and 2), indicate which bit to
  ;use in the byte. Probably use a lut to get the right bit rat-
  ;her than a loop for rotating a bit.

  lda x_coord
  and #%00000111
  tax

  lda dynamic_single_screen_collision_field+1,y
  and bit_clear_lut,x
  sta dynamic_single_screen_collision_field+1,y

  ;restore x
  pla
  tax

  rts

.endproc

;This routine tests a bit in the dynamic single screen collision field
;expects w0 to contain map x coordinate in metatile coordinates
;expects w1 to contain map y coordinate in metatile coordinates
;returns result in b0
.proc test_dynamic_single_screen_collision_field_bit
input_x_coord = w0
input_y_coord = w1
x_coord = w5
y_coord = w6
row_offset = w2
result = b0

  ;save x, this routine may be called by entities
  txa
  pha

  ;wrap the coordinates so that they fit in the single screen collision field
  lda input_x_coord
  and #%00001111
  sta x_coord
  lda #$00
  sta x_coord+1

  lda input_y_coord
  tax
  lda mod15lut,x
  sta y_coord
  lda #$00
  sta y_coord+1

  ;-metatile Y * 2 = row to check. This is because we use two bytes per
  ;row.

  lda y_coord
  sta row_offset
  lda y_coord+1
  sta row_offset+1

  lda row_offset+1
  asl row_offset
  rol
  sta row_offset+1

  ldy row_offset

  ;-metatile X, bit 3, (1000), indicates whether to check the first or the
  ;second byte of that row
  lda x_coord
  and #%00001000
  bne test_second_byte
test_first_byte:

  ;-metatile X, lowest 3 bits (bits 0, 1, and 2), indicate which bit to
  ;use in the byte. Probably use a lut to get the right bit rat-
  ;her than a loop for rotating a bit.

  lda x_coord
  and #%00000111
  tax

  lda dynamic_single_screen_collision_field,y
  and bit_select_lut,x
  sta result

  ;restore x
  pla
  tax

  rts
test_second_byte:

  ;-metatile X, lowest 3 bits (bits 0, 1, and 2), indicate which bit to
  ;use in the byte. Probably use a lut to get the right bit rat-
  ;her than a loop for rotating a bit.

  lda x_coord
  and #%00000111
  tax

  lda dynamic_single_screen_collision_field+1,y
  and bit_select_lut,x
  sta result

  ;restore x
  pla
  tax

  rts

.endproc

;convenient bit select lut for the single screen collision field
bit_select_lut:
  .byte %10000000
  .byte %01000000
  .byte %00100000
  .byte %00010000
  .byte %00001000
  .byte %00000100
  .byte %00000010
  .byte %00000001

bit_clear_lut:
  .byte %01111111
  .byte %10111111
  .byte %11011111
  .byte %11101111
  .byte %11110111
  .byte %11111011
  .byte %11111101
  .byte %11111110

;lut for modulus of 15, used for quickly computing correct attribute and nametable rows
mod15lut:
.repeat 5
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
.endrepeat

;returns the properties byte for the metatile inside which the input point resides
;expects w0 and w1 to contain the X and Y coordinate of the point to test.
;returns metatile properties byte in b0
;temporarily to map_bank before switching back to calling bank.
.proc map_test_collision
map_x_in_metatile_coordinates = w0
map_y_in_metatile_coordinates = w1
map_x_in_big_metatile_coordinates = w3
map_y_in_big_metatile_coordinates = w4
metatile_properties = b0
metatile_param = b1

map_offset = w16

  ;save calling bank
  lda current_bank
  pha
  ;we need to see the map data for the duration of this routine
  switch_bank_ldy map_bank

  ;calculate map x and y in metatile and big metatile coordinates
  lda map_x_in_metatile_coordinates
  lsr map_x_in_metatile_coordinates+1
  ror
  lsr map_x_in_metatile_coordinates+1
  ror
  lsr map_x_in_metatile_coordinates+1
  ror
  lsr map_x_in_metatile_coordinates+1
  ror
  sta map_x_in_metatile_coordinates

  lda map_y_in_metatile_coordinates
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  sta map_y_in_metatile_coordinates

  jsr test_dynamic_single_screen_collision_field_bit
  lda b0
  beq no_dynamic_collision

  lda #FLAG_SOLID
  sta metatile_properties

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

no_dynamic_collision:

  lda map_x_in_metatile_coordinates
  sta map_x_in_big_metatile_coordinates
  lda map_x_in_metatile_coordinates+1
  sta map_x_in_big_metatile_coordinates+1

  lda map_x_in_big_metatile_coordinates
  lsr map_x_in_big_metatile_coordinates+1
  ror
  sta map_x_in_big_metatile_coordinates

  lda map_y_in_metatile_coordinates
  sta map_y_in_big_metatile_coordinates
  lda map_y_in_metatile_coordinates+1
  sta map_y_in_big_metatile_coordinates+1

  lda map_y_in_big_metatile_coordinates
  lsr map_y_in_big_metatile_coordinates+1
  ror
  sta map_y_in_big_metatile_coordinates

  ;now modify the metatile coordinates to only be an offset within the big metatile
  lda map_x_in_metatile_coordinates
  and #%00000001
  sta map_x_in_metatile_coordinates

  lda map_y_in_metatile_coordinates
  and #%00000001
  sta map_y_in_metatile_coordinates

  ;calculate map offset
  lda map_y_in_big_metatile_coordinates
  sta map_offset
  lda map_y_in_big_metatile_coordinates+1
  sta map_offset+1

  ;shift map y in big metatile coordinates left by 5 to multiply by 32
  ;after this, map_offset will be the offset of the row
  ;in which we want to begin decoding
  lda map_offset+1
  asl map_offset
  rol
  asl map_offset
  rol
  asl map_offset
  rol
  asl map_offset
  rol
  asl map_offset
  rol
  sta map_offset+1

  ;add on map y in big metatile coordinates
  clc
  lda map_offset
  adc map_x_in_big_metatile_coordinates
  sta map_offset
  lda map_offset+1
  adc map_x_in_big_metatile_coordinates+1
  sta map_offset+1

  ;add on base address of map
  clc
  lda map_offset
  adc map_address
  sta map_offset
  lda map_offset+1
  adc map_address+1
  sta map_offset+1

.scope
  lda map_x_in_metatile_coordinates
  bne right_side
left_side:

  .scope
  lda map_y_in_metatile_coordinates
  bne bottom_half
top_half:

  ;top left case

  ;get the big metatile index
  ldy #0
  lda (map_offset),y
  ;lookup metatile index
  tay
  lda (big_metatile_table_top_left_address),y
  tay
  ;get metatile properties byte and param byte and return
  lda (metatile_table_properties_address),y
  sta metatile_properties
  lda (metatile_table_params_address),y
  sta metatile_param

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

  jmp done
bottom_half:

  ;bottom left case

  ;get the big metatile index
  ldy #0
  lda (map_offset),y
  ;lookup metatile index
  tay
  lda (big_metatile_table_bottom_left_address),y
  tay
  ;get metatile properties byte and param byte and return
  lda (metatile_table_properties_address),y
  sta metatile_properties
  lda (metatile_table_params_address),y
  sta metatile_param

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

done:
  .endscope

  jmp done
right_side:

  .scope
  lda map_y_in_metatile_coordinates
  bne bottom_half
top_half:

  ;top right case

  ;get the big metatile index
  ldy #0
  lda (map_offset),y
  ;lookup metatile index
  tay
  lda (big_metatile_table_top_right_address),y
  tay
  ;get metatile properties byte and param byte and return
  lda (metatile_table_properties_address),y
  sta metatile_properties
  lda (metatile_table_params_address),y
  sta metatile_param

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

  jmp done
bottom_half:

  ;bottom right case

  ;get the big metatile index
  ldy #0
  lda (map_offset),y
  ;lookup metatile index
  tay
  lda (big_metatile_table_bottom_right_address),y
  tay
  ;get metatile properties byte and param byte and return
  lda (metatile_table_properties_address),y
  sta metatile_properties
  lda (metatile_table_params_address),y
  sta metatile_param

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

done:
  .endscope

done:
.endscope

  ;there are four cases with an rts above, no ending
  ;rts is needed

.endproc

map_decode_row = big_map_decode_row
map_decode_column = big_map_decode_column

;decodes a single row of metatiles from a big (4 screen by 4 screen) map
.proc big_map_decode_row
map_x = w0
map_y = w1
map_x_in_big_metatile_coordinates = w3
map_y_in_big_metatile_coordinates = w4
map_x_in_metatile_coordinates = w5
map_y_in_metatile_coordinates = w6
map_x_in_nametable_coordinates = b2
map_y_in_nametable_coordinates = b3
nametable_vram_offset = b4
odd_nametable_row_flag = b5
odd_metatile_row_flag = b6
odd_metatile_column_flag = b7
nametable_row_buffer_offset = b8
intermediate_attribute_row_buffer_offset = b9
metatile_counter = b10
metatile_index = b11

map_offset = w16

  ;calculate useful transformations of map_x and map_y
  lda map_x
  sta map_x_in_metatile_coordinates
  lda map_x+1
  sta map_x_in_metatile_coordinates+1

  lda map_y
  sta map_y_in_metatile_coordinates
  lda map_y+1
  sta map_y_in_metatile_coordinates+1

  lda map_x_in_metatile_coordinates
  lsr map_x_in_metatile_coordinates+1
  ror
  lsr map_x_in_metatile_coordinates+1
  ror
  lsr map_x_in_metatile_coordinates+1
  ror
  lsr map_x_in_metatile_coordinates+1
  ror
  sta map_x_in_metatile_coordinates

  lda map_y_in_metatile_coordinates
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  sta map_y_in_metatile_coordinates

  lda map_x_in_metatile_coordinates
  sta map_x_in_big_metatile_coordinates
  lda map_x_in_metatile_coordinates+1
  sta map_x_in_big_metatile_coordinates+1

  lda map_x_in_big_metatile_coordinates
  lsr map_x_in_big_metatile_coordinates+1
  ror
  sta map_x_in_big_metatile_coordinates

  lda map_y_in_metatile_coordinates
  sta map_y_in_big_metatile_coordinates
  lda map_y_in_metatile_coordinates+1
  sta map_y_in_big_metatile_coordinates+1

  lda map_y_in_big_metatile_coordinates
  lsr map_y_in_big_metatile_coordinates+1
  ror
  sta map_y_in_big_metatile_coordinates

  ;calculate map_x_in_nametable_coordinates.
  lda map_x_in_metatile_coordinates
  asl
  and #%00011111
  sta map_x_in_nametable_coordinates

  ;calculate map_y_in_nametable_coordinates

  ;use lo byte of y metatile coord to get mod15 value. only use lo byte,
  ;but this will constrain the vertical height of the map to roughly 18 screens
  ;which should be fine for our purposes.
  ldx map_y_in_metatile_coordinates
  lda mod15lut,x
  asl
  sta map_y_in_nametable_coordinates

  ;calculate nametable_vram_offset. This variable is used to help the vblank
  ;routine determine whether to write the upper or lower portion of a metatile
  ;row.
  lda map_y
  lsr
  lsr
  lsr
  and #$01
.scope
  beq even
odd:
  lda #32
  sta nametable_vram_offset
  lda #1
  sta odd_nametable_row_flag
  jmp done
even:
  lda #0
  sta nametable_vram_offset
  lda #0
  sta odd_nametable_row_flag
done:
.endscope

  ;calculate whether we're on an even or an odd metatile row
  lda map_y_in_metatile_coordinates
  and #$01
.scope
  beq even
odd:
  lda #$01
  sta odd_metatile_row_flag
  jmp done
even:
  lda #$00
  sta odd_metatile_row_flag
done:
.endscope

  ;calculate whether we're on an even or an odd metatile column
  lda map_x_in_metatile_coordinates
  and #$01
.scope
  beq even
odd:
  lda #$01
  sta odd_metatile_column_flag
  jmp done
even:
  lda #$00
  sta odd_metatile_column_flag
done:
.endscope

  ;calculate name_table1_row_start_x, name_table1_row_length,
  ;name_table2_row_start_x, name_table2_row_length using
  ;map_x_in_nametable_coordinates and map_y_in_nametable_coordinates

.scope
  lda map_x+1
  and #$01
  beq even
odd:

  jsr calculate_nametable_row_params_odd

  jmp done
even:

  jsr calculate_nametable_row_params_even

done:

.endscope

  ;calculate map offset
  lda map_y_in_big_metatile_coordinates
  sta map_offset
  lda map_y_in_big_metatile_coordinates+1
  sta map_offset+1

  ;shift map y in big metatile coordinates left by 5 to multiply by 32
  ;after this, map_offset will be the offset of the row
  ;in which we want to begin decoding
  lda map_offset+1
  asl map_offset
  rol
  asl map_offset
  rol
  asl map_offset
  rol
  asl map_offset
  rol
  asl map_offset
  rol
  sta map_offset+1

  ;add on map y in big metatile coordinates
  clc
  lda map_offset
  adc map_x_in_big_metatile_coordinates
  sta map_offset
  lda map_offset+1
  adc map_x_in_big_metatile_coordinates+1
  sta map_offset+1

  ;add on base address of map
  clc
  lda map_offset
  adc map_address
  sta map_offset
  lda map_offset+1
  adc map_address+1
  sta map_offset+1

  lda #0
  sta nametable_row_buffer_offset
  sta intermediate_attribute_row_buffer_offset
  lda #17
  sta metatile_counter

next_metatile:

  ;load an index into the big metatile arrays from the map
  ldy #0
  lda (map_offset),y
  sta metatile_index

  lda odd_metatile_row_flag
.scope
  beq even
odd:

  lda odd_metatile_column_flag
.scope
  beq even
odd:

  ;bottom right

  ;lookup little metatile from bottom right of big metatile
  ldy metatile_index
  lda (big_metatile_table_bottom_right_address),y
  sta metatile_index

  jmp done
even:

  ;bottom left

  ;lookup little metatile from bottom left of big metatile
  ldy metatile_index
  lda (big_metatile_table_bottom_left_address),y
  sta metatile_index

done:
.endscope

  jmp done
even:

  lda odd_metatile_column_flag
.scope
  beq even
odd:

  ;top right

  ;lookup little metatile from top right of big metatile
  ldy metatile_index
  lda (big_metatile_table_top_right_address),y
  sta metatile_index

  jmp done
even:

  ;top left

  ;lookup little metatile from top left of big metatile
  ldy metatile_index
  lda (big_metatile_table_top_left_address),y
  sta metatile_index

done:
.endscope

done:
.endscope

  lda odd_nametable_row_flag
  and #$01
.scope
  beq even
odd:

  ldy metatile_index
  lda (metatile_table_bottom_left_tiles_address),y
  ldx nametable_row_buffer_offset
  sta nametable_row_buffer,x

  lda (metatile_table_bottom_right_tiles_address),y
  sta nametable_row_buffer+1,x

  jmp done
even:

  ldy metatile_index
  lda (metatile_table_top_left_tiles_address),y
  ldx nametable_row_buffer_offset
  sta nametable_row_buffer,x

  lda (metatile_table_top_right_tiles_address),y
  sta nametable_row_buffer+1,x

done:
.endscope

  ldy metatile_index
  lda (metatile_table_attributes_address),y
  ldx intermediate_attribute_row_buffer_offset
  sta intermediate_attribute_row_buffer,x

  clc
  lda map_offset
  adc odd_metatile_column_flag
  sta map_offset
  lda map_offset+1
  adc #$00
  sta map_offset+1

  ;flip the column even/odd flag
  lda odd_metatile_column_flag
  eor #$01
  sta odd_metatile_column_flag

  ;increment offsets in the various buffers
  inc nametable_row_buffer_offset
  inc nametable_row_buffer_offset
  inc intermediate_attribute_row_buffer_offset

  ;loop based on metatile unit counter
  dec metatile_counter
  bne next_metatile

  rts

calculate_nametable_row_params_even:

  lda #0
  sta name_table1_row_start_x

  sec
  lda #32
  sbc map_x_in_nametable_coordinates
  sta name_table1_row_length

  sec
  lda #34
  sbc name_table1_row_length
  sta name_table2_row_length

  lda name_table1_row_length
  sta name_table2_row_start_x

  ;calculate vram start offset for name_table1. this is $2000 + map_y_in_nametable_coordinates * 32 + map_x_in_nametable_coordinates

  lda map_y_in_nametable_coordinates
  sta name_table1_row_vram_offset
  lda #$00
  sta name_table1_row_vram_offset+1

  ;multiply row start y by 32
  lda name_table1_row_vram_offset+1
  asl name_table1_row_vram_offset
  rol
  asl name_table1_row_vram_offset
  rol
  asl name_table1_row_vram_offset
  rol
  asl name_table1_row_vram_offset
  rol
  asl name_table1_row_vram_offset
  rol
  sta name_table1_row_vram_offset+1

  ;add on map_x_in_nametable_coordinates
  clc
  lda name_table1_row_vram_offset
  adc map_x_in_nametable_coordinates
  sta name_table1_row_vram_offset
  lda name_table1_row_vram_offset+1
  adc #$00
  sta name_table1_row_vram_offset+1

  ;add on nametable_vram_offset
  clc
  lda name_table1_row_vram_offset
  adc nametable_vram_offset
  sta name_table1_row_vram_offset
  lda name_table1_row_vram_offset+1
  adc #$00
  sta name_table1_row_vram_offset+1

  ;add on $2000
  clc
  lda name_table1_row_vram_offset
  adc #$00
  sta name_table1_row_vram_offset
  lda name_table1_row_vram_offset+1
  adc #$20
  sta name_table1_row_vram_offset+1

  ;calculate vram start offset for name_table2. this is $2400 + map_y_in_nametable_coordinates * 32

  lda map_y_in_nametable_coordinates
  sta name_table2_row_vram_offset
  lda #$00
  sta name_table2_row_vram_offset+1

  ;multiply row start y by 32
  lda name_table2_row_vram_offset+1
  asl name_table2_row_vram_offset
  rol
  asl name_table2_row_vram_offset
  rol
  asl name_table2_row_vram_offset
  rol
  asl name_table2_row_vram_offset
  rol
  asl name_table2_row_vram_offset
  rol
  sta name_table2_row_vram_offset+1

  ;add on nametable_vram_offset
  clc
  lda name_table2_row_vram_offset
  adc nametable_vram_offset
  sta name_table2_row_vram_offset
  lda name_table2_row_vram_offset+1
  adc #$00
  sta name_table2_row_vram_offset+1

  ;add on $2400
  clc
  lda name_table2_row_vram_offset
  adc #$00
  sta name_table2_row_vram_offset
  lda name_table2_row_vram_offset+1
  adc #$24
  sta name_table2_row_vram_offset+1

  rts

calculate_nametable_row_params_odd:

  lda #0
  sta name_table2_row_start_x

  sec
  lda #32
  sbc map_x_in_nametable_coordinates
  sta name_table2_row_length

  sec
  lda #34
  sbc name_table2_row_length
  sta name_table1_row_length

  lda name_table2_row_length
  sta name_table1_row_start_x

  ;calculate vram start offset for name_table2. this is $2400 + map_y_in_nametable_coordinates * 32 + map_x_in_nametable_coordinates

  lda map_y_in_nametable_coordinates
  sta name_table2_row_vram_offset
  lda #$00
  sta name_table2_row_vram_offset+1

  ;multiply row start y by 32
  lda name_table2_row_vram_offset+1
  asl name_table2_row_vram_offset
  rol
  asl name_table2_row_vram_offset
  rol
  asl name_table2_row_vram_offset
  rol
  asl name_table2_row_vram_offset
  rol
  asl name_table2_row_vram_offset
  rol
  sta name_table2_row_vram_offset+1

  ;add on map_x_in_nametable_coordinates
  clc
  lda name_table2_row_vram_offset
  adc map_x_in_nametable_coordinates
  sta name_table2_row_vram_offset
  lda name_table2_row_vram_offset+1
  adc #$00
  sta name_table2_row_vram_offset+1

  ;add on nametable_vram_offset
  clc
  lda name_table2_row_vram_offset
  adc nametable_vram_offset
  sta name_table2_row_vram_offset
  lda name_table2_row_vram_offset+1
  adc #$00
  sta name_table2_row_vram_offset+1

  ;add on $2400
  clc
  lda name_table2_row_vram_offset
  adc #$00
  sta name_table2_row_vram_offset
  lda name_table2_row_vram_offset+1
  adc #$24
  sta name_table2_row_vram_offset+1

  ;calculate vram start offset for name_table1. this is $2000 + map_y_in_nametable_coordinates * 32

  lda map_y_in_nametable_coordinates
  sta name_table1_row_vram_offset
  lda #$00
  sta name_table1_row_vram_offset+1

  ;multiply row start y by 32
  lda name_table1_row_vram_offset+1
  asl name_table1_row_vram_offset
  rol
  asl name_table1_row_vram_offset
  rol
  asl name_table1_row_vram_offset
  rol
  asl name_table1_row_vram_offset
  rol
  asl name_table1_row_vram_offset
  rol
  sta name_table1_row_vram_offset+1

  ;add on nametable_vram_offset
  clc
  lda name_table1_row_vram_offset
  adc nametable_vram_offset
  sta name_table1_row_vram_offset
  lda name_table1_row_vram_offset+1
  adc #$00
  sta name_table1_row_vram_offset+1

  ;add on $2000
  clc
  lda name_table1_row_vram_offset
  adc #$00
  sta name_table1_row_vram_offset
  lda name_table1_row_vram_offset+1
  adc #$20
  sta name_table1_row_vram_offset+1

  rts

.endproc

;decodes a column from the map
.proc big_map_decode_column
map_x = w0
map_y = w1
map_x_in_big_metatile_coordinates = w3
map_y_in_big_metatile_coordinates = w4
map_x_in_metatile_coordinates = w5
map_y_in_metatile_coordinates = w6
map_x_in_nametable_coordinates = b2
map_y_in_nametable_coordinates = b3
nametable_vram_offset = b4
odd_nametable_column_flag = b5
odd_metatile_row_flag = b6
odd_metatile_column_flag = b7
nametable_column_buffer_offset = b8
intermediate_attribute_column_buffer_offset = b9
metatile_counter = b10
metatile_index = b11

map_offset = w16

  ;copy various table addresses to zp
  lda metatile_table_attributes_address
  sta metatile_table_attributes_address
  lda metatile_table_attributes_address+1
  sta metatile_table_attributes_address+1

  lda metatile_table_top_left_tiles_address
  sta metatile_table_top_left_tiles_address
  lda metatile_table_top_left_tiles_address+1
  sta metatile_table_top_left_tiles_address+1

  lda metatile_table_top_right_tiles_address
  sta metatile_table_top_right_tiles_address
  lda metatile_table_top_right_tiles_address+1
  sta metatile_table_top_right_tiles_address+1

  lda metatile_table_bottom_left_tiles_address
  sta metatile_table_bottom_left_tiles_address
  lda metatile_table_bottom_left_tiles_address+1
  sta metatile_table_bottom_left_tiles_address+1

  lda metatile_table_bottom_right_tiles_address
  sta metatile_table_bottom_right_tiles_address
  lda metatile_table_bottom_right_tiles_address+1
  sta metatile_table_bottom_right_tiles_address+1

  lda big_metatile_table_top_left_address
  sta big_metatile_table_top_left_address
  lda big_metatile_table_top_left_address+1
  sta big_metatile_table_top_left_address+1

  lda big_metatile_table_top_right_address
  sta big_metatile_table_top_right_address
  lda big_metatile_table_top_right_address+1
  sta big_metatile_table_top_right_address+1

  lda big_metatile_table_bottom_left_address
  sta big_metatile_table_bottom_left_address
  lda big_metatile_table_bottom_left_address+1
  sta big_metatile_table_bottom_left_address+1

  lda big_metatile_table_bottom_right_address
  sta big_metatile_table_bottom_right_address
  lda big_metatile_table_bottom_right_address+1
  sta big_metatile_table_bottom_right_address+1

  ;calculate useful transformations of map_x and map_y
  lda map_x
  sta map_x_in_metatile_coordinates
  lda map_x+1
  sta map_x_in_metatile_coordinates+1

  lda map_y
  sta map_y_in_metatile_coordinates
  lda map_y+1
  sta map_y_in_metatile_coordinates+1

  lda map_x_in_metatile_coordinates
  lsr map_x_in_metatile_coordinates+1
  ror
  lsr map_x_in_metatile_coordinates+1
  ror
  lsr map_x_in_metatile_coordinates+1
  ror
  lsr map_x_in_metatile_coordinates+1
  ror
  sta map_x_in_metatile_coordinates

  lda map_y_in_metatile_coordinates
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  sta map_y_in_metatile_coordinates

  lda map_x_in_metatile_coordinates
  sta map_x_in_big_metatile_coordinates
  lda map_x_in_metatile_coordinates+1
  sta map_x_in_big_metatile_coordinates+1

  lda map_x_in_big_metatile_coordinates
  lsr map_x_in_big_metatile_coordinates+1
  ror
  sta map_x_in_big_metatile_coordinates

  lda map_y_in_metatile_coordinates
  sta map_y_in_big_metatile_coordinates
  lda map_y_in_metatile_coordinates+1
  sta map_y_in_big_metatile_coordinates+1

  lda map_y_in_big_metatile_coordinates
  lsr map_y_in_big_metatile_coordinates+1
  ror
  sta map_y_in_big_metatile_coordinates

  ;calculate map_x_in_nametable_coordinates.
  lda map_x_in_metatile_coordinates
  asl
  and #%00011111
  sta map_x_in_nametable_coordinates

  ;calculate map_y_in_nametable_coordinates

  ;use lo byte of y metatile coord to get mod15 value. only use lo byte,
  ;but this will constrain the vertical height of the map to roughly 18 screens
  ;which should be fine for our purposes.
  ldx map_y_in_metatile_coordinates
  lda mod15lut,x
  asl
  sta map_y_in_nametable_coordinates

  ;calculate nametable_vram_offset. This variable is used to help the vblank
  ;routine determine whether to write the upper or lower portion of a metatile
  ;row.
  lda map_x
  lsr
  lsr
  lsr
  and #$01
.scope
  beq even
odd:
  lda #1
  sta nametable_vram_offset
  lda #1
  sta odd_nametable_column_flag
  jmp done
even:
  lda #0
  sta nametable_vram_offset
  lda #0
  sta odd_nametable_column_flag
done:
.endscope

  ;calculate whether we're on an even or an odd metatile row
  lda map_y_in_metatile_coordinates
  and #$01
.scope
  beq even
odd:
  lda #%00100000
  sta odd_metatile_row_flag
  jmp done
even:
  lda #$00
  sta odd_metatile_row_flag
done:
.endscope

  ;calculate whether we're on an even or an odd metatile column
  lda map_x_in_metatile_coordinates
  and #$01
.scope
  beq even
odd:
  lda #%00100000
  sta odd_metatile_column_flag
  jmp done
even:
  lda #$00
  sta odd_metatile_column_flag
done:
.endscope

; -calculate vram offset for vblank routine
; this is just map_x in nametable coordinates
; plus the base of the nametable we're writing to.

  lda map_x_in_metatile_coordinates
  asl
  and #%00011111
  sta nametable_column_vram_offset
  lda #$00
  sta nametable_column_vram_offset+1

  lda map_x+1
  and #$01
.scope
  beq even
odd:

  ;nametable 2
  clc
  lda nametable_column_vram_offset
  adc #$00
  sta nametable_column_vram_offset
  lda nametable_column_vram_offset+1
  adc #$24
  sta nametable_column_vram_offset+1

  jmp done
even:

  ;nametable 1
  clc
  lda nametable_column_vram_offset
  adc #$00
  sta nametable_column_vram_offset
  lda nametable_column_vram_offset+1
  adc #$20
  sta nametable_column_vram_offset+1

done:
.endscope

  ;add on nametable_vram_offset to get correct column
  clc
  lda nametable_column_vram_offset
  adc nametable_vram_offset
  sta nametable_column_vram_offset
  lda nametable_column_vram_offset+1
  adc #$00
  sta nametable_column_vram_offset+1

  ;calculate map offset
  lda map_y_in_big_metatile_coordinates
  sta map_offset
  lda map_y_in_big_metatile_coordinates+1
  sta map_offset+1

  ;shift map y in big metatile coordinates left by 5 to multiply by 32
  ;after this, map_offset will be the offset of the row
  ;in which we want to begin decoding
  lda map_offset+1
  asl map_offset
  rol
  asl map_offset
  rol
  asl map_offset
  rol
  asl map_offset
  rol
  asl map_offset
  rol
  sta map_offset+1

  ;add on map y in big metatile coordinates
  clc
  lda map_offset
  adc map_x_in_big_metatile_coordinates
  sta map_offset
  lda map_offset+1
  adc map_x_in_big_metatile_coordinates+1
  sta map_offset+1

  ;add on base address of map
  clc
  lda map_offset
  adc map_address
  sta map_offset
  lda map_offset+1
  adc map_address+1
  sta map_offset+1

  ldx map_y_in_metatile_coordinates
  lda mod15lut,x
  sta intermediate_attribute_column_buffer_offset
  asl
  sta nametable_column_buffer_offset

  lda #15
  sta metatile_counter

next_metatile:

  ;load an index into the big metatile arrays from the map
  ldy #0
  lda (map_offset),y
  sta metatile_index

  ldy metatile_index

  lda odd_metatile_row_flag
.scope
  beq even
odd:

  lda odd_metatile_column_flag
.scope
  beq even
odd:

  ;bottom right

  ;lookup little metatile from bottom right of big metatile
  lda (big_metatile_table_bottom_right_address),y
  sta metatile_index

  jmp done
even:

  ;bottom left

  ;lookup little metatile from bottom left of big metatile
  lda (big_metatile_table_bottom_left_address),y
  sta metatile_index

done:
.endscope

  jmp done
even:

  lda odd_metatile_column_flag
.scope
  beq even
odd:

  ;top right

  ;lookup little metatile from top right of big metatile
  lda (big_metatile_table_top_right_address),y
  sta metatile_index

  jmp done
even:

  ;top left

  ;lookup little metatile from top left of big metatile
  lda (big_metatile_table_top_left_address),y
  sta metatile_index

done:
.endscope

done:
.endscope

  ldy metatile_index

  lda odd_nametable_column_flag
  and #%00000001
.scope
  beq even
odd:

  lda (metatile_table_top_right_tiles_address),y
  ldx nametable_column_buffer_offset
  sta nametable_column_buffer,x

  lda (metatile_table_bottom_right_tiles_address),y
  sta nametable_column_buffer+1,x

  jmp done
even:

  lda (metatile_table_top_left_tiles_address),y
  ldx nametable_column_buffer_offset
  sta nametable_column_buffer,x

  lda (metatile_table_bottom_left_tiles_address),y
  sta nametable_column_buffer+1,x

done:
.endscope

  lda (metatile_table_attributes_address),y
  ldx intermediate_attribute_column_buffer_offset
  sta intermediate_attribute_column_buffer,x

  clc
  lda map_offset
  adc odd_metatile_row_flag
  sta map_offset
  lda map_offset+1
  adc #$00
  sta map_offset+1

  ;flip the row even/odd flag
  lda odd_metatile_row_flag
  eor #%00100000
  sta odd_metatile_row_flag

  ;increment offsets in the various buffers
  inc intermediate_attribute_column_buffer_offset
  ldx intermediate_attribute_column_buffer_offset
  lda mod15lut,x
  sta intermediate_attribute_column_buffer_offset
  asl
  sta nametable_column_buffer_offset

  ;loop based on metatile unit counter
  dec metatile_counter
  bne next_metatile

  rts

.endproc

.proc map_process_intermediate_attribute_row_buffer
map_x = w0
map_y = w1
map_x_in_attribute_coordinates = w2
map_y_in_attribute_coordinates = w3
map_x_in_metatile_coordinates = b0
map_y_in_metatile_coordinates = w4
nybble_mask = b4
opposite_nybble_mask = b5
erase_mask = b6
even_odd = b7
new_attribute_value = b8
attribute_row_index = b9
attribute_length_counter = b10
attribute_table_row_address = w5

  ;calculate some useful transformations of map_x and map_y
  ;for later use

  ;only need low byte to get screen attribute and metatile coordinates from X,
  ;since modulus of 16 can be computed so easily this way.
  lda map_x
  lsr
  lsr
  lsr
  lsr
  and #%00001111
  sta map_x_in_metatile_coordinates
  lsr
  sta map_x_in_attribute_coordinates

  ;must use all lower 8 bits of camera y in metatile coordinates in order to look
  ;up modulus of 15 to get correct metatile and attribute Y coordinate for nametable.
  lda map_y
  sta map_y_in_metatile_coordinates
  lda map_y+1
  sta map_y_in_metatile_coordinates+1

  lda map_y_in_metatile_coordinates
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  sta map_y_in_metatile_coordinates

  lda map_y_in_metatile_coordinates
  tax
  lda mod15lut,x
  sta map_y_in_metatile_coordinates
  lsr
  sta map_y_in_attribute_coordinates

; -calculate attribute_table1_row_start_x, attribute_table1_row_start_y,
; attribute_table1_row_length, attribute_table2_row_start_x,
; attribute_table2_row_start_y, and attribute_table2_row_length, based on
; map_x and map_y.

; -calculate current nybble mask for pulling correct nybble out of the
; intermediate attribute row buffer.

.scope
  ;load map_y_in_metatile_coordinates to determine which nybble mask to use
  lda map_y_in_metatile_coordinates
  and #$01
  beq even
odd:

  lda #%11110000
  sta nybble_mask
  eor #$ff
  sta opposite_nybble_mask

  jmp done
even:

  lda #%00001111
  sta nybble_mask
  eor #$ff
  sta opposite_nybble_mask

done:

.endscope

; -calculate current even odd flag for getting the attribute bits pair
; into the right position for "OR"ing into the attribute buffer.

.scope
  ;load map_x_in_metatile_coordinates to determine the shift amount
  lda map_x_in_metatile_coordinates
  and #$01
  beq even
odd:

  lda #$01
  sta even_odd

; -calculate current mask for ANDing out the bits we want to replace
; within the attribute buffer.
  lda #%11001100
  and nybble_mask
  eor #$ff
  sta erase_mask

  jmp done
even:

  lda #$00
  sta even_odd

; -calculate current mask for ANDing out the bits we want to replace
; within the attribute buffer.

  lda #%00110011
  and nybble_mask
  eor #$ff
  sta erase_mask

done:
.endscope

.scope
  ;test hi byte of map_x for even/odd for which nametable to
  ;calculate row variables first.
  lda map_x+1
  and #$01
  beq even
odd:

  ;subtract from 16 to get attribute_table2_row_length
  lda #16
  sec
  sbc map_x_in_metatile_coordinates
  sta attribute_table2_row_length
  ;calculate vram length (divide by 2 to change from metatile to attribute length)
  clc
  adc #$01
  lsr
  sta attribute_table2_row_vram_length

  ;calculate start row offsets for nametable 1 and 2
  lda map_y_in_attribute_coordinates
  asl
  asl
  asl
  sta attribute_table1_row_offset
  clc
  adc map_x_in_attribute_coordinates
  sta attribute_table2_row_offset

  ;calculate vram offset for both attribute tables
  clc
  lda #$C0
  adc attribute_table1_row_offset
  sta attribute_table1_row_vram_offset
  lda #$23
  sta attribute_table1_row_vram_offset+1

  clc
  lda #$C0
  adc attribute_table2_row_offset
  sta attribute_table2_row_vram_offset
  lda #$27
  sta attribute_table2_row_vram_offset+1

  ;now we can easily figure out the length for the opposite nametable

  lda #17
  sec
  sbc attribute_table2_row_length
  sta attribute_table1_row_length
  ;calculate vram length (divide by 2 to change from metatile to attribute length)
  clc
  adc #$01
  lsr
  sta attribute_table1_row_vram_length

  ldx #$00
  jsr process_attribute_table2
  jsr process_attribute_table1

  jmp done
even:

  ;subtract from 16 to get attribute_table1_row_length
  lda #16
  sec
  sbc map_x_in_metatile_coordinates
  sta attribute_table1_row_length

  ;calculate vram length (divide by 2 to change from metatile to attribute length)
  clc
  adc #$01
  lsr
  sta attribute_table1_row_vram_length

  ;calculate start row offsets for nametable 1 and 2
  lda map_y_in_attribute_coordinates
  asl
  asl
  asl
  sta attribute_table2_row_offset
  clc
  adc map_x_in_attribute_coordinates
  sta attribute_table1_row_offset

  ;calculate vram offset for both attribute tables
  clc
  lda #$C0
  adc attribute_table1_row_offset
  sta attribute_table1_row_vram_offset
  lda #$23
  sta attribute_table1_row_vram_offset+1

  clc
  lda #$C0
  adc attribute_table2_row_offset
  sta attribute_table2_row_vram_offset
  lda #$27
  sta attribute_table2_row_vram_offset+1

  ;now we can easily figure out the length for the opposite nametable

  lda #17
  sec
  sbc attribute_table1_row_length
  sta attribute_table2_row_length
  ;calculate vram length (divide by 2 to change from metatile to attribute length)
  clc
  adc #$01
  lsr
  sta attribute_table2_row_vram_length

  ldx #$00
  jsr process_attribute_table1
  jsr process_attribute_table2

done:

.endscope

  rts

process_attribute_table1:

.scope

; start loop (using variables calculated for the first attribute table)

  ; load offset into attribute table1

  lda attribute_table1_row_offset
  sta attribute_row_index

  lda attribute_table1_row_length
  sta attribute_length_counter
  beq skip_intermediate_attribute_row_buffer_loop

intermediate_attribute_row_buffer_loop:

  ; -load intermediate attribute row value.
  lda intermediate_attribute_row_buffer,x

  ; -apply nybble mask.

  and nybble_mask

  ; -store this value temporarily to OR into the attribute table later
  sta new_attribute_value

  ; -we're not done finishing off new_attribute_value, still need to shift
  ; left by shift_amount. Note: Originally we used shift_amount thinking
  ; that asl var would shift by the value in var, but asl only shifts left
  ; by one bit so we use it as a flag, here.
  lda even_odd
  beq do_not_shift_left

  asl new_attribute_value
  asl new_attribute_value

do_not_shift_left:

  ; -load existing attribute byte from attribute table.

  ldy attribute_row_index
  lda attribute_table1,y

  ; -apply erase mask to erase bits we want to replace.

  and erase_mask

  ; -or the bits into the attribute table.

  ora new_attribute_value

  ; -store modified attribute back into the table.

  sta attribute_table1,y

  ; -increment index in intermediate attribute row buffer.
  inx

  clc
  lda attribute_row_index
  adc even_odd
  sta attribute_row_index

  ; -switch to opposite erase mask

  lda erase_mask
  eor #$ff
  ora opposite_nybble_mask
  sta erase_mask

  ; -flip even odd flag

  lda even_odd
  eor #$01
  sta even_odd

  ; -test attribute row index for whether we're done with this loop
  dec attribute_length_counter
  bne intermediate_attribute_row_buffer_loop
skip_intermediate_attribute_row_buffer_loop:
.endscope

  rts

process_attribute_table2:

.scope

  ; load offset into attribute table 2

  lda attribute_table2_row_offset
  sta attribute_row_index

  lda attribute_table2_row_length
  sta attribute_length_counter
  beq skip_intermediate_attribute_row_buffer_loop

; start loop (using variables calculated for the second attribute table)

intermediate_attribute_row_buffer_loop:

  ; -load intermediate attribute row value.
  lda intermediate_attribute_row_buffer,x

  ; -apply nybble mask.

  and nybble_mask

  ; -store this value temporarily to OR into the attribute table later
  sta new_attribute_value

  ; -we're not done finishing off new_attribute_value, still need to shift
  ; left by shift_amount. Note: Originally we used shift_amount thinking
  ; that asl var would shift by the value in var, but asl only shifts left
  ; by one bit so we use it as a flag, here.
  lda even_odd
  beq do_not_shift_left

  asl new_attribute_value
  asl new_attribute_value

do_not_shift_left:

  ; -load existing attribute byte from attribute table.

  ldy attribute_row_index
  lda attribute_table2,y

  ; -apply erase mask to erase bits we want to replace.

  and erase_mask

  ; -or the bits into the attribute table.

  ora new_attribute_value

  ; -store modified attribute back into the table.

  sta attribute_table2,y

  ; -increment index in intermediate attribute row buffer.
  inx

  clc
  lda attribute_row_index
  adc even_odd
  sta attribute_row_index

  ; -switch to opposite erase mask

  lda erase_mask
  eor #$ff
  ora opposite_nybble_mask
  sta erase_mask

  ; -flip even odd flag

  lda even_odd
  eor #$01
  sta even_odd

  ; -test attribute row index for whether we're done with this loop
  dec attribute_length_counter
  bne intermediate_attribute_row_buffer_loop
skip_intermediate_attribute_row_buffer_loop:
.endscope

  rts

.endproc

.proc map_process_intermediate_attribute_column_buffer
map_x = w0
map_y = w1
map_x_in_attribute_coordinates = w2
map_y_in_attribute_coordinates = w3
map_x_in_metatile_coordinates = b0
map_y_in_metatile_coordinates = w4
nybble_mask = b1
original_erase_mask = b2
erase_mask = b3
even_odd = b4
new_attribute_value = b5
intermediate_attribute_column_index = b6
attribute_column_index = b7
attribute_length_counter = b8
attribute_table_column_address = w5
attribute_table_address = w6

  ;calculate some useful transformations of map_x and map_y
  ;for later use

  ;only need low byte to get screen attribute and metatile coordinates from X,
  ;since modulus of 16 can be computed so easily this way.
  lda map_x
  lsr
  lsr
  lsr
  lsr
  and #%00001111
  sta map_x_in_metatile_coordinates
  lsr
  sta map_x_in_attribute_coordinates

  ;must use all lower 8 bits of camera y in metatile coordinates in order to look
  ;up modulus of 15 to get correct metatile and attribute Y coordinate for nametable.
  lda map_y
  sta map_y_in_metatile_coordinates
  lda map_y+1
  sta map_y_in_metatile_coordinates+1

  lda map_y_in_metatile_coordinates
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  lsr map_y_in_metatile_coordinates+1
  ror
  sta map_y_in_metatile_coordinates

  lda map_y_in_metatile_coordinates
  tax
  lda mod15lut,x
  sta map_y_in_metatile_coordinates
  lsr
  sta map_y_in_attribute_coordinates

; -we need to compute the offset from which to begin reading the
; intermediate attribute table column.
  lda map_y_in_metatile_coordinates
  sta intermediate_attribute_column_index

; -we need to compute the offset at which to begin writing to the
; attribute table.
  lda map_y_in_attribute_coordinates
  ;multply by 8 to get correct row
  asl
  asl
  asl
  ;add map_x_in_attribute_coordinates to get correct starting offset
  clc
  adc map_x_in_attribute_coordinates
  sta attribute_column_index

; -we need to determine which attribute table we're writing to. This
; is related to computing the vram offset for the top of an attribute
; table row.
; -we will need to compute the vram offset for the top of an attribute
; table row.

  lda map_x_in_attribute_coordinates
  sta attribute_column_offset

  lda map_x+1
  and #$01
.scope
  beq even
odd:

  clc
  lda #$c0
  adc map_x_in_attribute_coordinates
  sta attribute_column_vram_offset
  lda #$27
  adc #$00
  sta attribute_column_vram_offset+1

  lda #<attribute_table2
  sta attribute_table_address
  lda #>attribute_table2
  sta attribute_table_address+1

  jmp done
even:

  clc
  lda #$c0
  adc map_x_in_attribute_coordinates
  sta attribute_column_vram_offset
  lda #$23
  adc #$00
  sta attribute_column_vram_offset+1

  lda #<attribute_table1
  sta attribute_table_address
  lda #>attribute_table1
  sta attribute_table_address+1

done:
.endscope

; -for even rows, the nybble mask will be 00001111, for odd rows, the
; nybble mask will be 11110000. On each iteration we will flip the nybble
; mask.

  lda map_y_in_metatile_coordinates
  and #$01
.scope
  beq even
odd:

  lda #%11110000
  sta nybble_mask

  jmp done
even:

  lda #%00001111
  sta nybble_mask

done:
.endscope

; -for an even column, the erase mask will be 11001100. For an odd
; column, the erase mask will be 00110011. This will not change inside
; the loop.

; -for an even column, the shift amount will be 0. For an odd column,
; the shift amount will be 2.

; -we will pre-compute a shift amount just once. We won't be flipping it
; every iteration like the row one.

  lda map_x_in_metatile_coordinates
  and #$01
.scope
  beq even
odd:

  lda #%11001100
  sta original_erase_mask
  and nybble_mask
  eor #$ff
  sta erase_mask

  lda #$01
  sta even_odd

  jmp done
even:

  lda #%00110011
  sta original_erase_mask
  and nybble_mask
  eor #$ff
  sta erase_mask

  lda #$00
  sta even_odd

done:
.endscope

; -we will count down from 15
  lda #$0f
  sta attribute_length_counter

loop:

  ; -load intermediate attribute row value.
  ldx intermediate_attribute_column_index
  lda intermediate_attribute_column_buffer,x

  ; -apply nybble mask.

  and nybble_mask

  ; -store this value temporarily to OR into the attribute table later
  sta new_attribute_value

  ; -we're not done finishing off new_attribute_value, still need to shift
  ; left by shift_amount. Note: Originally we used shift_amount thinking
  ; that asl var would shift by the value in var, but asl only shifts left
  ; by one bit so we use it as a flag, here.
  lda even_odd
  beq do_not_shift_left

  asl new_attribute_value
  asl new_attribute_value

do_not_shift_left:

  ; -load existing attribute byte from attribute table.

  ldy attribute_column_index
  lda (attribute_table_address),y

  ; -apply erase mask to erase bits we want to replace.

  and erase_mask

  ; -or the bits into the attribute table.

  ora new_attribute_value

  ; -store modified attribute back into the table.

  sta (attribute_table_address),y

  ; -increment the intermediate attribute column index.
  ; if we wrap, do not negate the nybble mask or erase
  ; mask. if not, negate them.

  inc intermediate_attribute_column_index
  lda intermediate_attribute_column_index
  cmp #15
.scope
  beq wrap
no_wrap:

; -for each row, we'll be negating the nybble mask.
  lda nybble_mask
  eor #$ff
  sta nybble_mask

; -for each row, we need the opposite erase mask
  lda original_erase_mask
  and nybble_mask
  eor #$ff
  sta erase_mask

  jmp done
wrap:

  lda #0
  sta intermediate_attribute_column_index

done:
.endscope

; -use map_y_in_metatile_coordinates to determine which
;  attribute row to write to.

  inc map_y_in_metatile_coordinates
  ldx map_y_in_metatile_coordinates
  lda mod15lut,x
  sta map_y_in_metatile_coordinates
  lsr
  sta map_y_in_attribute_coordinates

  lda map_y_in_attribute_coordinates
  ;multply by 8 to get correct row
  asl
  asl
  asl
  ;add map_x_in_attribute_coordinates to get correct starting offset
  clc
  adc map_x_in_attribute_coordinates
  sta attribute_column_index

  dec attribute_length_counter
  bne loop

  rts
.endproc

sn = 66   ;stationary
vn = 47   ;vertical
hn = 49   ;horizontal
dn = 38   ;diagonal
sp = 178  ;stationary
vp = 159  ;vertical
hp = 161  ;horizontal
dp = 151  ;diagonal
cycle_pad_lut1:
  .byte sp, vp, hp, dp, sn, vn, hn, dn

cycle_pad_lut2:
  .byte sp+1, vp+1, hp, dp, sn, vn, hn, dn

cycle_pad_lut3:
  .byte sp+1, vp+2, hp+3, dp+1, sn, vn+1, hn+1, dn+2

.proc nametable_and_attribute_update_ppu

  .scope
  lda hide_graphics_top
  beq do_not_hide_graphics_top

  ;turn off sprite visibility
  ;clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  ;turn off background visibility
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001
do_not_hide_graphics_top:
  .endscope

  .scope
  lda column_ready
  beq column_nop
  jsr map_upload_column_ppu
  jsr map_upload_attribute_table_column_ppu
column_nop:
  .endscope

  .scope
  lda row_ready
  beq row_nop
  jsr map_upload_row_ppu
  jsr map_upload_attribute_table_row_ppu
row_nop:
  .endscope

  ;pre-calculate the index for the cycle pad lut used
  ;later in the routine. We're also going to use it to
  ;check whether it is safe to upload the palette this
  ;frame (only a row or a column was uploaded but not both)
  lda #0
  sta cycle_pad_lut_index
  lda column_ready
  ror
  rol cycle_pad_lut_index
  lda #0
  sta column_ready

  lda row_ready
  ror
  rol cycle_pad_lut_index
  lda #0
  sta row_ready

  .scope
  lda cycle_pad_lut_index
  cmp #3
  beq not_enough_time_for_palette
  ;save current palette address
  lda palette_address
  pha
  lda palette_address+1
  pha

  lda #<dynamic_palette
  sta palette_address
  lda #>dynamic_palette
  sta palette_address+1

  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  jsr ppu_load_palette_bg

  ;restore previous palette address
  pla
  sta palette_address+1
  pla
  sta palette_address
not_enough_time_for_palette:
  .endscope

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

  .scope
  lda sprites_ready
  beq sprites_not_ready
  jsr sprite_update_all
  lda #0
  sta sprites_ready
  jmp done
sprites_not_ready:
  ldx #108
: dex
  bne :-
done:
  .endscope

  set_vblank_done

  ;cycle pad this ppu upload routine for the artificial scroll
  ;update hiding bar (see the main module)
  clc
  lda cycle_pad_lut_index
  adc cycle_pad_lut_offset
  sta cycle_pad_lut_index
  ldy #3
: ldx cycle_pad_lut_index
  lda cycle_pad_lut1,x
  tax
: dex
  bne :-
  ldx cycle_pad_lut_index
  lda cycle_pad_lut2,x
  tax
: dex
  bne :-
  ldx cycle_pad_lut_index
  lda cycle_pad_lut3,x
  tax
: dex
  bne :-
  dey
  bne :----

  rts

.endproc

.proc nametable_and_attribute_update_ppu_direct

  .scope
  lda column_ready
  beq column_nop
  jsr map_upload_column_ppu
  jsr map_upload_attribute_table_column_ppu
  lda #0
  sta column_ready
column_nop:
  .endscope

  .scope
  lda row_ready
  beq row_nop
  jsr map_upload_row_ppu
  jsr map_upload_attribute_table_row_ppu
  lda #0
  sta row_ready
row_nop:
  .endscope

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

  rts

.endproc

;uploads the contents of the current row buffer to the ppu.
.proc map_upload_row_ppu

  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  lda name_table1_row_vram_offset
  sta ppu_2006+1
  lda name_table1_row_vram_offset+1
  sta ppu_2006

  upload_ppu_2006

  ;copy row buffer directly to nametable
  ldx name_table1_row_start_x
  ldy name_table1_row_length
  beq row1_invisible

.scope
next:

  lda nametable_row_buffer,x
  sta $2007

  inx

  dey
  bne next
.endscope
row1_invisible:

  lda name_table2_row_vram_offset
  sta ppu_2006+1
  lda name_table2_row_vram_offset+1
  sta ppu_2006

  upload_ppu_2006

  ;copy row buffer directly to nametable
  ldx name_table2_row_start_x
  ldy name_table2_row_length
  beq row2_invisible

.scope
next:

  lda nametable_row_buffer,x
  sta $2007

  inx

  dey
  bne next
.endscope
row2_invisible:

  rts

.endproc

;copies nametable_column_buffer to ppu
.proc map_upload_column_ppu

  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  lda nametable_column_vram_offset
  sta ppu_2006+1
  lda nametable_column_vram_offset+1
  sta ppu_2006
  upload_ppu_2006

  ldx #$00
  ldy #30

.scope
loop:
  lda nametable_column_buffer,x
  sta $2007

  inx
  dey
  bne loop
.endscope

  rts

.endproc

.proc map_upload_attribute_table_row_ppu

  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

.scope
  lda attribute_table1_row_vram_offset
  sta ppu_2006+1
  lda attribute_table1_row_vram_offset+1
  sta ppu_2006
  upload_ppu_2006

  ldx attribute_table1_row_offset
  ldy attribute_table1_row_vram_length
  beq done
loop:

  lda attribute_table1,x
  sta $2007

  inx
  dey
  bne loop
done:
.endscope

.scope
  lda attribute_table2_row_vram_offset
  sta ppu_2006+1
  lda attribute_table2_row_vram_offset+1
  sta ppu_2006
  upload_ppu_2006

  ldx attribute_table2_row_offset
  ldy attribute_table2_row_vram_length
  beq done
loop:

  lda attribute_table2,x
  sta $2007

  inx
  dey
  bne loop
done:
.endscope

  rts

.endproc

.proc map_upload_attribute_table_column_ppu

  lda attribute_column_vram_offset
  sta ppu_2006+1
  lda attribute_column_vram_offset+1
  sta ppu_2006
  upload_ppu_2006

  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  lda attribute_column_vram_offset+1
  cmp #$27
.scope
  bne :+
  jmp  write_to_attribute_table2
:
write_to_attribute_table1:

  ldy attribute_column_offset
  lda attribute_table1,y
  sta $2007
  lda attribute_table1+32,y
  sta $2007

  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  upload_ppu_2006

  lda attribute_table1+8,y
  sta $2007
  lda attribute_table1+(32+8),y
  sta $2007

  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  upload_ppu_2006

  lda attribute_table1+(8*2),y
  sta $2007
  lda attribute_table1+(32+8*2),y
  sta $2007

  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  upload_ppu_2006

  lda attribute_table1+(8*3),y
  sta $2007
  lda attribute_table1+(32+8*3),y
  sta $2007

  jmp done
write_to_attribute_table2:

  ldy attribute_column_offset
  lda attribute_table2,y
  sta $2007
  lda attribute_table2+32,y
  sta $2007

  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  upload_ppu_2006

  lda attribute_table2+8,y
  sta $2007
  lda attribute_table2+(32+8),y
  sta $2007

  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  upload_ppu_2006

  lda attribute_table2+(8*2),y
  sta $2007
  lda attribute_table2+(32+8*2),y
  sta $2007

  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  upload_ppu_2006

  lda attribute_table2+(8*3),y
  sta $2007
  lda attribute_table2+(32+8*3),y
  sta $2007

done:
.endscope

  rts

.endproc
