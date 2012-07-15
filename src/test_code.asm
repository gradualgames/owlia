.include "test_code.inc"
.include "map.inc"
.include "ram.inc"
.include "zp.inc"
.include "ppu.inc"
.include "controller.inc"
.include "sprite.inc"
.include "spritesheet0.inc"
.include "soundengine.inc"
.include "entity.inc"

.segment "CODE"

song1:
.scope
  .word Square1
  .word Square2
  .word Triangle
  .word Noise
  .word volume_envelopes
  .word pitch_envelopes
  .word duty_envelopes

volume_envelopes:
  .word volume_envelope_0
  .word volume_envelope_1
  .word volume_envelope_2
  .word volume_envelope_3
  .word volume_envelope_4

pitch_envelopes:
  .word pitch_envelope_0
  .word pitch_envelope_1

duty_envelopes:
  .word duty_envelope_0

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 9,9,8,8,7,6,5,4,3,2,ENV_STOP
volume_envelope_3:
  .byte 8,8,7,8,8,0,ENV_STOP
volume_envelope_4:
  .byte 4,3,2,1,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP
pitch_envelope_1:
  .byte 28,45,55,68,78,90,0,ENV_STOP

duty_envelope_0:
  .byte 0, ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,20,G2,C2,A2,C2,F2,C2,G2,C2,B2,C2,C3,C2,A2,C2,B2,C2

  .byte GOT
  .word Square1

Square2:
  .byte STV,2,STP,0,SDU,0,STL,10,G3,F3,E3,B3,STL,40,G3,STL,10,E3,STL,20,F3,STL,50,G3
  .byte STL,10,B3,G3,B3,E3,F3,STL,30,C4,STL,10,E3,STL,20,D3,STL,50,E3
  .byte GOT
  .word Square2

Triangle:
  .byte STV,3,STP,1,SDU,0,STL,80,D4,D4,D4,D4
  .byte GOT
  .word Triangle

Noise:
  .byte STV,0,STL,20,A0,STV,4,STP,0,SDU,0,STL,80,2,2,2,STL,60,2
  .byte GOT
  .word Noise
.endscope

.proc horizontal_scrolling_test

loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  lda #1
  sta b0
  jsr increment_camera_x
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp loop

.endproc

.proc fill_nametable_columns

  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  clc
  lda camera_x
  adc #$08
  sta camera_x
  lda camera_x+1
  adc #$00
  sta camera_x+1

  lda camera_x+1
  cmp #1
  bne :+
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  rts
:
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp :--

  rts

.endproc
  
.proc fill_nametable_rows

fill_nametable_loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  clc
  lda camera_y
  adc #$08
  sta camera_y
  lda camera_y+1
  adc #$00
  sta camera_y+1
  
  lda camera_y
  cmp #240
  beq bottom_row
not_bottom_row:
  
  jmp done
bottom_row:

  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready

  rts

done:
  
  ; clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  ; upload_ppu_2001
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready

  jmp fill_nametable_loop

.endproc

.proc vertical_scrolling_test

  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  lda #1
  sta b0
  jsr increment_camera_y
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
    
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp :-

.endproc

;assumes b0 to contain amount to increment camera x by
;assumes b0 to be a power of 2
.proc increment_camera_x

  ;increment camera x
  lda camera_x+1
  cmp #3
  bne :+
  lda camera_x
  cmp #0
  beq :++
:
  clc
  lda camera_x
  adc b0
  sta camera_x
  lda camera_x+1
  adc #$00
  sta camera_x+1
  
  jsr increment_camera_scroll_x
:
  
  rts

.endproc

;assumes b0 to contain amount to decrement camera x by
;assumes b0 to be a power of 2
.proc decrement_camera_x

  ;decrement camera x
  lda camera_x+1
  bne :+
  lda camera_x
  beq :++
:
  sec
  lda camera_x
  sbc b0
  sta camera_x
  lda camera_x+1
  sbc #$00
  sta camera_x+1
  
  jsr decrement_camera_scroll_x
:
  
  rts

.endproc

;assumes b0 to contain amount to increment camera y by
;assumes b0 to be a power of 2
.proc increment_camera_y

  ;increment camera y
  lda camera_y+1
  cmp #3
  bne :+
  lda camera_y
  cmp #32
  beq :++
:
  clc
  lda camera_y
  adc b0
  sta camera_y
  lda camera_y+1
  adc #$00
  sta camera_y+1
  
  jsr increment_camera_scroll_y
