.ifndef EEL_SPRITES_AND_ANIMATIONS_INC
EEL_SPRITES_AND_ANIMATIONS_INC = 1

eel0:
  .byte $02
  .byte $ff,$01,$02,$00,$00
  .byte $07,$02,$02,$00,$00
eel1:
  .byte $04
  .byte $ff,$01,$02,$00,$08
  .byte $ff,$03,$02,$08,$00
  .byte $07,$02,$02,$00,$08
  .byte $07,$04,$02,$08,$00
eel2:
  .byte $06
  .byte $ff,$01,$02,$00,$10
  .byte $ff,$03,$02,$08,$08
  .byte $ff,$05,$02,$10,$00
  .byte $07,$02,$02,$00,$10
  .byte $07,$04,$02,$08,$08
  .byte $07,$06,$02,$10,$00
eel3:
  .byte $08
  .byte $ff,$01,$02,$00,$18
  .byte $ff,$03,$02,$08,$10
  .byte $ff,$05,$02,$10,$08
  .byte $ff,$05,$02,$18,$00
  .byte $07,$02,$02,$00,$18
  .byte $07,$04,$02,$08,$10
  .byte $07,$06,$02,$10,$08
  .byte $07,$06,$02,$18,$00
eel4:
  .byte $0a
  .byte $ff,$01,$02,$00,$20
  .byte $ff,$03,$02,$08,$18
  .byte $ff,$05,$02,$10,$10
  .byte $ff,$05,$02,$18,$08
  .byte $ff,$05,$02,$20,$00
  .byte $07,$02,$02,$00,$20
  .byte $07,$04,$02,$08,$18
  .byte $07,$06,$02,$10,$10
  .byte $07,$06,$02,$18,$08
  .byte $07,$06,$02,$20,$00
eel5:
  .byte $0c
  .byte $ff,$01,$02,$00,$28
  .byte $ff,$03,$02,$08,$20
  .byte $ff,$05,$02,$10,$18
  .byte $ff,$05,$02,$18,$10
  .byte $ff,$05,$02,$20,$08
  .byte $ff,$05,$02,$28,$00
  .byte $07,$02,$02,$00,$28
  .byte $07,$04,$02,$08,$20
  .byte $07,$06,$02,$10,$18
  .byte $07,$06,$02,$18,$10
  .byte $07,$06,$02,$20,$08
  .byte $07,$06,$02,$28,$00

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
