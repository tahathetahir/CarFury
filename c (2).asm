[org 0x0100]
jmp start
scrollrow: times 132 dw 0 ; space for 1 row
seed : dw 0
carLane: dw 3
score : dw 0
clock : dw 0
laps : dw 1
oldisr: dd 0
oldisr2 : dd 0
scoreprint: db 'Score: '
bonusprint: db 'Bonus: '
lapsprint: db 'Laps: '
gameEnd : dw 0
ticks : dw 0
messageForYou : db 'You can change the name tho, latecomer >:|0'
MessageLen : dw 0
timeToPrintCar : dw 1
skipheart: dw 0
skipclock: dw 0
prevLane : dw 0
paused: dw 0
buffer : times 5676 dw 0
ticks2 : dw 0
PausedScreenText1 : db 'Sure? Press [N] to Continue or [Y] To Exit',0
PausedStrLen : dw 0
TitleName:  db '  _____           ______                 0'
			db ' / ____|         |  ____|                0'
			db '| |     __ _ _ __| |__ _   _ _ __ _   _  0'
			db '| |    / _` |  __|  __| | | |  __| | | | 0'
			db '| |___| (_| | |  | |  | |_| | |  | |_| | 0'
			db ' \_____\__,_|_|  |_|   \__,_|_|   \__, | 0'
			db '                                   __/ | 0'
			db '                                  |___/  0'
		

TitleNamelen : dw 0

StartTitle :db ' ___ _            _   0' 
			db '/ __| |_ __ _ _ _| |_ 0'
			db '\__ \  _/ _` |  _|  _|0'
			db '|___/\__\__,_|_|  \__|0'
StartTItleLen : dw 9
ExitTitle : db ' ___     _ _   0' 
		    db '| __|_ _(_) |_ 0'
		    db '| _|\ \ / |  _|0'
			db '|___/_\_\_|\__|0'
ExitTitleLen : dw 8
menu : dw 1
lapsUpdatedOnce : dw 0
collided : dw 0
OurRollNumbers : db '24l-0943 & 24l-0677',0
OurRollNumbersLen : dw 0

; takes seed from pc to generate random numbers
getTimeSeed:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		
		mov ah,0x00
		int 1Ah
		xor  dx, cx        
		in   al, 40h        
		xor  dl, al
		mov  ax, dx     

		mov [seed],ax		
		
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 


;generates a random number and puts it into global variable seed
randomNum:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		
		
		call getTimeSeed
		mov ax,[seed]
		mov bx,25173
		mul bx
		add ax,13849
		mov [seed],ax
		
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 


;based on random number, it checks its divisibilty by 3 and then returns 1-3 based on remainder in dx
getLaneNumber:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		
		call randomNum
		xor dx,dx
		mov ax,[seed]
		mov bx,3
		div bx
		
		cmp dx,0
		jz lane1
		cmp dx,1
		jz lane2
		
		jmp lane3
	
	lane1:
		mov  word[bp+4],1
		jmp term
	lane2:
		mov  word[bp+4],2
		jmp term
	lane3:
		mov  word[bp+4],3
		jmp term
		
	term:
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret


;gets a random lane number by above function and prints car of blue attribute in that specific lane
EnemyCars:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		
		sub sp,2
		call getLaneNumber
		pop ax
		
		cmp ax,1
		jz lane1Enemy
		cmp ax,2
		jz lane2Enemy
		
		jmp lane3Enemy
		
		lane1Enemy:
			mov al,00010000b
			push ax
			mov ax,0
			push ax
			mov ax,42
			push ax
			call printCar
			jmp term2
			
		lane2Enemy:
			mov al,00010000b
			push ax
			mov ax,0
			push ax
			mov ax,63
			push ax
			call printCar
			jmp term2
		
		lane3Enemy:
			mov al,00010000b
			push ax
			mov ax,0
			push ax
			mov ax,83
			push ax
			call printCar
			jmp term2
		
		term2:
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 

clrscr:
		push es
		push ax
		push cx
		push di

		mov ax, 0xb800
		mov es, ax
		mov di, 0
		mov ax, 0x0720
		mov cx, 5676
		cld
		rep stosw

		pop di
		pop cx
		pop ax
		pop es
		ret

offsetCalculator:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		
		mov ax,132
		mul word[bp+6] 				
		add ax,[bp+4] 				
		shl ax,1
		mov [bp+8],ax
		
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 4


printgreen:
		push es
		push ax
		push bx
		push dx
		push di

		mov ax, 0xb800
		mov es, ax	
		mov di, 0				

	nextleft:
		mov bx, 32
		
		pg1:
		mov ah, 0x27
		mov al, 0	
		stosw		
		dec bx
		jnz pg1

		cmp di, 11152 ;change
		jge nextloc
		add di, 200 ; 99x2
		jmp nextleft

	nextloc:
		mov di, 200 ; starting index for right side printing
		nextright:
		mov bx, 132

	pg2:
		mov ah, 0x27
		mov al, 0	
		stosw		
		dec bx
		cmp bx, 100
		jne pg2

		cmp di, 11352
		jge exit
		add di, 200 ; 99x2
		jmp nextright


	exit:
		pop di
		pop dx
		pop bx
		pop ax
		pop es
		ret

printroad:
		push es
		push ax
		push bx
		push dx
		push di

		mov ax, 0xb800
		mov es, ax	
		mov di, 70 ; starting index for road				

	nextroad:
		mov bx, 62

	pgrey:
		mov ah, 0x70 ; grey
		mov al, 0	
		stosw		
		dec bx
		jnz pgrey

		cmp di, 11282
		jge exitroad
		add di, 140 ; 70 x 2
		jmp nextroad

	exitroad:
		pop di
		pop dx
		pop bx
		pop ax
		pop es
		ret

