.include "map.inc"
.include "ram.inc"
.include "zp.inc"
.include "ppu.inc"
.include "controller.inc"

.segment "CODE"

;lut for modulus of 15, used for quickly computing correct attribute and nametable rows
mod15lut:
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  .byte 0

.proc decompress_rle_map
rle_compressed_map_address = w0
current_map_value = b0
decompressed_map_offset = w1

  ;point at beginning of decompressed map
  lda #<decompressed_map
  sta decompressed_map_offset
  lda #>decompressed_map
  sta decompressed_map_offset+1
  
  ;index is always 0, we're moving 16 bit pointers around in this routine
  ldy #0
  
next_rle:
  ;get a value from the rle compressed map
  lda (rle_compressed_map_address),y
  sta current_map_value
  
  ;test the rle flag
  lda current_map_value
  and #$80
  beq value_only
value_and_count:

  ;erase rle flag
  lda current_map_value
  and #$7f
  sta current_map_value
  
  ;increment pointer into rle map to get count
  clc
  lda rle_compressed_map_address
  adc #$01
  sta rle_compressed_map_address
  lda rle_compressed_map_address+1
  adc #$00
  sta rle_compressed_map_address+1
  
  ;get count
  lda (rle_compressed_map_address),y
  tax

: lda current_map_value
  sta (decompressed_map_offset),y
  
  ;move along in the decompressed map
  clc
  lda decompressed_map_offset
  adc #$01
  sta decompressed_map_offset
  lda decompressed_map_offset+1
  adc #$00
  sta decompressed_map_offset+1
  
  dex
  bne :-
  
  ;increment pointer into rle map to get next value
  clc
  lda rle_compressed_map_address
  adc #$01
  sta rle_compressed_map_address
  lda rle_compressed_map_address+1
  adc #$00
  sta rle_compressed_map_address+1
  
  jmp done
value_only:

  lda current_map_value
  sta (decompressed_map_offset),y
  
  ;move along in the decompressed map
  clc
  lda decompressed_map_offset
  adc #$01
  sta decompressed_map_offset
  lda decompressed_map_offset+1
  adc #$00
  sta decompressed_map_offset+1
  
  ;increment pointer into rle map to get next value
  clc
  lda rle_compressed_map_address
  adc #$01
  sta rle_compressed_map_address
  lda rle_compressed_map_address+1
  adc #$00
  sta rle_compressed_map_address+1

done:

  lda decompressed_map_offset
  cmp #<decompressed_map_end
  bne next_rle
  lda decompressed_map_offset+1
  cmp #>decompressed_map_end
  bne next_rle
  
  rts

.endproc
  
.proc horizontal_scrolling_test

loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  lda #1
  sta b0
  jsr increment_camera_x
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp loop

.endproc

.proc fill_nametable_columns

  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  clc
  lda camera_x
  adc #$08
  sta camera_x
  lda camera_x+1
  adc #$00
  sta camera_x+1

  lda camera_x+1
  cmp #1
  bne :+
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  rts
:
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp :--

  rts

.endproc
  
.proc fill_nametable_rows

fill_nametable_loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  clc
  lda camera_y
  adc #$08
  sta camera_y
  lda camera_y+1
  adc #$00
  sta camera_y+1
  
  lda camera_y
  cmp #240
  beq bottom_row
not_bottom_row:
  
  jmp done
bottom_row:

  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready

  rts

done:
  
  ; clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  ; upload_ppu_2001
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready

  jmp fill_nametable_loop

.endproc

.proc vertical_scrolling_test

  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  lda #1
  sta b0
  jsr increment_camera_y
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
    
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp :-

.endproc

;assumes b0 to contain amount to increment camera x by
;assumes b0 to be a power of 2
.proc increment_camera_x

  ;increment camera x
  lda camera_x+1
  cmp #3
  bne :+
  lda camera_x
  cmp #0
  beq :++
:
  clc
  lda camera_x
  adc b0
  sta camera_x
  lda camera_x+1
  adc #$00
  sta camera_x+1
  
  jsr increment_camera_scroll_x
:
  
  rts

.endproc

;assumes b0 to contain amount to decrement camera x by
;assumes b0 to be a power of 2
.proc decrement_camera_x

  ;decrement camera x
  lda camera_x+1
  bne :+
  lda camera_x
  beq :++
:
  sec
  lda camera_x
  sbc b0
  sta camera_x
  lda camera_x+1
  sbc #$00
  sta camera_x+1
  
  jsr decrement_camera_scroll_x
:
  
  rts

.endproc

