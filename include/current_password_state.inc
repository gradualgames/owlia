.ifndef CURRENT_PASSWORD_STATE_INC
CURRENT_PASSWORD_STATE_INC = 1

;assumed to match the inventory state bank
CURRENT_PASSWORD_STATE_BANK = 1

.global current_password_state_init

.struct current_password_state_control
  nametable_hi .byte
  password_field .byte 6
.endstruct

.endif
