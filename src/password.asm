.feature force_range
.include "password.inc"
.include "zp.inc"
.include "ram.inc"
.include "inventory.inc"
.include "charmap_password.inc"
.include "textbox.inc"
.include "ndxdebug.h"

.segment "ROM01"

.proc password_module_init

  ;clear out last earned password because we're starting fresh
  ldx #5
  lda #0
: sta last_password,x
  dex
  bpl :-

  rts

.endproc

password_obfuscation_masks:
  .byte %10010000
  .byte %10100100
  .byte %10100100
  .byte %11100010
  .byte %10010000
  .byte %10101000

;generates a password from current inventory state.
;expects w0 to contain the address of the 6 byte bit field
;into which to generate the password.
;uses b0 through b5 to work with the password field before
;storing it at the 6 byte field pointed to by w0
.proc inventory_state_to_password_bit_field

  lda inventory_gp+1
  ldx #8
  jsr rotate_value_into_password_field

  lda inventory_earned_techs
  ldx #3
  jsr rotate_value_into_password_field

  lda inventory_keys
  ldx #3
  jsr rotate_value_into_password_field

  lda inventory_lanterns
  ldx #3
  jsr rotate_value_into_password_field

  lda inventory_bombs
  ldx #3
  jsr rotate_value_into_password_field

  lda inventory_healths
  ldx #3
  jsr rotate_value_into_password_field

  lda inventory_gp+2
  ldx #8
  jsr rotate_value_into_password_field

  lda inventory_dungeon_flags
  ldx #8
  jsr rotate_value_into_password_field

  lda inventory_entered_dungeon
  ldx #1
  jsr rotate_value_into_password_field

  lda inventory_gp
  ldx #8
  jsr rotate_value_into_password_field

  ;copy b0 through b5 into the password field
  ldy #5
: lda b0,y
  ;obfuscate the password field on the way out
  eor password_obfuscation_masks,y
  sta (w0),y
  dey
  bpl :-

  rts

;expects accumulator to contain the value to rotate into the password field
;expects x to be told how many bits to rotate into the password field
rotate_value_into_password_field:

  clc
: ror
  jsr rotate_carry_into_password_field
  dex
  bne :-

  rts

rotate_carry_into_password_field:

  ror b0
  ror b1
  ror b2
  ror b3
  ror b4
  ror b5

  rts

.endproc

;generates a password string from a 6 byte password bit field
;expects w0 to contain the address of the 6 byte bit field
;expects w1 to contain the address of the string buffer to which
;to write the string.
.proc password_bit_field_to_password_string

  ;copy password field into b0 through b5
  ldy #5
: lda (w0),y
  sta b0,y
  dey
  bpl :-

  clc

  ldy #0

next_password_character:
  ;rotate 5 bits into accumulator
  lda #0
  ldx #5
: jsr rotate_password_field_into_carry
  rol
  dex
  bne :-

  ;store accumulator (+ 'A' to get beginning of actual text font) in string buffer
  clc
  adc #'A'
  sta (w1),y

  iny
  cpy #9
  bne next_password_character

  ;At this point, we have represented 45 bits of the 48 bit password field in the string.
  ;we now need to rotate the last three bits into the accumulator and use this as the last
  ;character of the password.
  ;rotate 3 bits into accumulator
  lda #0
  ldx #3
: jsr rotate_password_field_into_carry
  rol
  dex
  bne :-

  ;store accumulator (+ 'A' to get beginning of actual text font) in string buffer
  clc
  adc #'A'
  sta (w1),y

  ;store end of string character to finish off the password string
  iny
  lda #ES
  sta (w1),y

  rts

rotate_password_field_into_carry:

  rol b5
  rol b4
  rol b3
  rol b2
  rol b1
  rol b0

  rts

.endproc

;generates a 6 byte password bit field from a 10 byte password string.
;expects w0 to contain the address of the 10 byte password string.
;expects w1 to contain the address of the 6 byte bit field.
;uses b0 through b5 to represent the password field temporarily.
.proc password_string_to_password_bit_field

  ;clear the working password field
  lda #0
  ldx #5
: sta b0,x
  dex
  bpl :-

  ;rotate the first three bits of the password (the 10th character)
  ;into the password field
  ldy #9
  lda (w0),y
  sec
  sbc #'A'

  ldx #3
:
  ror
  jsr rotate_carry_into_password_field
  dex
  bne :-

  ;iterate over the password string, subtracting the chr offset for the font
  ;from each character to get the encoded 5 bits of the password.
  ldy #8
next_character:
  lda (w0),y
  sec
  sbc #'A'

  ;the accumulator has 5 bits of the password.
  ;rotate the 5 bits into the 6 byte password field.
  ldx #5
:
  ror
  jsr rotate_carry_into_password_field
  dex
  bne :-

  dey
  bpl next_character

  ;copy working password field to output password field
  ldy #5
: lda b0,y
  sta (w1),y
  dey
  bpl :-

  rts

rotate_carry_into_password_field:

  ror b0
  ror b1
  ror b2
  ror b3
  ror b4
  ror b5

  rts

.endproc

;rotates a 6 byte password bit field into the various inventory variables.
;expects w0 to point to the 6 byte password bit field
;uses b0 through b5 to work with the password bit field
.proc password_bit_field_to_inventory_state

  ;copy the password bit field into b0 through b5
  ldy #5
: lda (w0),y
  ;de-obfuscate the password field on the way in
  eor password_obfuscation_masks,y
  sta b0,y
  dey
  bpl :-

  ldx #8
  jsr rotate_password_field_into_accumulator
  sta inventory_gp+1

  ldx #3
  jsr rotate_password_field_into_accumulator
  sta inventory_earned_techs

  ldx #3
  jsr rotate_password_field_into_accumulator
  sta inventory_keys

  ldx #3
  jsr rotate_password_field_into_accumulator
  sta inventory_lanterns

  ldx #3
  jsr rotate_password_field_into_accumulator
  sta inventory_bombs

  ldx #3
  jsr rotate_password_field_into_accumulator
  sta inventory_healths

  ldx #8
  jsr rotate_password_field_into_accumulator
  sta inventory_gp+2

  ldx #8
  jsr rotate_password_field_into_accumulator
  sta inventory_dungeon_flags

  ldx #1
  jsr rotate_password_field_into_accumulator
  sta inventory_entered_dungeon

  ldx #8
  jsr rotate_password_field_into_accumulator
  sta inventory_gp

  rts

rotate_password_field_into_accumulator:

  txa
  tay

  lda #0
  clc
: jsr rotate_password_field_into_carry
  ror
  dex
  bne :-

  ;we picked up these bits in the right order but they are at the most significant side of the
  ;accumulator. rotate them around into the correct position.
  clc
  iny
next_label3:
: rol
  dey
  bne :-

  rts

rotate_password_field_into_carry:

  ror b0
  ror b1
  ror b2
  ror b3
  ror b4
  ror b5

  rts

.endproc
