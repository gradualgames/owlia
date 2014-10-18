.feature force_range
.include "sprites_and_animations_data.inc"

;The following sets of sprites and animations are
;not associated with the entities module directly.
;They are known about by their respective modules.
.segment "ROM06"

.include "hero_sprites_and_animations.inc"
.include "techs_sprites_and_animations.inc"
.include "familiar_sprites_and_animations.inc"
.include "owliatitle_sprites_and_animations.inc"
.include "cursor_sprites_and_animations.inc"

;The following sets of sprites and animations are
;associated with the entities tables. Each entity
;type knows the bank that its set of sprites and
;animations reside in.

.include "octopus_sprites_and_animations.inc"
.include "explosion_sprites_and_animations.inc"
.include "bomb_sprites_and_animations.inc"
.include "npcman_sprites_and_animations.inc"
.include "npcwoman_sprites_and_animations.inc"
.include "lantern_sprites_and_animations.inc"
.include "coins_sprites_and_animations.inc"
.include "key_sprites_and_animations.inc"
.include "treasure_chest_sprites_and_animations.inc"
.include "pufferfish_sprites_and_animations.inc"
.include "crab_sprites_and_animations.inc"
.include "anglerfish_sprites_and_animations.inc"
.include "spotlight_sprites_and_animations.inc"
.include "octoboss_sprites_and_animations.inc"
.include "tyto_sprites_and_animations.inc"
.include "silmaran_sprites_and_animations.inc"
.include "greathornedowl_sprites_and_animations.inc"
.include "cage_sprites_and_animations.inc"
.include "dungeon_entrance_statue_sprites_and_animations.inc"
.include "intro_cut_scene_great_owls_sprites_and_animations.inc"
.include "intro_cut_scene_mermon_leer_sprites_and_animations.inc"
