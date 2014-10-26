.ifndef EEL_SPRITES_AND_ANIMATIONS_INC
EEL_SPRITES_AND_ANIMATIONS_INC = 1

eel0:
  .byte $02
  .byte $ff,$01,$03,$0b,$fd
  .byte $07,$02,$03,$0b,$fd
eel1:
  .byte $04
  .byte $ff,$01,$03,$03,$05
  .byte $ff,$03,$03,$0b,$fd
  .byte $07,$02,$03,$03,$05
  .byte $07,$04,$03,$0b,$fd
eel2:
  .byte $06
  .byte $ff,$01,$03,$fb,$0d
  .byte $ff,$03,$03,$03,$05
  .byte $ff,$05,$03,$0b,$fd
  .byte $07,$02,$03,$fb,$0d
  .byte $07,$04,$03,$03,$05
  .byte $07,$06,$03,$0b,$fd
eel3:
  .byte $08
  .byte $ff,$01,$03,$f3,$15
  .byte $ff,$03,$03,$fb,$0d
  .byte $ff,$05,$03,$03,$05
  .byte $ff,$05,$03,$0b,$fd
  .byte $07,$02,$03,$f3,$15
  .byte $07,$04,$03,$fb,$0d
  .byte $07,$06,$03,$03,$05
  .byte $07,$06,$03,$0b,$fd
eel4:
  .byte $0a
  .byte $ff,$01,$03,$eb,$1d
  .byte $ff,$03,$03,$f3,$15
  .byte $ff,$05,$03,$fb,$0d
  .byte $ff,$05,$03,$03,$05
  .byte $ff,$05,$03,$0b,$fd
  .byte $07,$02,$03,$eb,$1d
  .byte $07,$04,$03,$f3,$15
  .byte $07,$06,$03,$fb,$0d
  .byte $07,$06,$03,$03,$05
  .byte $07,$06,$03,$0b,$fd
eel5:
  .byte $0c
  .byte $ff,$01,$03,$e3,$25
  .byte $ff,$03,$03,$eb,$1d
  .byte $ff,$05,$03,$f3,$15
  .byte $ff,$05,$03,$fb,$0d
  .byte $ff,$05,$03,$03,$05
  .byte $ff,$05,$03,$0b,$fd
  .byte $07,$02,$03,$e3,$25
  .byte $07,$04,$03,$eb,$1d
  .byte $07,$06,$03,$f3,$15
  .byte $07,$06,$03,$fb,$0d
  .byte $07,$06,$03,$03,$05
  .byte $07,$06,$03,$0b,$fd

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
