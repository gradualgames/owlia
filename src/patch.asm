.feature force_range
.include "patch.inc"
.include "areas.inc"
.include "ram.inc"
.include "zp.inc"
.include "mapper.inc"
.include "ppu.inc"
.include "sprite.inc"
.include "util.inc"
.include "ndxdebug.h"

.segment "CODE"

mod30lut:
.repeat 5
  .byte 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29
.endrepeat

;Resets the patch column counter to zero.
.proc patch_frame_start

  lda #0
  sta patch_column_count
  lda #0
  sta patch_column_offset

  rts

.endproc

;This routine decodes a foreground patch in front of
;a background patch at a specified height. In other words,
;the foreground patch slides overtop of the background
;patch, revealing it with higher row numbers. This was
;written to facilitate monolith animations.
;expects b0 to be the background patch index for the current area
;expects b1 to be the foreground patch index for the current area
;expects b2 to be the desired column from which to decode
;expects b3 to be the desired row at which to end bg drawing and start fg drawing
;expects w0 to be the map X coordinate at which to draw the column
;expects w1 to be the map Y coordinate at which to draw the column
;preserves contents of x register
.proc patch_decode_foreground_revealing_background
;8 bit params
background_patch = b0
foreground_patch = b1
column = b2
row = b3

;8 bit vars
patch_width = b4
patch_height = b5
counter = b6

;16 bit params
map_x = w0
map_y = w1

;16 bit vars
vram_address = map_y
nametable_patches_address = w2
background_patch_address = w3
foreground_patch_address = w4

  ;save registers
  txa
  pha

  ;convert map x and map y to nametable coordinates in map space
  shift_right16 map_x, 3
  shift_right16 map_y, 3

  ;convert map x to nametable coordinates in screen space
  lda #0
  sta map_x+1
  lda map_x
  and #%00011111
  sta map_x

  ;convert map y to nametable coordinates in screen space
  lda #0
  sta map_y+1
  ldx map_y
  lda mod30lut,x
  sta map_y

  ;now compute vram address from these. vram address shares map_y

  ;multiply map y times 32
  shift_left16 vram_address, 5

  ;add on map x
  clc
  lda vram_address
  adc map_x
  sta vram_address
  lda vram_address+1
  adc map_x+1
  sta vram_address+1

  ;now add on camera_nametable_hibyte
  clc
  lda vram_address
  adc #0
  sta vram_address
  lda vram_address+1
  adc camera_nametable_hibyte
  sta vram_address+1

  ;store the address the column should draw at in vram
  ldx patch_column_offset
  lda vram_address
  sta patch_column_buffer,x

  inx
  lda vram_address+1
  sta patch_column_buffer,x

  ;get addresses of selected foreground and background patches
  switch_bank_ldy #AREAS_BANK
  ldy #area::nametable_patches_address
  lda (area_address),y
  sta nametable_patches_address
  iny
  lda (area_address),y
  sta nametable_patches_address+1

  lda background_patch
  asl
  tay
  lda (nametable_patches_address),y
  sta background_patch_address
  iny
  lda (nametable_patches_address),y
  sta background_patch_address+1

  lda foreground_patch
  asl
  tay
  lda (nametable_patches_address),y
  sta foreground_patch_address
  iny
  lda (nametable_patches_address),y
  sta foreground_patch_address+1

  ;get the height and width out of the background patch.
  ldy #0
  lda (background_patch_address),y
  sta patch_width
  iny
  lda (background_patch_address),y
  sta patch_height

  ;we'll assume both the bg and fg column height are the same.
  ;pick the height from the bg column and set it as the length of
  ;the column we're drawing.

  lda patch_height
  inx
  sta patch_column_buffer,x

  ;now, we want to figure out which tiles to copy from the background patch
  ;and which tiles to copy from the foreground patch based on the row.

  lda row
  beq no_bg_tiles

  lda row
  sta counter

  clc
  lda #2
  adc column
  tay
next_bg_tile:
  lda (background_patch_address),y

  inx
  sta patch_column_buffer,x

  clc
  tya
  adc patch_width
  tay

  dec counter
  bne next_bg_tile

no_bg_tiles:

  lda row
  cmp patch_height
  beq no_fg_tiles

  sec
  lda patch_height
  sbc row
  sta counter

  clc
  lda #2
  adc column
  tay
next_fg_tile:
  lda (foreground_patch_address),y

  inx
  sta patch_column_buffer,x

  clc
  tya
  adc patch_width
  tay

  dec counter
  bne next_fg_tile

no_fg_tiles:

  ; ;now store length in the current column
  ; inx
  ; lda #6
  ; sta patch_column_buffer,x

  ; inx
  ; lda #33
  ; sta patch_column_buffer,x

  ; inx
  ; sta patch_column_buffer,x

  ; inx
  ; sta patch_column_buffer,x

  inx
  stx patch_column_offset

  ;we're done decoding current column, add it to the count
  inc patch_column_count

  ;restore registers
  pla
  tax

  rts

.endproc

;This routine uploads a buffer of columns to the
;ppu. It only performs nametable updates, and is
;used exclusively for monolith animations.
.proc patch_nametable_update_ppu

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
  lda patch_column_count
  beq no_columns

  set_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  ;start at first byte
  ldx #$ff
next_column:
  ;read next column address header
  inx
  lda patch_column_buffer,x
  sta ppu_2006+1

  inx
  lda patch_column_buffer,x
  sta ppu_2006
  upload_ppu_2006

  ;read column length
  inx
  lda patch_column_buffer,x
  tay
  ;read column tiles and upload them to ppu
next_tile:

  inx
  lda patch_column_buffer,x
  sta $2007

  dey
  bne next_tile

  dec patch_column_count
  bne next_column

  lda #0
  sta patch_column_count
  sta patch_column_offset
no_columns:
  .endscope

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

  rts

.endproc
