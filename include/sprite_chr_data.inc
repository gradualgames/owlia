.ifndef SPRITE_CHR_INC
SPRITE_CHR_INC = 1

SHADOWSPOT_SPR_CHR_BANK = 1

.global sprite_chr_group_addresses_lo
.global sprite_chr_group_addresses_hi

.global hero_chr
.global Familiar_chr
.global JellyFish_chr
.global explosion_chr
.global ShadowSpot_chr
.global NpcMan_chr
.global NpcWoman_chr
.global Key_chr
.global Inventory_chr
.global KeyedDoor_chr
.global Bomb_chr
.global Lantern_chr

.enum
sprite_chr_group_index_hero
sprite_chr_group_index_familiar
sprite_chr_group_index_explosion
sprite_chr_group_index_shadowspot
sprite_chr_group_index_bomb
sprite_chr_group_index_jellyfish
sprite_chr_group_index_npcman
sprite_chr_group_index_npcwoman
sprite_chr_group_index_key
sprite_chr_group_index_inventory
sprite_chr_group_index_keyeddoor
sprite_chr_group_index_lantern
sprite_chr_group_index_rope
.endenum

.endif
