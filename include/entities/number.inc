.linecont +
.ifndef NUMBER_INC
NUMBER_INC = 1

.include "number_constants.inc"

define_lohi_tables number, \
 {number_state_init, \
  number_state_main}

number_update:

  entity_state_switchboard number_lo, number_hi

number_state_init:

  ;kill all digit entities
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_type,y
  cmp #entity_index_digit
  bne skip_entity

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y

skip_entity:
  dey
  bpl next_entity
  .endscope

  lda number_value_lo,x
  sta b0
  lda number_value_hi,x
  sta b1
  lda number_value_hi_hi,x
  sta b2

  lda #<string_buffer
  sta w1
  lda #>string_buffer
  sta w1+1

  txa
  pha

  jsr create_decimal_string

  pla
  tax

  ;now read the decimal string and create digit entities for each
  .scope
string_buffer_address = w10
string_index = b9
string_digit_value = b8
digit_x = w9
  ;we're going to start at the number's X coordinate and go right by 8
  ;each time we print a digit. We'll just use the Y coordinate.
  lda entity_x_lo,x
  sta digit_x
  lda entity_x_hi,x
  sta digit_x+1

  lda #<string_buffer
  sta string_buffer_address
  lda #>string_buffer
  sta string_buffer_address+1
  lda #0
  sta string_index
next_character:
  ldy string_index
  lda (string_buffer_address),y
  cmp #ES
  beq done

  sta string_digit_value

  ;spawn a digit entity and compute the correct frame it should display
  ;from the digits animation
  lda #entity_index_digit
  sta b0

  lda digit_x
  sta w0
  lda digit_x+1
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn
  ldy spawned_entity

  lda string_digit_value
  asl
  sta entity_animation_frame,y

  clc
  lda digit_x
  adc #<8
  sta digit_x
  lda digit_x+1
  adc #>8
  sta digit_x+1

  inc string_index
  jmp next_character
done:
  .endscope

  lda #NUMBER_STATE_MAIN
  sta entity_state,x

  rts

number_state_main:

  rts

.endif
