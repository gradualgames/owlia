.linecont +
.include "sprite_chr_data.inc"

.segment "CODE"

.define sprite_chr_group_addresses \
  intro_cut_scene_great_owls_spr_chr, \
  intro_cut_scene_mermon_leer_spr_chr, \
  hero_chr, \
  rushtech_chr, \
  fetchtech_chr, \
  unlocktech_chr, \
  bombtech_chr, \
  lanterntech_chr, \
  carrytech_chr, \
  shieldtech_chr, \
  homingtech_chr, \
  familiar_chr, \
  tyto_chr, \
  explosion_chr, \
  shadowspot_chr, \
  bomb_chr, \
  octopus_chr, \
  npcman_chr, \
  npcwoman_chr, \
  npc_commodore_chr, \
  npc_captain_chr, \
  npc_bosun_chr, \
  key_chr, \
  treasure_chest_chr, \
  cursor_spr_chr, \
  lantern_chr, \
  coins_chr, \
  owliatitle_spr_chr, \
  pufferfish_chr, \
  crab_chr, \
  anglerfish_chr, \
  spotlight_chr, \
  octoboss_chr, \
  splash_chr, \
  silmaran_chr, \
  greathornedowl_chr, \
  cage_chr, \
  dungeon_entrance_statue_chr, \
  eel_chr, \
  jellyfish_chr, \
  urchin_chr, \
  ice_shards_chr, \
  ice_block_chr, \
  swordfish_boss_chr, \
  siberianeagleowl_chr, \
  horseshoe_crab_chr, \
  seahorse_chr, \
  crab_boss_chr, \
  greatgrayowl_chr, \
  starfish_chr, \
  tunicate_chr, \
  clam_chr, \
  ray_chr, \
  sawwhetowl_chr, \
  minigame_chr, \
  kraken_chr, \
  barnowl_chr, \
  mermon_chr, \
  mermon_head_chr

sprite_chr_group_addresses_lo:
  .lobytes sprite_chr_group_addresses
sprite_chr_group_addresses_hi:
  .hibytes sprite_chr_group_addresses

sprite_chr_group_bank:
  .byte sprite_chr_group_bank_intro_cut_scene_great_owls
  .byte sprite_chr_group_bank_intro_cut_scene_mermon_leer
  .byte sprite_chr_group_bank_hero
  .byte sprite_chr_group_bank_rushtech
  .byte sprite_chr_group_bank_fetchtech
  .byte sprite_chr_group_bank_unlocktech
  .byte sprite_chr_group_bank_bombtech
  .byte sprite_chr_group_bank_lanterntech
  .byte sprite_chr_group_bank_carrytech
  .byte sprite_chr_group_bank_shieldtech
  .byte sprite_chr_group_bank_homingtech
  .byte sprite_chr_group_bank_familiar
  .byte sprite_chr_group_bank_tyto
  .byte sprite_chr_group_bank_explosion
  .byte sprite_chr_group_bank_shadowspot
  .byte sprite_chr_group_bank_bomb
  .byte sprite_chr_group_bank_octopus
  .byte sprite_chr_group_bank_npcman
  .byte sprite_chr_group_bank_npcwoman
  .byte sprite_chr_group_bank_npc_commodore
  .byte sprite_chr_group_bank_npc_captain
  .byte sprite_chr_group_bank_npc_bosun
  .byte sprite_chr_group_bank_key
  .byte sprite_chr_group_bank_treasure_chest
  .byte sprite_chr_group_bank_cursor
  .byte sprite_chr_group_bank_lantern
  .byte sprite_chr_group_bank_coins
  .byte sprite_chr_group_bank_title
  .byte sprite_chr_group_bank_pufferfish
  .byte sprite_chr_group_bank_crab
  .byte sprite_chr_group_bank_anglerfish
  .byte sprite_chr_group_bank_spotlight
  .byte sprite_chr_group_bank_octoboss
  .byte sprite_chr_group_bank_splash
  .byte sprite_chr_group_bank_silmaran
  .byte sprite_chr_group_bank_greathornedowl
  .byte sprite_chr_group_bank_cage
  .byte sprite_chr_group_bank_dungeon_entrance_statue
  .byte sprite_chr_group_bank_eel
  .byte sprite_chr_group_bank_jellyfish
  .byte sprite_chr_group_bank_urchin
  .byte sprite_chr_group_bank_ice_shards
  .byte sprite_chr_group_bank_ice_block
  .byte sprite_chr_group_bank_swordfish_boss
  .byte sprite_chr_group_bank_siberianeagleowl
  .byte sprite_chr_group_bank_horseshoe_crab
  .byte sprite_chr_group_bank_seahorse
  .byte sprite_chr_group_bank_crab_boss
  .byte sprite_chr_group_bank_greatgrayowl
  .byte sprite_chr_group_bank_starfish
  .byte sprite_chr_group_bank_tunicate
  .byte sprite_chr_group_bank_clam
  .byte sprite_chr_group_bank_ray
  .byte sprite_chr_group_bank_sawwhetowl
  .byte sprite_chr_group_bank_minigame
  .byte sprite_chr_group_bank_kraken
  .byte sprite_chr_group_bank_barnowl
  .byte sprite_chr_group_bank_mermon
  .byte sprite_chr_group_bank_mermon_head