;assumes b0 to contain amount to increment camera y by
;assumes b0 to be a power of 2
.proc increment_camera_y

  ;increment camera y
  lda camera_y+1
  cmp #3
  bne :+
  lda camera_y
  cmp #32
  beq :++
:
  clc
  lda camera_y
  adc b0
  sta camera_y
  lda camera_y+1
  adc #$00
  sta camera_y+1
  
  jsr increment_camera_scroll_y
:

  rts

.endproc

;assumes b0 to contain amount to decrement camera y by
;assumes b0 to be a power of 2
.proc decrement_camera_y

  ;decrement camera y
  lda camera_y+1
  cmp #$00
  bne :+
  lda camera_y
  cmp #$00
  beq :++
:
  sec
  lda camera_y
  sbc b0
  sta camera_y
  lda camera_y+1
  sbc #$00
  sta camera_y+1
  
  jsr decrement_camera_scroll_y
:
  
  rts

.endproc

;assumes b0 to contain amount to increment camera scroll x by
;assumes b0 to be a power of 2
.proc increment_camera_scroll_x

  ;increment camera x scroll
  clc
  lda camera_scroll_x
  adc b0
  sta camera_scroll_x
  bcc :+
  ;flip the nametable bit
  lda camera_nametable_hibyte
  eor #%00000100
  sta camera_nametable_hibyte
:

  rts

.endproc

;assumes b0 to contain amount to decrement camera scroll x by
;assumes b0 to be a power of 2
.proc decrement_camera_scroll_x

  ;decrement camera x scroll
  sec
  lda camera_scroll_x
  sbc b0
  sta camera_scroll_x
  bcs :+
  ;flip the nametable bit
  lda camera_nametable_hibyte
  eor #%00000100
  sta camera_nametable_hibyte
:

  rts

.endproc

;assumes b0 to contain amount to increment camera scroll y by
;assumes b0 to be a power of 2
.proc increment_camera_scroll_y

  ;increment camera y scroll
  clc
  lda camera_scroll_y
  adc b0
  sta camera_scroll_y
  
  sec
  lda camera_scroll_y
  sbc #240
  lda #0
  sbc #0
  bmi :+
  
  lda camera_scroll_y
  sbc #240
  sta camera_scroll_y
:

  rts

.endproc

;assumes b0 to contain amount to decrement camera scroll y by
;assumes b0 to be a power of 2
.proc decrement_camera_scroll_y

  ;decrement camera y scroll
  sec
  lda camera_scroll_y
  sbc b0
  sta camera_scroll_y
  bcs :+
  
  clc
  lda #240
  adc camera_scroll_y
  sta camera_scroll_y
  
:
  
  rts

.endproc

.proc fourway_scrolling_test
SPEED = 4

  lda #(16*0)
  sta camera_x
  lda #0
  sta camera_x+1
  lda #(16*0)
  sta camera_y
  lda #0
  sta camera_y+1

loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-

  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  
  jsr controller_read
  
  lda buffer_controller+buttons::_up
  and buffer_controller+buttons::_right
  and #$01
  bne up_and_right
  
  lda buffer_controller+buttons::_up
  and buffer_controller+buttons::_left
  and #$01
  bne up_and_left
  
  lda buffer_controller+buttons::_down
  and buffer_controller+buttons::_right
  and #$01
  bne down_and_right
  
  lda buffer_controller+buttons::_down
  and buffer_controller+buttons::_left
  and #$01
  bne down_and_left
  
  lda buffer_controller+buttons::_right
  and #$01
  bne right
  
  lda buffer_controller+buttons::_left
  and #$01
  bne left
  
  lda buffer_controller+buttons::_up
  and #$01
  bne up
  
  lda buffer_controller+buttons::_down
  and #$01
  bne down
  
up_and_right:

  jsr up_and_right_handler

  jmp done_scrolling

up_and_left:

  jsr up_and_left_handler
  
  jmp done_scrolling
  
down_and_right:

  jsr down_and_right_handler
  
  jmp done_scrolling
  
down_and_left:

  jsr down_and_left_handler
  
  jmp done_scrolling
  
right:

  jsr right_handler
  
  jmp done_scrolling
  
left:

  jsr left_handler
  
  jmp done_scrolling
  
up:

  jsr up_handler
 
  jmp done_scrolling
  
down:

  jsr down_handler
  
  jmp done_scrolling
  
done_scrolling:
  
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp loop

.proc right_handler

  lda #SPEED
  sta b0
  jsr increment_camera_x
  
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
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  rts
  
.endproc
  
.proc left_handler

  lda #SPEED
  sta b0
  jsr decrement_camera_x
  
  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  rts
  
.endproc
  
