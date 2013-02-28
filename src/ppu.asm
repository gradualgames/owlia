.include "zp.inc"
.include "ram.inc"
.include "ppu.inc"
.include "sprite.inc"
.include "mapper.inc"

.segment "CODE"

;nmi routine which does nothing except continue music driver
.proc ppu_vblank_nop

  lda #0
  sta vblank_data_ready

  rts

.endproc

;this routine is used when the palette is faded out to enable
;loading ppu graphics without synchronizing with vblank
;assumes the palette is black
;assumes that we are somewhere in the middle of rendering a frame
;so that it is safe to switch out the nmi routine to a no-op routine
;turns off graphics and sprites
;turns off artificial graphics hiding bar
.proc ppu_safely_disable_graphics

  ;turn off graphics hiding
  lda #0
  sta hide_graphics_top

  ;set nop vblank routine
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  ;turn off sprite visibility
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  ;turn off background visibility
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  set_vblank_data_ready
  wait_vblank_data_ready
  upload_ppu_2001
  rts

.endproc

;assumes the palette is black
;assumes that we are somewhere in the middle of rendering a frame
.proc ppu_safely_enable_graphics

  ;turn off graphics hiding
  lda #0
  sta hide_graphics_top

  ;set nop vblank routine
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  ;turn sprite and background visibility on
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  set_vblank_data_ready
  wait_vblank_data_ready
  upload_ppu_2001
  rts

.endproc

;expects w0 to have address of palette
.proc ppu_load_palette
  ldy #0
  lda #$3F
  sta $2006
  lda #$00
  sta $2006
  ldx #$00
: lda (w0),y
  sta $2007
  inx
  iny
  cpx #$20
  bne :-
  rts
.endproc

.proc ppu_load_palette_bg
  ldy #0
  lda #$3F
  sta $2006
  lda #$00
  sta $2006
  ldx #$00
: lda (w0),y
  sta $2007
  inx
  iny
  cpx #$10
  bne :-
  rts
.endproc

;loads a specified amount of chr data into VRAM starting at the current VRAM location.
;expects w0 to contain the address of the chr data.
;uses w1 to contain the number of bytes to copy from this location.
.proc ppu_load_chr_amount

  ;save y
  tya
  pha

  ldy #0
  lda (w0),y
  sta w1
  iny
  lda (w0),y
  sta w1+1
  iny

loadChrLoop:
  ;load a byte from the chr data
  lda (w0),y
  ;stuff it into vram
  sta $2007
  ;move the address along
  clc
  lda w0
  adc #1
  sta w0
  lda w0+1
  adc #0
  sta w0+1
  ;decrement the count
  sec
  lda w1
  sbc #1
  sta w1
  lda w1+1
  sbc #0
  sta w1+1

  ;keep looping while either lo or hi byte of count is not zero.
  lda w1
  bne loadChrLoop
  lda w1+1
  bne loadChrLoop

  ;restore y
  pla
  tay

  rts

.endproc

;loads a nametable and attribute table located at address in w0
;assumes VRAM points to the nametable that is to be loaded
.proc ppu_load_nametable
  ldy #$00
  ldx #$04

:
  lda (w0),y
  sta $2007
  iny
  bne :-
  inc w0+1
  dex
  bne :-

  rts
.endproc

;assumes we are safely in the middle of rendering a frame so we can
;switch to the palette vblank routine.
;assumes the palette is black
;expects w0 to point to palette to fade in to
;uses b4 to store palette step
.proc ppu_fade_in_palette
palette_step = b4

  ;save current nmi routine
  lda vblank_routine
  pha
  lda vblank_routine+1
  pha

  ;turn on graphics hiding
  lda #1
  sta hide_graphics_top

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_dynamic_palette_ppu
  sta vblank_routine
  lda #>ppu_upload_dynamic_palette_ppu
  sta vblank_routine+1

  lda #1
  sta palette_step

fading_loop:

  ;load up the dynamic palette with brightness in b3
  switch_bank_ldy map_bank
  lda palette_step
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  ;wait for vblank
  ldx #FADING_SPEED
:
  wait_vblank_data_ready
  set_vblank_data_ready
  dex
  bne :-

  ;do one more wait to make sure the vblank clears the ready
  ;flag, so that when we restore the old vblank routine, we
  ;don't upload unprepared garbage data!
  wait_vblank_data_ready

  inc palette_step
  lda palette_step
  cmp #5
  bmi fading_loop

  ;restore previous nmi routine
  pla
  sta vblank_routine+1
  pla
  sta vblank_routine

  rts