printCar:           
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		
		
		mov ax,0xb800
		mov es,ax
		
		carbase:
			
			mov bx,[bp+6]
			mov dx,[bp+4]
			
			sub sp,2
			push bx
			push dx
			call offsetCalculator
			pop di
			
			mov al, 0xDB 
            mov ah, 0xEE
			stosw ; left headlight
			
			mov ah,[bp+8]
			mov al,0x20
			push ax
			
			mov cx,5 ; 5->6->7
			rep stosw
			
			mov al, 0xDB 
            mov ah, 0xEE
			stosw ; right headlight
			
			pop ax ; ax restored
			
			add bx,1
			sub dx,1
			
			sub sp,2
			push bx
			push dx
			call offsetCalculator
			pop di
			push ax
			mov ah,0x07
			stosw 
			pop ax
			
			mov cx,7 ; 6->7
			rep stosw
			
			push ax 
			
			mov ah,0x07
			stosw 
			pop ax
		
			 mov cx,2 ; dont change!!
			 
			CarBody: ;here
			push cx
			inc dx
			inc bx
			
			sub sp,2
			push bx
			push dx
			call offsetCalculator
			pop di
			
			cmp cx,2 
			jnz notwindows	
			stosw
			
			push ax
			mov ah,00110000b
			mov al,0x20
			mov cx,5 ; 4->5
			rep stosw
			pop ax
			stosw
			jmp windows
			
			notwindows:
			mov cx,7 ; 6->7
			rep stosw
			
			
			windows:
			dec dx
			pop cx
			loop CarBody
			
			inc bx
			sub sp,2
			push bx
			push dx
			call offsetCalculator
			pop di
			
			push ax
			mov ah,0x07
			stosw
			pop ax
			
			 mov cx,3
			 
			inc dx
			
			sub sp,2
			push bx
			push dx
			call offsetCalculator
			pop di
			
			mov cx,7 ;6->7
			rep stosw
			
			push ax
			mov ah,0x07
			stosw
			pop ax
			
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 6
	

printwhite:
		push es
		push ax
		push bx
		push cx
		push dx
		push di

		mov ax, 0xb800
		mov es, ax	

		mov di, 110  ; start at column 55
		mov cx, 43          

	One:
	; Decide when to draw vs skip (draw for 3 rows and skip for 2 rows)
		mov ax, cx
		mov dx, 0
		mov bx, 6     ;5->6
		div bx        ; AX = quotient, DX = remainder
		cmp dx, 3
		jae skip1     ; skip if remainder 3 or 4 or 5

	; draw 1 white spaces if remainder is 0 or 1 or 2
		mov bx, 1 ; change

	pw1:
		mov ah, 0x7F     
		mov al, 0xDB
		stosw
		dec bx
		jnz pw1
		jmp next1

	skip1:
		add di, 2        

	next1:
		add di, 262     
		loop One


	mov di, 152         ; start at column 76 
	mov cx, 43

	Two:
		mov ax, cx
		mov dx, 0
		mov bx, 6
		div bx
		cmp dx, 3
		jae skip2

	mov bx, 1 ;change

	pw2:
		mov ah, 0x7F
		mov al, 0xDB
		stosw
		dec bx
		jnz pw2
		jmp next2

	skip2:
		add di, 2
		
	next2:
		add di, 262
		loop Two

	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	ret

checkCollision:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		push ds

		;moving top left (row,col) of car into ax,bx respectively
		mov ax,[bp+6]  ;row
		mov bx,[bp+4]  ;column
		
		sub sp,2
		push ax
		push bx
		call offsetCalculator
		pop si		;points to video memory one row above car
		
		mov ax,0xb800
		mov ds,ax
		
		mov word[bp+10],0			;base condition : no collision
		
		mov cx,8
		checkingCollisionLoop:		
		
			lodsw
			
			cmp ah,[bp+8] ; attribute of colliding object
			jz collision
			
			loop checkingCollisionLoop
			jmp terminateCollision
			
		collision:
			mov word[bp+10],1
	
	terminateCollision:
		pop ds
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 6
		
printyellow:
		push es
		push ax
		push bx
		push cx
		push dx
		push di

		mov ax, 0xb800
		mov es, ax	

		mov di, 64  ; start at column 32
		mov cx, 43          

	OneY:
	; Decide when to draw vs skip (draw for 2 rows and skip for 2 rows)
		mov ax, cx
		mov dx, 0
		mov bx, 4     ; 5<-->3
		div bx        ; AX = quotient, DX = remainder
		cmp dx, 2
		jae skip1Y     ; skip if remainder 2 or 3 or 4

	; draw 3 yellow spaces if remainder is 0 or 1
		mov bx, 3 ; change

	pw1Y:
		mov ah, 0x6E     
		mov al, 0xDB
		stosw
		dec bx
		jnz pw1Y
		jmp next1Y

	skip1Y:
		add di, 6        

	next1Y:
		add di, 258     
		loop OneY


	mov di, 194         ; start at column 97
	mov cx, 43

	TwoY:
		mov ax, cx
		mov dx, 0
		mov bx, 4
		div bx
		cmp dx, 2
		jae skip2Y

	mov bx, 3 ;change

	pw2Y:
		mov ah, 0x6E
		mov al, 0xDB
		stosw
		dec bx
		jnz pw2Y
		jmp next2Y

	skip2Y:
		add di, 6
		
	next2Y:
		add di, 258
		loop TwoY

	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	ret

drawtree:
		push bp
		mov bp,sp
		push es
		push ax
		push bx
		push cx
		push di

		mov ax, 0xb800
		mov es, ax
		mov bx, 1

		mov di, [bp+4]
		mov cx, 3             
	row:
		push cx
		mov cx, 0
		add cx, bx
	position:
		mov al, 0xDB             
		mov ah, 0x2A           
		stosw
		loop position

		mov ax, bx
		shl ax, 1
		add di, 262
		sub di, ax
		add bx, 2
		pop cx
		loop row

		mov di, [bp+4] ; draw tree base
		add di, 792
		mov al, 0x2A               
		mov ah, 0x66           
		stosw

		pop di
		pop cx 
		pop bx
		pop ax
		pop es
		pop bp
		ret 2

printtrees:
	push bp
	mov bp,sp

		mov ax, 1342 ; row 5, column 11
		push ax
		call drawtree
		mov ax, 9262 ; row 35, column 11
		push ax
		call drawtree
		mov ax, 5302 ; row 20, column 11
		push ax
		call drawtree
		mov ax, 3476 ; row 13, column 22
		push ax
		call drawtree
		mov ax, 7172 ; row 27, column 22
		push ax
		call drawtree
		mov ax, 1540 ; row 5, column 110
		push ax
		call drawtree
		mov ax, 9460 ; row 35, column 110
		push ax
		call drawtree
		mov ax, 5500 ; row 20, column 110
		push ax
		call drawtree
		;mov ax, 3674 ; row 13, column 121
		;push ax
		;call drawtree
		;mov ax, 7370 ; row 27, column 121
		;push ax
		;call drawtree

	pop bp
	ret

