.feature force_range
.include "zp.inc"
.include "ram.inc"
.include "inventory.inc"
.include "charmap_password.inc"
.include "textbox.inc"
.include "ndxdebug.h"

.segment "CODE"

.proc inventory_init

  lda #0
  sta inventory_lanterns
  sta inventory_bombs
  sta inventory_healths
  sta inventory_keys

  lda #tech_rush
  sta inventory_tech1
  lda #tech_fetch
  sta inventory_tech2

  lda #tech_fetch
  sta inventory_earned_techs

  ;select tech1 as the currently active tech
  lda #tech1
  sta inventory_selected_tech

  lda #<0
  sta inventory_gp
  lda #>0
  sta inventory_gp+1
  lda #^0
  sta inventory_gp+2

  ;start inventory_dungeon_flags at %11111111 to indicate
  ;that a dungeon has not yet been entered. When it is
  ;%00000000, the dungeon has been entered, and when it
  ;has any bits set, the dungeon is partially completed.
  lda #INVENTORY_DUNGEON_FLAGS_NOT_YET_ENTERED
  sta inventory_dungeon_flags

  .ifdef LANTERNS
  lda #LANTERNS
  sta inventory_lanterns
  .endif

  .ifdef BOMBS
  lda #BOMBS
  sta inventory_bombs
  .endif

  .ifdef HEALTHS
  lda #HEALTHS
  sta inventory_healths
  .endif

  .ifdef KEYS
  lda #KEYS
  sta inventory_keys
  .endif

  .ifdef EARNED_TECH
  lda #EARNED_TECH
  sta inventory_earned_techs
  .endif

  .ifdef GP
  lda #<GP
  sta inventory_gp
  lda #>GP
  sta inventory_gp+1
  lda #^GP
  sta inventory_gp+2
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
