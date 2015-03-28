.linecont +
.include "ndxdebug.h"
.include "entities.inc"
.include "hero_constants.inc"
.include "hero.inc"
.include "familiar_constants.inc"
.include "familiar.inc"
.include "entities.inc"
.include "sprite.inc"
.include "sprite_chr_data.inc"
.include "soundengine.inc"
.include "sfx_data.inc"
.include "music_data.inc"
.include "zp.inc"
.include "ram.inc"
.include "sprites_and_animations_data.inc"
.include "entity.inc"
.include "controller.inc"
.include "map.inc"
.include "patch.inc"
.include "play_state.inc"
.include "geotests.inc"
.include "conversation_data.inc"
.include "inventory.inc"
.include "camera.inc"
.include "textbox.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "slide_data.inc"
.include "locations.inc"
.include "areas.inc"
.include "util.inc"

.segment "ROM00"

;update routines for entities. The hero and familiar are left blank because
;they only use the entity system for loading CHR graphics.
.define entity_defs_update_address \
  instance_placeholder_update, \
  explosion_update, \
  projectile_update, \
  bomb_update, \
  octopus_update, \
  npc_update, \
  key_update, \
  treasure_chest_update, \
  lantern_update, \
  item_update, \
  pufferfish_update, \
  crab_update, \
  traproom_update, \
  treasure_room_update, \
  anglerfish_update, \
  spotlight_update, \
  spotlight_puzzle_update, \
  octoboss_head_update, \
  octoboss_legs_update, \
  splash_update, \
  intro_update, \
  silmaran_update, \
  rescueowl_update, \
  cage_update, \
  monolith_update, \
  dungeon_entrance_statue_update, \
  eel_update, \
  jellyfish_update, \
  urchin_update, \
  ice_shards_explosion_update, \
  bombable_wall_update, \
  ice_block_update, \
  ordered_defeat_puzzle_update, \
  simultaneous_defeat_puzzle_update, \
  swordfish_boss_update, \
  horseshoe_crab_update, \
  monolith_puzzle_update, \
  triple_anglerfish_puzzle_update, \
  seahorse_update, \
  crab_boss_body_update, \
  crab_boss_pincer_update, \
  crab_boss_eye_update, \
  starfish_update, \
  tunicate_update, \
  clam_update, \
  switch_update, \
  switch_puzzle_update

entity_defs_update_address_lo:
  .lobytes entity_defs_update_address
entity_defs_update_address_hi:
  .hibytes entity_defs_update_address

entity_defs_update_address_bank:
  .byte entity_update_bank_instance_placeholder
  .byte entity_update_bank_explosion
  .byte entity_update_bank_projectile
  .byte entity_update_bank_bomb
  .byte entity_update_bank_octopus
  .byte entity_update_bank_npc
  .byte entity_update_bank_key
  .byte entity_update_bank_treasure_chest
  .byte entity_update_bank_lantern
  .byte entity_update_bank_item
  .byte entity_update_bank_pufferfish
  .byte entity_update_bank_crab
  .byte entity_update_bank_traproom
  .byte entity_update_bank_treasure_room
  .byte entity_update_bank_anglerfish
  .byte entity_update_bank_spotlight
  .byte entity_update_bank_spotlight_puzzle
  .byte entity_update_bank_octoboss_head
  .byte entity_update_bank_octoboss_legs
  .byte entity_update_bank_splash
  .byte entity_update_bank_intro
  .byte entity_update_bank_silmaran
  .byte entity_update_bank_rescueowl
  .byte entity_update_bank_cage
  .byte entity_update_bank_monolith
  .byte entity_update_bank_dungeon_entrance_statue
  .byte entity_update_bank_eel
  .byte entity_update_bank_jellyfish
  .byte entity_update_bank_urchin
  .byte entity_update_bank_ice_shards_explosion
  .byte entity_update_bank_bombable_wall
  .byte entity_update_bank_ice_block
  .byte entity_update_bank_ordered_defeat_puzzle
  .byte entity_update_bank_simultaneous_defeat_puzzle
  .byte entity_update_bank_swordfish_boss
  .byte entity_update_bank_horseshoe_crab
  .byte entity_update_bank_monolith_puzzle
  .byte entity_update_bank_triple_anglerfish_puzzle
  .byte entity_update_bank_seahorse
  .byte entity_update_bank_crab_boss_body
  .byte entity_update_bank_crab_boss_pincer
  .byte entity_update_bank_crab_boss_eye
  .byte entity_update_bank_starfish
  .byte entity_update_bank_tunicate
  .byte entity_update_bank_clam
  .byte entity_update_bank_switch
  .byte entity_update_bank_switch_puzzle

