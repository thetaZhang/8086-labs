PortIn	EQU	80h	;定义输入端口号
PortOut	EQU	88h	;定义输出端口号

;-------------------------------------------------
;主程序部分                                      
;-------------------------------------------------
start: ;初始状态
	MOV AL, 36H ;36H对应东西南北均为红灯  
	OUT PortOut, AL ;输出当前状态
	CALL delay2 ;延时等待
	JMP state1 ;跳转状态1
	 
state1: ;状态1
	MOV AL, 33H ;33H对应南北绿灯东西红灯
	OUT PortOut,AL ;输出当前状态
	CALL delay2 ;延时等待
	JMP state2 ;跳转状态2

state2: ;状态2 
	MOV CX,0003H ;循环次数为3,亮与不亮交替循环形成闪烁3次
	
    state2loop: ;闪烁循环过程
	    MOV  AL, 37H ;37H对应南北不亮东西红灯
	    OUT PortOut,AL ;输出当前状态
	    CALL delay1 ;闪烁延时等待
	 
	    MOV AL, 33H ;33H对应南北绿灯东西红灯
	    OUT PortOut,AL ;输出当前状态
	    CALL delay1 ;闪烁延时等待
	    
        LOOP state2loop 
	    
	MOV  AL, 35H ;35H对应南北黄灯东西红灯
	OUT PortOut,AL ;输出当前状态,闪烁后转黄灯
	CALL delay2 ;延时等待
	 
	JMP state3 ;跳转状态3

state3: ;状态3
	MOV AL, 1EH ;1EH对应南北红灯东西绿灯
	OUT PortOut, AL ;输出当前状态
	CALL delay2 ;延时等待
	JMP state4 ;跳转状态4

state4: ;状态4
	MOV CX,0003H ;循环次数为3,亮与不亮交替循环形成闪烁3次
	
    state4loop:;闪烁循环过程
	    MOV  AL, 3EH ;3EH对应南北红灯东西不亮
	    OUT PortOut,AL;输出当前状态
	    CALL delay1;闪烁延时等待
	 
	    MOV AL, 1EH ;1EH对应南北红灯东西绿灯
	    OUT PortOut,AL;输出当前状态
	    CALL delay1;闪烁延时等待
	    
	    LOOP state4loop

	MOV  AL, 2EH ;2EH对应南北红灯东西黄灯
	OUT PortOut,AL;输出当前状态
	CALL delay2;延时等待
   
	JMP state1 ;跳转状态1，程序循环执行

;-------------------------------------------------
;延时子程序部分
;-------------------------------------------------
;延时过程
delay1 PROC ;短时间延时
    PUSH CX ;保护CX寄存器
   ;循环嵌套实现延时
    MOV CX,00AFH;外层循环次数
   
    delayfirst: ;外层循环过程
        MOV AX,0001H
        aloop: ;内层循环过程
	        INC AX ;AX自增
	        CMP AX,003FH ;判断AX是否达到内层循环次数
	        JB aloop ;如果未达到则继续循环,达到时跳出循环
      
        LOOP delayfirst

   POP CX;恢复CX寄存器
RET
delay1 ENDP
   
   
delay2 PROC ;长时间延时
   CALL delay1 ;调用短时间延时子程序3次实现
   CALL delay1
   CALL delay1
   RET
delay2 ENDP
	 
	 
