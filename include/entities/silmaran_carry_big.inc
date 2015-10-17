.linecont +
.ifndef SILMARAN_CARRY_BIG_INC
SILMARAN_CARRY_BIG_INC = 1

SILMARAN_CARRY_TIME = 1000

SILMARAN_CARRY_BIG_SPEED = 4
SILMARAN_INITIAL_Y_OFFSET = 220

SILMARAN_HERO_X_OFFSET = 24
SILMARAN_HERO_Y_OFFSET = 32

SILMARAN_FAMILIAR_X_OFFSET = -24
SILMARAN_FAMILIAR_Y_OFFSET = 32

SILMARAN_CARRY_BIG_WIDTH = $0f
SILMARAN_CARRY_BIG_HEIGHT = $0f

define_entity_properties silmaran_carry_big_spawn_x_lo,\
                         silmaran_carry_big_spawn_x_hi,\
                         silmaran_carry_big_y_counter,\
                         silmaran_carry_big_state_counter_lo,\
                         silmaran_carry_big_state_counter_hi,\
                         silmaran_carry_big_palette_level,\
                         silmaran_carry_big_palette_counter

.enum
SILMARAN_CARRY_BIG_STATE_INIT
SILMARAN_CARRY_BIG_STATE_MAIN
.endenum

define_lohi_tables silmaran_carry_big, \
 {silmaran_carry_big_state_init, \
  silmaran_carry_big_state_main}

silmaran_carry_big_update:

  entity_state_switchboard silmaran_carry_big_lo, silmaran_carry_big_hi

silmaran_carry_big_state_init:

  jsr entity_set_drawable

  jsr entity_set_shadow_spot

  jsr entity_set_not_pausable

  lda #<28
  sta entity_shadow_spot_x_lo,x
  lda #>28
  sta entity_shadow_spot_x_hi,x

  lda #<112
  sta entity_shadow_spot_y_lo,x
  lda #>112
  sta entity_shadow_spot_y_hi,x

  entity_move16 entity_x, silmaran_carry_big_spawn_x

  sec
  lda entity_y_lo,x
  sbc #<SILMARAN_INITIAL_Y_OFFSET
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #>SILMARAN_INITIAL_Y_OFFSET
  sta entity_y_hi,x

  lda #SILMARAN_INITIAL_Y_OFFSET
  sta silmaran_carry_big_y_counter,x

  lda #<silmaran_carry_big
  sta entity_animation_address_lo,x
  lda #>silmaran_carry_big
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SILMARAN_CARRY_BIG_WIDTH
  sta entity_width,x
  lda #SILMARAN_CARRY_BIG_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_silmaran_carry_big
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  jsr controller_clear
  set_controller_routine controller_nop

  lda #ENTITY_DIRECTION_RIGHT
  sta hero_direction

  lda hero_flags
  and #HERO_FLAGS_DRAWABLE_CLEAR
  ora #HERO_FLAGS_HIDE_STATUS_SET
  sta hero_flags

  far_call #FAMILIAR_BANK, familiar_common_init

  lda #ENTITY_DIRECTION_RIGHT
  sta familiar_direction

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_PASSIVE
  sta familiar_state

  ;this is an ugly hard-coded hack because these are hard-coded
  ;for the hero and familiar. But we didn't have room for the hero's
  ;CHR due to how huge this silmaran flying sprite is, so we load
  ;the familiar at slot 0 this time.
  ldy #0
  lda sprite_chr_group_offsets,y
  sta familiar_sprite_group_offset

  jsr silmaran_carry_big_set_hero_position

  jsr silmaran_carry_big_set_familiar_position

  lda #<1000
  sta silmaran_carry_big_state_counter_lo,x
  lda #>1000
  sta silmaran_carry_big_state_counter_hi,x

  lda #0
  sta silmaran_carry_big_palette_level,x

  lda #0
  sta silmaran_carry_big_palette_counter,x

  lda #SILMARAN_CARRY_BIG_STATE_MAIN
  sta entity_state,x

  rts

