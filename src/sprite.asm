.include "zp.inc"
.include "ram.inc"
.include "sprite.inc"
.include "mapper.inc"

.segment "CODE"

;should be called at start of program
.proc sprite_module_init

  lda #0
  sta next_sprite_address

  rts

.endproc

;explicitly draws frame b0 of animation def at w2
.proc sprite_draw_animation_frame
frame = b0
animation_rom_address = w2

  ldy frame
  iny
  iny
  lda (animation_rom_address),y
  sta w0
  iny
  lda (animation_rom_address),y
  sta w0+1
  jsr sprite_draw_metasprite

  rts

.endproc

;draws the current frame of the animation at w1
;against the animation frames at w2. The user is expected
;to adjust the address of the animation being drawn to
;point to the frames array, skipping the frame delay and count
.proc sprite_draw_animation
animation_ram_address = w1
animation_rom_address = w2

  ldy #animation_ram::frame
  lda (animation_ram_address),y
  tay
  iny
  iny
  lda (animation_rom_address),y
  sta w0
  iny
  lda (animation_rom_address),y
  sta w0+1
  jsr sprite_draw_metasprite

  rts

.endproc

;resets the animation_ram object at w1 using
;the frame_delay member of w2
.proc sprite_reset_animation
animation_ram_address = w1
animation_rom_address = w2

  ;save calling bank
  lda current_bank
  pha
  switch_bank_ldy sprites_and_animations_bank

  ;reset the counter
  ldy #animation_ram::counter ;same as animation_rom::frame_delay
  lda (animation_rom_address),y
  sta (animation_ram_address),y

  ;reset to frame zero
  ldy #animation_ram::frame
  lda #0
  sta (animation_ram_address),y

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

.endproc

;updates the animation_ram object at w1 against
;the animation_rom definition at w2
.proc sprite_update_animation
animation_ram_address = w1
animation_rom_address = w2

  ;save calling bank
  lda current_bank
  pha
  switch_bank_ldy sprites_and_animations_bank

  ldy #animation_ram::counter ;same as animation_rom::frame_delay
  sec
  lda (animation_ram_address),y
  sbc #1
  sta (animation_ram_address),y
  bne :+

  ;reset the counter
  lda (animation_rom_address),y
  sta (animation_ram_address),y

  ;advance the frame
  ldy #animation_ram::frame   ;same as animation_rom::frame_count
  clc
  lda (animation_ram_address),y
  adc #2
  sta (animation_ram_address),y

  cmp (animation_rom_address),y
  bne :+

  ;reset to frame zero
  lda #0
  sta (animation_ram_address),y

:

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

.endproc

;a new, simpler and faster way to draw meta sprites with 16 bit coordinates.
;w0: the location of the meta sprite to draw
;w3: the 16 bit x coordinate at which to draw the sprite
;w4: the 16 bit y coordinate at which to draw the sprite
;b2: extra bits to OR into the sprite attribute
;    (presumably %01000000 to flip horiz)
;sprite_group_offset: All tile offsets within meta sprites are relative to this value.
;Global variables:
;b3: the calculated x coordinate at which to draw a sprite
;b4: the calculated y coordinate at which to draw a sprite
;b5: a counter
.proc sprite_draw_metasprite
metasprite_address = w0
top_left_x = w3
top_left_y = w4
sprite_attributes = b2
sprite_x = b3
sprite_y = b4
metasprite_entry_counter = b5

  ;save regs
  txa
  pha

  ;we want to start writing to the sprite buffer at next_sprite_address
  ldx next_sprite_address

  ;get number of entries in this meta sprite
  ldy #$00
  lda (metasprite_address),y
  sta b5
next_metasprite_entry:

  ;load Y coordinate from meta sprite
  ;and add to top_left_y with sign extension
  iny
  lda (metasprite_address),y
  bmi y_offset_negative
