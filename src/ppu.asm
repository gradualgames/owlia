.feature force_range
.include "ndxdebug.h"
.include "zp.inc"
.include "ram.inc"
.include "ppu.inc"
.include "sprite.inc"
.include "mapper.inc"

.segment "CODE"

;this routine initializes the ppu module to state expected at startup.
;this routine does not wait for the ppu chip itself to initialize.
.proc ppu_module_init

  lda #0
  sta b3

  rts

.endproc

;nmi routine which does nothing except continue music driver
.proc ppu_vblank_nop

  set_vblank_done

  ;pad CPU cycles for finely tuned graphics hiding
  ldx #255
: dex
  bne :-

  ldx #208
: dex
  bne :-

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

  clear_vblank_done
  wait_vblank_done

  ;turn off graphics hiding
  lda #0
  sta hide_graphics_top

  ;set nop vblank routine
  safely_set_vblank_routine ppu_vblank_nop

  ;turn off sprite visibility
  clear_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  ;turn off background visibility
  clear_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  rts

.endproc

;assumes the palette is black
;assumes that we are somewhere in the middle of rendering a frame
.proc ppu_safely_enable_graphics

  clear_vblank_done
  wait_vblank_done

  ;set nop vblank routine
  safely_set_vblank_routine ppu_vblank_nop

  ;turn sprite and background visibility on
  set_ppu_2001_bit PPU1_SPRITE_VISIBILITY
  set_ppu_2001_bit PPU1_BACKGROUND_VISIBILITY
  upload_ppu_2001

  rts

.endproc

;expects palette_address to have address of palette
.proc ppu_load_palette
  ldy #0
  lda #$3F
  sta $2006
  lda #$00
  sta $2006
  ldx #$00
: lda (palette_address),y
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

.proc ppu_load_black_palette
  ldy #0
  lda #$3F
  sta $2006
  lda #$00
  sta $2006
  ldx #$00
  lda #$0e
: sta $2007
  inx
  iny
  cpx #$20
  bne :-
  rts
.endproc

;loads a specified amount of chr data into VRAM starting at the current VRAM location.
;expects w0 to contain the address of the chr data.
;uses w1 to count the number of bytes to copy from this location.
;uses w2 to preserve the number of bytes to copy from this location.
;uses b3 to accmulate number of tiles loaded thus var into VRAM. This allows chaining
;of ppu_load_chr_amount calls to know the offset of the next group to be loaded.
.proc ppu_load_chr_amount

  ;save y
  tya
  pha

  ldy #0
  lda (w0),y
  sta w1
  sta w2
  iny
  lda (w0),y
  sta w1+1
  sta w2+1
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

  ;shift right this 16 bit value to calculate number of tiles loaded.
  lda w2
  lsr w2+1
  ror
  lsr w2+1
  ror
  lsr w2+1
  ror
  lsr w2+1
  ror
  sta w2

  ;now accmulate the number of tiles loaded onto b3. Only use lo byte,
  ;we can't load more than 256 tiles anyway!
  clc
  lda b3
  adc w2
  sta b3

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
;expects palette_address to point to palette to fade in to
;expects b4 to indicate desired brightness for bg
;expects b5 to indicate desired brightness for spr
.proc ppu_fade_in_palette
desired_brightness_level_bg = b4
desired_brightness_level_spr = b5
brightness_level_bg = b6
brightness_level_spr = b7

  lda #MIN_BRIGHTNESS_LEVEL
  sta brightness_level_bg
  sta brightness_level_spr

  ;keep track of the desired brightness levels globally
  lda desired_brightness_level_bg
  sta dynamic_palette_brightness_level_bg
  lda desired_brightness_level_spr
  sta dynamic_palette_brightness_level_spr

  ;save current nmi routine
  lda vblank_routine
  pha
  lda vblank_routine+1
  pha

  ;switch to nmi routine for uploading the dynamic palette
  safely_set_vblank_routine ppu_upload_dynamic_palette_ppu

fading_loop:
  ;load dynamic palette for current bg and spr brightness levels independently
  lda brightness_level_bg
  sta b3
  jsr ppu_load_dynamic_palette_brightness_bg
  lda brightness_level_spr
  sta b3
  jsr ppu_load_dynamic_palette_brightness_spr

  ;pause for FADING_SPEED frames
  ldx #FADING_SPEED
: clear_vblank_done
  wait_vblank_done
  dex
  bne :-

  ;exit loop if both bg and spr brightness levels match their desired level
  lda brightness_level_bg
  cmp desired_brightness_level_bg
  bne desired_level_not_reached_yet
  lda brightness_level_spr
  cmp desired_brightness_level_spr
  bne desired_level_not_reached_yet

  jmp done_fading

desired_level_not_reached_yet:

  ;increment bg and spr brightness levels until they reach the desired level
  lda brightness_level_bg
  cmp desired_brightness_level_bg
  beq do_not_increment_brightness_level_bg
  inc brightness_level_bg
