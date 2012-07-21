.include "play_state.inc"
.include "controller.inc"
.include "ppu.inc"
.include "zp.inc"
.include "ram.inc"
.include "map.inc"
.include "map0.inc"
.include "sprite.inc"
.include "entity.inc"
.include "soundengine.inc"
.include "camera.inc"
.include "spritesheet0.inc"
.include "music.inc"

.segment "CODE"

.proc play_state
SPEED = 4

  ;initialize
  jsr ppu_safely_disable_graphics
  
  lda #<song1
  sta sound_param_word_1
  lda #>song1
  sta sound_param_word_1+1
  jsr song_initialize
  
  lda #$00
  sta $2006
  sta $2006

  lda #<map0_chr
  sta w0
  lda #>map0_chr
  sta w0+1
  jsr ppu_load_chr_amount
  
  lda #$10
  sta $2006
  lda #$00
  sta $2006
  
  lda #<Hero_chr
  sta w0
  lda #>Hero_chr
  sta w0+1
  jsr ppu_load_chr_amount
  
  lda #<palette
  sta w0
  lda #>palette
  sta w0+1
  wait_vblank
  jsr ppu_load_palette
  
  jsr ppu_safely_enable_graphics
  
  ;initialize variables
  lda #0
  sta vblank_data_ready
  
  lda #0
  sta row_ready
  lda #0
  sta column_ready
  
  lda #<nametable_and_attribute_update_ppu
  sta vblank_routine
  lda #>nametable_and_attribute_update_ppu
  sta vblank_routine+1
  
  lda #$20
  sta camera_nametable_hibyte
  
  lda #(16*0)
  sta camera_x
  lda #0
  sta camera_x+1
  lda #(16*0)
  sta camera_y
  lda #0
  sta camera_y+1
  
  lda #(16*0)
  sta camera_scroll_x
  lda #(232)
  sta camera_scroll_y
  
  lda #<metatile_table_attributes
  sta metatile_table_attributes_address
  lda #>metatile_table_attributes
  sta metatile_table_attributes_address+1
  
  lda #<metatile_table_top_left_tiles
  sta metatile_table_top_left_tiles_address
  lda #>metatile_table_top_left_tiles
  sta metatile_table_top_left_tiles_address+1
  
  lda #<metatile_table_top_right_tiles
  sta metatile_table_top_right_tiles_address
  lda #>metatile_table_top_right_tiles
  sta metatile_table_top_right_tiles_address+1
  
  lda #<metatile_table_bottom_left_tiles
  sta metatile_table_bottom_left_tiles_address
  lda #>metatile_table_bottom_left_tiles
  sta metatile_table_bottom_left_tiles_address+1

  lda #<metatile_table_bottom_right_tiles
  sta metatile_table_bottom_right_tiles_address
  lda #>metatile_table_bottom_right_tiles
  sta metatile_table_bottom_right_tiles_address+1
  
  lda #<big_metatile_table_top_left
  sta big_metatile_table_top_left_address
  lda #>big_metatile_table_top_left
  sta big_metatile_table_top_left_address+1
  
  lda #<big_metatile_table_top_right
  sta big_metatile_table_top_right_address
  lda #>big_metatile_table_top_right
  sta big_metatile_table_top_right_address+1

  lda #<big_metatile_table_bottom_left
  sta big_metatile_table_bottom_left_address
  lda #>big_metatile_table_bottom_left
  sta big_metatile_table_bottom_left_address+1
  
  lda #<big_metatile_table_bottom_right
  sta big_metatile_table_bottom_right_address
  lda #>big_metatile_table_bottom_right
  sta big_metatile_table_bottom_right_address+1
  
  lda #<map
  sta map_address
  lda #>map
  sta map_address+1

  jsr fill_nametable_columns

  lda #(16*0)
  sta camera_x
  lda #0
  sta camera_x+1
  lda #(16*0)
  sta camera_y
  lda #0
  sta camera_y+1
  
  jsr entity_init_all
  
  ;spawn the hero entity
  lda #0
  sta b0
  jsr entity_spawn
  
  ;attach the camera to the entity instance at x
  
  lda #<animation_object
  sta w1
  lda #>animation_object
  sta w1+1
  lda #<WalkSide
  sta w2
  sta current_animation_definition
  lda #>WalkSide
  sta w2+1
  sta current_animation_definition+1
  jsr sprite_reset_animation

loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  set_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  
  jsr sound_update
  jsr sound_upload
  
  jsr sprite_clear_all
  
  jsr controller_read
  
  ; lda buffer_controller+buttons::_up
  ; and buffer_controller+buttons::_right
  ; and #$01
  ; bne up_and_right
  
  ; lda buffer_controller+buttons::_up
  ; and buffer_controller+buttons::_left
  ; and #$01
  ; bne up_and_left
  
  ; lda buffer_controller+buttons::_down
  ; and buffer_controller+buttons::_right
  ; and #$01
  ; bne down_and_right
  
  ; lda buffer_controller+buttons::_down
  ; and buffer_controller+buttons::_left
  ; and #$01
  ; bne down_and_left
  
  ; lda buffer_controller+buttons::_right
  ; and #$01
  ; bne right
  
  ; lda buffer_controller+buttons::_left
  ; and #$01
  ; bne left
  
  ; lda buffer_controller+buttons::_up
  ; and #$01
  ; bne up
  
  ; lda buffer_controller+buttons::_down
  ; and #$01
  ; bne down
  
; up_and_right:

  ; jsr up_and_right_handler

  ; jmp done_scrolling

; up_and_left:

  ; jsr up_and_left_handler
  
  ; jmp done_scrolling
  
; down_and_right:

  ; jsr down_and_right_handler
  
  ; jmp done_scrolling
  
; down_and_left:

  ; jsr down_and_left_handler
  
  ; jmp done_scrolling
  
; right:

  ; jsr right_handler
  
  ; jmp done_scrolling
  
; left:

  ; jsr left_handler
  
  ; jmp done_scrolling
  
; up:

  ; jsr up_handler
 
  ; jmp done_scrolling
  
; down:

  ; jsr down_handler
  
  ; jmp done_scrolling
  
; done_scrolling:
  
  jsr entity_update_all
  
  jsr entity_draw_all
  
  clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  upload_ppu_2001
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp loop

; right_handler:

  ; lda #SPEED
  ; sta b0
  ; jsr increment_camera_x
  
  ; clc
  ; lda camera_x
  ; adc #$00
  ; sta w0
  ; lda camera_x+1
  ; adc #$01
  ; sta w0+1

  ; lda camera_y
  ; sta w1
  ; lda camera_y+1
  ; sta w1+1
  ; jsr map_decode_column
  ; jsr map_process_intermediate_attribute_column_buffer
  ; lda #1
  ; sta column_ready
  
  ; lda #<animation_object
  ; sta w1
  ; lda #>animation_object
  ; sta w1+1
  ; lda #<WalkSide
  ; sta current_animation_definition
  ; sta w2
  ; lda #>WalkSide
  ; sta current_animation_definition+1
  ; sta w2+1
  
  ; lda #0
  ; sta current_sprite_flags
  
  ; jsr sprite_update_animation
  
  ; rts
  
; left_handler:

  ; lda #SPEED
  ; sta b0
  ; jsr decrement_camera_x
  
  ; clc
  ; lda camera_x
  ; sta w0
  ; lda camera_x+1
  ; sta w0+1

  ; lda camera_y
  ; sta w1
  ; lda camera_y+1
  ; sta w1+1
  ; jsr map_decode_column
  ; jsr map_process_intermediate_attribute_column_buffer
  ; lda #1
  ; sta column_ready
  
  ; lda #<animation_object
  ; sta w1
  ; lda #>animation_object
  ; sta w1+1
  ; lda #<WalkSide
  ; sta current_animation_definition
  ; sta w2
  ; lda #>WalkSide
  ; sta current_animation_definition+1
  ; sta w2+1
  
  ; lda #%01000000
  ; sta current_sprite_flags
  
  ; jsr sprite_update_animation
  
  ; rts
  