:

  rts

.endproc

;assumes b0 to contain amount to decrement camera y by
;assumes b0 to be a power of 2
.proc decrement_camera_y

  ;decrement camera y
  lda camera_y+1
  cmp #$00
  bne :+
  lda camera_y
  cmp #$00
  beq :++
:
  sec
  lda camera_y
  sbc b0
  sta camera_y
  lda camera_y+1
  sbc #$00
  sta camera_y+1
  
  jsr decrement_camera_scroll_y
:
  
  rts

.endproc

;assumes b0 to contain amount to increment camera scroll x by
;assumes b0 to be a power of 2
.proc increment_camera_scroll_x

  ;increment camera x scroll
  clc
  lda camera_scroll_x
  adc b0
  sta camera_scroll_x
  bcc :+
  ;flip the nametable bit
  lda camera_nametable_hibyte
  eor #%00000100
  sta camera_nametable_hibyte
:

  rts

.endproc

;assumes b0 to contain amount to decrement camera scroll x by
;assumes b0 to be a power of 2
.proc decrement_camera_scroll_x

  ;decrement camera x scroll
  sec
  lda camera_scroll_x
  sbc b0
  sta camera_scroll_x
  bcs :+
  ;flip the nametable bit
  lda camera_nametable_hibyte
  eor #%00000100
  sta camera_nametable_hibyte
:

  rts

.endproc

;assumes b0 to contain amount to increment camera scroll y by
;assumes b0 to be a power of 2
.proc increment_camera_scroll_y

  ;increment camera y scroll
  clc
  lda camera_scroll_y
  adc b0
  sta camera_scroll_y
  
  sec
  lda camera_scroll_y
  sbc #240
  lda #0
  sbc #0
  bmi :+
  
  lda camera_scroll_y
  sbc #240
  sta camera_scroll_y
:

  rts

.endproc

;assumes b0 to contain amount to decrement camera scroll y by
;assumes b0 to be a power of 2
.proc decrement_camera_scroll_y

  ;decrement camera y scroll
  sec
  lda camera_scroll_y
  sbc b0
  sta camera_scroll_y
  bcs :+
  
  clc
  lda #240
  adc camera_scroll_y
  sta camera_scroll_y
  
:
  
  rts

.endproc

.proc fourway_scrolling_test
SPEED = 4

  lda #(16*0)
  sta camera_x
  lda #0
  sta camera_x+1
  lda #(16*0)
  sta camera_y
  lda #0
  sta camera_y+1
  
  jsr entity_init_all
  
  lda #0
  sta b0
  jsr entity_spawn
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda #<WalkSide
  sta w2
  sta current_animation_definition
  lda #>WalkSide
  sta w2+1
  sta current_animation_definition+1
  jsr sprite_reset_animation

loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  
  jsr sound_update
  jsr sound_upload
  
  jsr sprite_clear_all
  
  jsr controller_read
  
  lda buffer_controller+buttons::_up
  and buffer_controller+buttons::_right
  and #$01
  bne up_and_right
  
  lda buffer_controller+buttons::_up
  and buffer_controller+buttons::_left
  and #$01
  bne up_and_left
  
  lda buffer_controller+buttons::_down
  and buffer_controller+buttons::_right
  and #$01
  bne down_and_right
  
  lda buffer_controller+buttons::_down
  and buffer_controller+buttons::_left
  and #$01
  bne down_and_left
  
  lda buffer_controller+buttons::_right
  and #$01
  bne right
  
  lda buffer_controller+buttons::_left
  and #$01
  bne left
  
  lda buffer_controller+buttons::_up
  and #$01
  bne up
  
  lda buffer_controller+buttons::_down
  and #$01
  bne down
  
up_and_right:

  jsr up_and_right_handler

  jmp done_scrolling

up_and_left:

  jsr up_and_left_handler
  
  jmp done_scrolling
  
down_and_right:

  jsr down_and_right_handler
  
  jmp done_scrolling
  
down_and_left:

  jsr down_and_left_handler
  
  jmp done_scrolling
  
right:

  jsr right_handler
  
  jmp done_scrolling
  
left:

  jsr left_handler
  
  jmp done_scrolling
  
up:

  jsr up_handler
 
  jmp done_scrolling
  
down:

  jsr down_handler
  
  jmp done_scrolling
  
