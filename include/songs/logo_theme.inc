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

pitch:
  .word pitch0
  .word pitch1

duty:
  .word duty0

volume0:
  .byte 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,3,2,2,2,2,2,2,1,1,1,1,1,1,0,0,0,ENV_STOP
volume1:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,ENV_LOOP,11
pitch1:
  .byte 0,ENV_STOP

duty0:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,0,STP,0,SDU,0,SLL,24,G2,F2,SLL,6,E2,F2,SLL,36,G2,SLL,96
  .byte C2
  .byte TRM

square2:
  .byte STV,1,STP,1,SLL,6,A0,STV,0,STP,0,SDU,0,SLL,24,G2,F2,SLL,6
  .byte E2,F2,SLL,36,G2,SLL,90,C2
  .byte TRM

triangle:
  .byte STV,1,STP,1,SLL,192,A0
  .byte TRM

noise:
  .byte STV,1,STP,1,SLL,192,A0
  .byte TRM
