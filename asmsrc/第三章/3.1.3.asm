;功能：接收开关量输入，将高4位以二进制形式显示在LED，低4位显示在第一位数码管

;------------------------------------------
; 符号定义                                 |
;------------------------------------------

;8255芯片端口地址

PortA	EQU		90H			; Port A 地址，高4位输出LED，低4位输出数码管位选
PortB	EQU 	92H			; Port B 地址，数码管段码
PortC	EQU 	94H			; Port C 地址，开关量输入
CtrlPT	EQU 	96H			; 控制寄存器地址

;------------------------------------------
;定义数据段                                |
;------------------------------------------

.data                           ; 数据段开始
DelayShort	dw	4000			; 短延时参量	
DelayLong	dw	40000			; 长延时参量

;数码管段码
SEGTAB   DB 3FH	; 0     
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


;------------------------------------------
;定义代码段                                |
;------------------------------------------
.code
.startup                     ; 定义汇编程序执行入口点

MOV AL, 10001001B            ; 8255初始化，10001001B，表示方式0，A口输出，B口输出，C口输入
OUT CtrlPT, AL	             ; 控制字输出到控制寄存器

SWIN:                        ;接收开关量输入
		IN AL, PortC         ;C口数据即为开关量，读取C口数据到AL
		MOV BL,AL            ;BL用来保存开关量
		
		JMP LEDOUT           ;跳转到输出过程

LEDOUT:                      ;输出过程
		AND AL,0F0H          ;取高4位
		ADD AL,0EH           ;低4位变成1110，位选第一位数码管
		OUT PortA,AL         ;输出到A口,位选第一位数码管，高四位通过LED显示
		
		AND BL,0FH           ;取低4位
		MOV AL,[SEGTAB][BX]  ;根据低4位数值取对应的段码
		OUT POrtB,AL         ;数码管段码输出到B口
		
		JMP SWIN             ;跳转到接收开关量输入，循环执行


END