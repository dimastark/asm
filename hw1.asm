.model tiny
.code

org 2ch
	env_seg label word

org 100h

start:
	variables:
		jmp begin
		new_name db 20h,0,0,1,0,'= 256 + 32',0
		len			 dw	$-new_name

	begin:
		; free allocate memory
		mov es, env_seg
		mov ah, 49h
		int 21h

		; allocate new memory
		mov ah, 48h
		mov bx, 1h
		int 21h
		mov env_seg, ax

		; write name sequence [ds:si] -> [es:di]
		lea si, new_name
		mov es, env_seg
		xor di, di
		mov cx, len
		rep movsb

		; terminate and stay resident
		lea dx, start
		int 27h

end start