.proc up_handler

  lda #SPEED
  sta b0
  jsr decrement_camera_y
  
  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  rts
  
.endproc
  
.proc down_handler

  lda #SPEED
  sta b0
  jsr increment_camera_y
  
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
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready

  rts
  
.endproc
  
.proc up_and_right_handler

  lda buffer_controller+buttons::_right
  and #$01
  beq not_right_and_up
  lda buffer_controller+buttons::_up
  and #$01
  beq not_right_and_up
  ;right and up
  
  lda #SPEED
  sta b0
  jsr increment_camera_x
  
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
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #SPEED
  sta b0
  jsr decrement_camera_y
  
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
not_right_and_up:

  rts

.endproc
  
.proc up_and_left_handler

  lda buffer_controller+buttons::_left
  and #$01
  beq not_left_and_up
  lda buffer_controller+buttons::_up
  and #$01
  beq not_left_and_up
  ;left and up
  
  lda #SPEED
  sta b0
  jsr decrement_camera_x
  
  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$00
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #SPEED
  sta b0
  jsr decrement_camera_y
  
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
not_left_and_up:

  rts

.endproc
  
.proc down_and_right_handler

  lda buffer_controller+buttons::_right
  and #$01
  beq not_right_and_down
  lda buffer_controller+buttons::_down
  and #$01
  beq not_right_and_down
  ;right and down
  
  lda #SPEED
  sta b0
  jsr increment_camera_x
  
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
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #SPEED
  sta b0
  jsr increment_camera_y
  
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
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
not_right_and_down:

  rts

.endproc
  
.proc down_and_left_handler

  lda buffer_controller+buttons::_left
  and #$01
  beq not_left_and_down
  lda buffer_controller+buttons::_down
  and #$01
  beq not_left_and_down
  ;left and down
  
  lda #SPEED
  sta b0
  jsr decrement_camera_x
  
  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$00
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #SPEED
  sta b0
  jsr increment_camera_y
  
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
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
not_left_and_down:

  rts
  
.endproc
  
.endproc
  
.proc nametable_and_attribute_update_ppu

  lda vblank_data_ready
  beq data_not_ready
  
  lda column_ready
  beq :+
  jsr map_upload_column_ppu
  jsr map_upload_attribute_table_column_ppu
  lda #0
  sta column_ready
:
  
  lda row_ready
  beq :+
  jsr map_upload_row_ppu
  jsr map_upload_attribute_table_row_ppu
  lda #0
  sta row_ready
:
  
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
  
  lda #0
  sta vblank_data_ready
  
data_not_ready:

  rts

.endproc

map_decode_row = big_map_decode_row_decompressed
;map_decode_row = map_decode_row_uncompressed
map_decode_column = big_map_decode_column_decompressed
;map_decode_column = map_decode_column_uncompressed

;decodes a single row of metatiles from a big (4 screen by 4 screen)
;decompressed map stored at decompressed_map in ram
.proc big_map_decode_row_decompressed
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

metatile_table_attributes_address_zp = w7
metatile_table_top_left_tiles_address_zp = w8
metatile_table_top_right_tiles_address_zp = w9
metatile_table_bottom_left_tiles_address_zp = w10
metatile_table_bottom_right_tiles_address_zp = w11
big_metatile_table_top_left_address_zp = w12
big_metatile_table_top_right_address_zp = w13
big_metatile_table_bottom_left_address_zp = w14
big_metatile_table_bottom_right_address_zp = w15

