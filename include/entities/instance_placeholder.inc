;This entity is used as a workaround to enforce hard coded sprite priority
;in special static situations such as the rescue owl inside its cage. We
;need four empty entity slots BEFORE the owl and the cage so that when
;the explosions of the cage are spawned, they have higher sprite priority
;and show overtop of the owl. All this entity does is get spawned and die,
;leaving a slot open earlier in the entity instances arrays. This means any
;entity occupying these spots will have higher sprite priority. Kind of a hack,
;but it works.

.linecont +
.ifndef INSTANCE_PLACEHOLDER_INC
INSTANCE_PLACEHOLDER_INC = 1

.enum
INSTANCE_PLACEHOLDER_STATE_INIT
.endenum

.define instance_placeholder_states \
  instance_placeholder_state_init

instance_placeholder_lo:
  .lobytes instance_placeholder_states

instance_placeholder_hi:
  .hibytes instance_placeholder_states

instance_placeholder_update:

  entity_state_switchboard instance_placeholder_lo, instance_placeholder_hi

instance_placeholder_state_init:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

.endif
