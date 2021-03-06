; FLAG

flag_nums dw 16, 16
flag db 16 dup (0),22,22,12 dup (0),22,22,0,22,22,0,0,0,22,22,22,0,0,0,0,22,22,0,22,22,22,22,0,0,0,22,102,22
     db 0,0,22,22,22,22,0,22,22,22,0,0,0,22,22,0,0,0,22,22,22,0,6 dup (22),0,22,22,0,6 dup (22),0,0,22,102,8 dup (22)
     db 102,22,0,0,0,22,22,22,102,6 dup (22),102,22,22,22,0,0,0,22,22,22,22,102,22,22,102,22,22,22,22,0,0,0,0
     db 12 dup (22),5 dup (0),22,22,22,0,22,22,0,22,22,22,10 dup (0),22,22,13 dup (0),22,22,22,22,10 dup (0)
     db 8 dup (22),8 dup (0),22,22,0,22,22,0,22,22,20 dup (0)

beated_flag_nums dw 16, 16
beated_flag db 21 dup (0),6,14 dup (0),6,6,0,22,12 dup (0),6,0,22,22,22,10 dup (0),6,0,5 dup (22),8 dup (0),6,6,0,8 dup (22)
            db 5 dup (0),6,0,10 dup (22),0,0,0,6,6,0,10 dup (22),0,0,0,6,0,0,8 dup (22),0,22,22,0,0,6,0,6 dup (22),0
            db 0,22,0,22,22,0,0,6,0,0,0,22,22,22,5 dup (0),22,0,0,0,6,5 dup (0),22,5 dup (0),22,0,0,0,6,15 dup (0),6
            db 15 dup (0),6,30 dup (0)

; WALLS

bricks_nums dw 16, 16
bricks db 102,102,102,102,22,7 dup (102),22,102,102,102,6,6,6,6,22,102,6 dup (6),22,102,6 dup (6),22,102,6 dup (6)
       db 22,102,6,6,17 dup (22),7 dup (102),22,7 dup (102),22,102,6 dup (6),22,102,6 dup (6),22,102,6 dup (6)
       db 22,102,6 dup (6),16 dup (22),102,102,102,102,22,7 dup (102),22,102,102,102,6,6,6,6,22,102,6 dup (6),22
       db 102,6 dup (6),22,102,6 dup (6),22,102,6,6,17 dup (22),7 dup (102),22,7 dup (102),22,102,6 dup (6),22
       db 102,6 dup (6),22,102,6 dup (6),22,102,6 dup (6),16 dup (22)

grass_nums dw 16, 16
grass db 0,5 dup (2),11,0,0,5 dup (2),11,0,2,2,2,11,2,11,2,11,2,2,2,11,2,11,2,11,5 dup (2),11,11,11,5 dup (2)
      db 11,11,11,2,2,2,11,11,2,2,11,2,2,2,11,11,2,2,11,2,2,11,2,11,11,11,2,2,2,11,2,11,11,11,2,2,2,2,5 dup (11)
      db 2,2,2,10 dup (11),2,7 dup (11),2,11,11,0,11,11,2,11,11,11,0,0,11,11,2,11,11,11,0,0,5 dup (2),11,0,0,5 dup (2)
      db 11,0,2,2,2,11,2,11,2,11,2,2,2,11,2,11,2,11,5 dup (2),11,11,11,5 dup (2),11,11,11,2,2,2,11,11,2,2,11,2
      db 2,2,11,11,2,2,11,2,2,11,2,11,11,11,2,2,2,11,2,11,11,11,2,2,2,2,5 dup (11),2,2,2,10 dup (11),2,7 dup (11)
      db 2,11,11,0,11,11,2,11,11,11,0,0,11,11,2,11,11,11,1 dup (0)

metals_nums dw 16, 16
metals db 23 dup (25),22,7 dup (25),22,25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22
       db 25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25,25
       db 15,15,15,15,22,22,25,25,6 dup (22),25,25,6 dup (22),25,7 dup (22),25,7 dup (22),23 dup (25),22,7 dup (25)
       db 22,25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25
       db 25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25,25,15,15,15,15,22,22,25,25,6 dup (22)
       db 25,25,6 dup (22),25,7 dup (22),25,7 dup (22)

