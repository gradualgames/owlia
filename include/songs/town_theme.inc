Song1:
  .byte 255
  .word Square1
  .word Square2
  .word Triangle
  .word Noise
  .word volume_envelopes
  .word pitch_envelopes
  .word duty_envelopes

volume_envelopes:
  .word volume_envelope_0
  .word volume_envelope_1
  .word volume_envelope_2
  .word volume_envelope_3
  .word volume_envelope_4
  .word volume_envelope_5
  .word volume_envelope_6

pitch_envelopes:
  .word pitch_envelope_0
  .word pitch_envelope_1
  .word pitch_envelope_2

duty_envelopes:
  .word duty_envelope_0
  .word duty_envelope_1
  .word duty_envelope_2
  .word duty_envelope_3
  .word duty_envelope_4

volume_envelope_0:
  .byte 0, ENV_STOP
volume_envelope_1:
  .byte 7,5,2,0,ENV_STOP
volume_envelope_2:
  .byte 0,ENV_STOP
volume_envelope_3:
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP
volume_envelope_4:
  .byte 3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,3,ENV_STOP
volume_envelope_5:
  .byte 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
volume_envelope_6:
  .byte 4,4,4,4,4,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP
pitch_envelope_1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1
  .byte -1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1
  .byte 1,-1,-1,-1,-1,1,1,ENV_STOP
pitch_envelope_2:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1
  .byte -1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1
  .byte 1,-1,-1,-1,-1,1,1,ENV_STOP

duty_envelope_0:
  .byte 0, DUTY_ENV_STOP
duty_envelope_1:
  .byte 128,DUTY_ENV_STOP
duty_envelope_2:
  .byte 128,DUTY_ENV_STOP
duty_envelope_3:
  .byte 128,DUTY_ENV_STOP
duty_envelope_4:
  .byte 128,DUTY_ENV_STOP

Square1:
  .byte STV,3,STP,0,SDU,1,STL,20,CS2,GS2,F3,GS2,DS2,GS2,FS3,GS2,FS3,CS4,AS4,CS4,F3
  .byte CS4,GS4,CS4,DS3,AS3,FS4,AS3,CS3,F3,CS4,F3,C3,GS3,DS4,GS3,GS2,DS3,FS3,DS3,CS2
  .byte GS2,F3,GS2,DS2,GS2,FS3,GS2,FS3,AS3,FS4,CS4,F3,CS4,GS4,CS4,FS3,CS4,FS4,CS4
  .byte CS3,F3,CS4,F3,GS3,GS4,DS4,GS4,CS4,GS3,F3,GS3
  .byte GOT
  .word Square1
Square2:
  .byte STV,5,STP,2,SDU,3,STL,60,CS4,STL,20,CS4,STL,40,C4,GS3,STL,60,AS3,STL,20,AS3
  .byte STL,40,GS3,F3,STL,60,FS3,STL,20,FS3,F3,GS3,F3,CS3,STL,60,DS3,STL,20,F3,STL,40
  .byte GS3,AS3,STL,60,CS4,STL,20,CS4,STL,40,C4,GS3,STL,20,AS3,STL,40,CS4,STL,20,AS3
  .byte STL,40,GS3,F3,STL,20,FS3,STL,40,AS3,STL,20,FS3,F3,GS3,F3,CS3,STL,40,DS3,STL,20
  .byte CS3,C3,STL,80,CS3
  .byte GOT
  .word Square2
Triangle:
  .byte STV,0,STL,255,A0,A0,A0,A0,A0,STL,5,A0
  .byte GOT
  .word Triangle
Noise:
  .byte STV,0,STL,255,4,4,4,4,4,STL,5,4
  .byte GOT
  .word Noise
