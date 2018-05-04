.sect .text

!extern void putc_withcolor(char c,unsigned char color);
.globl _putc_withcolor
_putc_withcolor:
	jmp _putc_withcolor_over_data
	_putc_withcolor_row: dw 0
	_putc_withcolor_column: dw 0
	new_line: db 10
	car_ret:  db 13
_putc_withcolor_over_data:	
	push bp
	mov bp,sp
		mov al,[bp+4]

		mov bx,#new_line
		cmp al,[bx]
		jz _putc_withcolor_increment_cursor_row_goto

		mov bx,#car_ret
		cmp al,[bx]
		jz _putc_withcolor_increment_cursor_car_ret_goto


		call _getCurrentVideoPage
		mov bx,ax
		xchg bh,bl

		mov bl,[bp+6]
		mov al,[bp+4]
		mov cx,#1
		mov ah,#0x09
		int #0x10

		call _putc_withcolor_increment_cursor_column
		jmp _putc_withcolor_finish

_putc_withcolor_increment_cursor_column:
		push #_putc_withcolor_column
		push #_putc_withcolor_row
		call _getCursorPosition		
		add sp,#4
		
		mov bx,#_putc_withcolor_column
		mov ax,[bx]
		inc ax
		push ax

		mov bx,#_putc_withcolor_row
		mov ax,[bx]
		push ax
		call _setCursorPosition		
		add sp,#4		
ret		
_putc_withcolor_increment_cursor_row:
		push #_putc_withcolor_column
		push #_putc_withcolor_row
		call _getCursorPosition
		add sp,#4
		
		mov bx,#_putc_withcolor_column
		mov ax,[bx]
		push ax

		mov bx,#_putc_withcolor_row
		mov ax,[bx]
		inc ax
		push ax

		call _setCursorPosition		
		add sp,#4		
ret
_putc_withcolor_increment_cursor_row_goto:
	call _putc_withcolor_increment_cursor_row
	jmp _putc_withcolor_finish
_putc_withcolor_increment_cursor_car_ret_goto:
		push #_putc_withcolor_column
		push #_putc_withcolor_row
		call _getCursorPosition
		add sp,#4

		mov ax,#0
		push ax		

		mov bx,#_putc_withcolor_row
		mov ax,[bx]
		push ax

		call _setCursorPosition		
		add sp,#4		
		
_putc_withcolor_finish:		
	mov sp,bp
	pop bp
ret	

!extern unsigned char getCurrentVideoPage();
.globl _getCurrentVideoPage
_getCurrentVideoPage:
	push bp
	mov bp,sp
		xor bx,bx
		mov ah,#0x0F
		int #0x10
		xor ax,ax
		mov ax,bx
		xchg al,ah
	mov sp,bp
	pop bp
ret

!extern void 		 setCurrentVideoPage(unsigned char page);
.globl _setCurrentVideoPage
_setCurrentVideoPage:
	push bp
	mov bp,sp
		mov ax,[bp+4]
		mov ah,#0x05
		int #0x10
	mov sp,bp
	pop bp
ret

!extern void 		 setCursorPosition(unsigned char row,unsigned char column);
.globl _setCursorPosition
_setCursorPosition:
	push bp
	mov bp,sp
		call _getCurrentVideoPage
		xor bx,bx
		mov bx,ax
		xchg bh,bl
		mov dh,[bp+4]
		mov dl,[bp+6]
		mov ah,#0x02
		int #0x10
	mov sp,bp
	pop bp
ret

.globl _getCursorPosition
_getCursorPosition:
	push bp
	mov bp,sp
		call _getCurrentVideoPage
		xor bx,bx
		mov bx,ax
		xchg bh,bl
		mov ah,#0x03
		int #0x10
		mov bx,[bp+4]
		mov [bx],dh !row		
		mov bx,[bp+6]
		mov [bx],dl !column
	mov sp,bp
	pop bp
ret

!extern unsigned char getCursorRow();
.globl _getCursorRow
_getCursorRow:
	jmp _getCursorRow_over_data
	_getCursorRow_row: dw 0
	_getCursorRow_column: dw 0
_getCursorRow_over_data:	
	push bp
	mov bp,sp
		push #_getCursorRow_column
		push #_getCursorRow_row
		call _getCursorPosition
		add sp,#4
		mov bx,#_getCursorRow_row
		mov ax,[bx]
	mov sp,bp
	pop bp
ret

!extern unsigned char getCursorColumn();
.globl _getCursorColumn
_getCursorColumn:
	jmp _getCursorColumn_over_data
	_getCursorColumn_row: dw 0
	_getCursorColumn_column: dw 0
_getCursorColumn_over_data:	
	push bp
	mov bp,sp
		push #_getCursorColumn_column
		push #_getCursorColumn_row
		call _getCursorPosition
		add sp,#4
		mov bx,#_getCursorColumn_column
		mov ax,[bx]
	mov sp,bp
	pop bp
ret
