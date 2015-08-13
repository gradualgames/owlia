.ifndef SLIDE_DATA_INC
SLIDE_DATA_INC = 1

SLIDE_DATA_BANK = 0
LAST_SLIDE = 255

.struct slide
  bg_chr_bank .byte
  bg_chr_address .word
  nametable_bank .byte
  nametable_address .word
  palette_address .word
  conversation_index .byte
  sprite_chr_groups_address .word
  sprite_overlays_address .word
.endstruct

.global intro_cut_scene_great_owls
.global intro_cut_scene_slide2
.global intro_cut_scene_slide3
.global intro_cut_scene_slide4
.global end_cut_scene_slide1

.endif