decompressed_map_offset = w16

  ;copy various table addresses to zp
  lda metatile_table_attributes_address
  sta metatile_table_attributes_address_zp
  lda metatile_table_attributes_address+1
  sta metatile_table_attributes_address_zp+1

  lda metatile_table_top_left_tiles_address
  sta metatile_table_top_left_tiles_address_zp
  lda metatile_table_top_left_tiles_address+1
  sta metatile_table_top_left_tiles_address_zp+1

  lda metatile_table_top_right_tiles_address
  sta metatile_table_top_right_tiles_address_zp
  lda metatile_table_top_right_tiles_address+1
  sta metatile_table_top_right_tiles_address_zp+1

  lda metatile_table_bottom_left_tiles_address
  sta metatile_table_bottom_left_tiles_address_zp
  lda metatile_table_bottom_left_tiles_address+1
  sta metatile_table_bottom_left_tiles_address_zp+1
  
  lda metatile_table_bottom_right_tiles_address
  sta metatile_table_bottom_right_tiles_address_zp
  lda metatile_table_bottom_right_tiles_address+1
  sta metatile_table_bottom_right_tiles_address_zp+1
  
  lda big_metatile_table_top_left_address
  sta big_metatile_table_top_left_address_zp
  lda big_metatile_table_top_left_address+1
  sta big_metatile_table_top_left_address_zp+1
  
  lda big_metatile_table_top_right_address
  sta big_metatile_table_top_right_address_zp
  lda big_metatile_table_top_right_address+1
  sta big_metatile_table_top_right_address_zp+1
  
  lda big_metatile_table_bottom_left_address
  sta big_metatile_table_bottom_left_address_zp
  lda big_metatile_table_bottom_left_address+1
  sta big_metatile_table_bottom_left_address_zp+1
  
  lda big_metatile_table_bottom_right_address
  sta big_metatile_table_bottom_right_address_zp
  lda big_metatile_table_bottom_right_address+1
  sta big_metatile_table_bottom_right_address_zp+1
  
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
  sta decompressed_map_offset
  lda map_y_in_big_metatile_coordinates+1
  sta decompressed_map_offset+1
  
  ;shift map y in big metatile coordinates left by 5 to multiply by 32
  ;after this, decompressed_map_offset will be the offset of the row
  ;in which we want to begin decoding
  lda decompressed_map_offset+1
  asl decompressed_map_offset
  rol
  asl decompressed_map_offset
  rol
  asl decompressed_map_offset
  rol
  asl decompressed_map_offset
  rol
  asl decompressed_map_offset
  rol
  sta decompressed_map_offset+1
  
  ;add on map y in big metatile coordinates
  clc
  lda decompressed_map_offset
  adc map_x_in_big_metatile_coordinates
  sta decompressed_map_offset
  lda decompressed_map_offset+1
  adc map_x_in_big_metatile_coordinates+1
  sta decompressed_map_offset+1
  
  ;add on base address of decompressed map
  clc
  lda decompressed_map_offset
  adc #<decompressed_map
  sta decompressed_map_offset
  lda decompressed_map_offset+1
  adc #>decompressed_map
  sta decompressed_map_offset+1
  
  lda #0
  sta nametable_row_buffer_offset
  sta intermediate_attribute_row_buffer_offset
  lda #17
  sta metatile_counter
  
next_metatile:
  
  ;load an index into the big metatile arrays from the decompressed map
  ldy #0
  lda (decompressed_map_offset),y
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
  lda (big_metatile_table_bottom_right_address_zp),y
  sta metatile_index
  
  jmp done
even:

  ;bottom left

  ;lookup little metatile from bottom left of big metatile
  ldy metatile_index
  lda (big_metatile_table_bottom_left_address_zp),y
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
  lda (big_metatile_table_top_right_address_zp),y
  sta metatile_index
  
  jmp done
even:

  ;top left

  ;lookup little metatile from top left of big metatile
  ldy metatile_index
  lda (big_metatile_table_top_left_address_zp),y
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
  lda (metatile_table_bottom_left_tiles_address_zp),y
  ldx nametable_row_buffer_offset
  sta nametable_row_buffer,x
  
  lda (metatile_table_bottom_right_tiles_address_zp),y
  sta nametable_row_buffer+1,x

  jmp done
even:

  ldy metatile_index
  lda (metatile_table_top_left_tiles_address_zp),y
  ldx nametable_row_buffer_offset
  sta nametable_row_buffer,x
  
  lda (metatile_table_top_right_tiles_address_zp),y
  sta nametable_row_buffer+1,x

done:
.endscope
  
  ldy metatile_index
  lda (metatile_table_attributes_address_zp),y
  ldx intermediate_attribute_row_buffer_offset
  sta intermediate_attribute_row_buffer,x
  
  clc
  lda decompressed_map_offset
  adc odd_metatile_column_flag
  sta decompressed_map_offset
  lda decompressed_map_offset+1
  adc #$00
  sta decompressed_map_offset+1
  
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

.proc calculate_nametable_row_params_even

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

.endproc
  
.proc calculate_nametable_row_params_odd

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
  
.endproc

;decodes a column from the decompressed map
.proc big_map_decode_column_decompressed
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

metatile_table_attributes_address_zp = w7
metatile_table_top_left_tiles_address_zp = w8
metatile_table_top_right_tiles_address_zp = w9
metatile_table_bottom_left_tiles_address_zp = w10
metatile_table_bottom_right_tiles_address_zp = w11
big_metatile_table_top_left_address_zp = w12
big_metatile_table_top_right_address_zp = w13
big_metatile_table_bottom_left_address_zp = w14
big_metatile_table_bottom_right_address_zp = w15