entity_defs_sprites_and_animations_bank:
  .byte 0 ;entity_sprites_and_animations_bank_instance_placeholder
  .byte entity_sprites_and_animations_bank_explosion
  .byte entity_sprites_and_animations_bank_projectile
  .byte entity_sprites_and_animations_bank_bomb
  .byte entity_sprites_and_animations_bank_octopus
  .byte entity_sprites_and_animations_bank_npc
  .byte entity_sprites_and_animations_bank_key
  .byte entity_sprites_and_animations_bank_treasure_chest
  .byte entity_sprites_and_animations_bank_lantern
  .byte entity_sprites_and_animations_bank_item
  .byte entity_sprites_and_animations_bank_pufferfish
  .byte entity_sprites_and_animations_bank_crab
  .byte 0 ;entity_sprites_and_animations_bank_traproom
  .byte 0 ;entity_sprites_and_animations_bank_treasure_room
  .byte entity_sprites_and_animations_bank_anglerfish
  .byte entity_sprites_and_animations_bank_spotlight
  .byte 0 ;entity_sprites_and_animations_bank_spotlight_puzzle
  .byte entity_sprites_and_animations_bank_octoboss_head
  .byte entity_sprites_and_animations_bank_octoboss_legs
  .byte entity_sprites_and_animations_bank_splash
  .byte entity_sprites_and_animations_bank_intro
  .byte entity_sprites_and_animations_bank_silmaran
  .byte entity_sprites_and_animations_bank_rescueowl
  .byte entity_sprites_and_animations_bank_cage
  .byte 0 ;entity_sprites_and_animations_bank_monolith
  .byte entity_sprites_and_animations_bank_dungeon_entrance_statue
  .byte entity_sprites_and_animations_bank_eel
  .byte entity_sprites_and_animations_bank_jellyfish
  .byte entity_sprites_and_animations_bank_urchin
  .byte entity_sprites_and_animations_bank_ice_shards_explosion
  .byte 0 ;entity_sprites_and_animations_bank_bombable_wall
  .byte entity_sprites_and_animations_bank_ice_block
  .byte 0 ;entity_sprites_and_animations_bank_ordered_defeat_puzzle
  .byte 0 ;entity_sprites_and_animations_bank_simultaneous_defeat_puzzle
  .byte entity_sprites_and_animations_bank_swordfish_boss
  .byte entity_sprites_and_animations_bank_horseshoe_crab
  .byte 0 ;entity_sprites_and_animations_bank_monolith_puzzle
  .byte 0 ;entity_sprites_and_animations_bank_triple_anglerfish_puzzle
  .byte entity_sprites_and_animations_bank_seahorse
  .byte entity_sprites_and_animations_bank_crab_boss_body
  .byte entity_sprites_and_animations_bank_crab_boss_pincer
  .byte entity_sprites_and_animations_bank_crab_boss_eye
  .byte entity_sprites_and_animations_bank_starfish
  .byte entity_sprites_and_animations_bank_tunicate
  .byte entity_sprites_and_animations_bank_clam
  .byte 0 ;entity_sprites_and_animations_bank_switch
  .byte 0 ;entity_sprites_and_animations_bank_switch_puzzle

.segment "ROM04"
.include "instance_placeholder.inc"
.include "explosion.inc"
.include "projectile.inc"
.include "bomb.inc"
.include "octopus.inc"
.include "npc.inc"
.include "key.inc"
.include "treasure_chest.inc"
.include "lantern.inc"
.include "item.inc"
.include "pufferfish.inc"
.include "crab.inc"
.include "traproom.inc"
.include "treasure_room.inc"
.include "anglerfish.inc"
.include "spotlight.inc"
.include "spotlight_puzzle.inc"
.include "octoboss_head.inc"
.include "octoboss_legs.inc"
.include "splash.inc"
.include "intro.inc"
.include "silmaran.inc"
.include "rescueowl.inc"
.include "cage.inc"
.include "monolith.inc"
.include "dungeon_entrance_statue.inc"
.include "eel.inc"
.segment "ROM05"
.include "jellyfish.inc"
.include "urchin.inc"
.include "ice_shards_explosion.inc"
.include "bombable_wall.inc"
.include "ice_block.inc"
.include "ordered_defeat_puzzle.inc"
.include "simultaneous_defeat_puzzle.inc"
.include "swordfish_boss.inc"
.include "horseshoe_crab.inc"
.include "monolith_puzzle.inc"
.include "triple_anglerfish_puzzle.inc"
.include "seahorse.inc"
.include "crab_boss_body.inc"
.include "crab_boss_pincer.inc"
.include "crab_boss_eye.inc"
.include "starfish.inc"
.include "tunicate.inc"
.include "clam.inc"
.include "switch.inc"
.include "switch_puzzle.inc"
