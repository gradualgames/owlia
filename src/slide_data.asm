.feature force_range
.include "slide_data.inc"
.include "conversation_data.inc"
.include "bg_chr_data.inc"
.include "sprite_chr_data.inc"
.include "nametable_data.inc"
.include "sprites_and_animations_data.inc"
.include "music_data.inc"
.include "textbox.inc"

.segment "ROM15"

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
  .byte $0e,$0c,$26,$36,$0e,$18,$38,$20,$0e,$07,$06,$36,$0e,$0e,$0e,$0e
  .byte $0e,$18,$38,$20,$0e,$07,$06,$20,$0e,$07,$00,$10,$0e,$0e,$0e,$0e

end_cut_scene_slide2_palette:
  .byte $0e,$0c,$36,$20,$0e,$0c,$26,$36,$0e,$0c,$00,$10,$0e,$0c,$10,$20
  .byte $0e,$06,$26,$28,$0e,$00,$28,$10,$0e,$07,$06,$26,$0e,$0e,$0e,$0e

end_cut_scene_slide3_palette:
  .byte $0e,$26,$36,$37,$0e,$07,$17,$20,$0e,$18,$38,$20,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$20,$0e,$07,$06,$0c,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

end_cut_scene_slide4_palette:
  .byte $0e,$08,$28,$20,$0e,$18,$28,$20,$0e,$08,$18,$28,$0e,$28,$10,$20
  .byte $0e,$07,$17,$26,$0e,$0a,$19,$37,$0e,$16,$12,$21,$0e,$0e,$0e,$0e

end_cut_scene_slide5_palette:
  .byte $0e,$18,$38,$20,$0e,$0e,$01,$32,$0e,$07,$06,$0c,$0e,$06,$0c,$37
  .byte $0e,$00,$10,$36,$0e,$26,$36,$20,$0e,$0e,$06,$36,$0e,$0e,$0e,$0e

end_cut_scene_slide6_palette:
  .byte $0e,$0e,$06,$0c,$0e,$28,$10,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$26,$36,$0e,$0e,$08,$18,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e

end_cut_scene_text_palette:
  .byte $0e,$08,$28,$20,$0e,$18,$28,$20,$0e,$08,$18,$28,$0e,$28,$10,$20
  .byte $0e,$07,$17,$26,$0e,$0a,$19,$37,$0e,$16,$12,$21,$0e,$0e,$0e,$0e

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
  .word 0                                              ; strings_address .word
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
  .word 0                                              ; strings_address .word
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
  .word 0                                                    ; strings_address .word
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
  .word 0                                                    ; strings_address .word
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
  .word 0                                                    ; strings_address .word
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

end_cut_scene_thanks_for_playing:
  .byte SLIDE_TYPE_STRINGS_ONLY
  .byte 0                                              ; bg_chr_bank .byte
  .word 0                                              ; bg_chr_address .word
  .byte 0                                              ; nametable_bank .byte
  .word 0                                              ; nametable_address .word
  .word end_cut_scene_text_palette                     ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word
  .word end_cut_scene_thanks_for_playing_strings       ; strings_address .word
  .word ending_theme                                   ; song_address .word