walls_nums dw bricks_nums, metals_nums, grass_nums

; BULLET

bulletd_nums dw 3, 4
bulletd db 9 dup (25),0,25,0

bulletl_nums dw 4, 3
bulletl db 0,7 dup (25),0,3 dup (25)

bulletr_nums dw 4, 3
bulletr db 25,25,25,0,7 dup (25),0

bulletu_nums dw 3, 4
bulletu db 0,25,0,9 dup (25)

bulletdir dw bulletu_nums, bulletd_nums, bulletl_nums, bulletr_nums

; ENEMY

evild_nums dw 13, 13
evild db 34,4,4,7 dup (0),34,4,4,34,34,15,0,5 dup (15),0,34,34,34,15,4,15,4,15,4,4,4,4,34,34,4,4,34,34,15,15,4
      db 15,15,4,4,4,34,34,34,15,4,15,15,4,15,4,34,4,4,34,4,4,34,34,15,15,4,15,4,34,4,4,34,34,34,15,4,15,15,4
      db 4,34,34,4,4,34,4,4,34,34,15,15,15,4,4,4,4,34,34,34,34,15,4,15,0,34,34,15,34,34,0,34,4,4,34,34,15,0,0
      db 0,15,0,0,0,34,34,34,15,4,4,0,0,0,15,0,0,0,34,4,4,6 dup (0),15,12 dup (0),15,6 dup (0)

evill_nums dw 13, 13
evill db 0,0,11 dup (34),0,0,4,34,4,34,4,34,4,34,4,34,4,0,0,4,9 dup (15),34,5 dup (0),5 dup (15),34,6 dup (0)
      db 15,15,4,4,4,15,15,34,5 dup (0),4,4,15,15,15,4,15,34,0,5 dup (15),4,15,4,4,34,4,34,5 dup (0),34,4,4,34
      db 34,34,4,34,5 dup (0),34,5 dup (4),34,34,6 dup (0),6 dup (34),0,0,0,0,15,10 dup (34),0,0,4,34,4,34,4,34
      db 4,34,4,34,4,0,0,4,34,4,34,4,34,4,34,4,34,1 dup (4)

evilr_nums dw 13, 13
evilr db 11 dup (34),0,0,4,34,4,34,4,34,4,34,4,34,4,0,0,4,9 dup (15),4,0,0,0,0,4,5 dup (15),6 dup (0),15,15,4
      db 4,4,4,15,34,5 dup (0),15,4,15,15,15,4,4,34,5 dup (0),4,4,15,4,4,34,4,5 dup (15),0,4,4,4,34,34,34,4,34
      db 5 dup (0),4,34,5 dup (4),34,6 dup (0),6 dup (34),5 dup (0),15,10 dup (34),0,0,4,34,4,34,4,34,4,34,4,34
      db 4,0,0,4,34,4,34,4,34,4,34,4,34,4,2 dup (0)

evilu_nums dw 13, 13
evilu db 6 dup (0),15,12 dup (0),15,6 dup (0),15,4,4,0,0,0,15,0,0,0,15,4,4,34,34,15,0,0,0,15,0,0,0,34,34,34,15
      db 4,15,0,15,4,15,34,34,0,34,4,4,34,34,15,15,15,4,4,4,4,34,34,34,34,15,4,15,15,4,15,15,4,4,4,34,4,4,34,34
      db 15,15,4,15,4,34,4,4,34,34,34,15,4,15,15,4,15,4,34,4,4,34,4,4,34,34,15,15,15,4,34,34,4,4,34,34,34,15,4
      db 15,34,15,15,4,4,4,34,34,4,4,34,34,15,0,5 dup (34),0,34,34,34,15,4,4,7 dup (0),34,2 dup (4)

enemydir dw evilu_nums, evild_nums, evill_nums, evilr_nums

;  PLAYER

