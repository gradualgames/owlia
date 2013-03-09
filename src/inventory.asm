.include "ram.inc"
.include "inventory.inc"

.segment "CODE"

.proc inventory_max_all

  ;max out all item counts
  lda #7
  sta inventory_lanterns
  sta inventory_bombs
  sta inventory_ropes
  sta inventory_healths
  sta inventory_owl_healths

  ;set the owl to carry bombs
  lda #INVENTORY_BOMB_ID
  sta inventory_owl_carry_item

  ;set all techs earned
  lda #tech_multi_homing_earned
  sta inventory_earned_techs

  lda #0
  sta inventory_tech1
  lda #1
  sta inventory_tech2
  rts

.endproc
