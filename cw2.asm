.model tiny
.code

org 2ch
	env_seg label word

org 100h

start:

	variables:
		jmp begin

    handler	proc far
    	call dword ptr cs:[old_2fh]
    handler	endp

    old_2fh  dw	?, ?
		new_name db 20h,0,0,1,0,'2f handler',0
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

    ; get vector 2f
    mov	ax, 352fh
		int	21h
    mov	[old_2fh], bx
  	mov	[old_2fh + 2], es

    ; set handler
  	mov	ah, 25h
  	lea	dx, handler
  	int	21h

		; terminate and stay resident
		lea dx, start
		int 27h

end start


; /h - помощь
; /i - установка
; /u - удаление
; (проверяем, что мы сверху.
;  Да? восстанавливаем старый обработчик.
;  Нет? Говорим, что не можем)
; /s - статус
; /k - убить (Просто теряем всю цепочку)
; без всего - usage
; Резидент: (будет авторизация) (перехватываем 2f)
; Проверка:
; mov ax, auth_code
; int 2fh ; ax <- 'DS'
;         ; es <- seg; bx <- offset
; cmp ax, 'DS'

; следующая задача
; ручная запись рездента
; без 25h и 35h
; резидент не больше 100Б (48Б Hint: MCB)

; следующая задача
; считать прерывания, потом какая-нибудь фигня
