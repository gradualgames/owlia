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
.include "play_state.inc"

.segment "CODE"

;update routines for entities. The hero and familiar are left blank because
;they only use the entity system for loading CHR graphics.
.define entity_defs_update_address \
  0, \
  0, \
  explosion_update, \
  tiger_update, \
  npcman_update

.define entity_defs_chr_address \
  hero_chr, \
  Familiar_chr, \
  explosion_chr, \
  Tiger_chr, \
  NpcMan_chr

entity_defs_update_address_lo:
  .lobytes entity_defs_update_address
entity_defs_update_address_hi:
  .hibytes entity_defs_update_address

entity_defs_chr_address_lo:
  .lobytes entity_defs_chr_address
entity_defs_chr_address_hi:
  .hibytes entity_defs_chr_address

.segment "ROM01"

.include "hero.inc"
.include "familiar.inc"
.include "explosion.inc"
.include "tiger.inc"
.include "npcman.inc"