playerd_nums dw 13, 13
playerd db 191,191,191,7 dup (0),191,191,191,93,43,93,0,5 dup (93),0,191,43,43,191,191,93,43,93,43,43,43,43,191
        db 191,191,191,93,43,93,93,43,93,93,43,43,43,191,43,43,191,191,93,93,43,93,43,191,43,43,191,191,191,93,43
        db 93,93,43,93,43,191,43,43,191,43,43,191,191,93,93,43,43,191,191,43,43,191,191,191,93,43,93,93,93,43,43
        db 43,43,191,191,43,43,191,191,93,0,191,191,93,191,191,0,191,191,191,93,43,93,0,0,0,93,0,0,0,191,43,43,43
        db 191,191,0,0,0,93,0,0,0,191,191,191,6 dup (0),93,12 dup (0),93,6 dup (0)

playerl_nums dw 13, 13
playerl db 0,0,10 dup (191),43,0,0,191,43,191,43,191,43,191,43,191,43,191,0,0,191,9 dup (93),191,5 dup (0),5 dup (93)
        db 191,6 dup (0),93,93,43,43,43,93,93,191,5 dup (0),43,43,93,93,93,43,93,191,0,5 dup (93),43,93,43,43,191
        db 43,191,5 dup (0),191,43,43,191,191,191,43,191,5 dup (0),191,5 dup (43),191,191,6 dup (0),6 dup (191)
        db 0,0,0,0,93,10 dup (191),0,0,191,43,191,43,191,43,191,43,191,43,191,0,0,191,43,191,43,191,43,191,43,191
        db 43,1 dup (191)

playerr_nums dw 13, 13
playerr db 10 dup (191),43,0,0,191,43,191,43,191,43,191,43,191,43,191,0,0,191,9 dup (93),191,0,0,0,0,43,5 dup (93)
        db 6 dup (0),93,93,43,43,43,43,93,191,5 dup (0),93,43,93,93,93,43,43,191,5 dup (0),43,43,93,43,43,191,43
        db 5 dup (93),0,43,43,43,191,191,191,43,191,5 dup (0),43,191,5 dup (43),191,6 dup (0),6 dup (191),5 dup (0)
        db 93,10 dup (191),0,0,191,43,191,43,191,43,191,43,191,43,191,0,0,191,43,191,43,191,43,191,43,191,43,191
        db 2 dup (0)

playeru_nums dw 13, 13
playeru db 6 dup (0),93,12 dup (0),93,6 dup (0),93,191,191,0,0,0,93,0,0,0,93,191,191,93,43,93,0,0,0,93,0,0,0,191
        db 43,43,191,191,93,0,93,43,93,191,191,0,191,191,191,93,43,93,93,93,43,43,43,43,191,191,43,43,191,191,93
        db 93,43,93,93,43,43,43,191,191,191,93,43,93,93,43,93,43,191,43,43,191,43,43,191,191,93,93,43,93,43,191
        db 43,43,191,191,191,93,43,93,93,93,43,191,191,43,43,191,43,43,191,191,93,191,93,93,43,43,43,191,191,191
        db 191,93,43,93,0,5 dup (191),0,191,43,43,43,191,191,7 dup (0),3 dup (191)

playerdir dw playeru_nums, playerd_nums, playerl_nums, playerr_nums

; NUMS

num_0_nums dw 9, 9
num_0 db 12 dup (22),0,0,0,5 dup (22),0,22,22,0,0,22,22,22,0,0,22,22,22,0,0,22,22,0,0,22,22,22,0,0,22,22,0,0,22
      db 22,22,0,0,22,22,22,0,0,22,22,0,5 dup (22),0,0,0,12 dup (22)

num_1_nums dw 8, 9
num_1 db 11 dup (22),0,0,5 dup (22),0,0,0,6 dup (22),0,0,6 dup (22),0,0,6 dup (22),0,0,6 dup (22),0,0,22,22,22
      db 22,6 dup (0),9 dup (22)

num_2_nums dw 9, 9
num_2 db 11 dup (22),5 dup (0),22,22,22,0,0,22,22,22,0,0,6 dup (22),0,0,0,22,22,22,22,0,0,0,0,22,22,22,22,0,0
      db 0,0,22,22,22,22,0,0,0,6 dup (22),7 dup (0),10 dup (22)

; INTROS

