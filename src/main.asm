.include "ppu.inc"
.include "zp.inc"
.include "ram.inc"
.include "map.inc"
.include "map0.inc"

.segment "HEADER"
.byte "NES",$1a   ;iNES header
.byte $10         ;# of PRG-ROM blocks. These are 16kb each. $4000 hex.
.byte $00         ;# of CHR-ROM blocks. These are 8kb each. $2000 hex.
.byte $21         ;Vertical mirroring. SRAM disabled. No trainer. Four-screen mirroring disabled. Mapper #2 (UnROM)
.byte $00         ;Rest of Mapper #2 bits (all 0)

.segment "CODE"

reset:
  ;set interrupt disable flag
  sei

  ;clear binary encoded decimal flag
  cld

  ;initialize stack
  ldx #$FF
  txs

  ;turn off all graphics and clear our PPU registers
  lda #$00
  sta ppu_2000
  sta ppu_2001
  upload_ppu_2000
  upload_ppu_2001

  ;wait for PPU to be ready
  wait_vblank
  wait_vblank

  ;initialize vblank flags
  lda #0
  sta vblank_data_ready

  ;install blank nmi routine at first
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  ;initialize ppu registers with settings we're never going to change
  set_ppu_2000_bit PPU0_EXECUTE_NMI
  set_ppu_2001_bit PPU1_SPRITE_CLIPPING
  set_ppu_2001_bit PPU1_BACKGROUND_CLIPPING
  upload_ppu_2000
  upload_ppu_2001

  ;initialize
  jsr ppu_safely_disable_graphics
  
  lda #<map0_chr
  sta w0
  lda #>map0_chr
  sta w0+1
  jsr ppu_load_chr_amount
  
  lda #<palette
  sta w0
  lda #>palette
  sta w0+1
  wait_vblank
  jsr ppu_load_palette_bg
  
  jsr ppu_safely_enable_graphics
  
  ;initialize variables
  lda #0
  sta vblank_data_ready
  
  lda #0
  sta row_ready
  lda #0
  sta column_ready
  
  lda #<nametable_and_attribute_update_ppu
  sta vblank_routine
  lda #>nametable_and_attribute_update_ppu
  sta vblank_routine+1
  
  lda #$20
  sta camera_nametable_hibyte
  
  lda #(16*0)
  sta camera_x
  lda #0
  sta camera_x+1
  lda #(16*0)
  sta camera_y
  lda #0
  sta camera_y+1
  
  lda #(16*0)
  sta camera_scroll_x
  lda #(232)
  sta camera_scroll_y
  
  lda #<metatile_table_attributes
  sta metatile_table_attributes_address
  lda #>metatile_table_attributes
  sta metatile_table_attributes_address+1
  
  lda #<metatile_table_top_left_tiles
  sta metatile_table_top_left_tiles_address
  lda #>metatile_table_top_left_tiles
  sta metatile_table_top_left_tiles_address+1
  
  lda #<metatile_table_top_right_tiles
  sta metatile_table_top_right_tiles_address
  lda #>metatile_table_top_right_tiles
  sta metatile_table_top_right_tiles_address+1
  
  lda #<metatile_table_bottom_left_tiles
  sta metatile_table_bottom_left_tiles_address
  lda #>metatile_table_bottom_left_tiles
  sta metatile_table_bottom_left_tiles_address+1

  lda #<metatile_table_bottom_right_tiles
  sta metatile_table_bottom_right_tiles_address
  lda #>metatile_table_bottom_right_tiles
  sta metatile_table_bottom_right_tiles_address+1
  
  lda #<big_metatile_table_top_left
  sta big_metatile_table_top_left_address
  lda #>big_metatile_table_top_left
  sta big_metatile_table_top_left_address+1
  
  lda #<big_metatile_table_top_right
  sta big_metatile_table_top_right_address
  lda #>big_metatile_table_top_right
  sta big_metatile_table_top_right_address+1

  lda #<big_metatile_table_bottom_left
  sta big_metatile_table_bottom_left_address
  lda #>big_metatile_table_bottom_left
  sta big_metatile_table_bottom_left_address+1
  
  lda #<big_metatile_table_bottom_right
  sta big_metatile_table_bottom_right_address
  lda #>big_metatile_table_bottom_right
  sta big_metatile_table_bottom_right_address+1
  
  lda #<map
  sta map_address
  lda #>map
  sta map_address+1
  
  ;jsr fill_nametable_rows
  
  ;jmp vertical_scrolling_test
  
  jsr fill_nametable_columns
  
  ;jmp horizontal_scrolling_test
  
  jmp fourway_scrolling_test
  
  
loop:

  jmp loop

vblank:

  pha
  txa
  pha
  tya
  pha
  php

  jsr indirect_jsr_vblank_routine

  plp
  pla
  tay
  pla
  tax
  pla

irq:
  rti

.proc indirect_jsr_vblank_routine
  jmp (vblank_routine)
.endproc

.segment "VECTORS"
  .word vblank
  .word reset
  .word irq
