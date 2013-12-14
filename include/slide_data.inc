.ifndef SLIDE_DATA_INC
SLIDE_DATA_INC = 1

SLIDE_DATA_BANK = 10

.struct slide
  bg_chr_bank .byte
  bg_chr_address .word
  nametable_bank .byte
  nametable_address .word
  palette_address .word
  conversation_index .byte
.endstruct

.global intro_cut_scene_slide1

.endif
