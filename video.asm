.model tiny
.code
org 100h

; 80x25
; 23 + 2 + 16 + 15 + 2 + 22
start:
    xor bh, bh   ; bh <- 0 номер видеостраницы
    mov dh, 0     ; строка текущей позиции курсока
    mov dl, 0  ; колонка текущей позиции курсока
    mov bl, 00111100b ;атрибут - ярко-красный мигающий
    mov cx, 80  ; повторить 80 раз
    mov al, 0h
    jmp background

install_cursor proc
    mov ah, 02h ; устанавливаем позицию курсор
    int 10h     ; установили позицию курсора (15:15)
    mov ah, 09h
    int 10h ;прочитаем символ из текущей позиции видеопамяти:
    mov ah,08h
    int 10h ; выясним текущую позицию курсора
    xor bh, bh
    mov ah, 09h
    int 10h ;установили позицию курсора (10.10)
    mov ah, 09h
    int 10h
    ret
endp install_cursor

background:
    call install_cursor
    inc dh
    cmp dh, 4
    je left_side
    cmp dh, 25
    jne background
    ret

left_side:
    mov cx, 23
    call install_cursor
    add dl, 23
    cmp dh, 4h
    je top_tabel
    cmp dh, 21
    je bottom_tabel
    jmp left_frame

install_al:
    mov ah, 16
    mov al, dh
    sub al, 5
    mul ah
    jmp print_tabel

print_tabel:
    inc dl
    call install_cursor
    inc al
    push ax
    inc dl
    mov al, 0
    call install_cursor
    pop ax
    cmp dl, 56
    je right_frame

    jmp print_tabel

right_frame:
    mov al, 0
    call install_cursor
    mov al, 186
    inc dl
    call install_cursor
    jmp right_side

left_frame:
    mov cx, 1
    mov al, 186
    call install_cursor
    mov al, 0h
    inc dl
    call install_cursor
    jmp install_al

right_side:
    inc dl
    mov al, 0
    mov cx, 22
    call install_cursor
    add dl, 22
    inc dh
    mov dl, 0
    cmp dh, 22
    jne left_side
    mov cx, 80
    jmp background

bottom_tabel:
    mov cx, 1
    mov al, 200
    call install_cursor
    inc dl
    call top_band
    mov al, 188
    call install_cursor
    jmp right_side

top_tabel:
    mov cx, 1
    mov al, 201
    call install_cursor
    inc dl
    call top_band
    mov al, 187
    call install_cursor
    jmp right_side

top_band proc
    mov cx, 33
    mov al, 205
    call install_cursor
    add dl, 33
    mov cx, 1
    ret
endp top_band

end start
