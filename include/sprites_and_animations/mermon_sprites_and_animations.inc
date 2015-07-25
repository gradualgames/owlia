.ifndef MERMON_SPRITES_AND_ANIMATIONS_INC
MERMON_SPRITES_AND_ANIMATIONS_INC = 1

mermon_torso1:
  .byte $0e
  .byte $00,$0a,$02,$00,$18
  .byte $00,$0b,$02,$08,$10
  .byte $00,$0c,$02,$10,$08
  .byte $08,$14,$02,$00,$18
  .byte $08,$15,$02,$08,$10
  .byte $08,$16,$02,$10,$08
  .byte $08,$17,$02,$18,$00
  .byte $10,$1f,$02,$00,$18
  .byte $10,$20,$02,$08,$10
  .byte $10,$21,$02,$10,$08
  .byte $10,$22,$02,$18,$00
  .byte $18,$27,$00,$00,$18
  .byte $18,$2a,$02,$08,$10
  .byte $18,$29,$02,$10,$08
mermon_torso2:
  .byte $0d
  .byte $00,$0d,$02,$00,$18
  .byte $00,$0e,$02,$08,$10
  .byte $00,$0f,$00,$10,$08
  .byte $08,$18,$02,$00,$18
  .byte $08,$19,$02,$08,$10
  .byte $08,$1a,$02,$10,$08
  .byte $10,$23,$02,$00,$18
  .byte $10,$24,$02,$08,$10
  .byte $10,$25,$02,$10,$08
  .byte $10,$26,$02,$18,$00
  .byte $18,$2b,$02,$00,$18
  .byte $18,$2c,$02,$08,$10
  .byte $18,$2d,$02,$10,$08
mermon_tail0:
  .byte $0c
  .byte $00,$2e,$00,$10,$08
  .byte $00,$2f,$00,$18,$00
  .byte $08,$32,$00,$00,$18
  .byte $08,$33,$03,$08,$10
  .byte $08,$34,$03,$10,$08
  .byte $08,$35,$03,$18,$00
  .byte $10,$3c,$03,$08,$10
  .byte $10,$3d,$03,$10,$08
  .byte $10,$3e,$03,$18,$00
  .byte $18,$45,$03,$08,$10
  .byte $18,$46,$03,$10,$08
  .byte $18,$47,$03,$18,$00
mermon_torso0:
  .byte $0e
  .byte $00,$07,$02,$00,$18
  .byte $00,$08,$02,$08,$10
  .byte $00,$09,$02,$10,$08
  .byte $08,$10,$02,$00,$18
  .byte $08,$11,$02,$08,$10
  .byte $08,$12,$02,$10,$08
  .byte $08,$13,$02,$18,$00
  .byte $10,$1b,$02,$00,$18
  .byte $10,$1c,$02,$08,$10
  .byte $10,$1d,$02,$10,$08
  .byte $10,$1e,$02,$18,$00
  .byte $18,$27,$00,$00,$18
  .byte $18,$28,$02,$08,$10
  .byte $18,$29,$02,$10,$08
mermon_tail1:
  .byte $0c
  .byte $00,$30,$00,$10,$08
  .byte $00,$31,$00,$18,$00
  .byte $08,$32,$00,$00,$18
  .byte $08,$33,$03,$08,$10
  .byte $08,$36,$03,$10,$08
  .byte $08,$37,$03,$18,$00
  .byte $10,$3c,$03,$08,$10
  .byte $10,$3f,$03,$10,$08
  .byte $10,$40,$03,$18,$00
  .byte $18,$45,$03,$08,$10
  .byte $18,$48,$03,$10,$08
  .byte $18,$49,$03,$18,$00
mermon_tail2:
  .byte $0b
  .byte $07,$38,$03,$01,$17
  .byte $07,$39,$03,$09,$0f
  .byte $07,$3a,$03,$11,$07
  .byte $07,$3b,$03,$19,$ff
  .byte $0f,$41,$03,$01,$17
  .byte $0f,$42,$03,$09,$0f
  .byte $0f,$43,$03,$11,$07
  .byte $0f,$44,$03,$19,$ff
  .byte $17,$4a,$03,$09,$0f
  .byte $17,$4b,$03,$11,$07
  .byte $17,$4c,$03,$19,$ff

mermon_torso_toss:
  .byte $04, $06
  .word mermon_torso0
  .word mermon_torso1
  .word mermon_torso2
mermon_torso_fly:
  .byte $0a, $02
  .word mermon_torso0
mermon_tail_swim:
  .byte $0a, $08
  .word mermon_tail0
  .word mermon_tail1
  .word mermon_tail2
  .word mermon_tail1

.endif