scrollscreen: 
			push bp
			mov bp,sp
			push ax
			push cx
			push dx
			push si
			push di
			push es
			push ds
			push ds ; for buffer restoring on top row

; buffer functionality
;------------------------

		mov ax, 132 
		mov cx, 42
		mul cx
		shl ax, 1 ; at first cell of last row (132*42)*2
		mov cx, 132 ; 132 cells copied
			
		mov si, ax ; 11088 

		push ds
		pop es

		mov ax, 0xb800
		mov ds, ax

		mov di, scrollrow
		cld 
		rep movsw

;--------------------------------
			mov ax, 132 ; load chars per row in ax
			push ax ; save position for later use
			shl ax, 1 ; convert to byte offset
			
			mov si, 11086 ; start from second last row (42*132)*2
			
			mov cx, 11352 ; number of screen locations
			sub cx, ax ; count of words to move

			mov ax, 0xb800
			mov es, ax ; point es to video base
			mov ds, ax ; point ds to video base
			mov di, 11350 ; point di to lower right column
			
			
			mov bx,[bp+6] ; car last row
			mov dx,[bp+4] ; car last col
			
			calculatecar:
					sub sp,2
					push bx
					push dx
					call offsetCalculator
					pop dx ; dx has starting index of car
					 
					; skip 9 car cells (9 cols)
					
		    std ; set auto decrement mode
			checkcarandscoll:
			
			        mov bx, [bp+10]
					cmp di, bx
					jne checkcar
					
					skipcols:
					sub si, 36 ; 18*2
				    sub di, 36 ; 18*2
					
					sub word [bp+10], 264
					
					
					checkcar:
					cmp si, bx
					je skipcols
					
                    cmp si, dx
                    je skipcar					
			        cmp di, dx
					je skipcar
					
					
					push ax
					
					mov ax,[es:si]
					mov [es:di],ax
					
					pop ax
					
					sub di,2
					sub si,2
					
					
					cmp di,264
					jae checkcarandscoll
					
					jmp restore
					
				    skipcar:
					sub si, 18 ; 9*2
				    sub di, 18 ; 9*2
					
				    mov dx, [bp+4]
					mov bx,[bp+6]
					sub bx, [bp+8] ; 1 row up
					add byte [bp+8], 1
					
					cmp bx, 36
					ja nochangecar
					sub byte [bp+8], 1
					add bx, 1
					
					nochangecar:
					jmp calculatecar
			
;-------------------------------------
;copy last row stored in buffer to the top
 
    restore:
            mov ax, 0xb800
			mov es, ax 
			pop cx ; 132
			mov di, 0

			pop ds
			mov si, scrollrow
			cld
			
	reprint:		
			lodsw	
				
			cmp di,70
			jz restoreLane
			cmp di,112
			jz restoreLane
			cmp di,154
			jz restoreLane
			
			stosw 
			loop reprint

		pop ds
		pop es
		pop di
		pop si
		pop dx
		pop cx
		pop ax
		pop bp
		ret 8 ; 6->8

restoreLane:
	push ax
	push cx	
			mov cx,20
			push cx
			mov ax,0x7020
			rep stosw
			
			pop cx
			rep lodsw
			sub si,2
	pop cx
	sub cx,20
	pop ax
	jmp reprint

delay:
	pusha
	
	mov cx, [clock]
	
	cmp word[clock],0
	jnz delay_loop1
	
	mov word[weHitTheClock],0
	jmp SkipDelay
	
	delay_loop1:
	push cx
	mov cx, 0xFFFF
	delay_loop2:
	loop delay_loop2
	pop cx
	loop delay_loop1
	dec word[clock]
	SkipDelay:
	popa
	ret

getBonusRowCol:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		push ds
	
			mov ax,[bp+4]
		
		cmp ax,1
		jz lane1Bonus
		
		cmp ax,2
		jz lane2Bonus
		
		lane3Bonus:
			mov word[bp+6],0
			mov word[bp+8],83
			jmp terminateGetBonusRowCol
		
		lane2Bonus:
			mov word[bp+6],0
			mov word[bp+8],63
			jmp terminateGetBonusRowCol
			
		lane1Bonus:
			mov word[bp+6],0
			mov word[bp+8],42
	
	terminateGetBonusRowCol:
		pop ds
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 2

; based on global variable carLane value, it returns row and col coordinates of our car (row would be same but starting col would be different depending on lane)
getCarRowCol:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		push ds
	
			mov ax,[bp+4]
		
		cmp ax,1
		jz lane1Car
		
		cmp ax,2
		jz lane2Car
		
		lane3Car:
			mov word[bp+6],37
			mov word[bp+8],83
			jmp terminateGetCarRowCol
		
		lane2Car:
			mov word[bp+6],37
			mov word[bp+8],63
			jmp terminateGetCarRowCol
			
		lane1Car:
			mov word[bp+6],37
			mov word[bp+8],42
	
	terminateGetCarRowCol:
		pop ds
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 2


;prints bonus object (an attemp to make a heart (i can draw))
RenderBonus:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		push ds
	
		
		mov ax,0xb800
		mov es,ax
		
		mov ax,[bp+6] ;row
		mov bx,[bp+4] ;column
		
		sub sp,2
		push ax
		push bx
		call offsetCalculator
		pop di
		
		mov ah,01000000b
		mov al,0x20
		
		mov cx,7
		topHeart:
		cmp cx,4
		jz skipTopHeart
			
			mov [es:di],ax
			
		skipTopHeart: 
		add di,2
		loop topHeart 
		
		add di,252
			
		mov cx,5
		rep stosw
		
		add di,256
		
		mov cx,3
		rep stosw
		
		add di,260
		
		stosw
	
	terminateRenderBonus:
		pop ds
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 4

