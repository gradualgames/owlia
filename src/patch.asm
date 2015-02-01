.include "patch.inc"
.include "areas.inc"
.include "map.inc"
.include "ram.inc"
.include "zp.inc"
.include "mapper.inc"

.segment "CODE"

.proc patch_frame_start

  lda #0
  sta patch_row_ready
  sta patch_column_ready

  rts

.endproc

.proc patch_frame_end

  lda patch_row_ready
  beq :+
  sta row_ready
:
  lda patch_column_ready
  beq :+
  sta column_ready
:

  rts

.endproc

;expects w8 to be the map x coordinate at which to decode the row
;expects w9 to be the map y coordinate at which to decode the row
;expects b12 to be the index of the nametable patch out of which a row will be decoded
;expects b13 to be the row of the patch to use
;expects b14 to be an attribute to swap in on the attribute table
;expects b15 to be the offset at which to poke the attribute value, in map coordinates
.proc decode_nametable_patch_row_and_poke_attribute
;params
map_x = w8
map_y = w9
patch_index = b12
patch_row = b13
patch_attribute = b14
patch_attribute_x_offset = b15

;locals
row_offset = b2
patch_width = b3
patch_height = b4
patch_offset = b5
patches_address = w2
patch_address = w3

  txa
  pha

  ;save calling bank
  lda current_bank
  pha

  ;skip decoding a map row if a row is already ready. This enables us to
  ;perform patches across an entire row all during a single frame, such as
  ;for monoliths that are across from one another.
  lda patch_row_ready
  bne skip_row_decode

  ;transfer patch params for the map decode routines
  lda map_x
  sta w0
  lda map_x+1
  sta w0+1
  lda map_y
  sta w1
  lda map_y+1
  sta w1+1

  ;temporarily modify map_x to be camera_x. This is so that we decode
  ;a full row that fits the current screen, not bleeding into opposing nametables,
  ;and so that if there are more than one patch entity in the same row, they can
  ;rely on row offsets being relative to the same position.
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  far_call map_bank, map_decode_row

  ;calculate offset within intermediate attribute row buffer
  clc
  lda map_x
  adc patch_attribute_x_offset
  ror
  ror
  ror
  ror
  tax
  lda patch_attribute
  sta intermediate_attribute_row_buffer,x

  far_call map_bank, map_process_intermediate_attribute_row_buffer

skip_row_decode:

  ;calculate row_offset from map_x
  clc
  lda map_x
  ror
  ror
  ror
  sta row_offset

  ;get address of patches array
  switch_bank_ldy #AREAS_BANK
  ldy #area::nametable_patches_address
  lda (area_address),y
  sta patches_address
  iny
  lda (area_address),y
  sta patches_address+1

  ;get address of patch
  lda patch_index
  asl
  tay
  lda (patches_address),y
  sta patch_address
  iny
  lda (patches_address),y
  sta patch_address+1

  ;get width and height of patch
  ldy #0
  lda (patch_address),y
  sta patch_width
  iny
  lda (patch_address),y
  sta patch_height

  ;calculate row of patch to read from based on patch width
  lda #0
  sta patch_offset

  ;add patch_width to patch_offset patch_row times to get correct patch_offset
: clc
  lda patch_offset
  adc patch_width
  sta patch_offset
  dec patch_row
  bne :-

  ;now read from patch at patch_offset for patch_width tiles and copy them into
  ;nametable_row_buffer at row_offset.
  ldy patch_offset
  iny
  iny
  ldx row_offset

: lda (patch_address),y
  sta nametable_row_buffer,x
  inx
  iny
  dec patch_width
  bne :-

  lda #1
  sta patch_row_ready

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  pla
  tax

  rts

.endproc

;expects w8 to be the map x coordinate at which to decode the row
;expects w9 to be the map y coordinate at which to decode the row
;expects b12 to be the index of the nametable patch out of which a row will be decoded
;expects b13 to be the row of the patch to use
.proc decode_nametable_patch_row
;params
map_x = w8
map_y = w9
patch_index = b12
patch_row = b13

;locals
row_offset = b2
patch_width = b3
patch_height = b4
patch_offset = b5
patches_address = w2
patch_address = w3

  txa
  pha

  ;save calling bank
  lda current_bank
  pha

  ;skip decoding a map row if a row is already ready. This enables us to
  ;perform patches across an entire row all during a single frame, such as
  ;for monoliths that are across from one another.
  lda patch_row_ready
  bne skip_row_decode

  ;transfer patch params for the map decode routines
  lda map_x
  sta w0
  lda map_x+1
  sta w0+1
  lda map_y
  sta w1
  lda map_y+1
  sta w1+1

  ;temporarily modify map_x to be camera_x. This is so that we decode
  ;a full row that fits the current screen, not bleeding into opposing nametables,
  ;and so that if there are more than one patch entity in the same row, they can
  ;rely on row offsets being relative to the same position.
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  far_call map_bank, map_decode_row
  far_call map_bank, map_process_intermediate_attribute_row_buffer