decompressed_map_offset = w16

  ;copy various table addresses to zp
  lda metatile_table_attributes_address
  sta metatile_table_attributes_address_zp
  lda metatile_table_attributes_address+1
  sta metatile_table_attributes_address_zp+1

  lda metatile_table_top_left_tiles_address
  sta metatile_table_top_left_tiles_address_zp
  lda metatile_table_top_left_tiles_address+1
  sta metatile_table_top_left_tiles_address_zp+1

  lda metatile_table_top_right_tiles_address
  sta metatile_table_top_right_tiles_address_zp
  lda metatile_table_top_right_tiles_address+1
  sta metatile_table_top_right_tiles_address_zp+1

  lda metatile_table_bottom_left_tiles_address
  sta metatile_table_bottom_left_tiles_address_zp
  lda metatile_table_bottom_left_tiles_address+1
  sta metatile_table_bottom_left_tiles_address_zp+1
  
  lda metatile_table_bottom_right_tiles_address
  sta metatile_table_bottom_right_tiles_address_zp
  lda metatile_table_bottom_right_tiles_address+1
  sta metatile_table_bottom_right_tiles_address_zp+1
  
  lda big_metatile_table_top_left_address
  sta big_metatile_table_top_left_address_zp
  lda big_metatile_table_top_left_address+1
  sta big_metatile_table_top_left_address_zp+1
  
  lda big_metatile_table_top_right_address
  sta big_metatile_table_top_right_address_zp
  lda big_metatile_table_top_right_address+1
  sta big_metatile_table_top_right_address_zp+1
  
  lda big_metatile_table_bottom_left_address
  sta big_metatile_table_bottom_left_address_zp
  lda big_metatile_table_bottom_left_address+1
  sta big_metatile_table_bottom_left_address_zp+1
  
  lda big_metatile_table_bottom_right_address
  sta big_metatile_table_bottom_right_address_zp
  lda big_metatile_table_bottom_right_address+1
  sta big_metatile_table_bottom_right_address_zp+1
  
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
  sta decompressed_map_offset
  lda map_y_in_big_metatile_coordinates+1
  sta decompressed_map_offset+1
  
  ;shift map y in big metatile coordinates left by 5 to multiply by 32
  ;after this, decompressed_map_offset will be the offset of the row
  ;in which we want to begin decoding
  lda decompressed_map_offset+1
  asl decompressed_map_offset
  rol
  asl decompressed_map_offset
  rol
  asl decompressed_map_offset
  rol
  asl decompressed_map_offset
  rol
  asl decompressed_map_offset
  rol
  sta decompressed_map_offset+1
  
  ;add on map y in big metatile coordinates
  clc
  lda decompressed_map_offset
  adc map_x_in_big_metatile_coordinates
  sta decompressed_map_offset
  lda decompressed_map_offset+1
  adc map_x_in_big_metatile_coordinates+1
  sta decompressed_map_offset+1
  
  ;add on base address of decompressed map
  clc
  lda decompressed_map_offset
  adc #<decompressed_map
  sta decompressed_map_offset
  lda decompressed_map_offset+1
  adc #>decompressed_map
  sta decompressed_map_offset+1
  
  ldx map_y_in_metatile_coordinates
  lda mod15lut,x
  sta intermediate_attribute_column_buffer_offset
  asl
  sta nametable_column_buffer_offset

  lda #15
  sta metatile_counter
  
next_metatile:
  
  ;load an index into the big metatile arrays from the decompressed map
  ldy #0
  lda (decompressed_map_offset),y
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
  lda (big_metatile_table_bottom_right_address_zp),y
  sta metatile_index
  
  jmp done
even:

  ;bottom left

  ;lookup little metatile from bottom left of big metatile
  lda (big_metatile_table_bottom_left_address_zp),y
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
  lda (big_metatile_table_top_right_address_zp),y
  sta metatile_index
  
  jmp done
even:

  ;top left

  ;lookup little metatile from top left of big metatile
  lda (big_metatile_table_top_left_address_zp),y
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

  lda (metatile_table_top_right_tiles_address_zp),y
  ldx nametable_column_buffer_offset
  sta nametable_column_buffer,x
  
  lda (metatile_table_bottom_right_tiles_address_zp),y
  sta nametable_column_buffer+1,x

  jmp done
even:

  lda (metatile_table_top_left_tiles_address_zp),y
  ldx nametable_column_buffer_offset
  sta nametable_column_buffer,x
  
  lda (metatile_table_bottom_left_tiles_address_zp),y
  sta nametable_column_buffer+1,x

