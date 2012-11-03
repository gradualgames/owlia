.include "geotests.inc"
.include "zp.inc"

.segment "CODE"

;tests whether a point is inside a rectangle using 16 bit coordinates.
;w1 - x coordinate of point to test
;w2 - y coordinate of point to test
;w3 - top left x of rectangle
;w4 - top left y of rectangle
;b5 - width
;b6 - height
;global variables:
;w7 - bottom right x of rectangle
;w8 - bottom right y of rectangle
.proc geotests_point_in_rect_16bit
x_coord = w1
y_coord = w2
top_left_x = w3
top_left_y = w4
bot_right_x = w7
bot_right_y = w8
width = b5
height = b6

  ;calculate bot_right_x (top_left_x + width)
  lda top_left_x
  clc
  adc width
  sta bot_right_x
  lda top_left_x+1
  adc #0
  sta bot_right_x+1

  ;calculate bot_right_y (top_left_y + height)
  lda top_left_y
  clc
  adc height
  sta bot_right_y
  lda top_left_y+1
  adc #0
  sta bot_right_y+1

  ;if x < top left x (top_left_x - x_coord is positive), test fails
  lda top_left_x
  sec
  sbc x_coord
  lda top_left_x+1
  sbc x_coord+1
  bpl point_not_in_rect

  ;if y < top left y (top_left_y - y_coord is positive), test fails
  lda top_left_y
  sec
  sbc y_coord
  lda top_left_y+1
  sbc y_coord+1
  bpl point_not_in_rect

  ;if x > bottom right x (x_coord - bot_right_x is positive), test fails
  lda x_coord
  sec
  sbc bot_right_x
  lda x_coord+1
  sbc bot_right_x+1
  bpl point_not_in_rect

  ;if y > bottom right y (y_coord - bot_right_y is positive), test fails
  lda y_coord
  sec
  sbc bot_right_y
  lda y_coord+1
  sbc bot_right_y+1
  bpl point_not_in_rect

point_is_in_rect:

  ;set zero flag (point IS inside rectangle)
  lda #$00

  rts

point_not_in_rect:

  ;clear zero flag (point is NOT inside rectangle)
  lda #$ff

  rts

.endproc

;tests one rectangle for whether it intersects another.
;rectangle A:
;w2 - left x
;w3 - top y
;b2 - width
;b3 - height
;rectangle B:
;w4 - left x
;w5 - top y
;b4 - width
;b5 - height
;global variables used:
;rectangle A:
;w6 - right x
;w7 - bottom y
;rectangle B:
;w8 - right x
;w9 - bottom y
.proc geotests_rect_in_rect_16bit
  ;compute bottom of rectangle A
  clc
  lda w3
  adc b3
  sta w7
  lda w3+1
  adc #0
  sta w7+1

  ;load bottom of rectA (w7)
  ;subtract top of rectB (w5)
  sec
  lda w7
  sbc w5
  lda w7+1
  sbc w5+1
  bpl :+
  ;clear zero flag
  lda #$ff
  rts
:

  ;compute bottom of rectangle B
  clc
  lda w5
  adc b5
  sta w9
  lda w5+1
  adc #0
  sta w9+1

  ;load top of rectA (w3)
  ;subtract bottom of rectB (w9)
  sec
  lda w3
  sbc w9
  lda w3+1
  sbc w9+1
  bmi :+
  ;clear zero flag
  lda #$ff
  rts
:

  ;compute right of rectangle A
  clc
  lda w2
  adc b2
  sta w6
  lda w2+1
  adc #0
  sta w6+1

  ;load right of rectA (w6)
  ;subtract left of rectB (w4)
  sec
  lda w6
  sbc w4
  lda w6+1
  sbc w4+1
  bpl :+
  ;clear zero flag
  lda #$ff
  rts
:

  ;compute right of rectangle B
  clc
  lda w4
  adc b4
  sta w8
  lda w4+1
  adc #0
  sta w8+1

  ;load left of rectA (w2)
  ;subtract right of rectB (w8)
  sec
  lda w2
  sbc w8
  lda w2+1
  sbc w8+1
  bmi :+
  lda #$ff
  rts
:

  ;set zero flag
  lda #0

  rts
.endproc

;tests one rectangle for whether it intersects another.
;rectangle A:
;w2 - top left x, y
;w3 - bot right x, y
;rectangle B:
;w4 - top left x, y
;w5 - bot right x, y
;outputs:
;Z - true = intersection, false = no intersection
.proc geotests_rect_in_rect
  ;load bottom of rectA
  lda w3+1
  sec
  ;subtract top of rectB
  sbc w4+1
  bpl :+
  ;clear zero flag
  lda #$ff
  rts
:
  ;load top of rectA
  lda w2+1
  sec
  ;subtract bottom of rectB
  sbc w5+1
  bmi :+
  ;clear zero flag
  lda #$ff
  rts
:
  ;load right of rectA
  lda w3
  sec
  ;subtract left of rectB
  sbc w4
  bpl :+
  ;clear zero flag
  lda #$ff
  rts
:
  ;load left of rectA
  lda w2
  sec
  ;subtract right of rectB
  sbc w5
  bmi :+
  lda #$ff
  rts
:

  ;set zero flag
  lda #0

  rts
.endproc