end_cut_scene_produced_by:
  .byte SLIDE_TYPE_STRINGS_ONLY
  .byte 0                                              ; bg_chr_bank .byte
  .word 0                                              ; bg_chr_address .word
  .byte 0                                              ; nametable_bank .byte
  .word 0                                              ; nametable_address .word
  .word end_cut_scene_text_palette                     ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word
  .word end_cut_scene_produced_by_strings              ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_slide1:
  .byte SLIDE_TYPE_IMAGE_ONLY
  .byte 26                                             ; bg_chr_bank .byte
  .word end_cut_scene_slide1_chr                       ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                           ; nametable_bank .byte
  .word end_cut_scene_slide1_nametable                 ; nametable_address .word
  .word end_cut_scene_slide1_palette                   ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word end_cut_scene_slide1_sprite_chr_sets           ; sprite_chr_sets_address .word
  .word end_cut_scene_slide1_sprite_overlays           ; sprite_overlays_address .word
  .word 0                                              ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_derek_andrews:
  .byte SLIDE_TYPE_STRINGS_ONLY
  .byte 0                                              ; bg_chr_bank .byte
  .word 0                                              ; bg_chr_address .word
  .byte 0                                              ; nametable_bank .byte
  .word 0                                              ; nametable_address .word
  .word end_cut_scene_text_palette                     ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word
  .word end_cut_scene_derek_andrews_strings            ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_slide2:
  .byte SLIDE_TYPE_IMAGE_ONLY
  .byte 26                                             ; bg_chr_bank .byte
  .word end_cut_scene_slide2_chr                       ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                           ; nametable_bank .byte
  .word end_cut_scene_slide2_nametable                 ; nametable_address .word
  .word end_cut_scene_slide2_palette                   ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word end_cut_scene_slide2_sprite_chr_sets           ; sprite_chr_sets_address .word
  .word end_cut_scene_slide2_sprite_overlays           ; sprite_overlays_address .word
  .word 0                                              ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_laurie_andrews:
  .byte SLIDE_TYPE_STRINGS_ONLY
  .byte 0                                              ; bg_chr_bank .byte
  .word 0                                              ; bg_chr_address .word
  .byte 0                                              ; nametable_bank .byte
  .word 0                                              ; nametable_address .word
  .word end_cut_scene_text_palette                     ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word
  .word end_cut_scene_laurie_andrews_strings           ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_slide3:
  .byte SLIDE_TYPE_IMAGE_ONLY
  .byte 26                                             ; bg_chr_bank .byte
  .word end_cut_scene_slide3_chr                       ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                           ; nametable_bank .byte
  .word end_cut_scene_slide3_nametable                 ; nametable_address .word
  .word end_cut_scene_slide3_palette                   ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word end_cut_scene_slide3_sprite_chr_sets           ; sprite_chr_sets_address .word
  .word end_cut_scene_slide3_sprite_overlays           ; sprite_overlays_address .word
  .word 0                                              ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_testers:
  .byte SLIDE_TYPE_STRINGS_ONLY
  .byte 0                                              ; bg_chr_bank .byte
  .word 0                                              ; bg_chr_address .word
  .byte 0                                              ; nametable_bank .byte
  .word 0                                              ; nametable_address .word
  .word end_cut_scene_text_palette                     ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word
  .word end_cut_scene_testers_strings                  ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_slide5:
  .byte SLIDE_TYPE_IMAGE_ONLY
  .byte BG_CHR_DATA_BANK6                              ; bg_chr_bank .byte
  .word end_cut_scene_slide5_chr                       ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                           ; nametable_bank .byte
  .word end_cut_scene_slide5_nametable                 ; nametable_address .word
  .word end_cut_scene_slide5_palette                   ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word end_cut_scene_slide5_sprite_chr_sets           ; sprite_chr_sets_address .word
  .word end_cut_scene_slide5_sprite_overlays           ; sprite_overlays_address .word
  .word 0                                              ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_tools:
  .byte SLIDE_TYPE_STRINGS_ONLY
  .byte 0                                              ; bg_chr_bank .byte
  .word 0                                              ; bg_chr_address .word
  .byte 0                                              ; nametable_bank .byte
  .word 0                                              ; nametable_address .word
  .word end_cut_scene_text_palette                     ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word
  .word end_cut_scene_tools_strings                    ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_slide6:
  .byte SLIDE_TYPE_IMAGE_ONLY
  .byte BG_CHR_DATA_BANK6                              ; bg_chr_bank .byte
  .word end_cut_scene_slide6_chr                       ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                           ; nametable_bank .byte
  .word end_cut_scene_slide6_nametable                 ; nametable_address .word
  .word end_cut_scene_slide6_palette                   ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word end_cut_scene_slide6_sprite_chr_sets           ; sprite_chr_sets_address .word
  .word end_cut_scene_slide6_sprite_overlays           ; sprite_overlays_address .word
  .word 0                                              ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_thanks_to:
  .byte SLIDE_TYPE_STRINGS_ONLY
  .byte 0                                              ; bg_chr_bank .byte
  .word 0                                              ; bg_chr_address .word
  .byte 0                                              ; nametable_bank .byte
  .word 0                                              ; nametable_address .word
  .word end_cut_scene_text_palette                     ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte 255                                            ; slide_length .byte
  .word 0                                              ; sprite_chr_sets_address .word
  .word 0                                              ; sprite_overlays_address .word
  .word end_cut_scene_thanks_to_strings                ; strings_address .word
  .word 0                                              ; song_address .word

