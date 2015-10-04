.feature force_range
.include "sprites_and_animations_data.inc"

;The following sets of sprites and animations are
;not associated with the entities module directly.
;They are known about by their respective modules.
.segment "ROM07"

.include "intro_cut_scene_great_owls_sprites_and_animations.inc"
.include "intro_cut_scene_mermon_leer_sprites_and_animations.inc"
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
.include "npc_commodore_sprites_and_animations.inc"
.include "npc_captain_sprites_and_animations.inc"
.include "npc_bosun_sprites_and_animations.inc"
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
.include "cage_sprites_and_animations.inc"
.include "eel_sprites_and_animations.inc"
.include "jellyfish_sprites_and_animations.inc"
.include "urchin_sprites_and_animations.inc"
.include "ice_shards_explosion_sprites_and_animations.inc"
.include "dungeon_entrance_statue_sprites_and_animations.inc"
.include "ice_block_sprites_and_animations.inc"
.include "swordfish_boss_sprites_and_animations.inc"
.include "horseshoe_crab_sprites_and_animations.inc"
.include "seahorse_sprites_and_animations.inc"
.include "crab_boss_sprites_and_animations.inc"
.include "ray_sprites_and_animations.inc"
.include "minigame_sprites_and_animations.inc"
.include "bubbles_sprites_and_animations.inc"

;the rescue owl sprites and animations must all reside in the same bank
.include "greathornedowl_sprites_and_animations.inc"
.include "siberianeagleowl_sprites_and_animations.inc"
.include "greatgrayowl_sprites_and_animations.inc"
.include "sawwhetowl_sprites_and_animations.inc"
.include "barnowl_sprites_and_animations.inc"

.segment "ROM23"

.include "starfish_sprites_and_animations.inc"
.include "tunicate_sprites_and_animations.inc"
.include "clam_sprites_and_animations.inc"
.include "kraken_sprites_and_animations.inc"
.include "mermon_sprites_and_animations.inc"
.include "mermon_head_sprites_and_animations.inc"
.include "fortress_sprites_and_animations.inc"
.include "end_cut_scene_slide1_sprites_and_animations.inc"
.include "end_cut_scene_slide2_sprites_and_animations.inc"
.include "end_cut_scene_slide3_sprites_and_animations.inc"
.include "end_cut_scene_slide4_sprites_and_animations.inc"
.include "end_cut_scene_slide5_sprites_and_animations.inc"
.include "end_cut_scene_slide6_sprites_and_animations.inc"
.include "digit_sprites_and_animations.inc"
