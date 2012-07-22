.include "camera.inc"
.include "zp.inc"
.include "ram.inc"
.include "map.inc"

.segment "CODE"

;assumes x register points to entity instance to attach to (follow)
.proc attach_camera_to_entity

  stx camera_entity

  rts

.endproc

;follows the entity at camera_entity whenever it moves outside of a
;hard-coded rectangular area
.proc update_camera
CAMERA_HORIZ_SIZE = 80
CAMERA_VERT_SIZE = 80
camera_right_x = w4
camera_left_x = w5
camera_top_y = w6
camera_bottom_y = w7
camera_increment = b0

  ldx camera_entity

  clc
  lda camera_x
  adc #(256 - CAMERA_HORIZ_SIZE)
  sta camera_right_x
  lda camera_x+1
  adc #$00
  sta camera_right_x+1
  
  ldx camera_entity
  sec
  lda entity_x_lo,x
  sbc camera_right_x
  sta camera_increment
  lda entity_x_hi,x
  sbc camera_right_x+1
  bmi skip_follow_right
  
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
  jmp skip_follow_left
skip_follow_right:
  
  clc
  lda camera_x
  adc #(CAMERA_HORIZ_SIZE)
  sta camera_left_x
  lda camera_x+1
  adc #$00
  sta camera_left_x+1
  
  ldx camera_entity
  sec
  lda camera_left_x
  sbc entity_x_lo,x
  sta camera_increment
  lda camera_left_x+1
  sbc entity_x_hi,x
  bmi skip_follow_left
  
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
skip_follow_left:

  clc
  lda camera_y
  adc #(240 - CAMERA_VERT_SIZE)
  sta camera_bottom_y
  lda camera_y+1
  adc #$00
  sta camera_bottom_y+1
  
  ldx camera_entity
  sec
  lda entity_y_lo,x
  sbc camera_bottom_y
  sta camera_increment
  lda entity_y_hi,x
  sbc camera_bottom_y+1
  bmi skip_follow_down
  
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
  jmp skip_follow_up
skip_follow_down:
  
  clc
  lda camera_y
  adc #(CAMERA_VERT_SIZE)
  sta camera_top_y
  lda camera_y+1
  adc #$00
  sta camera_top_y+1
  
  ldx camera_entity
  sec
  lda camera_top_y
  sbc entity_y_lo,x
  sta camera_increment
  lda camera_top_y+1
  sbc entity_y_hi,x
  bmi skip_follow_up
  
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
  
skip_follow_up:

  rts

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
