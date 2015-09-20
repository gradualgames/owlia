.ifndef SLIDE_DATA_INC
SLIDE_DATA_INC = 1

SLIDE_DATA_BANK = 31
LAST_SLIDE = 255

.enum
SLIDE_TYPE_TEXTBOX
SLIDE_TYPE_IMAGE_ONLY
SLIDE_TYPE_STRINGS_ONLY
.endenum

SLIDE_LENGTH_INFINITE = 0

.struct slide
  slide_type .byte
  bg_chr_bank .byte
  bg_chr_address .word
  nametable_bank .byte
  nametable_address .word
  palette_address .word
  conversation_index .byte
  slide_length .byte
  sprite_chr_groups_address .word
  sprite_overlays_address .word
  strings_address .word
  song_address .word
.endstruct

.global intro_cut_scene_great_owls
.global intro_cut_scene_slide2
.global intro_cut_scene_slide3
.global intro_cut_scene_slide4
.global end_cut_scene_slide1

.endif
