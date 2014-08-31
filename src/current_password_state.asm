.include "mapper.inc"
.include "ppu.inc"
.include "current_password_state.inc"
.include "inventory_state.inc"
.include "zp.inc"
.include "ram.inc"
.include "textbox.inc"
.include "sprite.inc"
.include "locations.inc"
.include "controller.inc"
.include "charmap.inc"

.segment "ROM01"

current_password_string: .byte "CURRENT PASSWORD",ES

current_password_state_init:

  ;fade out from current palette (assumed to be inventory state palette, previously
  ;loaded into palette_address)
  jsr ppu_fade_out_palette

  ;set blank nmi routine
  safely_set_vblank_routine ppu_vblank_nop

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  jsr sprite_update_all

  ;load chr data for inventory screen
  lda #$00
  sta ppu_2006
  sta ppu_2006+1
  upload_ppu_2006

  ;reset tile accumulator
  lda #$00
  sta b3

  lda #<inventory_bg_chr
  sta w0
  lda #>inventory_bg_chr
  sta w0+1
  far_call #INVENTORY_STATE_BG_CHR_BANK, ppu_load_chr_amount

  ;grab tile accumulator to know where the textbox and font group begins
  lda b3
  sta textbox_and_font_chr_offset

  ;load the textbox graphics.
  lda #<textbox_chr
  sta w0
  lda #>textbox_chr
  sta w0+1
  far_call #TEXTBOX_BG_CHR_BANK, ppu_load_chr_amount

  ;load nametable data for inventory screen on opposite nametable from
  ;camera. This won't matter for overworld, since we never use nametable
  ;patching, but for dungeons which are always done at the top left of
  ;one of the two nametables, this will help preserve any nametable
  ;patching that had been previously performed.
  lda camera_nametable_hibyte
  eor #$04
  sta state_control_params+current_password_state_control::nametable_hi

  lda state_control_params+current_password_state_control::nametable_hi
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  lda #<inventory_screen
  sta w0
  lda #>inventory_screen
  sta w0+1
  far_call #INVENTORY_STATE_BG_NAMETABLE_BANK, ppu_load_nametable

  ;print current password string on the screen
  lda textbox_and_font_chr_offset
  sta chr_group_offset
  print_string current_password_string, state_control_params+current_password_state_control::nametable_hi, #12, #8

  ;reset scroll
  lda state_control_params+current_password_state_control::nametable_hi
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006

  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005

  jsr ppu_safely_enable_graphics

  ;fade in palette (again, inherited from inventory state)
  lda #MAX_BRIGHTNESS_LEVEL
  sta b4
  sta b5
  jsr ppu_fade_in_palette

current_password_state_main:

  clear_vblank_done
  wait_vblank_done

  jsr controller_read

  ;test select button
  lda buffer_controller+buttons::_select
  and #%00000011
  cmp #%00000001
  beq return_to_inventory_state

  jmp current_password_state_main

return_to_inventory_state:

  ;tell the inventory state where to find its own palette
  lda #INVENTORY_STATE_BANK
  sta state_control_params+inventory_state_control::fade_out_palette_bank
  lda #<inventory_screen_palette
  sta state_control_params+inventory_state_control::fade_out_palette_address
  lda #>inventory_screen_palette
  sta state_control_params+inventory_state_control::fade_out_palette_address+1

  jmp inventory_state_init
