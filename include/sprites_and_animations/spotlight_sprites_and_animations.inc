.ifndef SPOTLIGHT_SPRITES_AND_ANIMATIONS_INC
SPOTLIGHT_SPRITES_AND_ANIMATIONS_INC = 1

SpotLight0:
  .byte $02
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00

SpotLight:
  .byte $0a,$02
  .word SpotLight0

.endif
