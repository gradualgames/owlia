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

;this routine has two entry points, geotests_rect_inside_rect_size,
;and geotests_rect_inside_rect. geotests_rect_inside_rect_size computes
;the dimensions of both rectangles based on 8 bit sizes, and
;geotests_rect_inside_rect assumes that all these values have already
;been computed.
;tests rectangle B for whether it is inside rectangle A.
;sets zero flag if rectangle B is inside rectangle A.
geotests_rect_inside_rect_size:
;parameters
rectangle_a_left_x = w2
rectangle_a_top_y = w3
rectangle_a_width = b2
rectangle_a_height = b3

rectangle_b_left_x = w4
rectangle_b_top_y = w5
rectangle_b_width = b4
rectangle_b_height = b5

;variables
rectangle_a_right_x = w6
rectangle_a_bottom_y = w7
rectangle_b_right_x = w8
rectangle_b_bottom_y = w9
b_inside_a_count = b6

  ;calculate right and bottom sides of rectangle A and B
  clc
  lda rectangle_a_left_x
  adc rectangle_a_width
  sta rectangle_a_right_x
  lda rectangle_a_left_x+1
  adc #0
  sta rectangle_a_right_x+1

  clc
  lda rectangle_a_top_y
  adc rectangle_a_height
  sta rectangle_a_bottom_y
  lda rectangle_a_top_y+1
  adc #0
  sta rectangle_a_bottom_y+1

  clc
  lda rectangle_b_left_x
  adc rectangle_b_width
  sta rectangle_b_right_x
  lda rectangle_b_left_x+1
  adc #0
  sta rectangle_b_right_x+1

  clc
  lda rectangle_b_top_y
  adc rectangle_b_height
  sta rectangle_b_bottom_y
  lda rectangle_b_top_y+1
  adc #0
  sta rectangle_b_bottom_y+1

geotests_rect_inside_rect:

  ;initialize counter for whether B might be inside A
  lda #0
  sta b_inside_a_count

  ;if left side of B is greater than the left side of A then B might be inside A
  sec
  lda rectangle_b_left_x
  sbc rectangle_a_left_x
  lda rectangle_b_left_x+1
  sbc rectangle_a_left_x+1
  bmi left_side_of_b_is_not_greater_than_left_side_of_a

  inc b_inside_a_count

left_side_of_b_is_not_greater_than_left_side_of_a:

  ;if right side of B is less than right side of A then B might be inside A
  sec
  lda rectangle_a_right_x
  sbc rectangle_b_right_x
  lda rectangle_a_right_x+1
  sbc rectangle_b_right_x+1
  bmi right_side_of_b_is_not_greater_than_left_side_of_a

  inc b_inside_a_count

right_side_of_b_is_not_greater_than_left_side_of_a:

  ;if top of B is greater than top of A then B might be inside A
  sec
  lda rectangle_b_top_y
  sbc rectangle_a_top_y
  lda rectangle_b_top_y+1
  sbc rectangle_a_top_y+1
  bmi top_of_b_is_not_greater_than_top_of_a

  inc b_inside_a_count

top_of_b_is_not_greater_than_top_of_a:

  ;if bottom of B is less than bottom of A then B might be inside A
  sec
  lda rectangle_a_bottom_y
  sbc rectangle_b_bottom_y
  lda rectangle_a_bottom_y+1
  sbc rectangle_b_bottom_y+1
  bmi bottom_of_a_is_not_greater_than_bottom_of_b

  inc b_inside_a_count

bottom_of_a_is_not_greater_than_bottom_of_b:

  ;if all the above cases are true, B is inside A
  lda b_inside_a_count
  cmp #4
  ;at this point, if zero flag is set, B is inside A

  rts

;tests one rectangle for whether it intersects another. There are two
;entry points for this routine. geotests_rect_in_rect_size uses the
;width and height parameters as listed below. geotests_rect_in_rect assumes
;the right and bottom parameters as listed below are already computed.
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
geotests_rect_in_rect_size:
  ;compute bottom of rectangle A
  clc
  lda w3
  adc b3
  sta w7
  lda w3+1
  adc #0
  sta w7+1

  ;compute bottom of rectangle B
  clc
  lda w5
  adc b5
  sta w9
  lda w5+1
  adc #0
  sta w9+1

  ;compute right of rectangle A
  clc
  lda w2
  adc b2
  sta w6
  lda w2+1
  adc #0
  sta w6+1

  ;compute right of rectangle B
  clc
  lda w4
  adc b4
  sta w8
  lda w4+1
  adc #0
  sta w8+1

geotests_rect_in_rect:

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
