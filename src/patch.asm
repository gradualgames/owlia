.include "patch.inc"
.include "areas.inc"
.include "map.inc"
.include "ram.inc"
.include "zp.inc"
.include "mapper.inc"

.segment "CODE"

; -a routine which takes an x and a y coordinate, and decodes a row of the
; map, but then writes a row of a given nametable patch overtop of the
; decoded nametable buffer. There would need to be a row offset for where
; to begin drawing the row of the given nametable patch.

;expects w0 to be the map x coordinate at which to decode the row
;expects w1 to be the map y coordinate at which to decode the row
;expects b0 to be the index of the nametable patch out of which a row will be decoded
;expects b1 to be the row of the patch to use
.proc decode_nametable_patch_row
;params
map_x = w0
map_y = w1
patch_index = b0
patch_row = b1

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
  lda row_ready
  bne skip_row_decode

  ;save patch params, the map decode routines clobber a lot of zp state
  lda map_x
  pha
  lda map_x+1
  pha
  lda map_y
  pha
  lda map_y+1
  pha
  lda patch_index
  pha
  lda patch_row
  pha

  ;temporarily modify map_x to be the nearest screen boundary. This is so that we decode
  ;a full row that fits the current screen, not bleeding into opposing nametables.
  lda #0
  sta map_x

  far_call map_bank, map_decode_row
  far_call map_bank, map_process_intermediate_attribute_row_buffer

  ;restore patch params
  pla
  sta patch_row
  pla
  sta patch_index
  pla
  sta map_y+1
  pla
  sta map_y
  pla
  sta map_x+1
  pla
  sta map_x
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
  sta row_ready

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  pla
  tax

  rts

.endproc