; up_handler:

  ; lda #SPEED
  ; sta b0
  ; jsr decrement_camera_y
  
  ; clc
  ; lda camera_x
  ; sta w0
  ; lda camera_x+1
  ; sta w0+1

  ; lda camera_y
  ; sta w1
  ; lda camera_y+1
  ; sta w1+1
  ; jsr map_decode_row
  ; jsr map_process_intermediate_attribute_row_buffer
  ; lda #1
  ; sta row_ready
  
  ; lda #<animation_object
  ; sta w1
  ; lda #>animation_object
  ; sta w1+1
  ; lda #<WalkUp
  ; sta current_animation_definition
  ; sta w2
  ; lda #>WalkUp
  ; sta current_animation_definition+1
  ; sta w2+1
  
  ; lda #0
  ; sta current_sprite_flags
  
  ; jsr sprite_update_animation
  
  ; rts
  
; down_handler:

  ; lda #SPEED
  ; sta b0
  ; jsr increment_camera_y
  
  ; clc
  ; lda camera_x
  ; sta w0
  ; lda camera_x+1
  ; sta w0+1

  ; clc
  ; lda camera_y
  ; adc #224
  ; sta w1
  ; lda camera_y+1
  ; adc #$00
  ; sta w1+1
  ; jsr map_decode_row
  ; jsr map_process_intermediate_attribute_row_buffer
  ; lda #1
  ; sta row_ready

  ; lda #<animation_object
  ; sta w1
  ; lda #>animation_object
  ; sta w1+1
  ; lda #<WalkDown
  ; sta current_animation_definition
  ; sta w2
  ; lda #>WalkDown
  ; sta current_animation_definition+1
  ; sta w2+1
  
  ; lda #0
  ; sta current_sprite_flags
  
  ; jsr sprite_update_animation
  
  ; rts
  
; up_and_right_handler:

  ; lda buffer_controller+buttons::_right
  ; and #$01
  ; beq not_right_and_up
  ; lda buffer_controller+buttons::_up
  ; and #$01
  ; beq not_right_and_up
  ; ;right and up
  
  ; lda #SPEED
  ; sta b0
  ; jsr increment_camera_x
  
  ; clc
  ; lda camera_x
  ; adc #$00
  ; sta w0
  ; lda camera_x+1
  ; adc #$01
  ; sta w0+1

  ; lda camera_y
  ; sta w1
  ; lda camera_y+1
  ; sta w1+1
  ; jsr map_decode_column
  ; jsr map_process_intermediate_attribute_column_buffer
  ; lda #1
  ; sta column_ready
  
  ; lda #SPEED
  ; sta b0
  ; jsr decrement_camera_y
  
  ; lda camera_x
  ; sta w0
  ; lda camera_x+1
  ; sta w0+1

  ; lda camera_y
  ; sta w1
  ; lda camera_y+1
  ; sta w1+1
  ; jsr map_decode_row
  ; jsr map_process_intermediate_attribute_row_buffer
  ; lda #1
  ; sta row_ready
  
  ; lda #<animation_object
  ; sta w1
  ; lda #>animation_object
  ; sta w1+1
  ; lda current_animation_definition
  ; sta w2
  ; lda current_animation_definition+1
  ; sta w2+1
  ; jsr sprite_update_animation
  
; not_right_and_up:

  ; rts

; up_and_left_handler:

  ; lda buffer_controller+buttons::_left
  ; and #$01
  ; beq not_left_and_up
  ; lda buffer_controller+buttons::_up
  ; and #$01
  ; beq not_left_and_up
  ; ;left and up
  
  ; lda #SPEED
  ; sta b0
  ; jsr decrement_camera_x
  
  ; clc
  ; lda camera_x
  ; adc #$00
  ; sta w0
  ; lda camera_x+1
  ; adc #$00
  ; sta w0+1

  ; lda camera_y
  ; sta w1
  ; lda camera_y+1
  ; sta w1+1
  ; jsr map_decode_column
  ; jsr map_process_intermediate_attribute_column_buffer
  ; lda #1
  ; sta column_ready
  
  ; lda #SPEED
  ; sta b0
  ; jsr decrement_camera_y
  
  ; lda camera_x
  ; sta w0
  ; lda camera_x+1
  ; sta w0+1

  ; lda camera_y
  ; sta w1
  ; lda camera_y+1
  ; sta w1+1
  ; jsr map_decode_row
  ; jsr map_process_intermediate_attribute_row_buffer
  ; lda #1
  ; sta row_ready
  
  ; lda #<animation_object
  ; sta w1
  ; lda #>animation_object
  ; sta w1+1
  ; lda current_animation_definition
  ; sta w2
  ; lda current_animation_definition+1
  ; sta w2+1
  ; jsr sprite_update_animation
  
