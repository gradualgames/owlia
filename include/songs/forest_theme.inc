song1:
  .byte 255
  .word square1
  .word square2
  .word triangle
  .word noise
  .word volume
  .word pitch
  .word duty

volume:
  .word volume0
  .word volume1
  .word volume2
  .word volume3
  .word volume4
  .word volume5
  .word volume6

pitch:
  .word pitch0
  .word pitch1
  .word pitch2

duty:
  .word duty0
  .word duty1
  .word duty2
  .word duty3

volume0:
  .byte 7,5,2,0,ENV_STOP
volume1:
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP
volume2:
  .byte 3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,3,ENV_STOP
volume3:
  .byte 3,4,4,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,3,3,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,0,0,ENV_STOP
volume4:
  .byte 4,4,4,4,4,0,ENV_STOP
volume5:
  .byte 1,1,1,1,1,1,1,1,1,ENV_STOP
volume6:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,ENV_LOOP,11
pitch1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch2:
  .byte 0,ENV_STOP

duty0:
  .byte 128,DUTY_ENV_STOP
duty1:
  .byte 128,DUTY_ENV_STOP
duty2:
  .byte 128,DUTY_ENV_STOP
duty3:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,5,STP,0,SDU,1,SLL,20,DS2,AS2,F3,AS2,DS2,AS2,F3,AS2
  .byte DS2,AS2,F3,AS2,DS2,AS2,F3,AS2,DS2,AS2,F3,C4,DS2,AS2,F3
  .byte C4,DS2,AS2,F3,C4,DS2,AS2,F3,C4,SLL,10,DS3,F3,DS3,F3,DS3
  .byte F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3
  .byte F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3
  .byte F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3
  .byte F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3
  .byte F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3
  .byte F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3,F3,DS3
  .byte F3,DS3,F3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,C3,CS3,C3,CS3
  .byte C3,CS3,C3,CS3,B2,CS3,B2,CS3,AS2,F3,AS2,F3
  .byte GOT
  .word square1

square2:
  .byte STV,3,STP,0,SDU,2,SLL,80,DS3,SLL,10,DS3,SLL,50,F3,SLL,20
  .byte AS2,SLL,10,G3,GS3,AS3,GS3,SLL,40,G3,STV,5,SDU,1,SLL,10
  .byte G4,GS4,AS4,GS4,SLL,40,G4,STV,3,SDU,2,SLL,80,DS3,SLL,10
  .byte DS3,F3,SLL,60,C4,SLL,10,D4,AS3,C4,G4,SLL,40,DS4,STV,5
  .byte SDU,1,SLL,10,D4,AS3,C4,G4,SLL,40,DS4,STV,3,SDU,2,SLL,20
  .byte DS4,SLL,10,CS4,C4,SLL,20,AS3,SLL,10,C4,CS4,SLL,20,DS4
  .byte SLL,10,DS4,AS3,SLL,20,DS3,SLL,10,DS3,AS3,SLL,20,DS4,SLL,10
  .byte CS4,C4,SLL,20,AS3,SLL,10,C4,CS4,SLL,20,FS4,SLL,10,F4,DS4
  .byte SLL,40,DS3,SLL,20,DS4,SLL,10,CS4,C4,SLL,20,AS3,SLL,10
  .byte C4,CS4,SLL,20,DS4,SLL,10,DS4,AS3,SLL,20,DS3,SLL,10
  .byte DS3,AS3,SLL,20,DS4,SLL,10,CS4,C4,SLL,20,AS3,SLL,10
  .byte C4,CS4,SLL,20,FS4,SLL,10,F4,DS4,SLL,40,DS3,SLL,10,F3,FS3
  .byte C4,CS4,SLL,120,FS4,SLL,10,F3,FS3,AS3,C4,SLL,120,F4,SLL,10
  .byte DS3,F3,FS3,AS3,SLL,120,DS4,SLL,10,DS3,F3,FS3,AS3,SLL,40
  .byte C4,B3,AS3
  .byte GOT
  .word square2

triangle:
  .byte STV,4,STP,2,SDU,3,SLL,20,DS2,SLL,140,DS2,SLL,20,DS2,SLL,140
  .byte DS2,SLL,20,DS2,SLL,140,DS2,SLL,20,DS2,SLL,140,DS2,SLL,10
  .byte DS3,AS3,SLL,60,DS4,SLL,10,DS3,AS3,SLL,60,DS4,SLL,10
  .byte DS3,AS3,SLL,60,DS4,SLL,10,DS3,AS3,SLL,60,DS4,SLL,10
  .byte DS3,AS3,SLL,60,DS4,SLL,10,DS3,AS3,SLL,60,DS4,SLL,10
  .byte DS3,AS3,SLL,60,DS4,SLL,10,DS3,AS3,SLL,140,DS4,SLL,10
  .byte DS2,DS2,DS2,DS2,SLL,120,DS2,SLL,10,DS2,DS2,DS2,DS2,SLL,120
  .byte DS2,SLL,10,CS2,CS2,CS2,CS2,SLL,120,CS2,SLL,10,B1,B1,B1
  .byte B1,AS1,AS1,AS1,AS1
  .byte GOT
  .word triangle

noise:
  .byte STV,6,STP,2,SLL,128,SLH,7,A0
  .byte GOT
  .word noise

