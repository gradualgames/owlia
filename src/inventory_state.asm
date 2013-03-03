.linecont +
.include "map.inc"
.include "play_state.inc"
.include "controller.inc"
.include "bg_chr_data.inc"
.include "nametable_data.inc"
.include "inventory_state.inc"
.include "areas.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprite.inc"
.include "sprite_chr_data.inc"
.include "sprites_and_animations_data.inc"
.include "soundengine.inc"
.include "sfx_data.inc"
.include "textbox.inc"

.segment "CODE"

;inventory title string
inventory_string: .byte I,N,V,E,N,T,O,R,_Y,ES

;stat strings
gp_string: .byte G,P,ES
keys_string: .byte K,E,_Y,S,ES

;use item menu strings
use_item_string: .byte U,S,E,ES
health_string: .byte H,E,_A,L,T,H,ES
owl_health_string: .byte O,W,L,SP,H,E,_A,L,T,H,ES
rope_string: .byte R,O,P,E,SP

;carry item menu strings
carry_item_string: .byte C,_A,R,R,_Y,ES
bomb_string: .byte B,O,M,B,ES
lantern_string: .byte L,_A,N,T,E,R,N,ES

;tech menu strings
tech_string: .byte T,E,C,H,ES
rush_string: .byte R,U,S,H,ES
fetch_string: .byte F,E,T,C,H,ES
sonar_string: .byte S,O,N,_A,R,ES
;carry_item_string
carry_adlanniel_string: .byte C,_A,R,R,_Y,SP,_A,D,L,_A,N,N,I,E,L,ES
confuse_string: .byte C,O,N,F,U,S,E,ES
homing_string: .byte H,O,M,I,N,G,ES
multi_homing_string: .byte M,U,L,T,I,SP,H,O,M,I,N,G,ES

inventory_screen_palette:
  .byte $0d,$0d,$18,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $0d,$0d,$0d,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

.proc ppu_inventory_vblank

  jsr sprite_update_all

  lda #0
  sta vblank_data_ready

  rts

.endproc

.proc update_cursor

  ;test A button and call callback for current menu position if pressed
  .scope
  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne a_not_pressed

  ldx state_control_params+inventory_state_control::callback_index
  lda menu_position_action_callbacks_lo,x
  sta w0
  lda menu_position_action_callbacks_hi,x
  sta w0+1
  jsr indirect_jsr_w0

  jmp done
a_not_pressed:
  ;if A button was not pressed, then call the d-pad callback index for
  ;the current menu position.
  lda #DPAD_NOP
  sta state_control_params+inventory_state_control::dpad_direction
  lda buffer_controller+buttons::_left
  and #%00000011
  cmp #%00000001
  bne left_not_pressed
  lda #DPAD_LEFT
  sta state_control_params+inventory_state_control::dpad_direction
left_not_pressed:
  lda buffer_controller+buttons::_right
  and #%00000011
  cmp #%00000001
  bne right_not_pressed
  lda #DPAD_RIGHT
  sta state_control_params+inventory_state_control::dpad_direction
right_not_pressed:
  lda buffer_controller+buttons::_down
  and #%00000011
  cmp #%00000001
  bne down_not_pressed
  lda #DPAD_DOWN
  sta state_control_params+inventory_state_control::dpad_direction
down_not_pressed:
  lda buffer_controller+buttons::_up
  and #%00000011
  cmp #%00000001
  bne up_not_pressed
  lda #DPAD_UP
  sta state_control_params+inventory_state_control::dpad_direction
up_not_pressed:

  lda state_control_params+inventory_state_control::dpad_direction
  beq dpad_not_pressed
  ldx state_control_params+inventory_state_control::callback_index
  lda menu_position_dpad_callbacks_lo,x
  sta w0
  lda menu_position_dpad_callbacks_hi,x
  sta w0+1
  jsr indirect_jsr_w0

dpad_not_pressed:
done:
  .endscope
  rts

.endproc

.proc draw_cursor

  ldy #sprite_chr_group_index_cursor
  lda sprite_chr_group_offsets,y
  sta sprite_group_offset

  switch_bank_ldy #INVENTORY_STATE_SPRITES_AND_ANIMATIONS_BANK
  lda #<Cursor0
  sta w0
  lda #>Cursor0
  sta w0+1

  lda state_control_params+inventory_state_control::cursor_column
  sta w3
  lda #0
  sta w3+1

  lda state_control_params+inventory_state_control::cursor_row
  sta w4
  lda #0
  sta w4+1

  lda #0
  sta b2

draw_next_heart:
  jsr sprite_draw_metasprite

  rts

.endproc

.define menu_position_action_callbacks \
  menu_position_action_callback_test

menu_position_action_callbacks_lo:
  .lobytes menu_position_action_callbacks

menu_position_action_callbacks_hi:
  .hibytes menu_position_action_callbacks

.define menu_position_dpad_callbacks \
  menu_position_dpad_callback_test

menu_position_dpad_callbacks_lo:
  .lobytes menu_position_dpad_callbacks

menu_position_dpad_callbacks_hi:
  .hibytes menu_position_dpad_callbacks

.proc menu_position_action_callback_test

  ;play a sound
  txa
  pha

  lda #<sfx_test
  sta sound_param_word_0
  lda #>sfx_test
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  rts

.endproc

.proc menu_position_dpad_callback_test

  ;play a sound
  txa
  pha

  lda #<sfx_sword
  sta sound_param_word_0
  lda #>sfx_sword
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  lda state_control_params+inventory_state_control::dpad_direction
  cmp #DPAD_LEFT
  bne not_left
  sec
  lda state_control_params+inventory_state_control::cursor_column
  sbc #$08
  sta state_control_params+inventory_state_control::cursor_column
