.include "ppu.inc"
.include "zp.inc"
.include "ram.inc"
.include "actions.inc"
.include "map.inc"
.include "map_data.inc"
.include "sprites_and_animations_data.inc"
.include "play_state.inc"
.include "sprite.inc"
.include "soundengine.inc"
.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"

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
  clear_ppu_2000_bit PPU0_BACKGROUND_PATTERN_TABLE_ADDRESS
  set_ppu_2000_bit PPU0_SPRITE_PATTERN_TABLE_ADDRESS
  upload_ppu_2000
  upload_ppu_2001

  ;initialize modules
  jsr sprite_module_init

  jsr sound_initialize

  jsr play_state_initialize

  lda #<sfx_set1
  sta sound_param_word_0
  lda #>sfx_set1
  sta sound_param_word_0+1
  jsr sfx_initialize

  ldx #location_index_dungeon_area_start
  lda locations_lo,x
  sta location_address
  lda locations_hi,x
  sta location_address+1
  jmp play_state_load_location

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