skip_row_decode:

  ;calculate row_offset from map_x
  clc
  lda map_x
  ror
  ror
  ror
  sta row_offset

  ;get address of patches array
  switch_bank_ldy #AREAS_BANK
  ldy #area::nametable_patches_address
  lda (area_address),y
  sta patches_address
  iny
  lda (area_address),y
  sta patches_address+1

  ;get address of patch
  lda patch_index
  asl
  tay
  lda (patches_address),y
  sta patch_address
  iny
  lda (patches_address),y
  sta patch_address+1

  ;get width and height of patch
  ldy #0
  lda (patch_address),y
  sta patch_width
  iny
  lda (patch_address),y
  sta patch_height

  ;calculate row of patch to read from based on patch width
  lda #0
  sta patch_offset

  ;add patch_width to patch_offset patch_row times to get correct patch_offset
: clc
  lda patch_offset
  adc patch_width
  sta patch_offset
  dec patch_row
  bne :-

  ;now read from patch at patch_offset for patch_width tiles and copy them into
  ;nametable_row_buffer at row_offset.
  ldy patch_offset
  iny
  iny
  ldx row_offset

: lda (patch_address),y
  sta nametable_row_buffer,x
  inx
  iny
  dec patch_width
  bne :-

  lda #1
  sta patch_row_ready

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  pla
  tax

  rts

.endproc

;expects w8 to be the map x coordinate at which to decode the column
;expects w9 to be the map y coordinate at which to decode the column
;expects b12 to be the index of the nametable patch out of which a column will be decoded
;expects b13 to be the column of the patch to use
;expects b14 to be height of the column to copy
.proc decode_nametable_patch_column
;params
map_x = w8
map_y = w9
patch_index = b12
patch_column = b13
patch_column_height = b14

;locals
column_offset = b3
patch_width = b4
patch_height = b5
patch_offset = b6
patches_address = w2
patch_address = w3

  txa
  pha

  ;save calling bank
  lda current_bank
  pha

  ;skip decoding a map column if a column is already ready. This enables us to
  ;perform patches across an entire column all during a single frame, such as
  ;for monoliths that are vertically across from one another.
  lda patch_column_ready
  bne skip_column_decode

  ;transfer patch params for the map decode routines
  lda map_x
  sta w0
  lda map_x+1
  sta w0+1
  lda map_y
  sta w1
  lda map_y+1
  sta w1+1

  ;temporarily modify map_y to be camera_y. This is so that we decode
  ;a full column that fits the current screen, and if a second patch
  ;entity in the same column chooses to patch more parts of the column,
  ;it can rely on the offsets being relative to the same position.
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1

  far_call map_bank, map_decode_column
  far_call map_bank, map_process_intermediate_attribute_column_buffer

skip_column_decode:

  ;transform map_y to metatile coordinates
  lda map_y
  lsr map_y+1
  ror
  lsr map_y+1
  ror
  lsr map_y+1
  ror
  pha  ;save the low byte here, as the low bit will be needed as an offset
       ;from the value read from mod15lut. We can only compute the correct
       ;nametable offset every 2 tiles from mod15lut because it was designed
       ;for metatile units, not nametable units.
  lsr map_y+1
  ror
  sta map_y

  ;transform map_y to nametable coordinates using mod15lut
  ldx map_y
  lda mod15lut,x
  asl
  sta map_y

  ;grab the low byte of map_x that we grabbed in the midst of dividing map_y
  ;by 16 (right when we had it at divided by 8), and use the low bit as an offset
  ;from the nametable coordinate we computed from the mod15lut, to finally get the
  ;correct offset within the column in nametable units. Kind of a funky workaround
  ;for the fact that we do not have a mod30lut, but I don't feel like putting another
  ;chunky look up table in the fixed bank. :)
  pla
  and #1
  clc
  adc map_y
  sta map_y

  ;calculate column offset from map_y
  sta column_offset

  ;get address of patches array
  switch_bank_ldy #AREAS_BANK
  ldy #area::nametable_patches_address
  lda (area_address),y
  sta patches_address
  iny
  lda (area_address),y
  sta patches_address+1

  ;get address of patch
  lda patch_index
  asl
  tay
  lda (patches_address),y
  sta patch_address
  iny
  lda (patches_address),y
  sta patch_address+1

  ;get width and height of patch
  ldy #0
  lda (patch_address),y
  sta patch_width
  iny
  lda (patch_address),y
  sta patch_height

  ;start at first row of column (offset by 2 to skip width and height header)
  lda #2
  sta patch_offset

  ;start at the column of the patch that we selected
  clc
  lda patch_offset
  adc patch_column
  sta patch_offset

  ldx column_offset
: ldy patch_offset
  lda (patch_address),y
  sta nametable_column_buffer,x

  ;advance to next row of column that we are copying
  clc
  lda patch_offset
  adc patch_width
  sta patch_offset

  inx
  dec patch_column_height
  bne :-

  lda #1
  sta patch_column_ready

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  pla
  tax

  rts

.endproc