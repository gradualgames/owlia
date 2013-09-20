
Song1:
  .byte 255
  .word Square1
  .word 0
  .word 0
  .word 0
  .word volume_envelopes
  .word pitch_envelopes
  .word duty_envelopes

volume_envelopes:
  .word volume_envelope_0
  .word volume_envelope_1
  .word volume_envelope_2
  .word volume_envelope_3
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

pitch_envelopes:
  .word pitch_envelope_0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

duty_envelopes:
  .word duty_envelope_0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 3,6,7,7,12,0,ENV_STOP
volume_envelope_3:
  .byte 2,5,6,9,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, DUTY_ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,3,F5,D5,B4,E5,CS5,AS4,DS5,C5,A4,D5,B4,GS4,CS5,AS4,G4,C5
  .byte A4,FS4,B4,GS4,F4,AS4,G4,E4,A4,FS4,DS4,GS4,F4,D4,G4,E4,CS4,F4
  .byte TRM