;this function hasnt been tested yet but what it does it, it checks if the blue car has touched the floor of screen, if yes it increments global variable of score		
checkScore:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		push ds
		
		sub sp,2
		mov al,00010000b
		push ax
		mov ax,42
		push ax
		mov ax,42
		push ax
		call checkCollision  
		pop ax
		
		cmp ax,1
		jnz lane2BonusCheck
		
		add word[score],1
		
		lane2BonusCheck:
		sub sp,2
		mov al,00010000b
		push ax
		mov ax,42
		push ax
		mov ax,63
		push ax
		call checkCollision
		pop ax
		
		cmp ax,1
		jnz lane3BonusCheck
		
		add word[score],1
		
		lane3BonusCheck:
		sub sp,2
		mov al,00010000b
		push ax
		mov ax,42
		push ax
		mov ax,83
		push ax
		call checkCollision
		pop ax
		
		cmp ax,1
		jnz terminateBonusCheck
		
		add word[score],1
		
		terminateBonusCheck:
		pop ds
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 

RenderclockBonus:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		push ds
		
		sub sp,2
		call getLaneNumber
		pop bx
		
		sub sp,4
		push bx
		call getBonusRowCol
		pop ax
		pop bx
	
		push bx		;A->x
		push ax		;A->y
		add bx,6	;B-> x					     ;+8
		push bx
		add ax,3	;B->y					     ;+6
		push ax
		call RenderClock
	
	
		
		pop ds
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret
		
		
RenderClock:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	push ds
	
	mov bh,0x6e
	mov bl,0xdb
	xor ax,ax
	BoundsValidator:
	mov ax,[bp+4]
	cmp ax,[bp+8]
	jb near terminateBlockFun
	
	mov ax,[bp+6]
	cmp ax,[bp+10]
	jb near terminateBlockFun
	
	mov ax,0xb800
	mov es,ax
	
	mov ah,bh
	mov al,bl
	
	Looper1:
	sub sp,2
	push word[bp+8]
	push word[bp+10]
	call offsetCalculator
	pop di
	
	mov cx,[bp+6]
	sub cx,[bp+10]
	
	cld
	rep stosw			;upper line
	
	sub di,2
	
	mov cx,[bp+4]
	sub cx,[bp+8]
		rightLoop:
			add di,264 ; 160->264
			mov [es:di],ax
			
			loop rightLoop
	
	mov cx,[bp+6]
	sub cx,[bp+10]
	
	std
	rep stosw			;down line
	cld
	
	add di,2
	
	mov cx,[bp+4]
	sub cx,[bp+8]
		LeftLoop:
			sub di,264 ; 160->264
			mov [es:di],ax
			
			loop LeftLoop
	
	mov bh, 0x7f
	mov bl,0xdb
	inc word[bp+10]
	inc word[bp+8]
	dec word[bp+4]
	dec word[bp+6]
	jmp BoundsValidator
		

terminateBlockFun:
	pop ds
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8
	
printGreyBlock:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	push ds
	
	mov bh,0x70
	mov bl,0x20 ;0
	xor ax,ax
	gBoundsValidator:
	mov ax,[bp+4]
	cmp ax,[bp+8]
	jb near gterminateBlockFun
	
	mov ax,[bp+6]
	cmp ax,[bp+10]
	jb near gterminateBlockFun
	
	mov ax,0xb800
	mov es,ax
	
	mov ah,bh
	mov al,bl
	
	gLooper1:
	sub sp,2
	push word[bp+8]
	push word[bp+10]
	call offsetCalculator
	pop di
	
	mov cx,[bp+6]
	sub cx,[bp+10]
	
	cld
	rep stosw			;upper line
	
	sub di,2
	
	mov cx,[bp+4]
	sub cx,[bp+8]
		grightLoop:
			add di,264 ; 160->264
			mov [es:di],ax
			
			loop grightLoop
	
	mov cx,[bp+6]
	sub cx,[bp+10]
	
	std
	rep stosw			;down line
	cld
	
	add di,2
	
	mov cx,[bp+4]
	sub cx,[bp+8]
		gLeftLoop:
			sub di,264 ; 160->264
			mov [es:di],ax
			
			loop gLeftLoop
	
	mov bh, 0x70
	mov bl,0x20
	inc word[bp+10]
	inc word[bp+8]
	dec word[bp+4]
	dec word[bp+6]
	jmp gBoundsValidator
		

gterminateBlockFun:
	pop ds
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8

renderHeartBonus:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	push ds
		

		sub sp,2
		call getLaneNumber
		pop bx
		
		sub sp,4
		push bx
		call getBonusRowCol
		pop ax
		pop bx
		
		push ax
		push bx
		call RenderBonus
	pop ds
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
	
printScoreAfterCollision:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		push ds
		
		mov ax,0xb800
		mov es,ax
		mov di,[bp+4]
		
		
		;print score count
		mov ax, [score]
		mov bx, 10
		mov cx, 0
		
		anextdigitscore: 
				mov dx, 0
				div bx
				add dl, 0x30
				push dx
				inc cx
				cmp ax, 0
				jnz anextdigitscore
				
				
		anextposscore:
				pop dx
				mov dh, 0x07
				mov [es:di], dx
				add di, 2
				loop anextposscore
		
		
		aterminatePrintScore:
		pop ds
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 2
			

printScore:
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push dx
		push es
		push si
		push di
		push ds
		
		mov ax,0xb800
		mov es,ax
		
		mov si, lapsprint
        mov cx, 6
        mov di, 4458 ; row 16, col 117
        mov ah, 0x07
		
		cld 
		nextc: lodsb 
		stosw 
		loop nextc 
		
		; print lap number
		mov ax, [laps]
		mov bx, 10
		mov cx, 0
		
		nextdigit: 
				mov dx, 0
				div bx
				add dl, 0x30
				push dx
				inc cx
				cmp ax, 0
				jnz nextdigit
				
				
		nextpos:
				pop dx
				mov dh, 0x07
				mov [es:di], dx
				add di, 2
				loop nextpos
				
		
		mov si, scoreprint
        mov cx, 7 
        mov di, 5250 ; row 19, col 117
        mov ah, 0x07

		cld 
		nextch: lodsb 
		stosw 
		loop nextch 
		
		;print score count
		mov ax, [score]
		mov bx, 10
		mov cx, 0
		
		nextdigitscore: 
				mov dx, 0
				div bx
				add dl, 0x30
				push dx
				inc cx
				cmp ax, 0
				jnz nextdigitscore
				
				
		nextposscore:
				pop dx
				mov dh, 0x07
				mov [es:di], dx
				add di, 2
				loop nextposscore
		
		
		mov si, bonusprint
        mov cx, 7 
        mov di, 6042 ; row 22, col 117
        mov ah, 0x07

		cld 
		nextchar1: lodsb 
		stosw 
		loop nextchar1 
		
		mov bx,[clock]
		cmp bx,0
		jz skipBonusPrinting
		
		add di,2
		
		mov ah,00100000b
		mov al,0x20
		
		stosw
		jmp terminatePrintScore
		
		skipBonusPrinting:

		add di,2
		mov ah,0
		mov al,0x20
		
		stosw
		
		terminatePrintScore:
		pop ds
		pop di
		pop si
		pop es
		pop dx
		pop cx
		pop bx
		pop ax
		pop bp
		ret 
		