done:
.endscope
  
  lda (metatile_table_attributes_address_zp),y
  ldx intermediate_attribute_column_buffer_offset
  sta intermediate_attribute_column_buffer,x
  
  clc
  lda decompressed_map_offset
  adc odd_metatile_row_flag
  sta decompressed_map_offset
  lda decompressed_map_offset+1
  adc #$00
  sta decompressed_map_offset+1
  
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

;decodes a single row of the map into buffers to be consumed by nmi
.proc map_decode_row_uncompressed
map_x = w0
map_y = w1
local_map_offset = w2
metatile_index = b0
metatile_address = w3
map_row_offset = b1
map_x_in_metatile_coordinates = w4
map_y_in_metatile_coordinates = w5
map_x_in_nametable_coordinates = b2
map_y_in_nametable_coordinates = b3
nametable_vram_offset = b4
odd_row_flag = b5

metatile_table_attributes_address_zp = w6
metatile_table_top_left_tiles_address_zp = w7
metatile_table_top_right_tiles_address_zp = w8
metatile_table_bottom_left_tiles_address_zp = w9
metatile_table_bottom_right_tiles_address_zp = w10

  ;copy various table addresses to zp
  lda metatile_table_attributes_address
  sta metatile_table_attributes_address_zp
  lda metatile_table_attributes_address+1
  sta metatile_table_attributes_address_zp+1

  lda metatile_table_top_left_tiles_address
  sta metatile_table_top_left_tiles_address_zp
  lda metatile_table_top_left_tiles_address+1
  sta metatile_table_top_left_tiles_address_zp+1

  lda metatile_table_top_right_tiles_address
  sta metatile_table_top_right_tiles_address_zp
  lda metatile_table_top_right_tiles_address+1
  sta metatile_table_top_right_tiles_address_zp+1

  lda metatile_table_bottom_left_tiles_address
  sta metatile_table_bottom_left_tiles_address_zp
  lda metatile_table_bottom_left_tiles_address+1
  sta metatile_table_bottom_left_tiles_address_zp+1
  
  lda metatile_table_bottom_right_tiles_address
  sta metatile_table_bottom_right_tiles_address_zp
  lda metatile_table_bottom_right_tiles_address+1
  sta metatile_table_bottom_right_tiles_address_zp+1
  
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
  sta odd_row_flag
  jmp done
even:
  lda #0
  sta nametable_vram_offset
  lda #0
  sta odd_row_flag
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
  
  ;calculate local_map_offset using map_address, map_x_in_metatile_coordinates, map_y_in_metatile_coordinates
  
  lda map_y_in_metatile_coordinates
  sta local_map_offset
  lda map_y_in_metatile_coordinates+1
  sta local_map_offset+1
  
  ;shift left local map offset by 6 to multiply by 64
  
  lda local_map_offset+1
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  sta local_map_offset+1
  
  ;add on map_x_in_metatile_coordinates
  clc
  lda local_map_offset
  adc map_x_in_metatile_coordinates
  sta local_map_offset
  lda local_map_offset+1
  adc map_x_in_metatile_coordinates+1
  sta local_map_offset+1
  
  ;add on map base address
  clc
  lda local_map_offset
  adc map_address
  sta local_map_offset
  lda local_map_offset+1
  adc map_address+1
  sta local_map_offset+1
  
  ;now we can read from map using local_map_offset

  ;initialize map row offset
  lda #0
  sta map_row_offset
  
  ;init x, we are using it to count nametable tiles
  ldx #0
  
  lda odd_row_flag
  cmp #1
  beq bottom_row
top_row:
  
.scope
next:

  ;load metatile index from current local map offset
  ldy map_row_offset
  lda (local_map_offset),y
  sta metatile_index
  
  ;load the attribute
  ldy metatile_index
  lda (metatile_table_attributes_address_zp),y
  
  ldy map_row_offset
  sta intermediate_attribute_row_buffer,y
  
  ;load the top left and top right tiles
  ldy metatile_index
  lda (metatile_table_top_left_tiles_address_zp),y
  sta nametable_row_buffer,x
  lda (metatile_table_top_right_tiles_address_zp),y
  sta nametable_row_buffer+1,x
  
  ;advance to next tile
  inc map_row_offset
  
  ;move over two nametable tiles
  inx
  inx
  cpx #34
  bne next
.endscope
  
  rts
bottom_row:
.scope
next:

  ;load metatile index from current local map offset
  ldy map_row_offset
  lda (local_map_offset),y
  sta metatile_index
  
  ;load the attribute
  ldy metatile_index
  lda (metatile_table_attributes_address_zp),y
  
  ldy map_row_offset
  sta intermediate_attribute_row_buffer,y
  
  ;load the top left and top right tiles
  ldy metatile_index
  lda (metatile_table_bottom_left_tiles_address_zp),y
  sta nametable_row_buffer,x
  lda (metatile_table_bottom_right_tiles_address_zp),y
  sta nametable_row_buffer+1,x

  ;advance to next tile
  inc map_row_offset
  
  ;move over two nametable tiles
  inx
  inx
  cpx #34
  bne next