.endproc

;assumes we are safely in the middle of rendering a frame so we can
;switch to the palette vblank routine and turn on graphics hiding
;expects w0 to point to the palette to fade out from
;uses b4 to store palette step
.proc ppu_fade_out_palette
palette_step = b4

  ;save current nmi routine
  lda vblank_routine
  pha
  lda vblank_routine+1
  pha

  ;turn on graphics hiding
  lda #1
  sta hide_graphics_top

  ;switch to nmi routine for uploading the dynamic palette
  lda #<ppu_upload_dynamic_palette_ppu
  sta vblank_routine
  lda #>ppu_upload_dynamic_palette_ppu
  sta vblank_routine+1

  lda #4
  sta palette_step

fading_loop:

  ;load up the dynamic palette with brightness in b3
  switch_bank_ldy map_bank
  lda palette_step
  sta b3
  jsr ppu_load_dynamic_palette_brightness

  ;wait for vblank
  ldx #FADING_SPEED
:
  wait_vblank_data_ready
  set_vblank_data_ready
  dex
  bne :-

  dec palette_step
  bpl fading_loop

  ;do one more wait to make sure the vblank clears the ready
  ;flag, so that when we restore the old vblank routine, we
  ;don't upload unprepared garbage data!
  wait_vblank_data_ready

  ;restore previous nmi routine
  pla
  sta vblank_routine+1
  pla
  sta vblank_routine

  rts
.endproc

;nmi routine for uploading the dynamic palette
.proc ppu_upload_dynamic_palette_ppu

  lda vblank_data_ready
  beq :+

  jsr sprite_update_all

  ;save current palette address
  lda w0
  pha
  lda w0+1
  pha

  lda #<dynamic_palette
  sta w0
  lda #>dynamic_palette
  sta w0+1

  clear_ppu_2000_bit PPU0_ADDRESS_INCREMENT
  upload_ppu_2000

  jsr ppu_load_palette

  ;restore previous palette address
  pla
  sta w0+1
  pla
  sta w0

  ;restore 2006 and 2005 to what we had written them to previously
  upload_ppu_2006
  upload_ppu_2005

  lda #0
  sta vblank_data_ready
:

  ;pad CPU cycles for finely tuned graphics hiding
  ldx #218
: dex
  bne :-

  rts
.endproc


brightness_table:
  .byte $00, $00, $00, $00
  .byte $00, $10, $10, $10
  .byte $00, $10, $20, $20
  .byte $00, $10, $20, $30

.proc ppu_adjust_color_brightness
color = b0
color_brightness = b1
color_hue = b2
input_brightness = b3

  ;save x
  txa
  pha

  ;this color is black but we don't want to use it. (it is
  ;"blacker than black" and outputs a low enough voltage to
  ;screw up some TV's)
  ;return a correct black.
  lda color
  cmp #$0d
  beq return_black

  ;return black for the lowest brightness level
  lda input_brightness
  beq return_black

  ;get current brightness of color
  lda color
  and #%00110000
  sta color_brightness

  ;get hue of color
  lda color
  and #%00001111
  sta color_hue

  ;these hues are always black
  cmp #$0e
  beq return_black
  cmp #$0f
  beq return_black

  ;use color's brightness and input brightness to index into brightness_table
  ;and produce the adjusted color
  lda color_brightness
  lsr
  lsr
  clc
  adc input_brightness
  tax
  ;subtract one because brightness will be 1 thru 4 and 0 means drop to black
  ;we want the values 0, 1, 2, 3 not 1 ,2 ,3 ,4
  dex
  lda brightness_table,x
  ora color_hue

  ;return adjusted color
  sta color

  ;restore x
  pla
  tax

  rts

return_black:

  lda #$0e
  sta color

  ;restore x
  pla
  tax

  rts

.endproc

;expects w0 to have address of palette to transfer to dynamic palette
;expects b3 to contain desired brightness level
.proc ppu_load_dynamic_palette_brightness

  ldy #$1f

:
  ;load a color from the palette
  lda (w0),y

  ;adjust that color's brightness based on input (b3)
  sta b0
  jsr ppu_adjust_color_brightness
  lda b0
  ;store it to dynamic palette
  sta dynamic_palette,y

  dey
  bpl :-

  rts
.endproc
