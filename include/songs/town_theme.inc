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
  .byte 0,ENV_STOP
volume2:
  .byte 9,8,8,7,7,6,6,6,5,5,4,4,4,3,3,1,ENV_STOP
volume3:
  .byte 3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,3,ENV_STOP
volume4:
  .byte 3,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,4,4,3,ENV_STOP
volume5:
  .byte 4,4,4,4,4,4,4,0,0,ENV_STOP
volume6:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,ENV_LOOP,11
pitch1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch2:
  .byte 0,ENV_STOP

duty0:
  .byte 64,DUTY_ENV_STOP
duty1:
  .byte 128,DUTY_ENV_STOP
duty2:
  .byte 192,DUTY_ENV_STOP
duty3:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,2,STP,2,SDU,0,SLL,20,CS3,GS3,F4,GS3,GS2,DS3,C3,DS3
  .byte FS2,CS3,AS2,CS3,F2,CS3,GS2,CS3,DS2,AS2,FS2,AS2,CS2,F2,GS2
  .byte F2,GS2,C3,DS2,C3,GS2,F2,FS2,GS2,CS3,GS3,F4,GS3,GS2,DS3
  .byte C3,DS3,FS2,AS2,FS2,CS3,F2,CS3,F2,CS3,DS2,FS2,DS2,AS2,CS2
  .byte F2,GS2,F2,GS2,F2,FS2,GS2,CS2,GS2,F2,GS2,FS2,CS3,AS3,CS3
  .byte FS2,CS3,AS3,CS3,F2,CS3,GS3,CS3,F2,CS3,GS3,CS3,AS1,F2,AS2
  .byte F2,DS2,AS2,FS3,AS2,GS1,DS2,GS1,DS2,GS2,DS2,GS1,DS2
  .byte GOT
  .word square1

square2:
  .byte STV,4,STP,0,SDU,2,SLL,60,CS4,SLL,20,CS4,SLL,40,C4,GS3
  .byte SLL,60,AS3,SLL,20,AS3,SLL,40,GS3,F3,SLL,60,FS3,SLL,20
  .byte FS3,F3,GS3,F3,CS3,SLL,60,DS3,SLL,20,F3,SLL,40,GS3,AS3
  .byte SLL,60,CS4,SLL,20,CS4,SLL,40,C4,GS3,SLL,20,AS3,SLL,40
  .byte CS4,SLL,20,AS3,SLL,40,GS3,F3,SLL,20,FS3,SLL,40,AS3,SLL,20
  .byte FS3,F3,GS3,F3,CS3,SLL,40,DS3,SLL,20,CS3,C3,SLL,80,CS3
  .byte SLL,60,FS4,SLL,20,FS4,CS4,SLL,60,AS4,F4,SLL,20,F4,CS4
  .byte SLL,60,GS4,CS4,SLL,20,DS4,F4,DS4,CS4,DS4,SLL,60,GS3,SLL,20
  .byte GS3,SLL,40,GS4,DS4
  .byte GOT
  .word square2

triangle:
  .byte STV,5,STP,2,SDU,3,SLL,20,CS4,SLL,40,CS4,SLL,20,CS4,GS3
  .byte SLL,40,GS3,SLL,20,GS3,FS3,SLL,40,FS3,SLL,20,GS3,F3,SLL,40
  .byte F3,SLL,20,F3,DS3,SLL,40,DS3,SLL,20,F3,CS3,SLL,40,CS3,SLL,20
  .byte CS3,GS3,SLL,40,GS3,SLL,20,GS3,GS3,SLL,40,GS3,SLL,20
  .byte GS3,CS4,SLL,40,CS4,SLL,20,CS4,GS3,SLL,40,GS3,SLL,20
  .byte GS3,FS3,CS4,FS3,CS4,F3,CS4,F3,CS4,DS3,AS3,DS3,AS3,CS3
  .byte GS3,CS3,GS3,GS3,SLL,40,GS3,SLL,20,GS3,CS3,GS3,F3,GS3,SLL,60
  .byte FS2,SLL,20,FS2,SLL,80,CS2,SLL,60,F2,SLL,20,F2,SLL,80
  .byte CS2,SLL,60,AS2,SLL,20,F3,SLL,60,DS3,SLL,20,DS3,SLL,60
  .byte GS2,SLL,20,GS2,SLL,40,GS3,GS2
  .byte GOT
  .word triangle

noise:
  .byte STV,6,STP,2,SLL,128,SLH,7,A0
  .byte GOT
  .word noise

