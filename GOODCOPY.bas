'PICARM PROGRAM BY HAYDEN TSUI

symbol hsensor=b6 ;declare variables
symbol vsensor=b7
symbol k = b5
symbol i = b4
symbol j = b0

servo b.1,80  	;set initial positions of servos
servo b.2,200
pause 1000		;wait to finish


start:

if j = 0 then  	;checks if start button is pressed
	goto myloop 

elseif j = 2 then		;if button is pressed update servo positions
servopos b.1,hsensor 
	servopos b.2,vsensor
	goto servos

end if

servos: 

readadc C.1,hsensor 	;read horizontal sensor

if hsensor<80 then	;if less than lower limit
	hsensor=80		;force value to lower limit


elseif hsensor>210 then	;if higher than high limit			
	hsensor=210		;force value to upper limit
			
endif
	
readadc C.3,vsensor		;read vertical sensor

if vsensor<80 then		;if less than lower limit
	vsensor=80				;force value to lower limit


elseif vsensor>200 then	;if higher than high limit
	vsensor=200		;force value to high limit
	
endif	
	
goto myloop1 ;check if restart counter button is pressed

myloop: 
button C.4,1,100,100,b3,1,pushed ;if start button is pressed go to pushed method
goto start
return

myloop1:
button C.5,1,100,100,b3,1,pushed1 ;if start button is pressed go to pushed1 method
button C.4,1,100,100,b3,1,winner
goto main
return

pushed: 
j = 2
sound b.0,(2,50) ;play startup sound
sound b.0,(50,50)
sound b.0,(100,50)
goto main ;start countdown
return

pushed1:
sound b.0,(120,50) ;plays a sound to signify the restart button has been pressed
k=10 ;restart counter value
goto main ;restart countdown
return 

winner:
sound b.0,(10,50) ;
sound b.0,(20,50)
sound b.0,(30,50)
sound b.0,(150,50)
play b.0,0 ;play happy birthday to signify they have won
j = 0 'restart the game
goto myloop1

main: ;method for countdown timer
if k = 0 then 
	k=10
	
elseif i = 65 then
	k=k-1
endif 

pause 10
if i = 65 then
	gosub segmentdisp ;display countdown value

else
	i = i + 1
	
endif
goto start ;loop back to start
return

segmentdisp: ;method for displaying countdown value
i = 0
Select k 
Case 0 low B.7 low B.6 low B.5 low b.4
Case 1 high B.7 low B.6 low B.5 low b.4
Case 2 low B.7 high B.6 low B.5 low b.4
Case 3 high B.7 high B.6 low B.5 low b.4
Case 4 low B.7 low B.6 high B.5 low b.4
Case 5 high B.7 low B.6 high B.5 low b.4
Case 6 low B.7 high B.6 high B.5 low b.4
Case 7 high B.7 high B.6 high B.5 low b.4
Case 8 low B.7 low B.6 low B.5 high b.4 
Case 9 high B.7 low B.6 low B.5 high b.4
endselect

if k = 0 then ;if countdown value is 0 then game is over
	sound b.0,(100,50) ;display gameover sounds
	sound b.0,(50,50)
	sound b.0,(2,50)
	j=0			;restart the game and wait for start button
	servo b.1,80  	;set initial positions of servos
	servo b.2,200
	goto start

endif
return