end_cut_scene_slide4:
  .byte SLIDE_TYPE_IMAGE_ONLY
  .byte 26                                             ; bg_chr_bank .byte
  .word end_cut_scene_slide4_chr                       ; bg_chr_address .word
  .byte NAMETABLE_DATA_BANK1                           ; nametable_bank .byte
  .word end_cut_scene_slide4_nametable                 ; nametable_address .word
  .word end_cut_scene_slide4_palette                   ; palette_address .word
  .byte 0                                              ; conversation_index .byte
  .byte SLIDE_LENGTH_INFINITE                          ; slide_length .byte
  .word end_cut_scene_slide4_sprite_chr_sets           ; sprite_chr_sets_address .word
  .word end_cut_scene_slide4_sprite_overlays           ; sprite_overlays_address .word
  .word 0                                              ; strings_address .word
  .word 0                                              ; song_address .word
  .byte LAST_SLIDE

end_cut_scene_slide1_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_end_cut_scene_slide1

end_cut_scene_slide1_sprite_overlays:
  .byte 1
  .byte 23
  .word end_cut_scene_slide1_sprite_overlay0

end_cut_scene_slide2_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_end_cut_scene_slide2

end_cut_scene_slide2_sprite_overlays:
  .byte 1
  .byte 23
  .word end_cut_scene_slide2_sprite_overlay0

end_cut_scene_slide3_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_end_cut_scene_slide3

end_cut_scene_slide3_sprite_overlays:
  .byte 1
  .byte 23
  .word end_cut_scene_slide3_sprite_overlay0

end_cut_scene_slide4_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_end_cut_scene_slide4

end_cut_scene_slide4_sprite_overlays:
  .byte 1
  .byte 23
  .word end_cut_scene_slide4_sprite_overlay0

end_cut_scene_slide5_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_end_cut_scene_slide5

end_cut_scene_slide5_sprite_overlays:
  .byte 1
  .byte 23
  .word end_cut_scene_slide5_sprite_overlay0

end_cut_scene_slide6_sprite_chr_sets:
  .byte 1
  .byte sprite_chr_group_index_end_cut_scene_slide6

end_cut_scene_slide6_sprite_overlays:
  .byte 1
  .byte 23
  .word end_cut_scene_slide6_sprite_overlay0

.include "charmap_password.inc"

end_cut_scene_thanks_for_playing_strings:
  .byte 3
  .byte 12, 6
  .word thank_you_for_playing_string
  .byte 14, 6
  .word the_legends_of_owlia_string
  .byte 16, 8
  .word by_gradual_games_string

thank_you_for_playing_string:
  .byte "THANK YOU FOR PLAYING",ES

the_legends_of_owlia_string:
  .byte "THE LEGENDS OF OWLIA",ES

by_gradual_games_string:
  .byte "BY GRADUAL GAMES",ES

end_cut_scene_derek_andrews_strings:
  .byte 3
  .byte 12, 7
  .word design_programming_string
  .byte 14, 10
  .word and_music_string
  .byte 16, 10
  .word derek_andrews_string

design_programming_string:
  .byte "DESIGN, PROGRAMMING",ES

and_music_string:
  .byte "AND MUSIC BY",ES

derek_andrews_string:
  .byte "DEREK ANDREWS",ES

end_cut_scene_laurie_andrews_strings:
  .byte 2
  .byte 12, 7
  .word art_string
  .byte 14, 9
  .word laurie_andrews_string

