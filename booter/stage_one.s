.sect .text
use16

.globl _getCursorPosition
.globl _setCursorPosition
.globl _prints
.globl _putc
.globl _teste_readsector

REALMODE_STACK_TOP 		equ 	0xFFFF
REALMODE_STACK_SEGMENT	equ 	0x8F00
REALMODE_STAGEONE_SEGMENT equ 0x0050

entry start

.globl start

start:
	cli
	jmpi #begin,#REALMODE_STAGEONE_SEGMENT
	msg: .asciz "\rola"
	row: dw 0
	column: dw 0
begin:	
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ax,#REALMODE_STACK_SEGMENT
	mov ss,ax
	mov sp,#REALMODE_STACK_TOP
	mov bp,#REALMODE_STACK_TOP

	sti


	call _teste_readsector

	!cmp ax,#18
	!jz print
	
print:
	push #msg
	call _prints
	add sp,#2

	jmp finish

reboot: 
	int #0x19 	

finish:
 cli
 hlt
