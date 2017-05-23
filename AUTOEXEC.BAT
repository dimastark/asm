@echo off
if %config%==MIN goto END
path a:\;a:\dos
goto %config%

:CD
mscdex /d:mscd001
goto STD

:NET
path %path%;a:\net
net initialize
netbind
umb
tcptsr
tinyrfc
nmtsr
emsbfr
net start

:STD
mode con codepage prepare=((866) dos\ega3.cpi)
mode con codepage select=866
keyb ru,866,dos\keybrd3.sys
mode con rate=30 delay=1
doskey /i
util\msmouse\mouse
path %path%;a:\asm\masm\bin;a:\bc\bin;a:\nc;a:\nu;a:\me;a:\util
if %config%==NET goto END
lh ng\ng
cls
goto EOF

:END
ver
:EOF
