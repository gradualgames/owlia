.include "camera.inc"
.include "zp.inc"
.include "ram.inc"

.segment "CODE"

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
