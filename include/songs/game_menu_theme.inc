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

pitch:
  .word pitch0
  .word pitch1

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
  .byte 2,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,ENV_STOP
volume3:
  .byte 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
volume4:
  .byte 4,4,4,4,4,0,ENV_STOP
volume5:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP

duty0:
  .byte 128,DUTY_ENV_STOP
duty1:
  .byte 128,DUTY_ENV_STOP
duty2:
  .byte 128,DUTY_ENV_STOP
duty3:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,2,STP,0,SDU,1,STL,20,G3,STL,10,C4,G3,STL,30,D4,STL,10
  .byte E4,STL,60,D4,STL,20,G4,F4,E4,F4,A4,STL,60,E4,STL,20,F4,D4
  .byte AS4,STL,80,G4
  .byte GOT
  .word square1

square2:
  .byte STV,3,STP,1,SDU,2,STL,20,C2,STL,10,F2,C2,STL,30,G2,STL,10
  .byte G2,STL,60,G2,STL,20,C3,AS2,A2,AS2,STL,10,C3,D3,STL,20,A2
  .byte STL,10,A2,AS2,STL,20,F2,D2,G2,DS2,STL,80,C2
  .byte GOT
  .word square2

triangle:
  .byte STV,4,SDU,3,STL,20,C2,STL,10,C2,C2,STL,20,C2,STL,10,C2,C2
  .byte STL,20,C2,STL,10,C2,C2,STL,20,C2,STL,10,C2,C2,STL,20,C2,STL,10
  .byte C2,C2,STL,20,C2,STL,10,C2,C2,STL,20,C2,STL,10,C2,C2,STL,20
  .byte C2,STL,10,C2,C2,STL,20,C2,STL,10,C2,C2,STL,20,C2,STL,10,C2
  .byte C2,STL,20,C2,STL,10,C2,C2
  .byte GOT
  .word triangle

noise:
  .byte STV,0,STL,20,$0,STL,10,$0,$0,STL,20,$0,STL,10,$0,STL,5,$0
  .byte $0,STL,20,$0,STL,10,$0,STL,5,$0,$0,STL,20,$0,STL,10,$0,$0
  .byte STL,20,$0,STL,10,$0,$0,STL,20,$0,STL,10,$0,$0,STL,20,$0,STL,10
  .byte $0,$0,STL,20,$0,STL,10,$0,$0,STL,20,$0,STL,5,$0,$0,$0,$0
  .byte STL,20,$0,$0,$0,STL,10,$0,STL,5,$0,$0
  .byte GOT
  .word noise

