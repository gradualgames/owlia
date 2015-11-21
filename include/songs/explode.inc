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
  .word volume7
  .word volume8
  .word volume9
  .word volume10
  .word volume11
  .word volume12

pitch:
  .word pitch0
  .word pitch1
  .word pitch2
  .word pitch3
  .word pitch4

duty:
  .word duty0
  .word duty1
  .word duty2
  .word duty3
  .word duty4

volume0:
  .byte 4,4,4,4,4,0,ENV_STOP
volume1:
  .byte 1,1,1,1,1,1,1,1,1,1,0,ENV_STOP
volume2:
  .byte 5,5,2,0,0,0,ENV_STOP
volume3:
  .byte 4,3,0,4,3,0,4,3,0,4,3,0,4,3,0,4,3,0,4,3,0,ENV_STOP
volume4:
  .byte 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
volume5:
  .byte 3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,3,ENV_STOP
volume6:
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP
volume7:
  .byte 0,ENV_STOP
volume8:
  .byte 7,5,2,0,ENV_STOP
volume9:
  .byte 11,9,6,3,1,1,1,ENV_STOP
volume10:
  .byte 1,1,1,1,1,1,0,ENV_STOP
volume11:
  .byte 2,ENV_STOP
volume12:
  .byte 0,ENV_STOP

pitch0:
  .byte 12,12,12,12,12,12,12,12,12,12,ENV_STOP
pitch1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch2:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch3:
  .byte 120,120,120,120,120,120,120,120,ENV_STOP
pitch4:
  .byte 0,ENV_STOP

duty0:
  .byte 128,DUTY_ENV_STOP
duty1:
  .byte 128,DUTY_ENV_STOP
duty2:
  .byte 128,DUTY_ENV_STOP
duty3:
  .byte 128,DUTY_ENV_STOP
duty4:
  .byte 128,0,DUTY_ENV_STOP

square1:
  .byte STV,7,STP,4,SLL,128,SLH,1,C2
  .byte GOT
  .word square1

square2:
  .byte STV,7,STP,4,SLL,128,SLH,1,C2
  .byte GOT
  .word square2

triangle:
  .byte STV,7,STP,4,SLL,128,SLH,1,C2
  .byte GOT
  .word triangle

noise:
  .byte STV,11,STP,4,SLL,128,SLH,1,15
  .byte GOT
  .word noise

