.model tiny

.code
    org 2ch
env dw ?
    org 100h
program:
    jmp start

    int_num = 2fh
    int_offset = int_num * 04h
    res_len = handler_end - handler
    sign_req = "PK"
    sign_ans = "KP"

;-----------��⠥� ��㬥���. ���������饥 ���ﭨ� � al------------;

read_args proc
    mov si, 81h ; ������ � ��ப�
    xor dx, dx  ; ⥪�饥 ���ﭨ�
read_args_loop:
    lodsb
    lea bx, t1
    xlat
    lea bx, t2
    add al, dh
    xlat
    cmp al, 09h
    jge end_of_args
    mov ah, 09h
    mul ah
    mov dh, al
    jmp read_args_loop
end_of_args:
    ret
read_args endp

;----------------------------------------------------------------------;

;----------------------------��� १�����-----------------------------;

handler:
    cmp ax, sign_req
    jne jmp_next
    cmp bx, 00h
    je no_delete
    mov cx, es
    mov dx, ds
    xor bx, bx
    mov es, bx
    mov di, int_offset
    mov ax, cs
    mov ds, ax
    mov si, next - handler
    movsw
    movsw

    dec ax
    mov es, ax
    mov di, 01h
    xor ax, ax
    stosw       ; ������ MCB ᢮�����
    mov es, cx
    mov ds, dx
no_delete:
    mov ax, sign_ans
    mov bx, cs
jmp_next:
    db 0eah
    next dw ?, ?
handler_end:

;----------------------------------------------------------------------;

;--------------�஢���� ����稥 १�����, �ᯥ� � cl-----------------;

check_res proc
    mov ax, sign_req
    mov bx, 00h
    int int_num
    cmp ax, sign_ans
    je check_yes
    mov ax, 00h
    ret
check_yes:
    mov ax, 01h
    ret
check_res endp

;----------------------------------------------------------------------;

;--------������� � 㪠������ � dx ���� ���� १����� �� bx---------;

write_addr proc
    mov ax, ds
    mov es, ax
    mov di, dx
    mov cl, 12
mov_loop:
    mov ax, bx
    shr ax, cl
    and ax, 0fh
    cmp ax, 0ah
    jl digit
    add ax, 07h
digit:
    add ax, 30h
    stosb

    sub cl, 04h
    jns mov_loop

    ret
write_addr endp

;----------------------------------------------------------------------;

;-------��⠭����� १�����. �ᯥ� � al, ���� ᥣ���� � bx----------;

install proc
    xor ax, ax
    mov ds, ax
    mov si, int_offset
    lea di, next
    movsw
    movsw
    mov ax, cs
    mov ds, ax

    mov ax, 4800h
    mov bx, res_len
    shr bx, 04h
    inc bx
    int 21h

    mov cx, res_len
    mov es, ax
    xor di, di
    lea si, handler
    rep movsb

    dec ax
    mov es, ax
    inc ax
    mov word ptr es:01h, ax ; ������塞 ���� PSP � MCB �� ᥣ���� � ��ࠡ��稪��

    mov es, cx
    mov di, int_offset+2
    std
    stosw
    mov bx, ax
    xor ax, ax
    stosw
    cld

    mov ax, 0001h
    ret
install endp

;----------------------------------------------------------------------;

start:
    call read_args

    cmp al, 0fh
    je usage
    cmp al, 09h
    je help
    cmp al, 0ch
    je inst
    cmp al, 0ah
    je kill
    cmp al, 0bh
    je state
    cmp al, 0dh
    je uninst

usage:
    lea dx, usage_msg
    jmp output

help:
    lea dx, help_msg
    jmp output

kill:
    call check_res
    cmp ax, 01h
    je kill_good
    lea dx, not_inst_msg
    jmp output
kill_good:
    mov ax, sign_req
    mov bx, 01h
    int int_num
    lea dx, kill_msg
    jmp output

