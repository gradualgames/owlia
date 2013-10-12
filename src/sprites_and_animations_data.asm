.include "sprites_and_animations_data.inc"

;The following sets of sprites and animations are
;not associated with the entities module directly.
;They are known about by their respective modules.
.segment "ROM00"

.include "hero_sprites_and_animations.inc"
.include "familiar_sprites_and_animations.inc"
.include "owliatitle_sprites_and_animations.inc"
.include "inventory_sprites_and_animations.inc"

;The following sets of sprites and animations are
;associated with the entities tables. Each entity
;type knows the bank that its set of sprites and
;animations reside in.
.segment "ROM00"

.include "octopus_sprites_and_animations.inc"
.include "explosion_sprites_and_animations.inc"
.include "bomb_sprites_and_animations.inc"
.include "npcman_sprites_and_animations.inc"
.include "npcwoman_sprites_and_animations.inc"
.include "lantern_sprites_and_animations.inc"
.include "rope_sprites_and_animations.inc"
.include "coins_sprites_and_animations.inc"

.segment "ROM01"

.include "key_sprites_and_animations.inc"
.include "pufferfish_sprites_and_animations.inc"