printScoreBlock:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	push ds
	
	mov bh,[bp+4]
	mov bl,0x20
	xor ax,ax
	sBoundsValidator:
	mov ax,[bp+6]
	cmp ax,[bp+10]
	jb near sterminateBlockFun
	
	mov ax,[bp+8]
	cmp ax,[bp+12]
	jb near sterminateBlockFun
	
	mov ax,0xb800
	mov es,ax
	
	mov ah,bh
	mov al,bl
	
	sLooper1:
	sub sp,2
	push word[bp+10]
	push word[bp+12]
	call offsetCalculator
	pop di
	
	mov cx,[bp+8]
	sub cx,[bp+12]
	
	cld
	rep stosw			;upper line
	
	sub di,2
	
	mov cx,[bp+6]
	sub cx,[bp+10]
		srightLoop:
			add di,264 ; 160->264
			mov [es:di],ax
			
			loop srightLoop
	
	mov cx,[bp+8]
	sub cx,[bp+12]
	
	std
	rep stosw			;down line
	cld
	
	add di,2
	
	mov cx,[bp+6]
	sub cx,[bp+10]
		sLeftLoop:
			sub di,264 ; 160->264
			mov [es:di],ax
			
			loop sLeftLoop
	
	mov bh, 0x00 ;77
	mov bl,0x20
	inc word[bp+12]
	inc word[bp+10]
	dec word[bp+6]
	dec word[bp+8]
	jmp sBoundsValidator
		

sterminateBlockFun:
	pop ds
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 10

collidedMsgPrintedOnce : dw 0

ourVeryOwnKbisr:
	pusha
	
	in al,0x60
	
	cmp word[menu],1
	jz near MenuSoBlockIsr
	
	cmp word[collided],1
	je near collidedHandler
	
	cmp word[paused],1
	jz near normal
	
	cmp al,0x01
	je paused1

	
	
	cmp word[weHitTheClock],1
	jz near normal
	
	cmp al,0x20
	je right
	
	cmp al,0x1e
	je left

	jmp normal
	
	MenuSoBlockIsr:
	cmp al,0x1f
	jnz DontGoToGame
	jz GoToGame
	
	
	GoToGame:
	mov word[menu],0
	call RenderGame
	
	DontGoToGame:
	cmp al,0x12
	jnz near normal
	
	mov word[gameEnd],1
	
	jmp normal
		
	right:
		

		
		cmp word[carLane],3
		je near normal
		
		mov word[timeToPrintCar],1
		
		mov ax,[carLane]
		mov [prevLane],ax
			
		add word[carLane],1
		jmp normal
		
	left:
		cmp word[carLane],1
		je normal
		
		
		mov ax,[carLane]
		mov [prevLane],ax
		
		
		mov word[timeToPrintCar],1	
		sub word[carLane],1
		
		jmp normal
		
	paused1:
	
		;TurnPauseOn
		call saveScreen
		mov word[pausedPrintedOnce],0
		mov word[paused],1
		jmp normal
		
	collidedHandler:
		cmp al,0x32
		jnz normal
	
		mov word[collidedMsgPrintedOnce],0
		mov word[MenuPrintedOnce],0
		mov word[menu],1
		mov word[paused],0
		mov word[collided],0
		call reset
		

	normal:
		popa
		
		jmp far [cs:oldisr]	
		
pausedPrintedOnce : dw 0		

reset:
	pusha
	
	mov word[score],0
	mov word[laps],0
	
	popa
	ret

saveScreen:
	pusha

	mov cx, 11352 ; number of screen locations

	mov ax, 0xb800
	mov ds, ax ; ds = 0xb800
	push cs
	pop es
	mov si, 0
	mov di, buffer
	cld ; set auto increment mode
	rep movsb ; save screen
	;[es:di] = [ds:si]

	popa

	ret

restoreScreen: 
	pusha

	mov cx,  11352; number of screen locations

	mov ax, 0xb800
	mov es, ax ; ds = 0xb800
	push cs
	pop ds
	mov si, buffer
	mov di, 0
	cld ; set auto increment mode
	rep movsb ; save screen
	;[es:di] = [ds:si]

	popa

	ret



RenderScoreBlock:
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	push ds
	
	mov ax,115	;A-> x  (2-120-20-130 makes the screen rain) ;+12
	push ax
	mov ax,	13 ;A->y					     ;+10
	push ax
	mov ax,131	;B-> x					     ;+8
	push ax
	mov ax,26	;B->y					     ;+6
	push ax
	mov al, 0x44 ;attribute					     ;+4
	push ax
	call printScoreBlock
	
	
	
	
	pop ds
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 



shiftLapsBool: 
	pusha
	
	cmp word[lapsUpdatedOnce],0
	jnz setone
	
	mov word[lapsUpdatedOnce],1
	jmp terminateShiftLapsBool
	
	setone:
		mov word[lapsUpdatedOnce],0
		jmp terminateShiftLapsBool
	
	terminateShiftLapsBool:
	popa
	ret

