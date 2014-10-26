.ifndef EEL_SPRITES_AND_ANIMATIONS_INC
EEL_SPRITES_AND_ANIMATIONS_INC = 1

eel0:
  .byte $02
  .byte $ff,$01,$02,$0b,$fd
  .byte $07,$02,$02,$0b,$fd
eel1:
  .byte $04
  .byte $ff,$01,$02,$03,$05
  .byte $ff,$03,$02,$0b,$fd
  .byte $07,$02,$02,$03,$05
  .byte $07,$04,$02,$0b,$fd
eel2:
  .byte $06
  .byte $ff,$01,$02,$fb,$0d
  .byte $ff,$03,$02,$03,$05
  .byte $ff,$05,$02,$0b,$fd
  .byte $07,$02,$02,$fb,$0d
  .byte $07,$04,$02,$03,$05
  .byte $07,$06,$02,$0b,$fd
eel3:
  .byte $08
  .byte $ff,$01,$02,$f3,$15
  .byte $ff,$03,$02,$fb,$0d
  .byte $ff,$05,$02,$03,$05
  .byte $ff,$05,$02,$0b,$fd
  .byte $07,$02,$02,$f3,$15
  .byte $07,$04,$02,$fb,$0d
  .byte $07,$06,$02,$03,$05
  .byte $07,$06,$02,$0b,$fd
eel4:
  .byte $0a
  .byte $ff,$01,$02,$eb,$1d
  .byte $ff,$03,$02,$f3,$15
  .byte $ff,$05,$02,$fb,$0d
  .byte $ff,$05,$02,$03,$05
  .byte $ff,$05,$02,$0b,$fd
  .byte $07,$02,$02,$eb,$1d
  .byte $07,$04,$02,$f3,$15
  .byte $07,$06,$02,$fb,$0d
  .byte $07,$06,$02,$03,$05
  .byte $07,$06,$02,$0b,$fd
eel5:
  .byte $0c
  .byte $ff,$01,$02,$e3,$25
  .byte $ff,$03,$02,$eb,$1d
  .byte $ff,$05,$02,$f3,$15
  .byte $ff,$05,$02,$fb,$0d
  .byte $ff,$05,$02,$03,$05
  .byte $ff,$05,$02,$0b,$fd
  .byte $07,$02,$02,$e3,$25
  .byte $07,$04,$02,$eb,$1d
  .byte $07,$06,$02,$f3,$15
  .byte $07,$06,$02,$fb,$0d
  .byte $07,$06,$02,$03,$05
  .byte $07,$06,$02,$0b,$fd

eel:
  .byte $06, $14
  .word eel0
  .word eel1
  .word eel2
  .word eel3
  .word eel4
  .word eel5
  .word eel4
  .word eel3
  .word eel2
  .word eel1

.endif