do_not_increment_brightness_level_bg:

  lda brightness_level_spr
  cmp desired_brightness_level_spr
  beq do_not_increment_brightness_level_spr
  inc brightness_level_spr
do_not_increment_brightness_level_spr:

  jmp fading_loop
done_fading:

  ;do one more wait to make sure the vblank clears the done
  ;flag, so that when we restore the old vblank routine, we
  ;don't upload unprepared garbage data!
  clear_vblank_done
  wait_vblank_done

  ;restore previous nmi routine
  pla
  sta vblank_routine+1
  pla
  sta vblank_routine
no_fading_needed:

  rts
.endproc

;assumes we are safely in the middle of rendering a frame so we can
;switch to the palette vblank routine and turn on graphics hiding
;expects palette_address to point to the palette to fade out from
;uses b4 to store bg brightness level
;uses b5 to store spr brightness level
.proc ppu_fade_out_palette
brightness_level_bg = b4
brightness_level_spr = b5

  ;save current nmi routine
  lda vblank_routine
  pha
  lda vblank_routine+1
  pha

  ;switch to nmi routine for uploading the dynamic palette
  safely_set_vblank_routine ppu_upload_dynamic_palette_ppu

  ;fade out from the current global brightness level
  lda dynamic_palette_brightness_level_bg
  sta brightness_level_bg
  lda dynamic_palette_brightness_level_spr
  sta brightness_level_spr

fading_loop:

  ;load up the dynamic palette with brightness in b3
  lda brightness_level_bg
  sta b3
  jsr ppu_load_dynamic_palette_brightness_bg
  lda brightness_level_spr
  sta b3
  jsr ppu_load_dynamic_palette_brightness_spr

  ;pause for FADING_SPEED frames
  ldx #FADING_SPEED
: wait_vblank_done
  clear_vblank_done
  dex
  bne :-

  ;exit loop if both bg and spr fading levels are at min brightness
  lda brightness_level_bg
  cmp #MIN_BRIGHTNESS_LEVEL
  bne not_faded_out_yet
  lda brightness_level_spr
  cmp #MIN_BRIGHTNESS_LEVEL
  bne not_faded_out_yet

  jmp done_fading

not_faded_out_yet:

  lda brightness_level_bg
  cmp brightness_level_spr
  bmi decrement_only_spr_brightness

  lda brightness_level_bg
  cmp #MIN_BRIGHTNESS_LEVEL
  beq bg_done_fading_out
  dec brightness_level_bg
bg_done_fading_out:

decrement_only_spr_brightness:
  lda brightness_level_spr
  cmp #MIN_BRIGHTNESS_LEVEL
  beq spr_done_fading_out
  dec brightness_level_spr
spr_done_fading_out:

  jmp fading_loop
done_fading:

  ;do one more wait to make sure the vblank clears the ready
  ;flag, so that when we restore the old vblank routine, we
  ;don't upload unprepared garbage data!
  wait_vblank_done

  ;restore previous nmi routine
  pla
  sta vblank_routine+1
  pla
  sta vblank_routine

  rts
.endproc

;nmi routine for uploading the dynamic palette
.proc ppu_upload_dynamic_palette_ppu

  jsr sprite_update_all

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

  jsr ppu_load_palette

  ;restore previous palette address
  pla
  sta palette_address+1
  pla
  sta palette_address

  ;restore 2006 and 2005 to what we had written them to previously
  upload_ppu_2006
  upload_ppu_2005

  set_vblank_done

  ;pad CPU cycles for finely tuned graphics hiding
  ldx #215
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

;expects palette_address to have address of palette to transfer to dynamic palette
;expects b3 to contain desired brightness level
;uses b0 temporarily
.proc ppu_load_dynamic_palette_brightness

  ldy #$1f

  ;load a color from the palette
: lda (palette_address),y

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

;this only adjusts brightness for the bg palette
;expects palette_address to have address of palette to transfer to dynamic palette
;expects b3 to contain desired brightness level
;uses b0 temporarily
.proc ppu_load_dynamic_palette_brightness_bg

  ldy #$0f

  ;load a color from the palette
: lda (palette_address),y

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

;this only adjusts brightness for the spr palette
;expects palette_address to have address of palette to transfer to dynamic palette
;expects b3 to contain desired brightness level
;uses b8 temporarily as a loop counter
;uses b0 temporarily
.proc ppu_load_dynamic_palette_brightness_spr

  lda #$10
  sta b8

  ldy #$1f

  ;load a color from the palette
: lda (palette_address),y

  ;adjust that color's brightness based on input (b3)
  sta b0
  jsr ppu_adjust_color_brightness
  lda b0
  ;store it to dynamic palette
  sta dynamic_palette,y

  dey
  dec b8
  bne :-

  rts

.endproc
