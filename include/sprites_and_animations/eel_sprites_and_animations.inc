.ifndef EEL_SPRITES_AND_ANIMATIONS_INC
EEL_SPRITES_AND_ANIMATIONS_INC = 1

eel0:
  .byte $02
  .byte $ff,$01,$02,$03,$fd
  .byte $07,$02,$02,$03,$fd
eel1:
  .byte $04
  .byte $ff,$01,$02,$03,$05
  .byte $ff,$03,$02,$0b,$fd
  .byte $07,$02,$02,$03,$05
  .byte $07,$04,$02,$0b,$fd
eel2:
  .byte $06
  .byte $ff,$01,$02,$03,$0d
  .byte $ff,$03,$02,$0b,$05
  .byte $ff,$05,$02,$13,$fd
  .byte $07,$02,$02,$03,$0d
  .byte $07,$04,$02,$0b,$05
  .byte $07,$06,$02,$13,$fd
eel3:
  .byte $08
  .byte $ff,$01,$02,$03,$15
  .byte $ff,$03,$02,$0b,$0d
  .byte $ff,$05,$02,$13,$05
  .byte $ff,$05,$02,$1b,$fd
  .byte $07,$02,$02,$03,$15
  .byte $07,$04,$02,$0b,$0d
  .byte $07,$06,$02,$13,$05
  .byte $07,$06,$02,$1b,$fd
eel4:
  .byte $0a
  .byte $ff,$01,$02,$03,$1d
  .byte $ff,$03,$02,$0b,$15
  .byte $ff,$05,$02,$13,$0d
  .byte $ff,$05,$02,$1b,$05
  .byte $ff,$05,$02,$23,$fd
  .byte $07,$02,$02,$03,$1d
  .byte $07,$04,$02,$0b,$15
  .byte $07,$06,$02,$13,$0d
  .byte $07,$06,$02,$1b,$05
  .byte $07,$06,$02,$23,$fd
eel5:
  .byte $0c
  .byte $ff,$01,$02,$03,$25
  .byte $ff,$03,$02,$0b,$1d
  .byte $ff,$05,$02,$13,$15
  .byte $ff,$05,$02,$1b,$0d
  .byte $ff,$05,$02,$23,$05
  .byte $ff,$05,$02,$2b,$fd
  .byte $07,$02,$02,$03,$25
  .byte $07,$04,$02,$0b,$1d
  .byte $07,$06,$02,$13,$15
  .byte $07,$06,$02,$1b,$0d
  .byte $07,$06,$02,$23,$05
  .byte $07,$06,$02,$2b,$fd

eel:
  .byte $04, $14
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
