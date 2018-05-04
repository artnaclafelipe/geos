.sect .text
use16

REALMODE_SEGMENT 		equ 	0x00
REALMODE_STACK_TOP 		equ 	0xFFFF
REALMODE_STACK_SEGMENT	equ 	0x8F00

REALMODE_STAGEZERO_SEGMENT equ 0x07C0
REALMODE_STAGEONE_SEGMENT equ 0x0050

BOOT_SIGNATURE_OFFSET 	equ		0x1FE
BOOT_SIGNATURE_MAGIC	equ 	0xAA55

entry start

start:
	cli
	jmpi #begin,#REALMODE_STAGEZERO_SEGMENT
begin:	
	
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ax,#REALMODE_STACK_SEGMENT
	mov ss,ax
	mov sp,#REALMODE_STACK_TOP
	mov bp,#REALMODE_STACK_TOP

	sti

	!reseting disquete controller
	xor ax,ax
	xor dx,dx
	int #0x13
	!if fails, then go to print fail msg
	jc print_msg_fail

	!read stage_one from disk
	mov ah,#0x02 !bios disk function - read sector
	mov al,#17 !bios disk function parameter - count sectors to read
	xor dl,dl !ero value on %dl means that the disk driver is a diskette
	mov dh,#0 !start head of sector
	mov cl,#2 !sector from which wanna start read
	mov ch,#0 !start cylinder of start head of start sector
	push es
	push #0
	pop es
	mov bx,#0x500 !region on memory to put data copied from disk
	int #0x13
	pop es
	!if fails with read sector, go to display msg fail
	jc print_msg_fail

	jmpi #0,#REALMODE_STAGEONE_SEGMENT

print_msg_fail:
	jmp	print_msg_fail_over_data
	msg_fail: .asciz "\rOperacao com carga do sistema a partir do disco falhou...TERMINANDO!"

print_msg_fail_over_data:
	mov  si,#msg_fail
	push si
	mov cx,#0
print_msg_fail_defining_msg_length:
	lodsb
	cmp al,#0
	jz print_msg_fail_defining_msg_length_finish
	inc cx
	jmp print_msg_fail_defining_msg_length	
print_msg_fail_defining_msg_length_finish:	
	pop si	
print_msg_fail_printing:
	push cx
	mov ah,#0x0E
	lodsb
	mov bh,#0
	mov bl,#15
	mov cx,#1
	int #0x10
	pop cx
	loop print_msg_fail_printing

finish:
	cli
	hlt	

signature: 
		   .org  	BOOT_SIGNATURE_OFFSET
		   dw		BOOT_SIGNATURE_MAGIC