preview_nums dw 188, 111
preview db 15,7 dup (6),15,7 dup (6),15,7 dup (6),16 dup (0),15,7 dup (6),15,6,6,6,16 dup (0),6,6,6,6,15,7 dup (6)
        db 15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6
        db 24 dup (0),6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6,6,15,7 dup (6),15,7 dup (6),15,7 dup (6),16 dup (0)
        db 15,7 dup (6),15,6,6,6,16 dup (0),6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,7 dup (6)
        db 15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6
        db 6,15,7 dup (6),15,7 dup (6),15,7 dup (6),16 dup (0),15,7 dup (6),15,6,6,6,16 dup (0),6,6,6,6,15,7 dup (6)
        db 15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6
        db 24 dup (0),6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6,6,24 dup (15),16 dup (0),12 dup (15),16 dup (0),24 dup (15)
        db 8 dup (0),24 dup (15),8 dup (0),8 dup (15),24 dup (0),24 dup (15),6,6,6,6,15,6,6,6,12 dup (0),15,7 dup (6)
        db 8 dup (0),15,7 dup (6),0,0,0,0,6,6,6,6,15,6,6,6,20 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0)
        db 15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),6,6,6,6,15,6,6,6,12 dup (0),15,7 dup (6),8 dup (0),15
        db 7 dup (6),0,0,0,0,6,6,6,6,15,6,6,6,20 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6)
        db 24 dup (0),15,7 dup (6),16 dup (0),6,6,6,6,15,6,6,6,12 dup (0),15,7 dup (6),8 dup (0),15,7 dup (6),0
        db 0,0,0,6,6,6,6,15,6,6,6,20 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0)
        db 15,7 dup (6),16 dup (0),8 dup (15),12 dup (0),8 dup (15),8 dup (0),8 dup (15),0,0,0,0,8 dup (15),20 dup (0)
        db 8 dup (15),24 dup (0),8 dup (15),16 dup (0),8 dup (15),24 dup (0),8 dup (15),16 dup (0),15,7 dup (6)
        db 12 dup (0),6,6,6,6,15,6,6,6,0,0,0,0,15,7 dup (6),12 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6
        db 6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),15
        db 7 dup (6),12 dup (0),6,6,6,6,15,6,6,6,0,0,0,0,15,7 dup (6),12 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6
        db 6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0)
        db 15,7 dup (6),12 dup (0),6,6,6,6,15,6,6,6,0,0,0,0,15,7 dup (6),12 dup (0),6,6,6,6,15,6,6,6,16 dup (0)
        db 6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6
        db 16 dup (0),8 dup (15),12 dup (0),8 dup (15),0,0,0,0,8 dup (15),12 dup (0),8 dup (15),16 dup (0),8 dup (15)
        db 24 dup (0),8 dup (15),16 dup (0),8 dup (15),24 dup (0),8 dup (15),16 dup (0),6,6,6,6,15,7 dup (6),15
        db 7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,12 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0)
        db 15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),15,7 dup (6),15,6,6,6,0,0,0,0,6,6,6,6,15
        db 7 dup (6),15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,12 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6)
        db 24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),15,7 dup (6),15,6,6,6,0,0,0,0
        db 6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,12 dup (0),15,7 dup (6),16 dup (0)
        db 15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),15,7 dup (6),15
        db 6,6,6,0,0,0,0,24 dup (15),8 dup (0),8 dup (15),12 dup (0),8 dup (15),16 dup (0),8 dup (15),24 dup (0)
        db 8 dup (15),16 dup (0),8 dup (15),24 dup (0),20 dup (15),0,0,0,0,15,7 dup (6),12 dup (0),6,6,6,6,15,6
        db 6,6,0,0,0,0,15,7 dup (6),15,7 dup (6),15,7 dup (6),15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6
        db 6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),15,7 dup (6),12 dup (0)
        db 6,6,6,6,15,6,6,6,0,0,0,0,15,7 dup (6),15,7 dup (6),15,7 dup (6),15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6
        db 24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),15,7 dup (6)
        db 12 dup (0),6,6,6,6,15,6,6,6,0,0,0,0,15,7 dup (6),15,7 dup (6),15,7 dup (6),15,6,6,6,16 dup (0),6,6,6
        db 6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0)
        db 8 dup (15),12 dup (0),8 dup (15),0,0,0,0,28 dup (15),16 dup (0),8 dup (15),24 dup (0),8 dup (15),16 dup (0)
        db 8 dup (15),24 dup (0),8 dup (15),16 dup (0),6,6,6,6,15,6,6,6,12 dup (0),15,7 dup (6),0,0,0,0,6,6,6,6
        db 15,6,6,6,12 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6)
        db 24 dup (0),15,7 dup (6),16 dup (0),6,6,6,6,15,6,6,6,12 dup (0),15,7 dup (6),0,0,0,0,6,6,6,6,15,6,6,6
        db 12 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0)
        db 15,7 dup (6),16 dup (0),6,6,6,6,15,6,6,6,12 dup (0),15,7 dup (6),0,0,0,0,6,6,6,6,15,6,6,6,12 dup (0)
        db 15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6)
        db 16 dup (0),8 dup (15),12 dup (0),8 dup (15),0,0,0,0,8 dup (15),12 dup (0),8 dup (15),16 dup (0),8 dup (15)
        db 24 dup (0),8 dup (15),16 dup (0),8 dup (15),24 dup (0),8 dup (15),16 dup (0),15,7 dup (6),15,7 dup (6)
        db 15,7 dup (6),8 dup (0),15,7 dup (6),12 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0)
        db 6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,7 dup (6)
        db 15,7 dup (6),15,6,6,6,15,7 dup (6),15,7 dup (6),15,7 dup (6),8 dup (0),15,7 dup (6),12 dup (0),6,6,6
        db 6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,7 dup (6),15
        db 7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6,6,15,7 dup (6),15,7 dup (6),15
        db 7 dup (6),8 dup (0),15,7 dup (6),12 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6
        db 6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,7 dup (6),15,7 dup (6),15,6,6,6,8 dup (0),6,6,6,6,15,7 dup (6),15
        db 7 dup (6),15,6,6,6,24 dup (15),8 dup (0),8 dup (15),12 dup (0),8 dup (15),16 dup (0),8 dup (15),24 dup (0)
        db 8 dup (15),16 dup (0),24 dup (15),8 dup (0),24 dup (15),2300 dup (0),6,6,6,6,15,7 dup (6),15,6,6,6,12 dup (0)
        db 15,7 dup (6),15,7 dup (6),15,7 dup (6),8 dup (0),15,7 dup (6),15,7 dup (6),15,7 dup (6),8 dup (0),15
        db 7 dup (6),8 dup (0),15,7 dup (6),72 dup (0),6,6,6,6,15,7 dup (6),15,6,6,6,12 dup (0),15,7 dup (6),15
        db 7 dup (6),15,7 dup (6),8 dup (0),15,7 dup (6),15,7 dup (6),15,7 dup (6),8 dup (0),15,7 dup (6),8 dup (0)
        db 15,7 dup (6),72 dup (0),6,6,6,6,15,7 dup (6),15,6,6,6,12 dup (0),15,7 dup (6),15,7 dup (6),15,7 dup (6)
        db 8 dup (0),15,7 dup (6),15,7 dup (6),15,7 dup (6),8 dup (0),15,7 dup (6),8 dup (0),15,7 dup (6),72 dup (0)
        db 16 dup (15),12 dup (0),24 dup (15),8 dup (0),24 dup (15),8 dup (0),8 dup (15),8 dup (0),8 dup (15),68 dup (0)
        db 6,6,6,6,15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0)
        db 6,6,6,6,15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,68 dup (0),6,6,6,6,15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,16 dup (0)
        db 6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,68 dup (0)
        db 6,6,6,6,15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,16 dup (0)
        db 6,6,6,6,15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,68 dup (0),8 dup (15),8 dup (0),8 dup (15),16 dup (0),8 dup (15)
        db 24 dup (0),8 dup (15),16 dup (0),8 dup (15),8 dup (0),8 dup (15),64 dup (0),6,6,6,6,15,6,6,6,36 dup (0)
        db 15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),8 dup (0),15,7 dup (6),64 dup (0),6,6,6
        db 6,15,6,6,6,36 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),8 dup (0),15,7 dup (6)
        db 64 dup (0),6,6,6,6,15,6,6,6,36 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),16 dup (0),15,7 dup (6),8 dup (0)
        db 15,7 dup (6),64 dup (0),8 dup (15),36 dup (0),8 dup (15),24 dup (0),8 dup (15),16 dup (0),8 dup (15)
        db 8 dup (0),8 dup (15),64 dup (0),15,7 dup (6),36 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6
        db 20 dup (0),15,7 dup (6),15,7 dup (6),68 dup (0),15,7 dup (6),36 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6
        db 6,6,6,15,6,6,6,20 dup (0),15,7 dup (6),15,7 dup (6),68 dup (0),15,7 dup (6),36 dup (0),6,6,6,6,15,6,6
        db 6,24 dup (0),6,6,6,6,15,6,6,6,20 dup (0),15,7 dup (6),15,7 dup (6),68 dup (0),8 dup (15),36 dup (0),8 dup (15)
        db 24 dup (0),8 dup (15),20 dup (0),16 dup (15),68 dup (0),6,6,6,6,15,6,6,6,36 dup (0),15,7 dup (6),24 dup (0)
        db 15,7 dup (6),24 dup (0),15,7 dup (6),72 dup (0),6,6,6,6,15,6,6,6,36 dup (0),15,7 dup (6),24 dup (0),15
        db 7 dup (6),24 dup (0),15,7 dup (6),72 dup (0),6,6,6,6,15,6,6,6,36 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6)
        db 24 dup (0),15,7 dup (6),72 dup (0),8 dup (15),36 dup (0),8 dup (15),24 dup (0),8 dup (15),24 dup (0)
        db 8 dup (15),76 dup (0),6,6,6,6,15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0)
        db 6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,76 dup (0),6,6,6,6,15,6,6,6,8 dup (0),6,6,6,6,15,6,6,6,16 dup (0)
        db 6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,76 dup (0),6,6,6,6,15,6,6,6
        db 8 dup (0),6,6,6,6,15,6,6,6,16 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6,15,6,6,6,24 dup (0),6,6,6,6
        db 15,6,6,6,76 dup (0),8 dup (15),8 dup (0),8 dup (15),16 dup (0),8 dup (15),24 dup (0),8 dup (15),24 dup (0)
        db 8 dup (15),80 dup (0),6,6,6,6,15,7 dup (6),15,6,6,6,12 dup (0),15,7 dup (6),15,7 dup (6),15,7 dup (6)
        db 16 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),80 dup (0),6,6,6,6,15,7 dup (6),15,6,6,6,12 dup (0),15
        db 7 dup (6),15,7 dup (6),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0),15,7 dup (6),80 dup (0),6,6,6
        db 6,15,7 dup (6),15,6,6,6,12 dup (0),15,7 dup (6),15,7 dup (6),15,7 dup (6),16 dup (0),15,7 dup (6),24 dup (0)
        db 15,7 dup (6),80 dup (0),16 dup (15),12 dup (0),24 dup (15),16 dup (0),8 dup (15),24 dup (0),8 dup (15)
        db 3860 dup (0),15,15,11 dup (0),6 dup (15),0,0,0,15,15,7 dup (0),15,15,15,0,0,0,0,15,15,0,0,15,15,0,0,6 dup (15)
        db 0,6 dup (15),128 dup (0),15,15,15,11 dup (0),15,15,0,0,0,15,15,0,0,15,15,6 dup (0),15,15,0,15,15,0,0
        db 0,15,15,0,0,15,15,0,0,15,15,5 dup (0),15,15,0,0,0,15,15,128 dup (0),15,15,11 dup (0),15,15,0,0,0,15,15
        db 0,0,15,15,5 dup (0),15,15,0,0,0,15,15,0,0,15,15,0,0,15,15,0,0,15,15,5 dup (0),15,15,0,0,0,15,15,128 dup (0)
        db 15,15,11 dup (0),15,15,0,0,0,15,15,0,0,15,15,5 dup (0),15,15,0,0,0,15,15,0,0,0,15,15,15,15,0,0,0,5 dup (15)
        db 0,0,15,15,0,0,15,15,15,128 dup (0),15,15,11 dup (0),6 dup (15),0,0,0,15,15,5 dup (0),7 dup (15),0,0,0
        db 0,15,15,0,0,0,0,15,15,5 dup (0),5 dup (15),130 dup (0),15,15,11 dup (0),15,15,7 dup (0),15,15,5 dup (0)
        db 15,15,0,0,0,15,15,0,0,0,0,15,15,0,0,0,0,15,15,5 dup (0),15,15,0,15,15,15,127 dup (0),6 dup (15),9 dup (0)
        db 15,15,7 dup (0),6 dup (15),0,15,15,0,0,0,15,15,0,0,0,0,15,15,0,0,0,0,6 dup (15),0,15,15,0,0,15,15,15
        db 1818 dup (0),5 dup (15),10 dup (0),6 dup (15),0,0,0,15,15,7 dup (0),15,15,15,0,0,0,0,15,15,0,0,15,15
        db 0,0,6 dup (15),0,6 dup (15),0,0,0,15,15,15,15,119 dup (0),15,15,0,0,0,15,15,9 dup (0),15,15,0,0,0,15
        db 15,0,0,15,15,6 dup (0),15,15,0,15,15,0,0,0,15,15,0,0,15,15,0,0,15,15,5 dup (0),15,15,0,0,0,15,15,0,15
        db 15,0,0,15,15,122 dup (0),15,15,15,9 dup (0),15,15,0,0,0,15,15,0,0,15,15,5 dup (0),15,15,0,0,0,15,15,0
        db 0,15,15,0,0,15,15,0,0,15,15,5 dup (0),15,15,0,0,0,15,15,0,15,15,124 dup (0),15,15,15,15,10 dup (0),15
        db 15,0,0,0,15,15,0,0,15,15,5 dup (0),15,15,0,0,0,15,15,0,0,0,15,15,15,15,0,0,0,5 dup (15),0,0,15,15,0,0
        db 15,15,15,0,0,5 dup (15),119 dup (0),15,15,15,15,11 dup (0),6 dup (15),0,0,0,15,15,5 dup (0),7 dup (15)
        db 0,0,0,0,15,15,0,0,0,0,15,15,5 dup (0),5 dup (15),8 dup (0),15,15,117 dup (0),15,15,15,13 dup (0),15,15
        db 7 dup (0),15,15,5 dup (0),15,15,0,0,0,15,15,0,0,0,0,15,15,0,0,0,0,15,15,5 dup (0),15,15,0,15,15,15,0
        db 0,15,15,0,0,0,15,15,117 dup (0),7 dup (15),9 dup (0),15,15,7 dup (0),6 dup (15),0,15,15,0,0,0,15,15,0
        db 0,0,0,15,15,0,0,0,0,6 dup (15),0,15,15,0,0,15,15,15,0,0,5 dup (15),57 dup (0)