MoveScreen:
	pusha
	
		cmp word[menu],1
		jz near RenderMenuInt
	
		cmp word[collided],1
		je near collidedMsgInt
	
		cmp word[paused],1
		jz near PausedScreen
		
		call printScore 
		inc word[ticks]
		
		cmp word[ticks],23
		jb scroll
	
		mov word[ticks],0
		
			bigLoop:
			
			
			
			cmp word[lapsUpdatedOnce],1
			jnz skipLapsUpdate
			
			inc word[laps]
			
			skipLapsUpdate:
			call shiftLapsBool
			
			
			sub sp,2
			call getLaneNumber
			pop bx
			
			cmp bx,1
			jz printBonus
			cmp bx,2
			jz printClock
			
			printEnemy:
			call EnemyCars
			jmp skipBonus
			
			printClock:
			call RenderclockBonus
			jmp skipBonus
			
			printBonus:
			call renderHeartBonus
			
		
			skipBonus:
			call EnemyCars
			scroll:
				
				cmp word[weHitTheClock],1
				jnz check21
				
				call delay
				
				check21:
				
				sub sp,4
				mov ax,[carLane]
				push ax
				call getCarRowCol
				pop bx
				pop dx
				
				mov ax, 11350 ; for score block
				push ax
				mov ax, 1
				push ax
				add bx,4 ; ending car row  
				add dx,7 ; ending car col
				push bx
				push dx
				call scrollscreen
			
			
				sub sp,4
				mov ax,[carLane]
				push ax
				call getCarRowCol
				pop bx
				pop dx
				
				sub sp,2
				mov al,01000000b ;red attribute
				push ax
				dec bx			;one row above the car where collision may happen
				push bx
				push dx
				call checkCollision
				pop ax
				
				
				cmp ax,0
				jz skipheart1
			
				mov word[skipheart],1
				
				skipheart1:
				
		
				
				sub sp,4
				mov ax,[carLane]
				push ax
				call getCarRowCol
				pop bx
				pop dx
				
				;checking colliion with clock
				sub sp,2
				mov al,0x6E ;red attribute
				push ax
				dec bx;one row above the car where collision may happen
				push bx
				push dx
				call checkCollision
				pop ax
				
				cmp ax,0
				jz skipclock1
				
				mov word[skipclock],1
				
				skipclock1:
				
				
				
				sub sp,4
				mov ax,[carLane]
				push ax
				call getCarRowCol
				pop bx
				pop dx
				
				;checking collision with other cars
				sub sp,2
				mov al,00010000b ;BLUE ATTRIBUTE
				push ax
				dec bx; no need to dec bx here since already done upar
				push bx
				push dx
				call checkCollision
				pop ax
				
				cmp ax,0		;function returns bool value
				jz skipterminatecheck1

				mov word[collided],1
				mov word[collidedMsgPrintedOnce],0

				skipterminatecheck1:
				
				sub sp,4
				mov ax,[carLane]
				push ax
				call getCarRowCol
				pop bx
				pop dx
				
				;checking collision with other cars
				sub sp,2
				mov al,00010000b ;BLUE ATTRIBUTE
				push ax
				add bx,5 	;one row below car where collision may happen
				push bx
				push dx
				call checkCollision
				pop ax
				
				cmp ax,0		;function returns bool value
				jz skipterminatecheck2

				mov word[collided],1
				mov word[collidedMsgPrintedOnce],0

				skipterminatecheck2:
				
		call checkScore
		
		
		
		
		cmp word[ticks],43
		jb terminateTimerInt
		
		mov ax,[ticks]
		and ax,1
		cmp ax,1
		jnz terminateTimerInt
		call EnemyCars
		jmp terminateTimerInt
		
		PausedScreen:
			cmp word[pausedPrintedOnce],1
			jz terminateTimerInt
			
			mov word[pausedPrintedOnce],1
			call printPauseScreen
			jmp terminateTimerInt
		
		RenderMenuInt:
			cmp word[MenuPrintedOnce],1
			jz terminateTimerInt
			
			mov word[MenuPrintedOnce],1
			call RenderMenu
			jmp terminateTimerInt
			
		collidedMsgInt:
			cmp word[collidedMsgPrintedOnce],1
			jz terminateTimerInt
			
			mov word[collidedMsgPrintedOnce],1
			call PrintCollidedMsg
		
		terminateTimerInt:
		
	popa
	jmp far [cs:oldisr2]

MenuPrintedOnce : dw 0


carPrintKaro: 
		pusha
		
		sub sp,4
		mov ax,[prevLane]
		push ax
		call getCarRowCol
		pop bx
		pop dx
		
				sub dx,1
				push dx		;A->x
				push bx		;A->y
				add dx,12	;B-> x					     ;+8
				push dx
				add bx,7	;B->y					     ;+6
				push bx
				call printGreyBlock
				
		
		
		sub sp,4
		mov ax,[carLane]
		push ax
		call getCarRowCol
		pop bx
		pop dx
		
		mov al,01000000b
		push ax
		push bx
		push dx
		call printCar
		
		popa
		ret

weHitTheClock: dw 0

ClockEncounterd:
			pusha
				
				mov word[weHitTheClock],1
				
				sub sp,4
				mov ax,[carLane]
				push ax
				call getCarRowCol
				pop ax
				pop bx
				
				
				sub ax,12
				
				push bx		;A->x
				push ax		;A->y
				add bx,6	;B-> x					     ;+8
				push bx
				add ax,11	;B->y					     ;+6
				push ax
				call printGreyBlock
		
			add word[score],150
			add word[clock],15
			
			popa
			ret
			

BonusEncountered:
			pusha
			add word[score],50
		
			sub sp,4
				mov ax,[carLane]
				push ax
				call getCarRowCol
				pop ax
				pop bx
				
				
				sub ax,12
				
				
				push bx		;A->x
				push ax		;A->y
				add bx,7	;B-> x	;+8
				push bx
				add ax,11	;B->y					     ;+6
				push ax
				call printGreyBlock
			
			popa			
				
				ret
				
crashScreen:
		push es
		push ax
		push bx
		push cx
		push dx
		push di

		mov ax, 0xb800
		mov es, ax	
		mov di, 0  
		mov cx, 8

printalllines:	
		push di
		push cx

		mov cx, 43          

	theLine:
		mov bx, 1 ; width

	line1:
		mov ah, 0x44     
		mov al, 0xDB
		stosw
		dec bx
		jnz line1

		add di, 264        
		loop theLine


	pop cx
	pop di
	add di, 26
	loop printalllines

	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	ret

PrintCollidedMsg:
	pusha
	
	;call crashScreen
	
	mov ax,57	;A-> x  (2-120-20-130 makes the screen rain) ;+12 ;do we neeed rain ????
	push ax
	mov ax,	13 ;A->y					     ;+10
	push ax
	mov ax,75	;B-> x					     ;+8
	push ax
	mov ax,24	;B->y					     ;+6
	push ax
	mov al, 01010000b ;attribute					     ;+4
	push ax
	call printScoreBlock
	call printCollidedScreen
	
	popa
	ret	


