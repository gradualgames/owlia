.linecont +
.include "entities.inc"
.include "sprite_chr_data.inc"
.include "soundengine.inc"
.include "sfx_data.inc"
.include "zp.inc"
.include "ram.inc"
.include "sprites_and_animations_data.inc"
.include "entity.inc"
.include "controller.inc"
.include "map.inc"
.include "actions.inc"
.include "play_state.inc"

.segment "CODE"

;update routines for entities. The hero and familiar are left blank because
;they only use the entity system for loading CHR graphics.
.define entity_defs_update_address \
  explosion_update, \
  jellyfish_update, \
  npcman_update, \
  npcwoman_update

entity_defs_update_address_lo:
  .lobytes entity_defs_update_address
entity_defs_update_address_hi:
  .hibytes entity_defs_update_address

.segment "ROM00"

.include "hero.inc"
.include "familiar.inc"
.include "explosion.inc"
.include "jellyfish.inc"
.include "npcman.inc"
.include "npcwoman.inc"
