.include "ram.inc"
.include "inventory.inc"

.segment "CODE"

.proc inventory_init

  lda #0
  sta player_lanterns
  sta player_bombs
  sta player_healths
  sta player_keys

  .ifdef LANTERNS
  lda #LANTERNS
  sta player_lanterns
  .endif

  .ifdef BOMBS
  lda #BOMBS
  sta player_bombs
  .endif

  .ifdef HEALTHS
  lda #HEALTHS
  sta player_healths
  .endif

  .ifdef KEYS
  lda #KEYS
  sta player_keys
  .endif

  .ifndef EARNED_TECH
  lda #tech_fetch
  sta player_earned_techs
  .else
  lda #EARNED_TECH
  sta player_earned_techs
  .endif

  lda #tech_rush
  sta player_tech1
  lda #tech_fetch
  sta player_tech2

  ;select tech1 as the currently active tech
  lda #tech1
  sta player_selected_tech

  lda #<0
  sta player_gp
  lda #>0
  sta player_gp+1
  lda #^0
  sta player_gp+2

  lda #0
  sta player_dungeon_flags

  rts

.endproc

;adds a key to the inventory. sets zero flag if
;key was not added (maxed out), clears zero flag
;if key was added.
.proc inventory_add_key

  lda player_keys
  cmp #7
  beq cannot_add_key
  inc player_keys
  rts
cannot_add_key:
  rts

.endproc

;removes a key from the inventory. sets zero flag
;if key was not removed (no keys), clears zero flag
;if key was removed.
.proc inventory_use_key

  lda player_keys
  cmp #0
  beq cannot_remove_key
  dec player_keys
  rts
cannot_remove_key:
  rts

.endproc

.proc inventory_can_use_key

  lda player_keys
  rts

.endproc

.proc inventory_can_add_key

  lda player_keys
  cmp #7
  rts

.endproc