art_string:
  .byte "GRAPHICS AND ART BY",ES

laurie_andrews_string:
  .byte "LAURIE ANDREWS",ES

end_cut_scene_testers_strings:
  .byte 8
  .byte 12, 12
  .word testers_string
  .byte 14,8
  .word daniel_hwozdek_string
  .byte 15,8
  .word john_alznauer_string
  .byte 16,8
  .word meg_alznauer_string
  .byte 17,8
  .word ernest_holland_string
  .byte 18,8
  .word bradley_bateman_string
  .byte 19,8
  .word john_white_string
  .byte 20,8
  .word justin_orenich_string

testers_string:
  .byte "TESTERS",ES

daniel_hwozdek_string:
  .byte "DANIEL HWOZDEK",ES

john_alznauer_string:
  .byte "JOHN ALZNAUER",ES

meg_alznauer_string:
  .byte "MEG ALZNAUER",ES

ernest_holland_string:
  .byte "ERNEST HOLLAND",ES

bradley_bateman_string:
  .byte "BRADLEY BATEMAN",ES

john_white_string:
  .byte "JOHN WHITE",ES

justin_orenich_string:
  .byte "JUSTIN ORENICH",ES

end_cut_scene_produced_by_strings:
  .byte 2
  .byte 12,10
  .word produced_by_string
  .byte 14,6
  .word infinite_nes_lives_string

produced_by_string:
  .byte "PRODUCED BY",ES

infinite_nes_lives_string:
  .byte "INFINITE NES LIVES",ES

end_cut_scene_tools_strings:
  .byte 12
  .byte 8,13
  .word tools_string
  .byte 10,8
  .word ca65_string
  .byte 11,8
  .word notepad_plus_plus_string
  .byte 12,8
  .word paint_dot_net_string
  .byte 13,8
  .word python_string
  .byte 14,8
  .word famitracker_string
  .byte 15,8
  .word fceux_string
  .byte 16,8
  .word nestopia_string
  .byte 17,8
  .word nintendulator_string
  .byte 18,8
  .word git_string
  .byte 19,8
  .word sourcetree_string
  .byte 20,8
  .word photoshop_string

tools_string:
  .byte "TOOLS",ES

ca65_string:
  .byte "CA65",ES

notepad_plus_plus_string:
  .byte "NOTEPAD PLUS PLUS",ES

paint_dot_net_string:
  .byte "PAINT.NET",ES

python_string:
  .byte "PYTHON",ES

famitracker_string:
  .byte "FAMITRACKER",ES

fceux_string:
  .byte "FCEUX",ES

nestopia_string:
  .byte "NESTOPIA",ES

nintendulator_string:
  .byte "NINTENDULATOR",ES

git_string:
  .byte "GIT",ES

sourcetree_string:
  .byte "SOURCETREE",ES

photoshop_string:
  .byte "PHOTOSHOP",ES

end_cut_scene_thanks_to_strings:
  .byte 8
  .byte 12,11
  .word thanks_to_string
  .byte 14,11
  .word lordqbasic_string
  .byte 15,11
  .word paul_molloy_string
  .byte 16,11
  .word joe_granato_string
  .byte 17,11
  .word joe_gillis_string
  .byte 18,11
  .word nesdev_string
  .byte 19,11
  .word nintendoage_string
  .byte 20,11
  .word thefox_string
  .byte 21,11
  .word brian_parker_string

thanks_to_string:
  .byte "THANKS TO",ES

lordqbasic_string:
  .byte "LORDQBASIC",ES

paul_molloy_string:
  .byte "PAUL MOLLOY",ES

joe_granato_string:
  .byte "JOE GRANATO",ES

joe_gillis_string:
  .byte "JOE GILLIS",ES

nesdev_string:
  .byte "NESDEV",ES

nintendoage_string:
  .byte "NINTENDOAGE",ES

thefox_string:
  .byte "THEFOX",ES

brian_parker_string:
  .byte "BRIAN PARKER",ES
