tasm /la /m5 /t /zi %1.asm
tlink /l /t %1.obj
del %1.obj
del %1.map