CollidedText: db '   Too Bad!0'
CollidedTextLen : dw 0
CollidedText1: db ' [M] for Menu0'
CollidedTextLen1 : dw 0
;names of functions are reversed, dont explode!
printCollidedScreen:
	pusha
	
	sub sp,2
	mov ax,16
	push ax
	mov ax,59
	push ax
	call offsetCalculator
	pop di

	
	mov ax,0xb800
	mov es,ax
	
	
	push CollidedTextLen
	push CollidedText
	call strlen
	
	mov cx,[CollidedTextLen]
	push cs
	pop ds
	mov si,CollidedText
	mov ah,0x07
	CollidedLoop:
		lodsb 
		mov [es:di],ax
		add di,2
		loop CollidedLoop

	sub sp,2
	mov ax,18
	push ax
	mov ax,59
	push ax
	call offsetCalculator
	pop di
	

	push CollidedTextLen1
	push CollidedText1
	call strlen
	
	mov cx,[CollidedTextLen1]
	push cs
	pop ds
	mov si,CollidedText1
	mov ah,0x07
	CollidedLoop1:
		lodsb 
		mov [es:di],ax
		add di,2
		loop CollidedLoop1
	
	sub sp,2
	mov ax,20
	push ax
	mov ax,59
	push ax
	call offsetCalculator
	pop di
	
	add di, 4 
	push di
	mov al,0x0f
	push ax
	
	mov ax,7
	push ax
	push scoreprint
	call printstr
	
	sub sp,2
	mov ax,20
	push ax
	mov ax,66
	push ax
	call offsetCalculator
	pop di
	
	add di, 4
	push di
	call printScoreAfterCollision
	
	sub sp,2
	mov ax,2
	push ax
	mov ax,22
	push ax
	call offsetCalculator
	pop di
	
	;to remove a random black dot appearing at this specific location
	mov ax,0xb800
	mov es,ax

	mov ax,0x2700
	mov [es:di],ax
	
		
	mov word[collided],1
	
	popa
	ret

scoreprintLen : dw 0	

printPauseScreen:
	pusha
	
	mov ax,36	;A-> x  (2-120-20-130 makes the screen rain) ;+12
	push ax
	mov ax,	13 ;A->y					     ;+10
	push ax
	mov ax,96	;B-> x					     ;+8
	push ax
	mov ax,30	;B->y					     ;+6
	push ax
	mov al, 01010000b ;attribute					     ;+4
	push ax
	call printScoreBlock
	
	call printPauseText
	
	
	
	popa
	ret

printPauseText:
	pusha
	sub sp,2
	mov ax,20
	push ax
	mov ax,40
	push ax
	call offsetCalculator
	pop di
	
	
	
	mov ax,0xb800
	mov es,ax
	
	mov cx,47
	push cs
	pop ds
	mov si,PausedScreenText1
	mov ah,0x07
	PausedLoop:
		lodsb 
		mov [es:di],ax
		add di,2
		loop PausedLoop

	sub sp,2
	mov ax,22
	push ax
	mov ax,40
	push ax
	call offsetCalculator
	pop di
		
	push di
	mov al,0x0f
	push ax
	mov ax,7
	push ax
	push scoreprint
	call printstr
	
	sub sp,2
	mov ax,22
	push ax
	mov ax,50
	push ax
	call offsetCalculator
	pop di
	
	push di
	call printScoreAfterCollision	
	
	
	sub sp,2
	mov ax,2
	push ax
	mov ax,45
	push ax
	call offsetCalculator
	pop di
	
	;to remove a random black dot appearing at this specific location
	mov ax,0xb800
	mov es,ax

	mov ax,0x7000
	mov [es:di],ax
	
		
	
		
	mov word[paused],1

	popa
	ret

strlen:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push si
    push di
    push es

    mov di,[bp+4]       
    mov ax,ds
    mov es,ax
    mov al,'0'
    mov cx,0FFFFh
    cld
    repne scasb
    mov ax,0FFFFh
    sub ax,cx
    dec ax              
    mov bx,[bp+6]       
    mov [bx],ax

    pop es
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4

strlen2:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push si
    push di
    push es

    mov di,[bp+4]       
    mov ax,ds
    mov es,ax
    mov al,0

    mov cx,0FFFFh
    cld
    repne scasb
    mov ax,0FFFFh
    sub ax,cx
    dec ax              
    mov bx,[bp+6]       
    mov [bx],ax

    pop es
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4


printstr:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push si
    push di
    push es

    mov ax,0b800h
    mov es,ax

	mov di,[bp+10]	

    mov si,[bp+4]       ;source 
    mov cx,[bp+6]       ;strlen
    mov ah,[bp+8]       ;attribute
    cld
nextchar:
    lodsb
    stosw
    loop nextchar

    pop es
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8


