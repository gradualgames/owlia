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
  .byte 3,2,1,0,ENV_STOP
volume9:
  .byte 11,9,6,3,1,1,1,ENV_STOP
volume10:
  .byte 1,1,1,1,1,1,0,ENV_STOP
volume11:
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
  .byte STV,4,STP,1,SDU,1,STL,20,D4,STL,10,D4,STL,20,A4,STL,10
  .byte A4,E4,F4,G4,STL,20,F4,STL,10,F4,STL,20,C4,STL,10,C4,STL,20
  .byte G4,STL,10,G4,D4,E4,C4,STL,30,D4,STL,20,D4,STL,10,D4,STL,20
  .byte A4,STL,10,A4,STL,20,E4,STL,10,E4,STL,20,B4,STL,10,B4,STL,20
  .byte G4,STL,10,G4,A4,B4,C5,B4,C5,D5,STL,20,A4,STL,10,A4
  .byte GOT
  .word square1

square2:
  .byte STV,5,STP,2,SDU,2,STL,60,F3,C4,E3,B3,F3,C4,G3,STL,10
  .byte A3,G3,F3,E3,F3,A3
  .byte GOT
  .word square2

triangle:
  .byte STV,6,STP,4,SDU,3,STL,50,D2,STL,10,D2,STL,60,A2,STL,50
  .byte C2,STL,10,C2,STL,60,G2,STL,50,D2,STL,10,D2,STL,50,A2,STL,10
  .byte A2,STL,50,B2,STL,10,B2,STL,50,C3,STL,10,A2
  .byte GOT
  .word triangle

noise:
  .byte STV,8,STP,4,STL,10,$4,$3,$3,$4,$3,$3,$4,$3,$3,$4,$3,$3
  .byte $4,$3,$3,$4,$3,$3,$4,STV,3,$3,STV,8,$3,$4,$3,$3,$4,$3,$3
  .byte $4,$3,$3,$4,$3,$3,$4,$3,$3,$4,$3,$3,$4,$3,$3,$4,STV,3
  .byte $3,STV,8,$3,$4,STV,3,$3,STV,8,$3
  .byte GOT
  .word noise

