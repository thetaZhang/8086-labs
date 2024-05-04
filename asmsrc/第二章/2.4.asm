; 功能：读取开关量状态，取反后输出（修改了端口地址
PortIn	EQU	90h	;定义输入端口号，改为任意修改后的地址，如90h
PortOut	EQU	0A0h	;定义输出端口号，改为任意修改后的地址，如A0h

        

Again:
		IN  AL,PortIn		;读取开关量状态
		NOT AL				;取反
		OUT PortOut,AL		;送显示
		JMP Again			;跳转循环执行

		END					;指示汇编程序结束编译