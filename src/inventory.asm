.feature force_range
.include "zp.inc"
.include "ram.inc"
.include "inventory.inc"
.include "charmap.inc"
.include "textbox.inc"
.include "ndxdebug.h"

.segment "CODE"

.proc inventory_init

  lda #0
  sta inventory_lanterns
  sta inventory_bombs
  sta inventory_healths
  sta inventory_keys

  .ifdef LANTERNS
  lda #LANTERNS
  sta inventory_lanterns
  .endif

  .ifdef BOMBS
  lda #BOMBS
  sta inventory_bombs
  .endif

  .ifdef HEALTHS
  lda #HEALTHS
  sta inventory_healths
  .endif

  .ifdef KEYS
  lda #KEYS
  sta inventory_keys
  .endif

  .ifndef EARNED_TECH
  lda #tech_fetch
  sta inventory_earned_techs
  .else
  lda #EARNED_TECH
  sta inventory_earned_techs
  .endif

  lda #tech_rush
  sta inventory_tech1
  lda #tech_fetch
  sta inventory_tech2

  ;select tech1 as the currently active tech
  lda #tech1
  sta inventory_selected_tech

  lda #<0
  sta inventory_gp
  lda #>0
  sta inventory_gp+1
  lda #^0
  sta inventory_gp+2

  lda #0
  sta inventory_dungeon_flags

  rts

.endproc

;adds a key to the inventory. sets zero flag if
;key was not added (maxed out), clears zero flag
;if key was added.
.proc inventory_add_key

  lda inventory_keys
  cmp #7
  beq cannot_add_key
  inc inventory_keys
  rts
cannot_add_key:
  rts

.endproc

;removes a key from the inventory. sets zero flag
;if key was not removed (no keys), clears zero flag
;if key was removed.
.proc inventory_use_key

  lda inventory_keys
  cmp #0
  beq cannot_remove_key
  dec inventory_keys
  rts
cannot_remove_key:
  rts

.endproc

.proc inventory_can_use_key

  lda inventory_keys
  rts

.endproc

.proc inventory_can_add_key

  lda inventory_keys
  cmp #7
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
.proc inventory_generate_password_bit_field

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

  lda inventory_earned_techs
  ldx #3
  jsr rotate_value_into_password_field

  lda inventory_dungeon_flags
  ldx #8
  jsr rotate_value_into_password_field

  lda inventory_gp
  ldx #8
  jsr rotate_value_into_password_field

  lda inventory_gp+1
  ldx #8
  jsr rotate_value_into_password_field

  lda inventory_gp+2
  ldx #8
  jsr rotate_value_into_password_field

  ;rotate in 0 as the unused bit
  lda #0
  ldx #1
  jsr rotate_value_into_password_field

  ;copy b0 through b5 into the password field
  ldy #5
: lda b0,y
  ;obfuscate the password field on the way out
  eor password_obfuscation_masks,y
  sta (w0),y
  dey
  bne :-

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

  ror b5
  ror b4
  ror b3
  ror b2
  ror b1
  ror b0

  rts

.endproc

;generates a password string from a 6 byte password bit field
;expects w0 to contain the address of the 6 byte bit field
;expects w1 to contain the address of the string buffer to which
;to write the string.
.proc inventory_generate_password_string

  ;copy password field into b0 through b5
  ldy #5
: lda (w0),y
  sta b0,y
  dey
  bne :-

  clc

  ldy #0

next_password_character:
  ;rotate 4 bits into accumulator
  lda #0
  ldx #4
: jsr rotate_password_field_into_carry
  rol
  dex
  bne :-

  ;store accumulator (+ 'A' to get beginning of actual text font) in string buffer
  clc
  adc #'A'
  sta (w1),y

  iny
  cpy #12
  bne next_password_character

  ;store end of string character to finish off the password string
  lda #ES
  sta (w1),y

  rts

rotate_password_field_into_carry:

  rol b5
  rol b4
  rol b3
  rol b2
  rol b1

  rts

.endproc