stage_nums dw 41, 8
stage db 22,22,0,0,0,0,22,22,22,22,6 dup (0),22,22,22,0,0,0,5 dup (22),5 dup (0),22,22,6 dup (0),22,22,0,0,22
      db 22,0,0,5 dup (22),0,0,22,22,22,22,0,0,22,0,0,22,22,22,0,0,6 dup (22),0,0,6 dup (22),0,0,9 dup (22),0
      db 0,22,22,22,0,0,22,22,22,0,0,22,0,0,7 dup (22),0,0,7 dup (22),5 dup (0),5 dup (22),0,0,22,22,22,0,0,22
      db 22,22,0,0,22,0,0,22,22,0,0,0,22,22,5 dup (0),8 dup (22),0,0,22,22,22,22,0,0,22,22,22,7 dup (0),22,0,0
      db 22,22,22,0,0,22,22,0,0,6 dup (22),0,0,22,22,22,0,0,22,22,22,22,0,0,22,22,22,0,0,22,22,22,0,0,22,22,0
      db 0,22,22,0,0,22,22,0,0,7 dup (22),5 dup (0),5 dup (22),0,0,22,22,22,0,0,22,22,22,0,0,22,22,22,5 dup (0)
      db 22,22,6 dup (0),42 dup (22)

game_over_nums dw 31, 15
game_over db 0,0,5 dup (4),0,0,0,4,4,4,0,0,0,4,4,0,0,0,4,4,0,0,6 dup (4),0,4,4,6 dup (0),4,4,0,4,4,0,0,4,4,4,0,4,4
          db 4,0,0,4,4,0,0,0,0,4,4,6 dup (0),4,4,0,0,0,4,4,0,7 dup (4),0,0,4,4,0,0,0,0,4,4,0,0,4,4,4,0,4,4,0,0,0,4
          db 4,0,7 dup (4),0,0,5 dup (4),0,4,4,0,0,0,4,4,0,7 dup (4),0,4,4,0,4,0,4,4,0,0,4,4,5 dup (0),4,4,0,0,4,4
          db 0,4,4,0,0,0,4,4,0,4,4,0,0,0,4,4,0,0,4,4,6 dup (0),5 dup (4),0,4,4,0,0,0,4,4,0,4,4,0,0,0,4,4,0,0,6 dup (4)
          db 32 dup (0),5 dup (4),0,0,4,4,0,0,0,4,4,0,0,6 dup (4),0,6 dup (4),0,4,4,0,0,0,4,4,0,4,4,0,0,0,4,4,0,0
          db 4,4,5 dup (0),4,4,0,0,0,4,4,4,4,0,0,0,4,4,0,4,4,0,0,0,4,4,0,0,4,4,5 dup (0),4,4,0,0,0,4,4,4,4,0,0,0,4
          db 4,0,4,4,4,0,4,4,4,0,0,5 dup (4),0,0,4,4,0,0,5 dup (4),0,0,0,4,4,0,0,5 dup (4),0,0,0,4,4,5 dup (0),5 dup (4)
          db 0,0,4,4,0,0,0,4,4,0,0,0,4,4,4,0,0,0,0,4,4,5 dup (0),4,4,0,4,4,4,0,0,5 dup (4),5 dup (0),4,5 dup (0),6 dup (4)
          db 0,4,4,0,0,3 dup (4)