state:
    call check_res
    cmp ax, 01h
    je state_good
    lea dx, not_inst_msg
    jmp output
state_good:
    lea dx, handler_addr_state
    call write_addr
    lea dx, state_msg
    jmp output

inst:
    call check_res
    cmp ax, 01h
    jne inst_good
    lea dx, handler_addr_bad
    call write_addr
    lea dx, inst_bad_msg
    jmp output
inst_good:
    call install
    lea dx, handler_addr_succ
    call write_addr
    lea dx, inst_succ_msg
    jmp output

uninst:
    call check_res
    cmp ax, 01h
    je uninst_semi
    lea dx, not_inst_msg
    jmp output
uninst_semi:
    xor ax, ax
    mov es, ax
    mov cx, word ptr es:int_offset
    mov dx, word ptr es:int_offset+2
    cmp cx, 00h
    jne uninst_bad
    cmp dx, bx
    je uninst_good
uninst_bad:
    lea dx, uninst_not_top_msg
    jmp output
uninst_good:
    mov ax, sign_req
    mov bx, 01h
    int int_num
    lea dx, uninst_succ_msg

output:
    mov ax, 0900h
    int 21h
    ret

    help_msg db "���� ��� �.", 0dh, 0ah
             db "������ �ணࠬ�� �������� ������� � ࠡ�⢮ ��ࠡ��稪 �᪫�祭�� 2F.", 0dh, 0ah
             db "����㯭� ��樨:", 0dh, 0ah
             db "    -h �뢥�� �� ᮮ�饭��", 0dh, 0ah
             db "    -i �������� � ������ ��ࠡ��稪", 0dh, 0ah
             db "    -u �ਭ��� �ਤ���� ���ࠢ��;", 0dh, 0ah
             db "       ���������� �᫨ ��ࠡ��稪 �� ��᫥���� � 楯�窥", 0dh, 0ah
             db "    -s �뢥�� ���⮯�������� ��ࠡ��稪� � �����", 0dh, 0ah
             db "    -k ��ࠢ��� ��ࠡ��稪 � �࠮�栬", "$"

    usage_msg db "�����: resm.com [-h] [-i] [-s] [-k]", 0dh, 0ah
              db "�� ����� ��⮪ � ��������稪��: resm.com -h", "$"

    inst_succ_msg     db "��ࠡ��稪 �ᯥ譮 ��⠭����� �� ����� "
    handler_addr_succ dd ?
                      db ":0000", "$"

    inst_bad_msg     db "��ࠡ��稪 㦥 �� ��⠭����� �� ����� "
    handler_addr_bad dd ?
                     db ":0000", "$"

    state_msg          db "��ࠡ��稪 ��⠭����� �� ����� "
    handler_addr_state dd ?
                       db ":0000", "$"

    not_inst_msg db "��ࠡ��稪 �� ��⠭�����", "$"

    uninst_not_top_msg db "��ࠡ��稪 �� ��᫥���� � 楯�窥, ��⨥ ����������", "$"

    uninst_succ_msg db "��ࠡ��稪 �� �ᯥ譮 ���", "$"

    kill_msg db "��� �� ���⮪, ��ண��...", "$"

    t1 db 13 dup(8), 7, 18 dup(8), 6, 12 dup(8), 0, 58 dup(8), 1, 4, 8, 2, 7 dup(8), 3, 8, 5, 10 dup(8)

    t2 db 0, 0, 0, 0, 0, 0, 1,  15, 0
       db 2, 0, 0, 0, 0, 0, 1,  15, 0
       db 0, 3, 4, 5, 6, 7, 1,  15, 0
       db 0, 0, 0, 0, 0, 0, 9,  9,  0
       db 0, 0, 0, 0, 0, 0, 10, 10, 0
       db 0, 0, 0, 0, 0, 0, 11, 11, 0
       db 0, 0, 0, 0, 0, 0, 12, 12, 0
       db 0, 0, 0, 0, 0, 0, 13, 13, 0

dno:
end program
