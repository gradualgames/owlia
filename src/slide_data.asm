.include "slide_data.inc"
.include "conversation_data.inc"
.include "bg_chr_data.inc"
.include "sprite_chr_data.inc"
.include "nametable_data.inc"
.include "sprites_and_animations_data.inc"
.include "music_data.inc"

.segment "CODE"

intro_cut_scene_great_owls_palette:
  .byte $0e,$08,$18,$20,$0e,$18,$38,$20,$0e,$08,$38,$20,$0e,$28,$10,$20
  .byte $0e,$0e,$16,$28,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

intro_cut_scene_slide2_palette:
  .byte $0e,$05,$28,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0e,$05,$28,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

intro_cut_scene_mermon_palette:
intro_cut_scene_mermon_mad_palette:
  .byte $0e,$12,$22,$3c,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$12,$22,$3c,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

intro_cut_scene_mermon_leer_palette:
  .byte $0e,$08,$38,$20,$0e,$11,$22,$3c,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$00,$10,$20,$0e,$0e,$0e,$28,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

intro_cut_scene_silmaran_palette:
  .byte $0e,$28,$10,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$28,$10,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

end_cut_scene_slide1_palette:
  .byte $0e,$0e,$0e,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

;NOTE! These slides must be contiguous in ROM. Supporting arrays such as
;sprite chr sets and sprite overlays must be defined outside the slides.
intro_cut_scene_great_owls:
  .byte SLIDE_TYPE_TEXTBOX
  .byte 10                                             ; bg_chr_bank .byte
  .word intro_cut_scene_great_owls_bg_chr              ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                           ; nametable_bank .byte
  .word intro_cut_scene_great_owls_nametable           ; nametable_address .word
  .word intro_cut_scene_great_owls_palette             ; palette_address .word
  .byte conversation_index_intro_cut_scene_owls_text   ; conversation_index .byte
  .byte 0                                              ; slide_length .byte
  .word intro_cut_scene_great_owls_sprite_chr_sets     ; sprite_chr_sets_address .word
  .word intro_cut_scene_great_owls_sprite_overlays     ; sprite_overlays_address .word
  .word 0                                              ; song_address .word

intro_cut_scene_mermon:
  .byte SLIDE_TYPE_TEXTBOX
  .byte 10                                             ; bg_chr_bank .byte
  .word intro_cut_scene_mermon_bg_chr                  ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                           ; nametable_bank .byte
  .word intro_cut_scene_mermon_nametable               ; nametable_address .word
  .word intro_cut_scene_mermon_palette                 ; palette_address .word
  .byte conversation_index_intro_cut_scene_mermon_text ; conversation_index .byte
  .byte 0                                              ; slide_length .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word
  .word 0                                              ; song_address .word

intro_cut_scene_mermon_mad:
  .byte SLIDE_TYPE_TEXTBOX
  .byte 10                                                   ; bg_chr_bank .byte
  .word intro_cut_scene_mermon_mad_bg_chr                    ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                                 ; nametable_bank .byte
  .word intro_cut_scene_mermon_mad_nametable                 ; nametable_address .word
  .word intro_cut_scene_mermon_mad_palette                   ; palette_address .word
  .byte conversation_index_intro_cut_scene_mermon_mad_text   ; conversation_index .byte
  .byte 0                                                    ; slide_length .byte
  .word 0                                                    ; sprite_chr_sets_address .word
  .word 0                                                    ; sprite_overlays_address .word
  .word 0                                                    ; song_address .word

intro_cut_scene_mermon_leer:
  .byte SLIDE_TYPE_TEXTBOX
  .byte 11                                                   ; bg_chr_bank .byte
  .word intro_cut_scene_mermon_leer_bg_chr                   ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                                 ; nametable_bank .byte
  .word intro_cut_scene_mermon_leer_nametable                ; nametable_address .word
  .word intro_cut_scene_mermon_leer_palette                  ; palette_address .word
  .byte conversation_index_intro_cut_scene_mermon_leer_text  ; conversation_index .byte
  .byte 0                                                    ; slide_length .byte
  .word intro_cut_scene_slide4_sprite_chr_sets               ; sprite_chr_sets_address .word
  .word intro_cut_scene_slide4_sprite_overlays               ; sprite_overlays_address .word
  .word 0                                                    ; song_address .word

intro_cut_scene_silmaran:
  .byte SLIDE_TYPE_TEXTBOX
  .byte 11                                                   ; bg_chr_bank .byte
  .word intro_cut_scene_silmaran_bg_chr                      ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                                 ; nametable_bank .byte
  .word intro_cut_scene_silmaran_nametable                   ; nametable_address .word
  .word intro_cut_scene_silmaran_palette                     ; palette_address .word
  .byte conversation_index_intro_cut_scene_silmaran_text     ; conversation_index .byte
  .byte 0                                                    ; slide_length .byte
  .word 0                                                    ; sprite_chr_sets_address .word
  .word 0                                                    ; sprite_overlays_address .word
  .word 0                                                    ; song_address .word

  ;marks end of slide show
  .byte LAST_SLIDE

intro_cut_scene_great_owls_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_intro_cut_scene_great_owls

intro_cut_scene_great_owls_sprite_overlays:
  .byte 1
  .byte 7
  .word intro_cut_scene_great_owls_spr_overlay
  .byte 0, 0

intro_cut_scene_slide4_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_intro_cut_scene_mermon_leer

intro_cut_scene_slide4_sprite_overlays:
  .byte 2
  .byte 7
  .word intro_cut_scene_mermon_leer_spr_overlay0
  .byte 0, 0
  .byte 7
  .word intro_cut_scene_mermon_leer_spr_overlay1
  .byte 0, 0

end_cut_scene_slide1:
  .byte SLIDE_TYPE_IMAGE_ONLY
  .byte 26                                             ; bg_chr_bank .byte
  .word end_cut_scene_slide1_chr                       ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                           ; nametable_bank .byte
  .word end_cut_scene_slide1_nametable                 ; nametable_address .word
  .word end_cut_scene_slide1_palette                   ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte SLIDE_LENGTH_INFINITE                          ; slide_length .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_chr_sets_address .word
  .word ending_theme                                   ; song_address .word
  .byte LAST_SLIDE
