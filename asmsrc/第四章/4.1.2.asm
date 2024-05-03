;显示学号

;--------------------------------
;符号定义                         |
;--------------------------------

; 8255芯片端口地址 
L8255PA			EQU		121h		  ;8255端口A地址，输出
L8255PB			EQU 	123h          ;8255端口B地址，输出			
L8255PC			EQU 	125h          ;8255端口C地址，低4位输入，高4位输出	
L8255CS			EQU 	127h          ;8255控制寄存器址	

;------------------------------------------
;定义数据段                                |
;------------------------------------------

.data                           ; 数据段开始
DelayShort	dw	4000			; 短延时参量

;数码管段码
SEGTAB  DB 3FH	; 0     
		DB 06H	; 1       7-Segment Tube, 共阴极类型的7段数码管示意图
		DB 5BH	; 2        a a a
		DB 4FH	; 3      f         b
		DB 66H	; 4      f         b
		DB 6DH	; 5      f         b
		DB 7DH	; 6         g g g 
		DB 07H	; 7      e         c
		DB 7FH	; 8      e         c
		DB 6FH	; 9      e         c
		DB 77H	; A         d d d     h h h
		DB 7CH	; B   ------------------------------
		DB 39H	; C    b7 b6 b5 b4 b3 b2 b1 b0
		DB 5EH	; D   h    g   f    e   d   c   b   a
		DB 79H	; E
		DB 71H	; F


;--------------------------------
;定义代码段                     |
;--------------------------------
		.code						; Code segment definition
		.startup					; 定义汇编程序执行入口点

START:				
	CALL INIT8255				    ; 初始化8255 

Display_Again:
		CALL DISPLAY8255			; 驱动四位七段数码管显示
		JMP  Display_Again			; 循环显示

		HLT							; 停止主程序运行

;--------------------------------
;8255初始化                     |
;--------------------------------

INIT8255 PROC
    MOV DX, L8255CS                   ;8255控制寄存器地址
	MOV AL, 10000001B                 ;控制字，对应方式0，端口A输出，端口B输出，端口C低4位输入，高4位输出	
	OUT DX, AL                        ;写入控制字
	RET
INIT8255 ENDP


;--------------------------------
;数码管显示过程                  |
;--------------------------------
DISPLAY8255 PROC
		
;	点亮第一个数码管
		MOV DX, L8255PA		; 指向PA
		MOV AL, 0FEh		; 位选第一个数码管
		OUT DX, AL			; 输出到PA
		MOV AL, SEGTAB+0	; 获取0的段码
		MOV DX, L8255PB		; 指向PB
		OUT DX, AL			; 输出段码，点亮数码管
		CALL DELAY			; 延时

;	点亮第二个数码管
		MOV DX, L8255PA		; 指向PA
		MOV AL, 0FDh		; 位选第二个数码管
		OUT DX, AL			; 输出到PA
		MOV AL, SEGTAB+1	; 获取1的段码
		MOV DX, L8255PB		; 指向PB
		OUT DX, AL			; 输出段码，点亮数码管
		CALL DELAY			; 延时

;	点亮第三个数码管
		MOV DX, L8255PA		; 指向PA
		MOV AL, 0FBh		; 位选第三个数码管
		OUT DX, AL			; 输出到PA
		MOV AL, SEGTAB+2	; 获取2的段码
		MOV DX, L8255PB		; 指向PB
		OUT DX, AL			; 输出段码，点亮数码管
		CALL DELAY			; 延时

;	点亮第四个数码管
		MOV DX, L8255PA		; 指向PA
		MOV AL, 0F7h		; 位选第四个数码管
		OUT DX, AL			; 输出到PA
		MOV AL, SEGTAB+9	; 获取9的段码
		MOV DX, L8255PB		; 指向PB
		OUT DX, AL			; 输出段码，点亮数码管
		CALL DELAY			; 延时

		RET
DISPLAY8255 ENDP

;--------------------------------
;延时程序                       |
;--------------------------------
DELAY 	PROC
    	PUSH CX
    	MOV CX, DelayShort
D1: 	LOOP D1
    	POP CX
    	RET
DELAY 	ENDP