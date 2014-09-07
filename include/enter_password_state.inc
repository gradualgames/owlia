.ifndef ENTER_PASSWORD_STATE_INC
ENTER_PASSWORD_STATE_INC = 1

ENTER_PASSWORD_STATE_BANK = 1

.global enter_password_state_init

.struct enter_password_state_control
  textbox_spr_chr_offset .byte
  cursor_spr_chr_offset .byte
  underscore_bg_chr_offset .byte
  underscore_blink_counter .byte
  cursor_position_x .byte
  cursor_position_y .byte
  entered_character_index .byte
.endstruct

.endif
