song1:
  .byte 100
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
  .byte 0,1,2,2,3,3,4,4,4,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,ENV_STOP
volume4:
  .byte 4,4,4,4,4,0,ENV_STOP
volume5:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
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
  .byte STV,5,STP,2,STL,5,A0,STV,3,STP,1,SDU,2,STL,20,DS4,STL,10
  .byte DS3,AS3,STL,30,CS4,STL,10,DS4,STL,20,AS4,STL,10,GS4,AS4
  .byte STL,30,F4,STL,10,F4,FS4,AS4,DS5,FS4,STL,30,F4,STL,10
  .byte CS4,DS4,FS4,B4,DS4,STL,30,CS4,STL,10,AS3,STL,20,DS4,STL,10
  .byte DS3,AS3,STL,30,CS4,STL,10,DS4,STL,20,AS4,STL,10,C5,AS4
  .byte STL,30,F4,STL,10,F4,FS4,AS4,DS5,FS4,STL,30,F4,STL,10
  .byte DS4,F4,GS4,CS5,F4,STL,35,DS4
  .byte GOT
  .word square1

square2:
  .byte STV,3,STP,1,SDU,2,STL,20,DS4,STL,10,DS3,AS3,STL,30
  .byte CS4,STL,10,DS4,STL,20,AS4,STL,10,GS4,AS4,STL,30,F4,STL,10
  .byte F4,FS4,AS4,DS5,FS4,STL,30,F4,STL,10,CS4,DS4,FS4,B4,DS4
  .byte STL,30,CS4,STL,10,AS3,STL,20,DS4,STL,10,DS3,AS3,STL,30
  .byte CS4,STL,10,DS4,STL,20,AS4,STL,10,C5,AS4,STL,30,F4,STL,10
  .byte F4,FS4,AS4,DS5,FS4,STL,30,F4,STL,10,DS4,F4,GS4,CS5,F4,STL,40
  .byte DS4
  .byte GOT
  .word square2

triangle:
  .byte STV,5,STP,2,STL,255,A0,A0,STL,130,A0
  .byte GOT
  .word triangle

noise:
  .byte STV,5,STP,2,STL,255,A0,A0,STL,130,A0
  .byte GOT
  .word noise