nya_nums dw 53, 20
nya db 8 dup (4),8 dup (0),8 dup (4),29 dup (0),27 dup (4),0,17 dup (90),8 dup (0),26 dup (4),0,90,90,90,13 dup (36)
    db 90,90,90,7 dup (0),8 dup (42),8 dup (4),8 dup (42),4,4,0,90,90,6 dup (36),20,36,36,20,5 dup (36),90,90
    db 7 dup (0),26 dup (42),0,90,36,36,20,14 dup (36),90,7 dup (0),26 dup (42),0,90,11 dup (36),0,0,36,20,36
    db 36,90,7 dup (0),8 dup (44),8 dup (42),8 dup (44),42,42,0,90,10 dup (36),0,22,22,0,36,36,36,90,0,0,0,22
    db 22,0,0,26 dup (44),0,90,6 dup (36),20,36,36,36,0,22,22,22,0,36,36,90,0,0,22,22,22,0,0,21 dup (44),0,0
    db 44,44,44,0,90,10 dup (36),0,22,22,22,22,0,0,0,0,22,22,22,22,0,0,8 dup (48),8 dup (44),48,48,48,48,0,22
    db 22,0,44,44,0,90,36,36,36,20,6 dup (36),0,12 dup (22),0,0,20 dup (48),0,22,22,0,0,0,0,90,7 dup (36),20
    db 36,0,14 dup (22),0,21 dup (48),0,22,22,22,22,0,90,36,20,7 dup (36),0,22,22,22,11,0,5 dup (22),11,0,22
    db 22,0,8 dup (54),8 dup (48),6 dup (54),0,0,22,22,0,90,9 dup (36),0,22,22,22,0,0,22,22,22,0,22,0,0,22,22
    db 0,24 dup (54),0,0,0,90,5 dup (36),20,36,36,36,0,22,65,65,9 dup (22),65,65,0,26 dup (54),0,90,90,36,20
    db 6 dup (36),0,22,65,65,22,0,22,22,0,22,22,0,22,65,65,0,8 dup (17),8 dup (54),8 dup (17),54,54,0,90,90
    db 90,8 dup (36),0,22,22,22,7 dup (0),22,22,0,0,26 dup (17),0,0,11 dup (90),0,10 dup (22),0,0,0,25 dup (17)
    db 0,22,22,33 dup (0),8 dup (17),8 dup (0),17,0,22,22,0,17,0,22,22,8 dup (0),22,22,0,0,0,22,22,58 dup (0)