; not_left_and_up:

  ; rts

; down_and_right_handler:

  ; lda buffer_controller+buttons::_right
  ; and #$01
  ; beq not_right_and_down
  ; lda buffer_controller+buttons::_down
  ; and #$01
  ; beq not_right_and_down
  ; ;right and down
  
  ; lda #SPEED
  ; sta b0
  ; jsr increment_camera_x
  
  ; clc
  ; lda camera_x
  ; adc #$00
  ; sta w0
  ; lda camera_x+1
  ; adc #$01
  ; sta w0+1

  ; lda camera_y
  ; sta w1
  ; lda camera_y+1
  ; sta w1+1
  ; jsr map_decode_column
  ; jsr map_process_intermediate_attribute_column_buffer
  ; lda #1
  ; sta column_ready
  
  ; lda #SPEED
  ; sta b0
  ; jsr increment_camera_y
  
  ; lda camera_x
  ; sta w0
  ; lda camera_x+1
  ; sta w0+1

  ; clc
  ; lda camera_y
  ; adc #224
  ; sta w1
  ; lda camera_y+1
  ; adc #$00
  ; sta w1+1
  ; jsr map_decode_row
  ; jsr map_process_intermediate_attribute_row_buffer
  ; lda #1
  ; sta row_ready
  
  ; lda #<animation_object
  ; sta w1
  ; lda #>animation_object
  ; sta w1+1
  ; lda current_animation_definition
  ; sta w2
  ; lda current_animation_definition+1
  ; sta w2+1
  ; jsr sprite_update_animation
  
; not_right_and_down:

  ; rts

; down_and_left_handler:

  ; lda buffer_controller+buttons::_left
  ; and #$01
  ; beq not_left_and_down
  ; lda buffer_controller+buttons::_down
  ; and #$01
  ; beq not_left_and_down
  ; ;left and down
  
  ; lda #SPEED
  ; sta b0
  ; jsr decrement_camera_x
  
  ; clc
  ; lda camera_x
  ; adc #$00
  ; sta w0
  ; lda camera_x+1
  ; adc #$00
  ; sta w0+1

  ; lda camera_y
  ; sta w1
  ; lda camera_y+1
  ; sta w1+1
  ; jsr map_decode_column
  ; jsr map_process_intermediate_attribute_column_buffer
  ; lda #1
  ; sta column_ready
  
  ; lda #SPEED
  ; sta b0
  ; jsr increment_camera_y
  
  ; lda camera_x
  ; sta w0
  ; lda camera_x+1
  ; sta w0+1

  ; clc
  ; lda camera_y
  ; adc #224
  ; sta w1
  ; lda camera_y+1
  ; adc #$00
  ; sta w1+1
  ; jsr map_decode_row
  ; jsr map_process_intermediate_attribute_row_buffer
  ; lda #1
  ; sta row_ready
  
  ; lda #<animation_object
  ; sta w1
  ; lda #>animation_object
  ; sta w1+1
  ; lda current_animation_definition
  ; sta w2
  ; lda current_animation_definition+1
  ; sta w2+1
  ; jsr sprite_update_animation
  
; not_left_and_down:

  ; rts

.endproc

.proc fill_nametable_columns

  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_column
  jsr map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  clc
  lda camera_x
  adc #$08
  sta camera_x
  lda camera_x+1
  adc #$00
  sta camera_x+1

  lda camera_x+1
  cmp #1
  bne :+
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  rts
:
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready
  
  jmp :--

  rts

.endproc
  
.proc fill_nametable_rows

fill_nametable_loop:
  ;wait til data has been consumed by nmi routine
:
  lda vblank_data_ready
  bne :-
  
  ;prepare data
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1
  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready
  
  clc
  lda camera_y
  adc #$08
  sta camera_y
  lda camera_y+1
  adc #$00
  sta camera_y+1
  
  lda camera_y
  cmp #240
  beq bottom_row
not_bottom_row:
  
  jmp done
bottom_row:

  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready

  rts

done:
  
  ; clear_ppu_2001_bit PPU1_DISPLAY_TYPE
  ; upload_ppu_2001
  
  ;tell nmi routine data is ready to consume
  lda #1
  sta vblank_data_ready

  jmp fill_nametable_loop

.endproc