.endscope

  rts
  
.proc calculate_nametable_row_params_even

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

.endproc
  
.proc calculate_nametable_row_params_odd

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
  
.endproc
  
;copies a single column of metatiles from the map to column buffers.
.proc map_decode_column_uncompressed
map_x = w0
map_y = w1
local_map_offset = w2
metatile_index = b0
metatile_address = w3
nametable_column_buffer_offset = b1
intermediate_attribute_column_buffer_offset = b2
loop_counter = b3
map_x_in_metatile_coordinates = w4
map_y_in_metatile_coordinates = w5
nametable_vram_offset = b4
odd_column_flag = b5

metatile_table_attributes_address_zp = w6
metatile_table_top_left_tiles_address_zp = w7
metatile_table_top_right_tiles_address_zp = w8
metatile_table_bottom_left_tiles_address_zp = w9
metatile_table_bottom_right_tiles_address_zp = w10

  ;copy various table addresses to zp
  lda metatile_table_attributes_address
  sta metatile_table_attributes_address_zp
  lda metatile_table_attributes_address+1
  sta metatile_table_attributes_address_zp+1

  lda metatile_table_top_left_tiles_address
  sta metatile_table_top_left_tiles_address_zp
  lda metatile_table_top_left_tiles_address+1
  sta metatile_table_top_left_tiles_address_zp+1

  lda metatile_table_top_right_tiles_address
  sta metatile_table_top_right_tiles_address_zp
  lda metatile_table_top_right_tiles_address+1
  sta metatile_table_top_right_tiles_address_zp+1

  lda metatile_table_bottom_left_tiles_address
  sta metatile_table_bottom_left_tiles_address_zp
  lda metatile_table_bottom_left_tiles_address+1
  sta metatile_table_bottom_left_tiles_address_zp+1
  
  lda metatile_table_bottom_right_tiles_address
  sta metatile_table_bottom_right_tiles_address_zp
  lda metatile_table_bottom_right_tiles_address+1
  sta metatile_table_bottom_right_tiles_address_zp+1

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
  sta odd_column_flag

  jmp done
even:

  lda #0
  sta nametable_vram_offset
  lda #0
  sta odd_column_flag

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
  
; -we need to calculate start map offset.

  ;calculate local_map_offset using map_address, map_x_in_metatile_coordinates, map_y_in_metatile_coordinates
  
  lda map_y_in_metatile_coordinates
  sta local_map_offset
  lda map_y_in_metatile_coordinates+1
  sta local_map_offset+1
  
  ;shift left local map offset by 6 to multiply by 64
  
  lda local_map_offset+1
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  asl local_map_offset
  rol
  sta local_map_offset+1
  
  ;add on map_x_in_metatile_coordinates
  clc
  lda local_map_offset
  adc map_x_in_metatile_coordinates
  sta local_map_offset
  lda local_map_offset+1
  adc map_x_in_metatile_coordinates+1
  sta local_map_offset+1
  
  ;add on map base address
  clc
  lda local_map_offset
  adc map_address
  sta local_map_offset
  lda local_map_offset+1
  adc map_address+1
  sta local_map_offset+1

; -we need to calculate start offset within the nametable_column_buffer
; and the intermediate_attribute_column_buffer.

  ldx map_y_in_metatile_coordinates
  lda mod15lut,x
  sta intermediate_attribute_column_buffer_offset
  asl
  sta nametable_column_buffer_offset

  lda #$0f
  sta loop_counter
  
  lda odd_column_flag
  cmp #0
  beq even_column
odd_column:

.scope
loop:
  
; -on every iteration, we need to calculate the meta tile address from
; the index read from the map.
  ldy #$00
  lda (local_map_offset),y
  sta metatile_index
  
; -on every iteration, we need to copy tile and attribute data from the
; map to the column buffers.

  ;get attribute
  ldy metatile_index
  lda (metatile_table_attributes_address_zp),y
  
  ldx intermediate_attribute_column_buffer_offset
  sta intermediate_attribute_column_buffer,x
  
  lda (metatile_table_top_right_tiles_address_zp),y
  ldx nametable_column_buffer_offset
  sta nametable_column_buffer,x
  
  lda (metatile_table_bottom_right_tiles_address_zp),y
  ldx nametable_column_buffer_offset
  sta nametable_column_buffer+1,x

