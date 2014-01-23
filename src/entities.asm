.linecont +
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
.include "actions.inc"
.include "play_state.inc"
.include "geotests.inc"
.include "conversation_data.inc"
.include "inventory.inc"
.include "camera.inc"
.include "textbox.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "slide_data.inc"

.segment "CODE"

;update routines for entities. The hero and familiar are left blank because
;they only use the entity system for loading CHR graphics.
.define entity_defs_update_address \
  explosion_update, \
  bomb_update, \
  octopus_update, \
  npc_update, \
  key_update, \
  door_update, \
  lantern_update, \
  item_update, \
  innkeep_update, \
  pufferfish_update, \
  crab_update, \
  traproom_update, \
  anglerfish_update, \
  spotlight_update, \
  spotlight_puzzle_update, \
  octoboss_head_update, \
  octoboss_legs_update, \
  splash_update, \
  intro_update, \
  silmaran_update, \
  monolith_update

entity_defs_update_address_lo:
  .lobytes entity_defs_update_address
entity_defs_update_address_hi:
  .hibytes entity_defs_update_address

entity_defs_update_address_bank:
  .byte entity_update_bank_explosion
  .byte entity_update_bank_bomb
  .byte entity_update_bank_octopus
  .byte entity_update_bank_npc
  .byte entity_update_bank_key
  .byte entity_update_bank_door
  .byte entity_update_bank_lantern
  .byte entity_update_bank_item
  .byte entity_update_bank_innkeep
  .byte entity_update_bank_pufferfish
  .byte entity_update_bank_crab
  .byte entity_update_bank_traproom
  .byte entity_update_bank_anglerfish
  .byte entity_update_bank_spotlight
  .byte entity_update_bank_spotlight_puzzle
  .byte entity_update_bank_octoboss_head
  .byte entity_update_bank_octoboss_legs
  .byte entity_update_bank_splash
  .byte entity_update_bank_intro
  .byte entity_update_bank_silmaran
  .byte entity_update_bank_monolith

entity_defs_sprites_and_animations_bank:
  .byte entity_sprites_and_animations_bank_explosion
  .byte entity_sprites_and_animations_bank_bomb
  .byte entity_sprites_and_animations_bank_octopus
  .byte entity_sprites_and_animations_bank_npc
  .byte entity_sprites_and_animations_bank_key
  .byte entity_sprites_and_animations_bank_door
  .byte entity_sprites_and_animations_bank_lantern
  .byte entity_sprites_and_animations_bank_item
  .byte entity_sprites_and_animations_bank_innkeep
  .byte entity_sprites_and_animations_bank_pufferfish
  .byte entity_sprites_and_animations_bank_crab
  .byte 0 ;entity_sprites_and_animations_bank_traproom
  .byte entity_sprites_and_animations_bank_anglerfish
  .byte entity_sprites_and_animations_bank_spotlight
  .byte 0 ;entity_sprites_and_animations_bank_spotlight_puzzle
  .byte entity_sprites_and_animations_bank_octoboss_head
  .byte entity_sprites_and_animations_bank_octoboss_legs
  .byte entity_sprites_and_animations_bank_splash
  .byte entity_sprites_and_animations_bank_intro
  .byte entity_sprites_and_animations_bank_silmaran
  .byte 0 ;entity_sprites_and_animations_bank_monolith

.segment "ROM05"
.include "explosion.inc"
.include "bomb.inc"
.include "octopus.inc"
.include "npc.inc"
.include "key.inc"
.include "door.inc"
.include "lantern.inc"
.include "item.inc"
.include "innkeep.inc"
.include "pufferfish.inc"
.include "crab.inc"
.include "traproom.inc"
.include "anglerfish.inc"
.include "spotlight.inc"
.include "spotlight_puzzle.inc"
.include "octoboss_head.inc"
.include "octoboss_legs.inc"
.include "splash.inc"
.include "intro.inc"
.include "silmaran.inc"
.include "monolith.inc"
