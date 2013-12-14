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
  .word volume_envelope_7

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
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP
volume_envelope_3:
  .byte 3,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,3,ENV_STOP
volume_envelope_4:
  .byte 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
volume_envelope_5:
  .byte 4,4,4,4,4,0,ENV_STOP
volume_envelope_6:
  .byte 0,ENV_STOP
volume_envelope_7:
  .byte 6,4,0,6,4,0,6,4,0,6,4,0,6,4,0,ENV_STOP

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
  .byte STV,3,STP,2,SDU,3,STL,48,DS4,STL,96,CS4,STL,48,C4,STL,96,AS3,STL,12,GS3,AS3
  .byte C4,GS3,STL,96,AS3,STL,12,GS3,FS3,F3,GS3,STL,72,FS3,STL,24,F3,STV,2,STP,0,SDU,1
  .byte DS1,STL,12,DS1,DS1,STL,24,DS1,STL,12,DS1,DS1,STL,24,DS1,STL,12,DS1,DS1,STL,24
  .byte CS1,STL,12,CS1,CS1,STL,24,CS1,STL,12,CS1,CS1,STL,24,CS1,STL,12,CS1,CS1,STL,24
  .byte B0,STL,12,B0,B0,STL,24,B0,STL,12,B0,B0,STL,24,B0,STL,12,B0,B0,STL,24,AS0,STL,12
  .byte AS0,AS0,STL,24,AS0,STL,12,AS0,AS0,STL,24,AS0,STL,12,AS0,AS0,STL,24,DS1,STL,12
  .byte DS1,DS1,STL,24,DS1,STL,12,DS1,DS1,STL,24,DS1,STL,12,DS1,DS1,DS1,AS0,C1,CS1
  .byte STL,24,DS1,STL,12,DS1,DS1,STL,24,DS1,STL,12,DS1,DS1,CS1,F1,DS1,CS1,STL,24
  .byte DS1,STL,12,DS1,DS1,STL,24,DS1,STL,12,DS1,DS1,CS1,FS1,F1,DS1,STL,24,CS1,STL,12
  .byte CS1,CS1,STL,24,CS1,STL,12,CS1,CS1,STL,24,B0,STL,12,B0,B0,STL,24,B0,STL,12
  .byte B0,B0,STL,24,B0,STL,12,B0,B0,STL,24,CS1,STL,12,CS1,CS1,STL,24,CS1,STL,12,CS1
  .byte CS1,STL,24,CS1,STL,12,CS1,CS1,STL,24,A1,STL,12,A1,A1,STL,24,A1,STL,12,A1,A1
  .byte STL,24,A1,STL,12,A1,A1,STL,24,B1,STL,12,B1,B1,STL,24,B1,STL,12,B1,B1,STL,24
  .byte B1,STL,12,B1,B1,STL,24,CS2,STL,12,CS2,CS2,STL,24,CS2,STL,12,CS2,CS2,STL,24
  .byte CS2,STL,12,CS2,CS2,STL,24,AS1,STL,12,AS1,AS1,STL,24,AS1,STL,12,AS1,AS1,STL,24
  .byte AS1,STL,12,AS1,AS1,STL,24,GS1,STL,12,GS1,GS1,STL,24,GS1,STL,12,GS1,GS1,STL,24
  .byte GS1,STL,12,GS1,GS1,STL,24,AS1,STL,12,AS1,AS1,STL,24,AS1,STL,12,AS1,AS1,STL,24
  .byte AS1,STL,12,AS1,AS1
  .byte GOT
  .word Square1
