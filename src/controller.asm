.include "ram.inc"
.include "controller.inc"

.segment "CODE"

.proc controller_clear

  lda #%00000010
  sta buffer_controller+buttons::_a
  sta buffer_controller+buttons::_b
  sta buffer_controller+buttons::_left
  sta buffer_controller+buttons::_right
  sta buffer_controller+buttons::_select
  sta buffer_controller+buttons::_start

  rts

.endproc

;reads only the start button into its buffer byte
.proc controller_read_start

  lda #$01  ; strobe joypad
  sta $4016
  lda #$00
  sta $4016

  lda $4016  ; A
  lda $4016  ; B
  lda $4016          ; Select
  lda $4016          ; Start
  ror
  rol buffer_controller+3

  rts

.endproc

;deserializes the controller into a buffer
;output: buffer_controller
.proc controller_read
  lda #$01  ; strobe joypad
  sta $4016
  lda #$00
  sta $4016

  lda $4016  ; A
  ;put button bit into carry
  ror
  ;put carry bit into controller buffer. use rol to keep
  ;history of button presses.
  rol buffer_controller

  lda $4016  ; B
  ror
  rol buffer_controller+1

  lda $4016          ; Select
  ror
  rol buffer_controller+2

  lda $4016          ; Start
  ror
  rol buffer_controller+3

  lda $4016          ; Up
  ror
  rol buffer_controller+4
  lda $4016          ; Down
  ror
  rol buffer_controller+5
  lda $4016          ; Left
  ror
  rol buffer_controller+6
  lda $4016          ; Right
  ror
  rol buffer_controller+7
  rts
.endproc
