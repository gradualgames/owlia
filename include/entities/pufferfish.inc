.linecont +
.ifndef PUFFERFISH_INC
PUFFERFISH_INC = 1

PUFFERFISH_WIDTH = $0f
PUFFERFISH_HEIGHT = $0f

PUFFERFISH_BOB_ACCELERATION = 10
PUFFERFISH_BOB_MAX_VELOCITY = 150

;re-use the built in X coordinate because there is no offset
pufferfish_shadow_spot_x_lo = entity_x_lo
pufferfish_shadow_spot_x_hi = entity_x_hi

;supply new Y coordinate; the entity Y coordinate will be computed
;to be offset from this on every frame
pufferfish_shadow_spot_y_lo = entity_local0
pufferfish_shadow_spot_y_hi = entity_local1

;variables for making the pufferfish bob slowly up and down over a
;shadow spot
bob_altitude_lo = entity_local2
bob_altitude_hi = entity_local3
bob_altitude_fine = entity_local4
bob_velocity_lo = entity_local5
bob_velocity_hi = entity_local6

.enum
PUFFERFISH_STATE_INIT
PUFFERFISH_STATE_BOB_UP
PUFFERFISH_STATE_BOB_CREST
PUFFERFISH_STATE_BOB_DOWN
PUFFERFISH_STATE_BOB_TROUGH
.endenum

.define pufferfish_states \
  pufferfish_state_init, \
  pufferfish_state_bob_up, \
  pufferfish_state_bob_crest, \
  pufferfish_state_bob_down, \
  pufferfish_state_bob_trough

pufferfish_lo:
  .lobytes pufferfish_states

pufferfish_hi:
  .hibytes pufferfish_states

pufferfish_update:

  entity_state_switchboard pufferfish_lo, pufferfish_hi

pufferfish_state_init:

  jsr entity_set_drawable

  lda #<PufferFishPuffedSide
  sta entity_animation_address_lo,x
  lda #>PufferFishPuffedSide
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #PUFFERFISH_WIDTH
  sta entity_width,x
  lda #PUFFERFISH_HEIGHT
  sta entity_height,x

  ldy #sprite_chr_group_index_pufferfish
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  ;initialize how high above the ground the pufferfish "bobs"
  lda #0
  sta bob_altitude_fine,x
  lda #20
  sta bob_altitude_lo,x
  lda #0
  sta bob_altitude_hi,x

  ;initialize how fast the pufferfish will bob up and down
  lda #<0
  sta bob_velocity_lo,x
  lda #>0
  sta bob_velocity_hi,x

  ;initialize pufferfish's coordinates
  lda entity_y_lo,x
  sta pufferfish_shadow_spot_y_lo,x
  lda entity_y_hi,x
  sta pufferfish_shadow_spot_y_hi,x

  jsr pufferfish_compute_coordinates

  lda #PUFFERFISH_STATE_BOB_UP
  sta entity_state,x

  rts

pufferfish_state_bob_up:

  clc
  lda bob_velocity_lo,x
  adc #<PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_lo,x
  lda bob_velocity_hi,x
  adc #>PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_hi,x

  .scope
  sec
  lda bob_velocity_lo,x
  sbc #<(PUFFERFISH_BOB_MAX_VELOCITY)
  lda bob_velocity_hi,x
  sbc #>(PUFFERFISH_BOB_MAX_VELOCITY)
  bmi do_not_switch_state

  lda #PUFFERFISH_STATE_BOB_CREST
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr pufferfish_main

  rts

pufferfish_state_bob_crest:

  sec
  lda bob_velocity_lo,x
  sbc #<PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_lo,x
  lda bob_velocity_hi,x
  sbc #>PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_hi,x

  .scope
  sec
  lda bob_velocity_lo,x
  sbc #0
  lda bob_velocity_hi,x
  sbc #0
  bne do_not_switch_state

  lda #PUFFERFISH_STATE_BOB_DOWN
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr pufferfish_main

  rts

pufferfish_state_bob_down:

  sec
  lda bob_velocity_lo,x
  sbc #<PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_lo,x
  lda bob_velocity_hi,x
  sbc #>PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_hi,x

  .scope
  sec
  lda bob_velocity_lo,x
  sbc #<(-(PUFFERFISH_BOB_MAX_VELOCITY-PUFFERFISH_BOB_ACCELERATION))
  lda bob_velocity_hi,x
  sbc #>(-(PUFFERFISH_BOB_MAX_VELOCITY-PUFFERFISH_BOB_ACCELERATION))
  bpl do_not_switch_state

  lda #PUFFERFISH_STATE_BOB_TROUGH
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr pufferfish_main

  rts

pufferfish_state_bob_trough:

  clc
  lda bob_velocity_lo,x
  adc #<PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_lo,x
  lda bob_velocity_hi,x
  adc #>PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_hi,x

  .scope
  sec
  lda bob_velocity_lo,x
  sbc #0
  lda bob_velocity_hi,x
  sbc #0
  bne do_not_switch_state

  lda #PUFFERFISH_STATE_BOB_UP
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr pufferfish_main

  rts

.proc pufferfish_main

  .scope
  lda bob_velocity_hi,x
  bmi velocity_negative
velocity_positive:
  clc
  lda bob_altitude_fine,x
  adc bob_velocity_lo,x
  sta bob_altitude_fine,x
  lda bob_altitude_lo,x
  adc bob_velocity_hi,x
  sta bob_altitude_lo,x
  lda bob_altitude_hi,x
  adc #0
  sta bob_altitude_hi,x
  jmp done
velocity_negative:
  clc
  lda bob_altitude_fine,x
  adc bob_velocity_lo,x
  sta bob_altitude_fine,x
  lda bob_altitude_lo,x
  adc bob_velocity_hi,x
  sta bob_altitude_lo,x
  lda bob_altitude_hi,x
  adc #$ff
  sta bob_altitude_hi,x
done:
  .endscope

  jsr pufferfish_compute_coordinates

  clc
  lda pufferfish_shadow_spot_x_lo,x
  adc #4
  sta w0
  lda pufferfish_shadow_spot_x_hi,x
  adc #0
  sta w0+1

  lda pufferfish_shadow_spot_y_lo,x
  sta w1
  lda pufferfish_shadow_spot_y_hi,x
  sta w1+1

  jsr sprite_add_shadow_spot

  jsr entity_update_animation

  rts

.endproc

.proc pufferfish_compute_coordinates

  sec
  lda pufferfish_shadow_spot_y_lo,x
  sbc bob_altitude_lo,x
  sta entity_y_lo,x
  lda pufferfish_shadow_spot_y_hi,x
  sbc bob_altitude_hi,x
  sta entity_y_hi,x

  rts

.endproc

.endif
