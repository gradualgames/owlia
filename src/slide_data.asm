.include "slide_data.inc"
.include "conversation_data.inc"
.include "bg_chr_data.inc"
.include "nametable_data.inc"

.segment "ROM10"

intro_cut_scene_slide1_palette:
  .byte $0e,$28,$10,$20,$0e,$08,$18,$20,$0e,$18,$38,$20,$0e,$08,$38,$20
  .byte $0e,$28,$10,$20,$0e,$08,$18,$20,$0e,$18,$38,$20,$0e,$08,$38,$20

intro_cut_scene_slide2_palette:
  .byte $0e,$05,$28,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0e,$05,$28,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

intro_cut_scene_slide1:
  .byte 9                                              ; bg_chr_bank .byte
  .word intro_cut_scene_slide1_bg_chr                  ; bg_chr_address .word
  .byte 13                                             ; nametable_bank .byte
  .word intro_cut_scene_slide1_nametable               ; nametable_address .word
  .word intro_cut_scene_slide1_palette                 ; palette_address .word
  .byte conversation_index_intro_cut_scene_slide1_text ; conversation_index .byte

intro_cut_scene_slide2:
  .byte 8                                              ; bg_chr_bank .byte
  .word inventory_chr                                  ; bg_chr_address .word
  .byte 13                                             ; nametable_bank .byte
  .word inventory_screen                               ; nametable_address .word
  .word intro_cut_scene_slide2_palette                 ; palette_address .word
  .byte conversation_index_intro_cut_scene_slide1_text ; conversation_index .byte

  ;marks end of slide show
  .byte LAST_SLIDE