done_scrolling:
  
  lda #<WalkSide0
  sta w0
  lda #>WalkSide0
  sta w0+1
  lda #112
  sta w3
  lda #0
  sta w3+1
  lda #120
  sta w4
  lda #0
  sta w4+1
  lda #0
  sta b2
  lda #0
  sta sprite_group_offset
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda current_animation_definition
  sta w2
  lda current_animation_definition+1
  sta w2+1
  
  lda current_sprite_flags
  sta b2
  
  ;jsr sprite_draw_animation

  jsr entity_update_all
  
  jsr entity_draw_all
  
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp loop

right_handler:

  lda #SPEED
  sta b0
  jsr increment_camera_x
  
  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$01
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda #<WalkSide
  sta current_animation_definition
  sta w2
  lda #>WalkSide
  sta current_animation_definition+1
  sta w2+1
  
  lda #0
  sta current_sprite_flags
  
  jsr sprite_update_animation
  
  rts
  
left_handler:

  lda #SPEED
  sta b0
  jsr decrement_camera_x
  
  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda #<WalkSide
  sta current_animation_definition
  sta w2
  lda #>WalkSide
  sta current_animation_definition+1
  sta w2+1
  
  lda #%01000000
  sta current_sprite_flags
  
  jsr sprite_update_animation
  
  rts
  
up_handler:

  lda #SPEED
  sta b0
  jsr decrement_camera_y
  
  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda #<WalkUp
  sta current_animation_definition
  sta w2
  lda #>WalkUp
  sta current_animation_definition+1
  sta w2+1
  
  lda #0
  sta current_sprite_flags
  
  jsr sprite_update_animation
  
  rts
  
down_handler:

  lda #SPEED
  sta b0
  jsr increment_camera_y
  
  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  clc
  lda camera_y
  adc #224
  sta w1
  lda camera_y+1
  adc #$00
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready

  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda #<WalkDown
  sta current_animation_definition
  sta w2
  lda #>WalkDown
  sta current_animation_definition+1
  sta w2+1
  
  lda #0
  sta current_sprite_flags
  
  jsr sprite_update_animation
  
  rts
  
up_and_right_handler:

  lda buffer_controller+buttons::_right
  and #$01
  beq not_right_and_up
  lda buffer_controller+buttons::_up
  and #$01
  beq not_right_and_up
  ;right and up
  
  lda #SPEED
  sta b0
  jsr increment_camera_x
  
  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$01
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #SPEED
  sta b0
  jsr decrement_camera_y
  
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda current_animation_definition
  sta w2
  lda current_animation_definition+1
  sta w2+1
  jsr sprite_update_animation
  
not_right_and_up:

  rts

up_and_left_handler:

  lda buffer_controller+buttons::_left
  and #$01
  beq not_left_and_up
  lda buffer_controller+buttons::_up
  and #$01
  beq not_left_and_up
  ;left and up
  
  lda #SPEED
  sta b0
  jsr decrement_camera_x
  
  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$00
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #SPEED
  sta b0
  jsr decrement_camera_y
  
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda current_animation_definition
  sta w2
  lda current_animation_definition+1
  sta w2+1
  jsr sprite_update_animation
  
not_left_and_up:

  rts

down_and_right_handler:

  lda buffer_controller+buttons::_right
  and #$01
  beq not_right_and_down
  lda buffer_controller+buttons::_down
  and #$01
  beq not_right_and_down
  ;right and down
  
  lda #SPEED
  sta b0
  jsr increment_camera_x
  
  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$01
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #SPEED
  sta b0
  jsr increment_camera_y
  
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  clc
  lda camera_y
  adc #224
  sta w1
  lda camera_y+1
  adc #$00
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda current_animation_definition
  sta w2
  lda current_animation_definition+1
  sta w2+1
  jsr sprite_update_animation
  
not_right_and_down:

  rts

down_and_left_handler:

  lda buffer_controller+buttons::_left
  and #$01
  beq not_left_and_down
  lda buffer_controller+buttons::_down
  and #$01
  beq not_left_and_down
  ;left and down
  
  lda #SPEED
  sta b0
  jsr decrement_camera_x
  
  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$00
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready
  
  lda #SPEED
  sta b0
  jsr increment_camera_y
  
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  clc
  lda camera_y
  adc #224
  sta w1
  lda camera_y+1
  adc #$00
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda current_animation_definition
  sta w2
  lda current_animation_definition+1
  sta w2+1
  jsr sprite_update_animation
  
not_left_and_down:

  rts

.endproc