y_offset_positive:
  clc
  adc top_left_y
  sta sprite_y
  lda top_left_y+1
  adc #$00
  bne clip_sprite_y
  jmp y_offset_sign_test_done
y_offset_negative:
  clc
  adc top_left_y
  sta sprite_y
  lda top_left_y+1
  adc #$ff
  bne clip_sprite_y
y_offset_sign_test_done:

  ;store calculated y coordinate
  lda sprite_y
  sta sprite+sprite_struct::ycoord,x

  ;load tile number of sprite
  iny
  lda (metasprite_address),y
  clc
  adc sprite_group_offset
  sta sprite+sprite_struct::tile,x

  ;load attribute of sprite
  iny
  lda (metasprite_address),y
  lda (w0),y
  eor sprite_attributes
  sta sprite+sprite_struct::attribute,x

  jmp load_x_coordinate
return_from_load_x_coordinate:

  ;move to next sprite
  inx
  inx
  inx
  inx

  dec b5
  bne next_metasprite_entry

  txa
  sta next_sprite_address

  ;restore regs
  pla
  tax

  rts

clip_sprite_y:

  ;skip sprite attributes
  iny
  ;skip tile number
  iny
  ;skip x coordinate
  iny
  ;skip flipped x coordinate
  iny

  lda #$ff
  sta sprite+sprite_struct::ycoord,x
  sta sprite+sprite_struct::xcoord,x

  ;move to next sprite
  inx
  inx
  inx
  inx

  dec b5
  bne next_metasprite_entry

  txa
  sta next_sprite_address

  ;restore regs
  pla
  tax

  rts

clip_sprite_x:

  lda #$ff
  sta sprite+sprite_struct::ycoord,x
  sta sprite+sprite_struct::xcoord,x

  ;move to next sprite
  inx
  inx
  inx
  inx

  dec b5
  bne next_metasprite_entry

  txa
  sta next_sprite_address

  ;restore regs
  pla
  tax

  rts

load_x_coordinate:
  ;test to see if sprite is flipped.
  bit sprite_attributes
  bvs sprite_is_flipped
sprite_not_flipped:
  .scope
  ;load non flipped X coordinate from meta
  ;sprite and add with sign extension to
  ;top_left_x
  iny
  lda (metasprite_address),y
  bmi x_offset_negative
x_offset_positive:
  iny  ;skip flipped x coordinate
  clc
  adc top_left_x
  sta sprite_x
  lda top_left_x+1
  adc #$00
  bne clip_sprite_x
  jmp x_offset_sign_test_done
x_offset_negative:
  iny ;skip flipped x coordinate
  clc
  adc top_left_x
  sta sprite_x
  lda top_left_x+1
  adc #$ff
  bne clip_sprite_x
x_offset_sign_test_done:
  .endscope
  jmp sprite_flipped_test_done
sprite_is_flipped:
  .scope
  ;load flipped X coordinate from meta
  ;sprite and add with sign extension to
  ;top_left_x
  iny
  iny
  lda (metasprite_address),y
  bmi x_offset_negative
x_offset_positive:
  clc
  adc top_left_x
  sta sprite_x
  lda top_left_x+1
  adc #$00
  bne clip_sprite_x
  jmp x_offset_sign_test_done
x_offset_negative:
  clc
  adc top_left_x
  sta sprite_x
  lda top_left_x+1
  adc #$ff
  bne clip_sprite_x
x_offset_sign_test_done:
  .endscope
sprite_flipped_test_done:

  ;store calculated x coordinate
  lda sprite_x
  sta sprite+sprite_struct::xcoord,x

  jmp return_from_load_x_coordinate

.endproc

.proc sprite_update_all
  lda #>(sprite)
  sta $4014    ; Jam page $200-$2FF into SPR-RAM
  rts
.endproc

.proc sprite_clear_all
  lda #$ff
  ldx #$00
: sta sprite, x
  inx
  bne :-
  rts
.endproc
