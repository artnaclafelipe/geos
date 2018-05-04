.sect .text

!typedef enum {ds=0,es=1,cs=2}segment_t;
DS_SEGMENT equ 0x00
ES_SEGMENT equ 0x01
CS_SEGMENT equ 0x02

!extern int disk_reset(unsigned char drive);
.globl _disk_reset
_disk_reset:
	push bp
	mov bp,sp
		mov dl,[bp+4]
		xor ax,ax
		int #0x13
		jc _disk_reset_error
		jmp _disk_reset_success		
_disk_reset_error:
		mov dl,[bp+4]
		xor dh,dh
		push dx
		call _disk_statusof_lastoperation_drive
		jmp _disk_reset_finish
_disk_reset_success:
		mov ax,#0		
_disk_reset_finish:		
	mov sp,bp
	pop bp
ret

!extern int disk_statusof_lastoperation_drive(unsigned char drive);
.globl _disk_statusof_lastoperation_drive
_disk_statusof_lastoperation_drive:
	push bp
	mov bp,sp
		mov al,[bp+4]
		mov ah,#0x01
		int #0x13
		jc _disk_statusof_lastoperation_drive_error
		jmp _disk_statusof_lastoperation_drive_status
_disk_statusof_lastoperation_drive_error:
		mov ax,#0xFFFF
		jmp _disk_statusof_lastoperation_drive_finish
_disk_statusof_lastoperation_drive_status:
		xchg al,ah
		xor ah,ah
_disk_statusof_lastoperation_drive_finish:		
	mov sp,bp
	pop bp
ret

!extern int disk_readsector(segment_t segment,
!						   unsigned char *offset,unsigned char sectors_count,
!						   unsigned char drive,unsigned char cylinder,
!						   unsigned char head,unsigned char sector);
.globl _disk_readsector
_disk_readsector:
	push bp
	mov bp,sp
		push es
		mov ax,4[bp]
		cmp ax,#0x00
		jz _disk_readsector_select_ds
		cmp ax,#0x01
		jz _disk_readsector_select_es
		cmp ax,#0x02
		jz _disk_readsector_select_cs
		jmp _disk_readsector_select_es
_disk_readsector_select_ds:
		mov ax,ds
		mov es,ax
		jmp _disk_readsector_begin_reading
_disk_readsector_select_es:
		mov ax,es
		mov es,ax
		jmp _disk_readsector_begin_reading
_disk_readsector_select_cs:
		mov ax,cs
		mov es,ax
_disk_readsector_begin_reading:		
	!segment_t segment - 	 		4[bp]
	!unsigned char *offset - 		6[bp]
	!unsigned char sectors_count -	8[bp]
	!unsigned char drive -			10[bp]
	!unsigned char cylinder -		12[bp]
	!unsigned char head -			14[bp]
	!unsigned char sector -			16[bp]
		mov ah,#0x02
		mov bx,[bp+6]
		mov al,[bp+8]
		mov dl,[bp+10]
		mov ch,[bp+12]
		mov dh,[bp+14]
		mov cl,[bp+16]
		int #0x13
		jc _disk_readsector_error
		jmp _disk_readsector_success
_disk_readsector_error:
		xor dx,dx
		mov dl,[bp+10]
		call _disk_statusof_lastoperation_drive
		jmp _disk_readsector_finish
_disk_readsector_success:
		mov ax,#0
_disk_readsector_finish:
		pop es
	mov sp,bp
	pop bp
ret
