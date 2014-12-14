.feature force_range
.include "ndxdebug.h"
.include "main.inc"
.include "ppu.inc"
.include "zp.inc"
.include "ram.inc"
.include "map.inc"
.include "map_data.inc"
.include "sprites_and_animations_data.inc"
.include "play_state.inc"
.include "title_state.inc"
.include "sprite.inc"
.include "entity.inc"
.include "soundengine.inc"
.include "music_data.inc"
.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "mapper.inc"
.include "controller.inc"
.include "familiar.inc"
.include "familiar_constants.inc"
.include "hero.inc"
.include "hero_constants.inc"
.include "password.inc"

.segment "HEADER"
.byte "NES",$1a   ;iNES header
.byte $10         ;# of PRG-ROM ice_blocks. These are 16kb each. $4000 hex.
.byte $00         ;# of CHR-ROM ice_blocks. These are 8kb each. $2000 hex.
.byte $21         ;Vertical mirroring. SRAM disabled. No trainer. Four-screen mirroring disabled. Mapper #2 (UnROM)
.byte $00         ;Rest of Mapper #2 bits (all 0)

.segment "CODE"

reset:
  ;set interrupt disable flag
  sei

  ;clear binary encoded decimal flag
  cld

  ;disable APU frame IRQ
  lda #$40
  sta $4017

  ;initialize stack
  ldx #$FF
  txs

  ;turn off all graphics, and clear PPU registers
  lda #$00
  sta ppu_2000
  sta ppu_2001
  upload_ppu_2000
  upload_ppu_2001

  ;disable DMC IRQs
  lda #$00
  sta $4010

  ;Clear the vblank flag, so we know that we are waiting for the
  ;start of a vertical blank and not powering on with the
  ;vblank flag spuriously set
  bit $2002

  ;wait for PPU to be ready
  wait_vblank
  wait_vblank

  ;install blank nmi routine at first. NMI is off right now, and
  ;we are within the second PPU ready window, so we can just
  ;install the routine without ensuring we will not be interrupted
  ;between loading bytes.
  unsafely_set_vblank_routine ppu_vblank_nop

  ;install default controller read routine
  set_controller_routine controller_read

  ;initialize ppu registers with settings we're never going to change
  set_ppu_2000_bit PPU0_EXECUTE_NMI
  set_ppu_2001_bit PPU1_SPRITE_CLIPPING
  set_ppu_2001_bit PPU1_BACKGROUND_CLIPPING
  clear_ppu_2000_bit PPU0_BACKGROUND_PATTERN_TABLE_ADDRESS
  set_ppu_2000_bit PPU0_SPRITE_PATTERN_TABLE_ADDRESS
  upload_ppu_2000
  upload_ppu_2001

  ;load all black palette
  jsr ppu_load_black_palette

  ;initialize RAM
  lda #1
  sta hide_graphics_top

  ;null out all bank numbers
  lda #0
  sta current_bank
  sta next_bank
  sta map_bank
  sta conversations_bank

  jsr ppu_module_init
  jsr controller_clear
  far_call #SOUND_BANK, sound_initialize
  jsr sprite_module_init
  jsr map_module_init
  jsr entity_module_init
  far_call #PASSWORD_BANK, password_module_init
  far_call #HERO_BANK, hero_module_init
  far_call #FAMILIAR_BANK, familiar_module_init

  ;jump to title state init
  switch_bank_ldy #TITLE_STATE_BANK
  jmp title_state_init

vblank:

  pha
  txa
  pha
  tya
  pha
  php

  jsr indirect_jsr_vblank_routine

  lda hide_graphics_top
  beq do_not_hide_graphics_top
  ;turn off sprite visibility
  ;clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  ;turn off background visibility
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  ;now wait for a finely tuned amount of CPU cycles to create a 16 pixel
  ;wide black bar at the top of the screen. Used in conjunction with
  ;how the scrolling engine works we can hide all scrolling updates this
  ;way.
  ldx #177
: dex
  bne :-
  ldx #178
: dex
  bne :-

  ;turn sprite and background visibility on
  ;set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

do_not_hide_graphics_top:

  safe_soundengine_update

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
