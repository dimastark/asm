.model tiny
.code
org 100h

start:
  ; - читаем из видео -
  mov al, 40h
  mov ds, ax
  mov bl, [ds:49h] ; текущий режим
  mov ax, [ds:4eh] ; адрес страницы
  ; - читаем из видео -

  ; - инициализируем -
  mov bp, 86
  cmp bl, 7
  je v7
  add ax, 0b800h
  cmp bl, 2
  jge go
  mov bp, 6
  jmp go
  v7:
  add ax, 0b000h
  go:
  ; - инициализируем -

  ; - чистим -
  mov es, ax
  mov ah, 02h    ; color
  mov cx, 25*80
  rep stosw
  ; - чистим -

  ; - границы -
  mov di, bp
  shr di, 1
  inc di
  mov bx, 0c9cdh
  mov dx, 0d1bbh
  call border

  push di ; save for indexes

  mov bx, 0ba20h
  mov dx, 0b3bah
  call border

  mov bx, 0c7c4h
  mov dx, 0c5b6h
  call border

  push di ; save for ascii

  mov cl, 16
  mov bx, 0ba20h
  mov dx, 0b3bah
  other_borders:
  call border
  loop other_borders

  mov bx, 0c8cdh
  mov dx, 0cfbch
  call border
  ; - границы -

  pop di
  mov dl, 48
  scasw ; di + 2
  add bp, 4
  ; - таблица -
  mov al, 0
  mov cl, 16
  outer:
  push cx
  mov cl, 16
  xchg al, dl
  stosw
  xchg al, dl
  inc dx
  scasw
  scasw
  cmp dl, 58
  jne inner
  add dl, 7
  inner:
  stosw
  inc ax
  scasw  ; di + 2
  loop inner
  add di, bp
  pop cx
  loop outer
  ; - таблица -

  pop di
  add di, 8
  mov cl, 16
  mov al, 48
  indexes:
  stosw
  inc al
  scasw
  cmp al, 58
  jne loooop
  add al, 7
  loooop:
  loop indexes

  xor ax, ax
  int 16h

  ; - чистим -
  xor di, di
  mov ax, 0200h
  mov cx, 25*80
  rep stosw
  ; - чистим -

  ret

  border proc
    push cx
    mov al, bh
    stosw
    mov al, bl
    stosw
    mov al, dh
    stosw
    mov al, bl
    mov cl, 33
    rep stosw
    mov al, dl
    stosw
    add di, bp
    pop cx
    ret
  endp border
end start

