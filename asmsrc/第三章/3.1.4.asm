;功能：接收开关量输入，将高4位以二进制形式显示在LED，并将高4位显示在第1，3位数码管，
;低4位显示在第2，4位数码管

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
        PUSH AX              ;AX入栈以保护输入开关量
		AND AL,0F0H          ;取开关量高四位
		ADD AL,0AH           ;低四位变为1010B，位选1，3位
		OUT PortA,AL         ;输出到PortA，位选1，3位，并高四位输出到LED
		
		
		AND BL,0FH           ;BL中仍位输入开挂量，取其低四位
		MOV AL,[SEGTAB][BX]  ;根据开关量低四位的值，取对应的段码
		OUT POrtB,AL         ;输出到PortB，显示在数码管上，此时数码管1，3显示开关低4位而2，4不显示
		
		CALL DELAY           ;短暂延时以免重叠显示
		
		POP AX               ;AX出栈，恢复开关量
		MOV BL,AL            ;BL保存开关量
		AND AL,0F0H          ;取开关量高四位，再输出到LED，以免重新位选时改变LED
		ADD AL,05H           ;低四位变为0101B，位选2，4位
		OUT PortA,AL         ;输出到PortA，位选2，4位，并高四位输出到LED
		
		MOV CL,4             ;CL用来保存4，以便右移，SHR右移位数不为1时不能用立即数
		SHR BL,CL            ;BL右移4位，低四位变为高四位，以便能正确寻址段码，远大于段码范围
		
		MOV AL,[SEGTAB][BX]  ;根据开关量高四位的值，取对应的段码
		OUT POrtB,AL         ;输出到PortB，显示在数码管上，此时数码管2，4显示开关高4位而1，3不显示
		
		CALL DELAY           ;短暂延时以免重叠显示，两种状态快速交替，在视觉暂留的影响下，出现同时显示的效果

		JMP SWIN            ;跳转到接收开关量输入过程，循环执行
				

;------------------------------------------
; 延时过程                                |
;------------------------------------------

DELAY 	PROC
    	PUSH CX              ; 保护CX寄存器
    	MOV CX,DelayShort    ; 设置短延时参量
D1: 	LOOP D1              ; 循环延时
    	POP CX               ; 恢复CX寄存器
    	RET
DELAY 	ENDP
END