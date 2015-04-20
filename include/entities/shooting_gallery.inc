.linecont +
.ifndef SHOOTING_GALLERY_INC
SHOOTING_GALLERY_INC = 1

SHOOTING_GALLERY_MAX_TARGETS = 4

define_entity_properties shooting_gallery_state_counter

.enum
SHOOTING_GALLERY_STATE_INIT
SHOOTING_GALLERY_STATE_MAIN
.endenum

define_lohi_tables shooting_gallery, \
 {shooting_gallery_state_init, \
  shooting_gallery_state_main}

shooting_gallery_update:

  entity_state_switchboard shooting_gallery_lo, shooting_gallery_hi

shooting_gallery_state_init:

  jsr entity_set_not_pausable

  lda rand
  sta shooting_gallery_state_counter,x

  lda #SHOOTING_GALLERY_STATE_MAIN
  sta entity_state,x

  rts

shooting_gallery_state_main:

  .scope
  dec shooting_gallery_state_counter,x
  bne do_not_spawn_target

  .scope
  lda #0
  sta b0
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  inc b0
skip_entity:

  dey
  bpl next_entity
  .endscope

  sec
  lda #SHOOTING_GALLERY_MAX_TARGETS
  sbc b0
  bmi do_not_spawn_target

  ;choose left or right side of screen
  .scope
  lda rand
  and #%00000001
  bne odd
even:

  jsr spawn_target_left

  jmp done
odd:

  jsr spawn_target_right

done:
  .endscope

  jsr next_rand
  lda rand
  ora #1
  sta shooting_gallery_state_counter,x

do_not_spawn_target:
  .endscope

  rts

.proc spawn_target_left

  lda #entity_index_target
  sta b0

  lda #<(-16)
  sta w0
  lda #>(-16)
  sta w0+1

  lda #<48
  sta w1
  lda #>48
  sta w1+1

  jsr entity_spawn

  ldy spawned_entity
  lda #ENTITY_DIRECTION_RIGHT
  sta target_direction,y

  jsr parameterize_new_target

  rts

.endproc

.proc spawn_target_right

  lda #entity_index_target
  sta b0

  lda #<256
  sta w0
  lda #>256
  sta w0+1

  lda #<48
  sta w1
  lda #>48
  sta w1+1

  jsr entity_spawn

  ldy spawned_entity
  lda #ENTITY_DIRECTION_LEFT
  sta target_direction,y

  jsr parameterize_new_target

  rts

.endproc

.proc parameterize_new_target

  ldy spawned_entity

  jsr next_rand
  lda rand
  and #%00000001
  sta target_mode,y

  jsr next_rand
  lda rand
  and #%00000011
  sta target_type,y

  jsr next_rand
  lda rand
  and #%00000011
  ora #1
  sta target_speed,y

  jsr next_rand
  lda rand
  and #%00000111
  sta target_random_speed_mask,y

  lda #1
  sta target_health,y

  .scope
  lda target_mode,y
  cmp #TARGET_MODE_NORMAL
  beq normal
  cmp #TARGET_MODE_RANDOM_SPEED
  beq random_speed
normal:

  .scope
  lda target_speed,y
  cmp #1
  beq one
  cmp #2
  beq two
  cmp #3
  beq three
one:

  lda #<1000
  sta target_gp_lo,y
  lda #>1000
  sta target_gp_hi,y

  jmp done
two:

  lda #<3000
  sta target_gp_lo,y
  lda #>3000
  sta target_gp_hi,y

  jmp done
three:

  lda #<5000
  sta target_gp_lo,y
  lda #>5000
  sta target_gp_hi,y

done:
  .endscope

  jmp done
random_speed:

  .scope
  lda target_random_speed_mask,y
  and #%00000001
  bne one
  lda target_random_speed_mask,y
  and #%00000010
  bne two
  lda target_random_speed_mask,y
  and #%00000100
  bne three
one:

  lda #<2000
  sta target_gp_lo,y
  lda #>2000
  sta target_gp_hi,y

  jmp done
two:

  lda #<4000
  sta target_gp_lo,y
  lda #>4000
  sta target_gp_hi,y

  jmp done
three:

  lda #<8000
  sta target_gp_lo,y
  lda #>8000
  sta target_gp_hi,y

done:
  .endscope

done:
  .endscope

  rts

.endproc

.endif
