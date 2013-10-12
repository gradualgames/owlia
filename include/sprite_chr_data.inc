.ifndef SPRITE_CHR_INC
SPRITE_CHR_INC = 1

.global sprite_chr_group_addresses_lo
.global sprite_chr_group_addresses_hi
.global sprite_chr_group_bank

.enum
sprite_chr_group_index_hero
sprite_chr_group_index_familiar
sprite_chr_group_index_explosion
sprite_chr_group_index_shadowspot
sprite_chr_group_index_bomb
sprite_chr_group_index_octopus
sprite_chr_group_index_npcman
sprite_chr_group_index_npcwoman
sprite_chr_group_index_key
sprite_chr_group_index_inventory
sprite_chr_group_index_lantern
sprite_chr_group_index_rope
sprite_chr_group_index_coins
sprite_chr_group_index_title
sprite_chr_group_index_pufferfish
.endenum

sprite_chr_group_bank_hero = 1
sprite_chr_group_bank_familiar = 1
sprite_chr_group_bank_explosion = 1
sprite_chr_group_bank_shadowspot = 1
sprite_chr_group_bank_bomb = 1
sprite_chr_group_bank_octopus = 1
sprite_chr_group_bank_npcman = 1
sprite_chr_group_bank_npcwoman = 1
sprite_chr_group_bank_key = 2
sprite_chr_group_bank_inventory = 2
sprite_chr_group_bank_lantern = 2
sprite_chr_group_bank_rope = 2
sprite_chr_group_bank_coins = 2
sprite_chr_group_bank_title = 2
sprite_chr_group_bank_pufferfish = 2

.endif