not_left:
  lda state_control_params+inventory_state_control::dpad_direction
  cmp #DPAD_RIGHT
  bne not_right
  clc
  lda state_control_params+inventory_state_control::cursor_column
  adc #$08
  sta state_control_params+inventory_state_control::cursor_column
not_right:
  lda state_control_params+inventory_state_control::dpad_direction
  cmp #DPAD_DOWN
  bne not_down
  clc
  lda state_control_params+inventory_state_control::cursor_row
  adc #$08
  sta state_control_params+inventory_state_control::cursor_row
not_down:
  lda state_control_params+inventory_state_control::dpad_direction
  cmp #DPAD_UP
  bne not_up
  sec
  lda state_control_params+inventory_state_control::cursor_row
  sbc #$08
  sta state_control_params+inventory_state_control::cursor_row
not_up:

  rts

.endproc

.proc indirect_jsr_w0
  jmp (w0)
.endproc

inventory_state_init:

  ;fade out from current palette
  switch_bank_ldy #AREAS_BANK
  ldy #area::palette_address
  lda (area_address),y
  sta w0
  iny
  lda (area_address),y
  sta w0+1
  switch_bank_ldy map_bank
  jsr ppu_fade_out_palette

  ;set blank nmi routine
  lda #<ppu_vblank_nop
  sta vblank_routine
  lda #>ppu_vblank_nop
  sta vblank_routine+1

  jsr ppu_safely_disable_graphics

  jsr sprite_clear_all

  jsr sprite_update_all

  ;load chr data for inventory screen
  lda #$00
  sta $2006
  sta $2006

  ;reset tile accumulator
  lda #$00
  sta b3

  lda #<inventory_chr
  sta w0
  lda #>inventory_chr
  sta w0+1
  switch_bank_ldy #INVENTORY_STATE_BG_CHR_BANK
  jsr ppu_load_chr_amount

  ;grab tile accumulator to know where the textbox and font group begins
  lda b3
  sta textbox_and_font_chr_offset

  ;load the textbox graphics. This is hardcoded because it is the same
  ;for the entire game. The assumption here is that the background
  ;graphics we use will never occupy so many tiles that we cannot
  ;display a textbox or font.
  lda #<textbox_chr
  sta w0
  lda #>textbox_chr
  sta w0+1
  switch_bank_ldy #TEXTBOX_BG_CHR_BANK
  jsr ppu_load_chr_amount

  ;load cursor graphics
  lda #$10
  sta $2006
  lda #$00
  sta $2006

  ;reset tile accumulator
  lda #$00
  sta b3

  lda #<Cursor_chr
  sta w0
  lda #>Cursor_chr
  sta w0+1

  ;store the current chr offset in sprite_chr_groups_chr_offsets array for the cursor
  ldy #sprite_chr_group_index_cursor
  lda b3
  sta sprite_chr_group_offsets,y

  switch_bank_ldy #INVENTORY_STATE_SPRITE_CHR_BANK
  jsr ppu_load_chr_amount

  ;load nametable data for inventory screen
  ;load the nametable and attribute table.
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006+1
  upload_ppu_2006
  lda #<inventory_screen
  sta w0
  lda #>inventory_screen
  sta w0+1
  switch_bank_ldy #INVENTORY_STATE_BG_NAMETABLE_BANK
  jsr ppu_load_nametable

  ;reset scroll
  lda #$20
  sta ppu_2006
  lda #$00
  sta ppu_2006
  upload_ppu_2006

  lda #0
  sta ppu_2005
  sta ppu_2005+1
  upload_ppu_2005

  ;initialize and draw initial cursor
  lda #(10*8)
  sta state_control_params+inventory_state_control::cursor_row
  sta state_control_params+inventory_state_control::cursor_column
  lda #0
  sta state_control_params+inventory_state_control::callback_index

  jsr draw_cursor

  jsr sprite_update_all

  ;draw menu layout with strings
  print_string inventory_string, #$20, #4, #11

  print_string gp_string, #$20, #7, #4
  print_string keys_string, #$20, #8, #4

  print_string use_item_string, #$20, #10, #4
  print_string health_string, #$20, #10, #13
  print_string owl_health_string, #$20, #11, #13

  print_string carry_item_string, #$20, #13, #4
  print_string bomb_string, #$20, #13, #13
  print_string lantern_string, #$20, #14, #13

  print_string tech_string, #$20, #16, #4
  print_string rush_string, #$20, #16, #13
  print_string fetch_string, #$20, #17, #13
  print_string sonar_string, #$20, #18, #13
  print_string carry_item_string, #$20, #19, #13
  print_string carry_adlanniel_string, #$20, #20, #13
  print_string confuse_string, #$20, #21, #13
  print_string homing_string, #$20, #22, #13
  print_string multi_homing_string, #$20, #23, #13

  jsr ppu_safely_enable_graphics

  ;fade in inventory screen palette
  lda #<inventory_screen_palette
  sta w0
  lda #>inventory_screen_palette
  sta w0+1
  jsr ppu_fade_in_palette

  lda #<ppu_inventory_vblank
  sta vblank_routine
  lda #>ppu_inventory_vblank
  sta vblank_routine+1

inventory_state_main:

  wait_vblank_data_ready

  jsr controller_read

  jsr sprite_clear_all

  jsr update_cursor

  jsr draw_cursor

  ;test start button
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  beq inventory_state_exit

  set_vblank_data_ready

  jmp inventory_state_main

inventory_state_exit:

  ;fade out inventory palette
  lda #<inventory_screen_palette
  sta w0
  lda #>inventory_screen_palette
  sta w0+1
  jsr ppu_fade_out_palette

  jmp play_state_reload