silmaran_carry_big_state_main:

  .scope
  sec
  lda silmaran_carry_big_state_counter_lo,x
  sbc #<1
  sta silmaran_carry_big_state_counter_lo,x
  lda silmaran_carry_big_state_counter_hi,x
  sbc #>1
  sta silmaran_carry_big_state_counter_hi,x

  lda silmaran_carry_big_state_counter_lo,x
  ora silmaran_carry_big_state_counter_hi,x
  bne do_not_transition_yet

  lda #ACTION_GOTO_LOCATION_GROUP1
  sta state_control_params+play_state_control::action
  lda #location_index_thrones_scene
  sta state_control_params+play_state_control::param

do_not_transition_yet:
  .endscope

  .scope
  lda silmaran_carry_big_palette_level,x
  cmp #MAX_BRIGHTNESS_LEVEL
  beq do_not_increment_scene_brightness

  inc silmaran_carry_big_palette_counter,x
  lda silmaran_carry_big_palette_counter,x
  cmp #64
  bne do_not_increment_scene_brightness

  lda #0
  sta silmaran_carry_big_palette_counter,x

  inc silmaran_carry_big_palette_level,x
  lda silmaran_carry_big_palette_level,x
  sta dynamic_palette_brightness_level_bg
  sta b3
  jsr entity_change_palette_brightness_bg_trampoline

do_not_increment_scene_brightness:
  .endscope

  .scope
  lda silmaran_carry_big_y_counter,x
  beq do_not_lower_silmaran_any_longer
  dec silmaran_carry_big_y_counter,x
  clc
  lda entity_y_lo,x
  adc #<1
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #>1
  sta entity_y_hi,x
do_not_lower_silmaran_any_longer:
  .endscope

  clc
  lda entity_x_lo,x
  adc #<SILMARAN_CARRY_BIG_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>SILMARAN_CARRY_BIG_SPEED
  sta entity_x_hi,x

  jsr silmaran_carry_big_set_hero_position

  jsr silmaran_carry_big_set_familiar_position

  jsr silmaran_carry_big_scroll_right

  .scope
  lda camera_x
  cmp #64
  bne do_not_reset_scroll

  lda #0
  sta camera_x
  sta camera_x+1
  sta camera_scroll_x

  entity_move16 silmaran_carry_big_spawn_x, entity_x

  jsr silmaran_carry_big_set_hero_position

  jsr silmaran_carry_big_set_familiar_position

do_not_reset_scroll:
  .endscope

  jsr entity_update_animation

  rts

.proc silmaran_carry_big_scroll_right

  txa
  pha

  lda #SILMARAN_CARRY_BIG_SPEED
  sta b0
  jsr increment_camera_x

  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$01
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  far_call map_bank, map_decode_column
  far_call map_bank,  map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  pla
  tax

  rts

.endproc

.proc silmaran_carry_big_set_hero_position

  clc
  lda entity_x_lo,x
  adc #<SILMARAN_HERO_X_OFFSET
  sta hero_x
  lda entity_x_hi,x
  adc #>SILMARAN_HERO_X_OFFSET
  sta hero_x+1
  clc
  lda entity_y_lo,x
  adc #<SILMARAN_HERO_Y_OFFSET
  sta hero_y
  lda entity_y_hi,x
  adc #>SILMARAN_HERO_Y_OFFSET
  sta hero_y+1

  rts

.endproc

.proc silmaran_carry_big_set_familiar_position

  clc
  lda entity_x_lo,x
  adc #<SILMARAN_FAMILIAR_X_OFFSET
  sta familiar_x
  lda entity_x_hi,x
  adc #>SILMARAN_FAMILIAR_X_OFFSET
  sta familiar_x+1
  clc
  lda entity_y_lo,x
  adc #<SILMARAN_FAMILIAR_Y_OFFSET
  sta familiar_y
  lda entity_y_hi,x
  adc #>SILMARAN_FAMILIAR_Y_OFFSET
  sta familiar_y+1

  rts

.endproc

.endif
