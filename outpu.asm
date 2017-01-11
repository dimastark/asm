.model tiny
.386
.code
org 100h

start:
jmp begin
	HELLO DB 'HELLO!',0 ;строка для вывода 

begin:
MOV AH,0Eh ; на экран номер подфункции BIOS
mov si,offset HELLO ;SI указывает на строку
next: lodsb ;помещаем символ в AL и переходим к следующему символу,
 INT 10h ;выводим символ на экран
test al,al ;проверяем на конец строки
jnz next ;если нет — повторяем все сначала
ret

end start