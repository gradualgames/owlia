.include "slide_data.inc"
.include "conversation_data.inc"
.include "bg_chr_data.inc"
.include "sprite_chr_data.inc"
.include "nametable_data.inc"
.include "sprites_and_animations_data.inc"

.segment "ROM10"

intro_cut_scene_slide1_palette:
  .byte $0e,$28,$10,$20,$0e,$08,$18,$20,$0e,$18,$38,$20,$0e,$08,$38,$20
  .byte $0e,$0e,$16,$28,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

intro_cut_scene_slide2_palette:
  .byte $0e,$05,$28,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0e,$05,$28,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

intro_cut_scene_mermon_palette:
intro_cut_scene_mermon_mad_palette:
  .byte $0e,$12,$22,$3c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0e,$12,$22,$3c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

intro_cut_scene_mermon_leer_palette:
  .byte $0e,$12,$22,$3c,$0e,$08,$38,$20,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0e,$2d,$10,$20,$0e,$0e,$0e,$28,$00,$00,$00,$00,$00,$00,$00,$00

thanks_for_playing_demo_palette:
  .byte $0e,$10,$20,$30,$0e,$10,$20,$30,$0e,$10,$20,$20,$0e,$10,$20,$20
  .byte $0e,$10,$20,$30,$0e,$10,$20,$30,$0e,$10,$20,$20,$0e,$10,$20,$20

;NOTE! These slides must be contiguous in ROM. Supporting arrays such as
;sprite chr sets and sprite overlays must be defined outside the slides.
intro_cut_scene_slide1:
  .byte 9                                              ; bg_chr_bank .byte
  .word intro_cut_scene_slide1_bg_chr                  ; bg_chr_address .word
  .byte 13                                             ; nametable_bank .byte
  .word intro_cut_scene_slide1_nametable               ; nametable_address .word
  .word intro_cut_scene_slide1_palette                 ; palette_address .word
  .byte conversation_index_intro_cut_scene_owls_text   ; conversation_index .byte
  .word intro_cut_scene_slide1_sprite_chr_sets         ; sprite_chr_sets_address .word
  .word intro_cut_scene_slide1_sprite_overlays         ; sprite_overlays_address .word

intro_cut_scene_slide2:
  .byte 9                                              ; bg_chr_bank .byte
  .word intro_cut_scene_mermon                         ; bg_chr_address .word
  .byte 13                                             ; nametable_bank .byte
  .word intro_cut_scene_mermon_nametable               ; nametable_address .word
  .word intro_cut_scene_mermon_palette                 ; palette_address .word
  .byte conversation_index_intro_cut_scene_mermon_text ; conversation_index .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word

intro_cut_scene_slide3:
  .byte 9                                                    ; bg_chr_bank .byte
  .word intro_cut_scene_mermon_mad                           ; bg_chr_address .word
  .byte 13                                                   ; nametable_bank .byte
  .word intro_cut_scene_mermon_mad_nametable                 ; nametable_address .word
  .word intro_cut_scene_mermon_mad_palette                   ; palette_address .word
  .byte conversation_index_intro_cut_scene_mermon_mad_text   ; conversation_index .byte
  .word 0                                                    ; sprite_chr_sets_address .word
  .word 0                                                    ; sprite_overlays_address .word

intro_cut_scene_slide4:
  .byte 13                                                   ; bg_chr_bank .byte
  .word intro_cut_scene_mermon_leer                          ; bg_chr_address .word
  .byte 13                                                   ; nametable_bank .byte
  .word intro_cut_scene_mermon_leer_nametable                ; nametable_address .word
  .word intro_cut_scene_mermon_leer_palette                  ; palette_address .word
  .byte conversation_index_intro_cut_scene_mermon_leer_text  ; conversation_index .byte
  .word intro_cut_scene_slide4_sprite_chr_sets               ; sprite_chr_sets_address .word
  .word intro_cut_scene_slide4_sprite_overlays               ; sprite_overlays_address .word

  ;marks end of slide show
  .byte LAST_SLIDE

thanks_for_playing_demo_slide1:
  .byte 9                                              ; bg_chr_bank .byte
  .word thanks_for_playing_demo_bg_chr                 ; bg_chr_address .word
  .byte 13                                             ; nametable_bank .byte
  .word thanks_for_playing_demo_nametable              ; nametable_address .word
  .word thanks_for_playing_demo_palette                ; palette_address .word
  .byte conversation_index_thanks_for_playing_demo     ; conversation_index .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word

  ;marks end of slide show
  .byte LAST_SLIDE

intro_cut_scene_slide1_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_owleyes

intro_cut_scene_slide1_sprite_overlays:
  .byte 2
  .byte 6
  .word OwlEyes0
  .byte 54, 112
  .byte 6
  .word OwlEyes1
  .byte 179, 109

intro_cut_scene_slide4_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_cagedowl

intro_cut_scene_slide4_sprite_overlays:
  .byte 2
  .byte 6
  .word CagedOwlEyes0
  .byte 144, 87
  .byte 6
  .word CagedOwlCage0
  .byte 131, 54