RenderMenu: 
		pusha
		
		mov ax,0xb800
		mov es,ax
		
		push cs
		pop ds
		
		call clrscr;
		
		

			;Printing GreenBackground for Menu:
			mov cx,  11352; number of screen locations

			mov ax, 0xb800
			mov es, ax ; ds = 0xb800
			mov ah, 0x27
			mov al, 0	
			mov di, 0
			cld ; set auto increment mode
			rep stosw ; save screen
		
		mov ax, 1342 ; row 5, column 11
		push ax
		call drawtree
		mov ax, 9262 ; row 35, column 11
		push ax
		call drawtree
		mov ax, 5302 ; row 20, column 11
		push ax
		call drawtree
		mov ax, 3476 ; row 13, column 22
		push ax
		call drawtree
		mov ax, 7172 ; row 27, column 22
		push ax
		call drawtree
		mov ax, 1540 ; row 5, column 110
		push ax
		call drawtree
		mov ax, 9460 ; row 35, column 110
		push ax
		call drawtree
		mov ax, 5500 ; row 20, column 110
		push ax
		call drawtree
		mov ax, 3674 ; row 13, column 121
		push ax
		call drawtree
		mov ax, 7370 ; row 27, column 121
		push ax
		call drawtree
		
		
		
		
		push OurRollNumbersLen
		push OurRollNumbers
		call strlen2
		
		sub sp,2
		mov ax,42
		push ax
		mov ax,112
		push ax
		call offsetCalculator
		pop di
	
		push di
		mov al,00101111b
		push ax
		push word[OurRollNumbersLen]
		push OurRollNumbers
		call printstr
		
		sub sp,2
		mov ax,41
		push ax
		mov ax,112
		push ax
		call offsetCalculator
		pop di
	
		push di
		mov al,00101111b
		push ax
		mov ax,13
		push ax
		push semester
		call printstr
	
		;printing TitleName
		mov dx,6
		xor bx,bx
		
		mov cx,8
		PrintTitle:
		push cx
		
		sub sp,2
		mov ax,dx
		push ax
		mov ax,47
		push ax
		call offsetCalculator
		pop di
		
		
		push TitleNamelen
		push TitleName
		call strlen
		
		push di
		mov al,00101111b
		push ax
		push word[TitleNamelen]
		mov ax,TitleName
		add ax,bx
		push ax
		call printstr
		
		pop cx
		inc dx
			
		add bx,[TitleNamelen]
		add bx,1
		loop PrintTitle
		
		
		mov dx,20
		xor bx,bx
		
		mov cx,4
		PrintStartTitle:
		push cx
		
		sub sp,2
		mov ax,dx
		push ax
		mov ax,55   ;start of "START" title (column number)
		push ax
		call offsetCalculator
		pop di
		
		
		push StartTItleLen
		push StartTitle
		call strlen
		
		push di
		mov al,00101111b
		push ax
		push word[StartTItleLen]
		mov ax,StartTitle
		add ax,bx
		push ax
		call printstr
		
		pop cx
		inc dx
			
		add bx,[StartTItleLen]
		add bx,1
		loop PrintStartTitle
		
		
		mov dx,27
		xor bx,bx
		
		mov cx,4
		PrintExitTitle:
		push cx
		
		sub sp,2
		mov ax,dx
		push ax
		mov ax,58 ;start of exit title (column number)
		push ax
		call offsetCalculator
		pop di
		
		
		push ExitTitleLen
		push ExitTitle
		call strlen
		
		push di
		mov al,00101111b
		push ax
		push word[ExitTitleLen]
		mov ax,ExitTitle
		add ax,bx
		push ax
		call printstr
		
		pop cx
		inc dx
			
		add bx,[ExitTitleLen]
		add bx,1
		loop PrintExitTitle
		
		sub sp,2
		mov ax,33
		push ax
		mov ax,58
		push ax
		call offsetCalculator
		pop di
	
		push di
		mov al,00100111b
		push ax
		mov ax,17
		push ax
		push inst1
		call printstr
		
		sub sp,2
		mov ax,34
		push ax
		mov ax,58
		push ax
		call offsetCalculator
		pop di
	
		push di
		mov al,00100111b
		push ax
		mov ax,17
		push ax
		push inst2
		call printstr
		
		sub sp,2
		mov ax,35
		push ax
		mov ax,58
		push ax
		call offsetCalculator
		pop di
	
		push di
		mov al,00100111b
		push ax
		mov ax,13
		push ax
		push inst3
		call printstr
		
		popa
		ret

inst1 : db '[a] to move left '
inst2 :	db '[d] to move right'
inst3 :	db '[esc] to exit'	
semester : db 'Semester-2025'						

RenderGame:

	pusha
	;rendering whole screen
	call clrscr 
	call printgreen
	call printroad
	call printwhite
	call printyellow
	call printtrees
	call RenderScoreBlock
	call carPrintKaro
	
	popa
	ret
	
start:

;--------------------Hooking----------------------------------
;--------------kbisr------------------------------------
;hooking the kbisr for game:
	push ax
	push es

	
	cli
	xor ax,ax
	mov es,ax


	;back up of old hook saved
	mov ax,[es:9*4]
	mov [oldisr],ax
	mov ax,[es:9*4+2]
	mov [oldisr+2],ax

	;hooking here:
	mov ax,cs
	mov [es:9*4+2],ax
	mov ax,ourVeryOwnKbisr
	mov [es:9*4],ax
	sti

	pop es
	pop ax
	

;---------------------timerInterrupt-------------------------
	push ax
	push es

	
	cli
	xor ax,ax
	mov es,ax


	;back up of old hook saved
	mov ax,[es:8*4]
	mov [oldisr2],ax
	mov ax,[es:8*4+2]
	mov [oldisr2+2],ax

	;hooking here:
	mov ax,cs
	mov [es:8*4+2],ax
	mov ax,MoveScreen
	mov [es:8*4],ax
	sti

	pop es
	pop ax



	; change screen resolution to 43x132 Mode
	mov ah,0x00
	mov al, 0x54
	int 0x10
	
	
	Game:
	
		cmp word[paused],1
		jnz check1
		
		mov ah,0x00
		int 0x16
		
		cmp al,'y'
		jz offtoMenu
		
		cmp al,'n'
		jnz check1
		
		;turn pause off
		call restoreScreen
		mov word[paused],0
		jmp check1
		
		offtoMenu:
		mov word[MenuPrintedOnce],0
		mov word[menu],1
		mov word[paused],0
		call reset
	
		check1:
		cmp word[collided],1
		jnz check2
		
	
		check2:
		cmp word[skipheart],1
		jnz check3
		
		call BonusEncountered
		mov word[skipheart],0
		
		check3:
		cmp word[skipclock],1
		jnz check4
		
		
		call ClockEncounterd
		mov word[skipclock],0
		
		check4:
		cmp word[timeToPrintCar],1
		jnz check5
		
		call carPrintKaro
		mov word[timeToPrintCar],0
	
		check5:
		cmp word[gameEnd],1
		jz terminateGame
		
		jmp Game
	
	
	

terminateGame:
;unhooking kbisr------------------------------------
	xor ax,ax
	mov es,ax
	mov ax,[oldisr]
	mov [es:9*4],ax
	mov ax,[oldisr+2]
	mov [es:9*4+2],ax
	
;unhooking timerInterrupt-------------------------	
	mov ax,[oldisr2]
	mov [es:8*4],ax
	mov ax,[oldisr2+2]
	mov [es:8*4+2],ax
	
	

mov ax, 0x4c00 
int 0x21