; -on every iteration, we need to add map_width to the map offset to get to
; the next row.

  clc
  lda local_map_offset
  adc map_width
  sta local_map_offset
  lda local_map_offset+1
  adc #$00
  sta local_map_offset+1

; -on every iteration, we need to increment row counters for the column
; buffers and add logic for wrapping

  inc intermediate_attribute_column_buffer_offset
  
  ldx intermediate_attribute_column_buffer_offset
  lda mod15lut,x
  sta intermediate_attribute_column_buffer_offset
  
  ;these offsets move in lock step anyway, just quickly calculate the
  ;nametable column buffer offset
  asl
  sta nametable_column_buffer_offset
  
  dec loop_counter
  bne loop
.endscope

  rts
even_column:
.scope
loop:
  
; -on every iteration, we need to calculate the meta tile address from
; the index read from the map.
  ldy #$00
  lda (local_map_offset),y
  sta metatile_index
  
; -on every iteration, we need to copy tile and attribute data from the
; map to the column buffers.

  ;get attribute
  ldy metatile_index
  lda (metatile_table_attributes_address_zp),y
  
  ldx intermediate_attribute_column_buffer_offset
  sta intermediate_attribute_column_buffer,x
  
  lda (metatile_table_top_left_tiles_address_zp),y
  ldx nametable_column_buffer_offset
  sta nametable_column_buffer,x
  
  lda (metatile_table_bottom_left_tiles_address_zp),y
  ldx nametable_column_buffer_offset
  sta nametable_column_buffer+1,x
  
; -on every iteration, we need to add map_width to the map offset to get to
; the next row.

  clc
  lda local_map_offset
  adc map_width
  sta local_map_offset
  lda local_map_offset+1
  adc #$00
  sta local_map_offset+1

; -on every iteration, we need to increment row counters for the column
; buffers and add logic for wrapping

  inc intermediate_attribute_column_buffer_offset
  
  ldx intermediate_attribute_column_buffer_offset
  lda mod15lut,x
  sta intermediate_attribute_column_buffer_offset
  
  ;these offsets move in lock step anyway, just quickly calculate the
  ;nametable column buffer offset
  asl
  sta nametable_column_buffer_offset
  
  dec loop_counter
  bne loop
.endscope
  
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
  
.proc process_attribute_table1

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
.endproc

.proc process_attribute_table2

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

;uploads the contents of the current row buffer to the ppu.
.proc map_upload_row_ppu

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
  
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000
  
  rts

.endproc
  
.proc map_upload_attribute_table_row_ppu

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
  lda ppu_2006
  adc #$00
  sta ppu_2006
  upload_ppu_2006
  
  lda attribute_table1+8,y
  sta $2007
  lda attribute_table1+(32+8),y
  sta $2007

  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  lda ppu_2006
  adc #$00
  sta ppu_2006
  upload_ppu_2006
  
  lda attribute_table1+(8*2),y
  sta $2007
  lda attribute_table1+(32+8*2),y
  sta $2007
  
  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  lda ppu_2006
  adc #$00
  sta ppu_2006
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
  lda ppu_2006
  adc #$00
  sta ppu_2006
  upload_ppu_2006
  
  lda attribute_table2+8,y
  sta $2007
  lda attribute_table2+(32+8),y
  sta $2007

  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  lda ppu_2006
  adc #$00
  sta ppu_2006
  upload_ppu_2006
  
  lda attribute_table2+(8*2),y
  sta $2007
  lda attribute_table2+(32+8*2),y
  sta $2007
  
  clc
  lda ppu_2006+1
  adc #$08
  sta ppu_2006+1
  lda ppu_2006
  adc #$00
  sta ppu_2006
  upload_ppu_2006
  
  lda attribute_table2+(8*3),y
  sta $2007
  lda attribute_table2+(32+8*3),y
  sta $2007
  
done:
.endscope
  
  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  rts

.endproc
  
.proc map_upload_attribute_table1

  ;point directly to attribute table
  lda #$23
  sta ppu_2006
  lda #$C0
  sta ppu_2006+1
  upload_ppu_2006
  
  ldx #0
  
.scope
loop:
  lda attribute_table1,x
  sta $2007
  
  inx
  cpx #$40
  bne loop
.endscope

  rts
  
.endproc

.proc map_upload_attribute_table2

  ;point directly to attribute table
  lda #$27
  sta ppu_2006
  lda #$C0
  sta ppu_2006+1
  upload_ppu_2006
  
  ldx #0
  
.scope
loop:
  lda attribute_table2,x
  sta $2007
  
  inx
  cpx #$40
  bne loop
.endscope

  rts
  
.endproc
