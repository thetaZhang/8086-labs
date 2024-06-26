MOV AX,4000H                 ;指定数据段的段基址
MOV DS,AX                    ;段基址只能通过寄存器来赋值
MOV BX,01H                   ;操作奇地址，偏移地址从01H开始
MOV AL,01H                   ;AL中存放的是要写入内存的数据，存入奇数，从01H开始
	
Write1:     
	MOV BYTE PTR [BX],  AL		;将AL中的数据以字节为单位送到DS:BX所指字节单元
	ADD AL,2                    ;AL中的数据每次加2，形成1，3，5，7...
	ADD BX,2                    ;BX中的数据每次加2，操作下一个奇地址
	JNC Write1                  ;判断是否有进位，无则继续循环，有则跳出循环
                                ;由于BX最大为64K，与内存总的单元数相同，
                                ;当其不断增大到出现进位时，恰说明所有的内存单元
                                ;都已经操作完毕，可以退出循环

WT:                             ;等待过程，操作完成后循环等待
	JMP WT