Square2:
  .byte STV,3,STP,2,SDU,3,STL,24,DS3,STL,12,DS2,AS2,STL,72,CS3,STL,24,CS3,C3,STL,12
  .byte DS2,GS2,STL,72,AS2,STL,24,AS2,GS2,STL,12,CS2,GS2,STL,72,AS2,STL,24,AS2,GS2
  .byte STL,12,DS2,F2,STL,72,FS2,STL,24,F2,DS4,STL,12,DS3,AS3,STL,72,CS4,STL,24,DS4
  .byte AS4,STL,12,GS4,AS4,STL,96,F4,STL,24,DS4,STL,12,DS3,AS3,STL,72,CS4,STL,24,DS4
  .byte AS4,STL,12,C5,AS4,STL,96,F4,STL,24,DS4,STL,12,DS3,AS3,STL,72,CS4,STL,24,CS4
  .byte C4,STL,12,DS3,GS3,STL,72,AS3,STL,24,AS3,GS3,STL,12,CS3,GS3,STL,72,AS3,STL,24
  .byte AS3,STL,12,GS3,FS3,F3,DS3,STL,96,F3,STL,24,B4,STL,12,DS4,F4,STL,72,FS4,STL,24
  .byte FS4,STL,12,GS4,FS4,F4,DS4,STL,96,F4,STL,24,A4,STL,12,CS4,DS4,STL,72,E4,STL,24
  .byte E4,STL,12,FS4,E4,DS4,CS4,STL,96,DS4,STL,24,CS4,STL,12,F4,CS4,STL,96,GS4,STL,24
  .byte AS4,STL,12,F4,DS4,STL,96,AS3,STL,24,DS4,STL,12,C4,DS4,STL,72,GS4,STL,24,FS4
  .byte F4,STL,12,AS3,F4,STL,24,AS4,STL,12,GS4,FS4,F4,DS4,D4,AS3
  .byte GOT
  .word Square2
Triangle:
  .byte STV,0,STL,255,A0,A0,STL,66,A0,STV,5,STP,0,SDU,4,STL,24,DS2,DS2,DS2,DS2,DS2
  .byte DS2,CS2,CS2,CS2,CS2,CS2,CS2,B1,B1,B1,B1,B1,B1,AS1,AS1,AS1,AS1,AS1,AS1,DS2
  .byte DS2,DS2,DS2,DS2,DS2,DS2,DS2,DS2,DS2,DS2,DS2,CS2,CS2,DS2,DS2,DS2,DS2,CS2,CS2
  .byte CS2,CS2,CS2,CS2,B1,B1,B1,B1,B1,B1,CS2,CS2,CS2,CS2,CS2,CS2,A2,A2,A2,A2,A2,A2
  .byte B2,B2,B2,B2,B2,B2,CS3,CS3,CS3,CS3,CS3,CS3,AS2,AS2,AS2,AS2,AS2,AS2,GS2,GS2
  .byte GS2,GS2,GS2,GS2,AS2,AS2,AS2,AS2,AS2,AS2
  .byte GOT
  .word Triangle
Noise:
  .byte STV,0,STL,255,4,4,STL,66,4,STV,1,STP,0,SDU,0,STL,24,1,STL,12,1,1,STL,24,1
  .byte STL,12,1,1,STL,24,1,STV,7,1,STV,1,1,STL,12,1,1,STL,24,1,STL,12,1,1,STL,24
  .byte 1,STV,7,1,STV,1,1,STL,12,1,1,STL,24,1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1
  .byte STL,12,1,1,STL,24,1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1,STL,12,1,1,STL,24
  .byte 1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1,STL,12,1,1,STL,24,1,STL,12,1,1,STL,24
  .byte 1,STV,7,1,STV,1,1,STL,12,1,1,STL,24,1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1
  .byte STL,12,1,1,STL,24,1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1,STL,12,1,1,STL,24
  .byte 1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1,STL,12,1,1,STL,24,1,STL,12,1,1,STL,24
  .byte 1,STV,7,1,STV,1,1,STL,12,1,1,STL,24,1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1
  .byte STL,12,1,1,STL,24,1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1,STL,12,1,1,STL,24
  .byte 1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1,STL,12,1,1,STL,24,1,STL,12,1,1,STL,24
  .byte 1,STV,7,1,STV,1,1,STL,12,1,1,STL,24,1,STL,12,1,1,STL,24,1,STV,7,1,STV,1,1
  .byte STL,12,1,1,STL,24,1,STL,12,1,1,STL,24,1,STV,7,1
  .byte GOT
  .word Noise
