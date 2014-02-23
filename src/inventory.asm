.include "ram.inc"
.include "inventory.inc"

.segment "CODE"

.proc inventory_init

  .ifdef ALL_ITEMS

  ;max out all item counts
  lda #7
  sta inventory_lanterns
  sta inventory_bombs
  sta inventory_healths
  sta inventory_owl_healths
  sta inventory_keys

  ;set all techs earned
  lda #tech_homing
  sta inventory_earned_techs

  ;select default tech 1 and tech 2
  lda #tech_rush
  sta inventory_tech1
  lda #tech_fetch
  sta inventory_tech2

  ;select tech1 as the currently active tech
  lda #tech1
  sta inventory_selected_tech

  lda #<20
  sta inventory_gp
  lda #>20
  sta inventory_gp+1

  .else
  lda #0
  sta inventory_lanterns
  sta inventory_bombs
  sta inventory_healths
  sta inventory_owl_healths
  sta inventory_keys

  lda #tech_rush
  sta inventory_earned_techs

  lda #tech_rush
  sta inventory_tech1
  lda #tech_rush
  sta inventory_tech2

  ;select tech1 as the currently active tech
  lda #tech1
  sta inventory_selected_tech

  lda #<20
  sta inventory_gp
  lda #>20
  sta inventory_gp+1

  .endif

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