.segment "ROM08"

intro_cut_scene_great_owls_spr_chr:
.incbin "intro_cut_scene_great_owls_spr.chr"

intro_cut_scene_mermon_leer_spr_chr:
.incbin "intro_cut_scene_mermon_leer_spr.chr"

hero_chr:
.incbin "hero.chr"

rushtech_chr:
.incbin "rushtech.chr"

fetchtech_chr:
.incbin "fetchtech.chr"

unlocktech_chr:
.incbin "unlocktech.chr"

bombtech_chr:
.incbin "bombtech.chr"

carrytech_chr:
.incbin "carrytech.chr"

lanterntech_chr:
.incbin "lanterntech.chr"

shieldtech_chr:
.incbin "shieldtech.chr"

homingtech_chr:
.incbin "homingtech.chr"

familiar_chr:
.incbin "familiar.chr"

tyto_chr:
.incbin "tyto.chr"

octopus_chr:
.incbin "octopus.chr"

explosion_chr:
.incbin "explosion.chr"

shadowspot_chr:
.incbin "shadowspot.chr"

bomb_chr:
.incbin "bomb.chr"

npcman_chr:
.incbin "npcman.chr"

npcwoman_chr:
.incbin "npcwoman.chr"

key_chr:
.incbin "key.chr"

treasure_chest_chr:
.incbin "treasure_chest.chr"

cursor_spr_chr:
.incbin "cursor_spr.chr"

lantern_chr:
.incbin "lantern.chr"

coins_chr:
.incbin "coins.chr"

owliatitle_spr_chr:
.incbin "owliatitle_spr.chr"

pufferfish_chr:
.incbin "pufferfish.chr"

crab_chr:
.incbin "crab.chr"

anglerfish_chr:
.incbin "anglerfish.chr"

spotlight_chr:
.incbin "spotlight.chr"

octoboss_chr:
.incbin "octoboss.chr"

splash_chr:
.incbin "splash.chr"

silmaran_chr:
.incbin "silmaran.chr"

greathornedowl_chr:
.incbin "greathornedowl.chr"

cage_chr:
.incbin "cage.chr"

eel_chr:
.incbin "eel.chr"

jellyfish_chr:
.incbin "jellyfish.chr"

urchin_chr:
.incbin "urchin.chr"

ice_shards_chr:
.incbin "ice_shards.chr"

ice_block_chr:
.incbin "ice_block.chr"

dungeon_entrance_statue_chr:
.incbin "dungeon_entrance_statue.chr"

swordfish_boss_chr:
.incbin "swordfish_boss.chr"

siberianeagleowl_chr:
.incbin "siberianeagleowl.chr"

horseshoe_crab_chr:
.incbin "horseshoe_crab.chr"

seahorse_chr:
.incbin "seahorse.chr"

.segment "ROM24"

crab_boss_chr:
.incbin "crab_boss.chr"

greatgrayowl_chr:
.incbin "greatgrayowl.chr"

starfish_chr:
.incbin "starfish.chr"

tunicate_chr:
.incbin "tunicate.chr"

clam_chr:
.incbin "clam.chr"

ray_chr:
.incbin "ray.chr"

sawwhetowl_chr:
.incbin "sawwhetowl.chr"

minigame_chr:
.incbin "minigame.chr"

npc_commodore_chr:
.incbin "npc_commodore.chr"

npc_captain_chr:
.incbin "npc_captain.chr"

npc_bosun_chr:
.incbin "npc_bosun.chr"

kraken_chr:
.incbin "kraken.chr"

barnowl_chr:
.incbin "barnowl.chr"

mermon_chr:
.incbin "mermon.chr"

mermon_head_chr:
.incbin "mermon_head.chr"
