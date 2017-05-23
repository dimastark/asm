.model tiny
.code
.386
org 100h

start:
  ; 320x200
  mov ax, 13h
  int 10h
  mov ax, 0A000h
  mov es, ax

  call intro
  call wait_select

  cmp [option], 1
  jne end_game

  start_game:
  call level_start_intro

  call draw_map
  call draw_player
  call draw_enemy

  call put_all_handlers
  
  loop_game:

  cmp g_s, 0
  je loop_game

  cmp [g_s], 1
  je next_level
  jne lose_game

  end_game:
  call del_all_handlers
  call clear_keyboard_buffer
  mov ah, 4ch
  int 21h
  ret

  next_level:
  cmp [mn], 1
  je win_game 
  call del_all_handlers
  call start_level
  inc [mn]
  mov [g_s], 0
  jmp start_game

  win_game:
  call del_all_handlers
  call clear_clear_nums
  call clear_pixels
  call clear_sprite_nums
  mov [x], 135
  mov [y], 90
  lea bx, nya_nums
  call mov_sprite_nums
  call draw_pixels
  jmp end_game

  lose_game:
  call del_all_handlers
  call clear_clear_nums
  call clear_pixels
  call clear_sprite_nums
  mov [x], 145
  mov [y], 93
  lea bx, game_over_nums
  call mov_sprite_nums
  call draw_pixels
  jmp end_game

p_x dw 122
p_y dw 177
p_d db 0
p_m db 0
p_b dw 0, 0, 0, 0

e_x dw 281
e_y dw 17
e_d db 2
e_m db 0
e_b dw 0, 0, 0, 0

g_s db 0

start_level proc
  mov [p_x], 122
  mov [p_y], 177
  mov [p_d], 0
  mov [p_m], 0
  mov [p_b], 0

  mov [e_x], 281
  mov [e_y], 17
  mov [e_d], 2
  mov [e_m], 0
  mov [e_b], 0
  ret
endp start_level

; ------- HANDLERS UTILS -------
  
  interrupt_code db ?
  handler_offset dw ?
  save_interrupt dw ?

  move_vector_address_to_di proc
    mov al, [interrupt_code]
    mov ah, 0
    mov cl, 4
    mul cl
    mov di, ax
    ret
  endp move_vector_address_to_di

  put_handler proc
    push es
    xor ax, ax
    mov es, ax
    call move_vector_address_to_di
    mov bx, es:[di]
    mov cx, es:[di+2]
    mov ax, [handler_offset]
    mov es:[di], ax
    mov es:[di+2], ds
    mov di, [save_interrupt]
    mov [di], bx
    mov [di+2], cx
    pop es
    ret
  endp put_handler

  del_handler proc
    push es
    xor ax, ax
    mov es, ax
    mov di, [save_interrupt]
    mov bx, [di]
    mov dx, [di+2]
    call move_vector_address_to_di
    mov es:[di], bx
    mov es:[di+2], dx
    pop es
    ret
  endp del_handler

  put_09h_handler proc
    mov [interrupt_code], 09h
    lea bx, handler_09h
    mov [handler_offset], bx
    lea bx, old_09h
    mov [save_interrupt], bx
    call put_handler
    ret
  endp put_09h_handler

  put_1ch_handler proc
    mov [interrupt_code], 1ch
    lea bx, handler_1ch
    mov [handler_offset], bx
    lea bx, old_1ch
    mov [save_interrupt], bx
    call put_handler
    ret
  endp put_1ch_handler

  del_09h_handler proc
    mov [interrupt_code], 09h
    lea bx, old_09h
    mov [save_interrupt], bx
    call del_handler
    ret
  endp del_09h_handler

  del_1ch_handler proc
    mov [interrupt_code], 1ch
    lea bx, old_1ch
    mov [save_interrupt], bx
    call del_handler
    ret
  endp del_1ch_handler

  put_all_handlers proc
    call put_09h_handler
    call put_1ch_handler
    ret
  endp put_all_handlers

  del_all_handlers proc
    call del_09h_handler
    call del_1ch_handler
    ret
  endp del_all_handlers

; ------- KEYBOARD UTILS -------

  clear_keyboard_buffer proc
    cli
    push es
    xor ax, ax
    mov es, ax
    mov al, es:[41ah]
    mov es:[41ch], al
    pop es
    sti
    ret
  endp clear_keyboard_buffer

  button db 0
  up_button = 0
  down_button = 1
  left_button = 2
  right_button = 3
  space_button = 4
  other_button = 10
  get_button proc
    cmp al, 1
    je end_game
    mov ah, 0
    cmp al, 72
    je @find
    inc ah
    cmp al, 80
    je @find
    inc ah
    cmp al, 75
    je @find
    inc ah
    cmp al, 77
    je @find
    inc ah
    cmp al, 57
    je @find
    mov [button], 10
    ret

    @find:
      mov [button], ah
      ret
  endp get_button

  action db 0 ; 0 - up, 1 - down, 2 - left, 3 - right, 4 - shoot
  need_shoot db 10
  get_action proc
    cmp [need_shoot], 0
    dec [need_shoot]
    je @shoot
    cmp [mn], 0
    je first_level_enemy
    jmp second_level_enemy

    first_level_enemy:
    mov ax, [p_x]
    add ax, 50
    cmp ax, [e_x]
    jl @left
    sub ax, 100
    cmp ax, [e_x]
    jg @right

    mov ax, [p_y]
    sub ax, 50
    cmp ax, [e_y]
    jg @down
    add ax, 100
    cmp ax, [e_y]
    jl @down
    ret
    second_level_enemy:
    cmp [e_y], 174
    jl @down
    cmp [e_x],  180
    jg @left
    ret
    @up:
    mov [action], 0
    ret
    @down:
    mov [action], 1
    ret
    @left:
    mov [action], 2
    ret
    @right:
    mov [action], 3
    ret
    @shoot:
    mov [need_shoot], 10
    mov [action], 4
    ret
  endp get_action

; ------- HANDLERS FUNCTIONS -------

  old_09h dw ?, ?
  handler_09h proc
    pushf
    call dword ptr old_09h
    in al, 60h
    test al, 10000000b
    jnz @release

    @press:
      call get_button
      cmp [button], other_button
      je @ret
      call select_p_d
      jmp @ret

    @release:
      mov [p_m], 0

    @ret:
    iret
  endp handler_09h

  old_1ch dw ?, ?
  handler_1ch proc
    call mov_player
    call draw_player
    call mov_bullet
    call draw_bullet

    call get_action
    call select_e_d

    call mov_enemy
    call draw_enemy
    call mov_bullet_e
    call draw_bullet_e

    call redraw_grass

    call async_sound
    iret
  endp handler_1ch

; ------- SPRITES FUNCTIONS -------

  ; bx - sprite addr
  x dw 0  ; x coordinate
  y dw 0  ; y coordinate
  w dw 0  ; width
  h dw 0  ; height
  f dw 0  ; first shift
  l dw 0  ; left shift
  r dw 0  ; right shift
  draw_pixels proc
    mov ax, [y]
    mov cx, 320
    mul cx
    add ax, [x]
    mov di, ax
    mov si, [f]
    mov cx, [h]
    lines:
      push cx
      mov cx, [w]
      add si, [l]
      columns:
        mov al, [bx][si]
        inc si
        stosb
      loop columns
      add si, [r]
      pop cx
      add di, 320
      sub di, [w]
    loop lines
    ret
  endp draw_pixels

  xc dw 0  ; x coordinate
  yc dw 0  ; y coordinate
  wc dw 0  ; width
  hc dw 0  ; height
  cc db 0  ; color for clean
  clear_pixels proc
    mov ax, [yc]
    mov cx, 320
    mul cx
    add ax, [xc]
    mov di, ax
    mov cx, [hc]
    linesс:
      push cx
      mov cx, [wc]
      columnsс:
        mov al, [cc]
        stosb
      loop columnsс
      pop cx
      add di, 320
      sub di, [wc]
    loop linesс
    ret
  endp clear_pixels

  ; bx - sprite nums addr
  mov_sprite_nums proc
    mov ax, word ptr [bx]
    mov [w], ax
    mov ax, word ptr [bx+2]
    mov [h], ax
    add bx, 4
    ret
  endp mov_sprite_nums

  clear_sprite_nums proc
    mov [w], 0
    mov [h], 0
    mov [x], 0
    mov [y], 0
    mov [f], 0
    mov [r], 0
    mov [l], 0
    ret
  endp clear_sprite_nums

  clear_clear_nums proc
    mov [wc], 320
    mov [hc], 200
    mov [xc], 0
    mov [yc], 0
    ret
  endp clear_clear_nums

  draw_map proc
    call clear_clear_nums
    mov [cc], 0
    call clear_pixels
    call select_map
    mov cx, 13
    mov [y], 0
    draw_element_1:
      push cx
      mov [x], 8
      mov cx, 19
      draw_element_2:
        push cx
        call draw_map_element
        pop cx
        add [x], 16
      loop draw_element_2
      pop cx
      add [y], 16
    loop draw_element_1
    lea bx, flag_nums
    call mov_sprite_nums
    mov [y], 176
    mov [x], 152
    call draw_pixels
    call clear_sprite_nums
    ret
  endp draw_map

  draw_map_element proc
    cmp byte ptr [bx], 0
    je drawed
    mov al, [bx]

    mov cl, [bx+1] ; t
    mov ch, [bx+2] ; b
    mov dl, [bx+3] ; l
    mov dh, [bx+4] ; r

    dec al
    shl ax, 1
    mov ah, 0

    push bx ; <--

    lea bx, walls_nums
    mov di, ax
    mov bx, [bx][di]
    call mov_sprite_nums

    mov al, cl
    mov ah, 0h
    sub [h], ax
    push [y]
    add [y], ax
    shl ax, 4
    mov [f], ax

    mov al, ch
    mov ah, 0h
    sub [h], ax

    mov al, dl
    mov ah, 0h
    sub [w], ax
    push [x]
    add [x], ax
    mov [l], ax

    mov al, dh
    mov ah, 0h
    sub [w], ax
    mov [r], ax

    call draw_pixels

    pop [x]
    pop [y]
    pop bx ; -->
    drawed:
    add bx, 5
    ret
  endp draw_map_element

  rx db 0  ; redraw columns
  ry db 0  ; redraw row
  redraw_map_element proc
    mov ax, 5 * 19
    mul [ry]
    add bx, ax
    mov ax, 5
    mul [rx]
    add bx, ax

    mov [x], 8
    mov al, [rx]
    mov ah, 0
    shl ax, 4
    add [x], ax

    mov al, [ry]
    mov ah, 0
    shl ax, 4
    mov [y], ax

    mov [wc], 16
    mov [hc], 16
    mov ax, [x]
    mov [xc], ax
    mov ax, [y]
    mov [yc], ax
    call clear_pixels
    call clear_clear_nums

    mov [w], 16
    mov [h], 16

    call draw_map_element
    ret
  endp redraw_map_element

  draw_player proc
    call clear_sprite_nums
    call select_p_sprite
    mov ax, [p_x]
    mov [x], ax
    mov ax, [p_y]
    mov [y], ax
    call draw_pixels
    ret
  endp draw_player

  draw_enemy proc
    call clear_sprite_nums
    call select_e_sprite
    mov ax, [e_x]
    mov [x], ax
    mov ax, [e_y]
    mov [y], ax
    call draw_pixels
    ret
  endp draw_enemy

  draw_bullet proc
    cmp [p_b], 0
    je draw_bullet_ret
    call select_b_sprite
    mov ax, [p_b+4]
    mov [x], ax
    mov ax, [p_b+6]
    mov [y], ax
    call draw_pixels
    draw_bullet_ret:
    ret
  endp draw_bullet

  draw_bullet_e proc
    cmp [e_b], 0
    je draw_bullet_e_ret
    call select_be_sprite
    mov ax, [e_b+4]
    mov [x], ax
    mov ax, [e_b+6]
    mov [y], ax
    call draw_pixels
    draw_bullet_e_ret:
    ret
  endp draw_bullet_e

; ------- MUSIC FUNCTIONS -------

  b_port = 61h
  cmdreg = 43h
  latch2 = 42h

  init_sound proc
    in al, b_port
    or al, 00000011b
    out b_port, al
    ret
  endp init_sound

  term_sound proc
    in al, b_port
    and al, 0fch
    out b_port, al
    ret
  endp term_sound
  
  melody dw 0 ; melody for playing
  beat dw 0   ; beats for playing
  play_sound proc
    xor si, si
    mov al, 0b6h
    out cmdreg, al

    next_note:
      call term_sound

      mov bx, [melody]
      mov al, [bx][si] 
      cmp al, 0
      je delay_loop
      cmp al, 0ffh
      je end_sound
      cbw

      lea bx, frequency
      shl ax, 1 
      mov di, ax
      mov dx, [bx][di]
     
      call init_sound
      mov al, dl 
      out latch2, al
      mov al, dh
      out latch2, al

      delay_loop:
      mov ah, 0
      int 1ah

      mov bx, [beat]
      cmp bx, 0
      je next_note

      mov cl, [bx][si]
      mov ch, 0
      mov bx, dx
      add bx, cx
      sound: 
        int 1ah
        cmp dx, bx
      jne sound
      inc si
      jmp next_note

    end_sound:
    call term_sound
    ret
  endp play_sound

  async_sound_db db 0, 0
  async_sound_count db 0
  async_sound proc
    cmp [async_sound_count], byte ptr 0
    je async_sound_ret
    call init_sound
    mov al, [async_sound_db]
    out latch2, al
    mov al, [async_sound_db+1]
    out latch2, al
    dec [async_sound_count]
    ret
    async_sound_ret:
    call term_sound
    ret
  endp async_sound

  ; bx - meta for sound
  mov_sound_nums proc
    mov ax, [bx]
    mov [beat], ax
    mov ax, [bx+2]
    mov [melody], ax
    ret
  endp mov_sound_nums

  shoot_sound proc
    mov cx, 3224
    mov [async_sound_db], cl
    mov [async_sound_db+1], ch
    mov [async_sound_count], byte ptr 1
    ret
  endp shoot_sound

  ;               C(до)  C#   D(ре)  D#   E(ми) F(фа)  F#   G(со)  G#   A(ля)  A#   B(си)
  frequency dw 0, 9121, 8609, 8126, 7670, 7239, 6833, 6449, 6087, 5746, 5423, 5119, 4831 ; малая
            dw    4560, 4304, 4063, 3834, 3619, 3416, 3224, 3043, 2873, 2711, 2559, 2415 ; 1
            dw    2280, 2152, 2031, 1917, 1809, 1715, 1612, 1521, 1436, 1355, 1292, 1207 ; 2
            dw    1140, 1076, 1015, 0958, 0904, 0857, 0806, 0760, 0718, 0677, 0646, 0603 ; 3

; ------- GAME FUNCTIONS -------

  intro proc
    lea bx, preview_nums
    call mov_sprite_nums

    mov [h], 2
    mov [x], 66
    mov [f], 188*109

    intro_animation_1:
      call draw_pixels
      inc [h]
      sub [f], 188
      mov ah, 1
      int 16h
      jnz end_animation
      cmp [f], 0
    jne intro_animation_1

    mov [wc], 320
    mov [hc], 1

    intro_animation_2:
      call draw_pixels
      call clear_pixels
      inc [y]
      inc [hc]
      mov ah, 1
      int 16h
      jnz end_animation
      cmp [y], 30
    jne intro_animation_2
    ret

    end_animation:
    mov [wc], 320
    mov [hc], 200
    call clear_pixels

    mov [x], 66
    mov [y], 30
    mov [f], 0

    lea bx, preview_nums
    call mov_sprite_nums
    call draw_pixels

    call clear_sprite_nums
    mov ax, 0
    int 16h
    ret
  endp intro

  ; 1 - 1 player, 2 - 2 players
  option db 0
  wait_select proc
    lea bx, playerr_nums
    call mov_sprite_nums
    mov [x], 105
    mov [xc], 105
    mov [wc], 13
    mov [hc], 13

    first_option:
      cmp [option], 1
      je wait_enter
      mov [option], 1
      mov [yc], 130
      call clear_pixels
      mov [y], 115
      call draw_pixels
      jmp wait_enter

    second_option:
      cmp [option], 2
      je wait_enter
      mov [option], 2
      mov [yc], 115
      call clear_pixels
      mov [y], 130
      call draw_pixels
      jmp wait_enter

    wait_enter:
      mov ax, 0
      int 16h
      cmp ah, 72
      je first_option
      cmp ah, 80
      je second_option
      cmp ah, 1
      je end_game
      cmp ah, 28
      jne wait_enter

    ret
  endp wait_select

  level_start_intro proc
    call clear_clear_nums
    mov [cc], 22
    call clear_pixels

    lea bx, stage_nums
    call mov_sprite_nums
    mov [y], 90
    mov [x], 130
    call draw_pixels

    lea bx, num_0_nums
    call mov_sprite_nums
    sub [y], 1
    add [x], 51
    call draw_pixels

    cmp [mn], 0
    jne second_level
    lea bx, num_1_nums
    jmp over_second_level
    second_level:
    lea bx, num_2_nums
    over_second_level:
    call mov_sprite_nums
    add [x], 9
    call draw_pixels

    lea bx, lvl_start
    call mov_sound_nums
    call play_sound
    ret
  endp level_start_intro

  mn db 0  ; map number
  select_map proc
    lea bx, maps
    mov al, [mn]
    mov ah, 0
    mov cx, 2
    mul cx
    mov di, ax
    mov bx, [bx][di]
    ret
  endp select_map

  select_b_sprite proc
    lea bx, bulletdir
    mov ax, [p_b+2]
    mov cx, 2
    mul cx
    mov di, ax
    mov bx, [bx][di]
    call mov_sprite_nums
    ret
  endp select_b_sprite

  select_be_sprite proc
    lea bx, bulletdir
    mov ax, [e_b+2]
    mov cx, 2
    mul cx
    mov di, ax
    mov bx, [bx][di]
    call mov_sprite_nums
    ret
  endp select_be_sprite

  select_p_sprite proc
    lea bx, playerdir
    mov al, [p_d]
    mov ah, 0
    mov cx, 2
    mul cx
    mov di, ax
    mov bx, [bx][di]
    call mov_sprite_nums
    ret
  endp select_p_sprite

  select_e_sprite proc
    lea bx, enemydir
    mov al, [e_d]
    mov ah, 0
    mov cx, 2
    mul cx
    mov di, ax
    mov bx, [bx][di]
    call mov_sprite_nums
    ret
  endp select_e_sprite

  select_p_d proc
    mov cl, [button]
    cmp cl, 10
    je end_select_p_d
    cmp cl, 4
    je shoot_bullet
    mov [p_d], cl
    mov [p_m], 1
    end_select_p_d:
    ret
    shoot_bullet:
    cmp [p_b], 0
    jne end_select_p_d
    mov ax, 1
    mov [p_b], ax
    mov al, [p_d]
    mov ah, 0
    mov [p_b+2], ax
    mov ax, [p_x]
    add ax, 5
    mov [p_b+4], ax
    mov ax, [p_y]
    add ax, 5 
    mov [p_b+6], ax
    call shoot_sound
    ret
  endp select_p_d

  select_e_d proc
    mov cl, [action]
    cmp cl, 10
    je end_select_e_d
    cmp cl, 4
    je shoot_bullet_e
    mov [e_d], cl
    mov [e_m], 1
    end_select_e_d:
    ret
    shoot_bullet_e:
    cmp [e_b], 0
    jne end_select_e_d
    mov ax, 1
    mov [e_b], ax
    mov al, [e_d]
    mov ah, 0
    mov [e_b+2], ax
    mov ax, [e_x]
    add ax, 5
    mov [e_b+4], ax
    mov ax, [e_y]
    add ax, 5 
    mov [e_b+6], ax
    call shoot_sound
    ret
  endp select_e_d

  clear_p_pixels proc
    mov ax, [p_x]
    mov [xc], ax
    mov ax, [p_y]
    mov [yc], ax
    mov [wc], 13
    mov [hc], 13
    mov [cc], 0
    call clear_pixels
    ret
  endp clear_p_pixels

  clear_e_pixels proc
    mov ax, [e_x]
    mov [xc], ax
    mov ax, [e_y]
    mov [yc], ax
    mov [wc], 13
    mov [hc], 13
    mov [cc], 0
    call clear_pixels
    ret
  endp clear_e_pixels

  clear_b_pixels proc
    mov ax, [p_b+4]
    mov [xc], ax
    mov ax, [p_b+6]
    mov [yc], ax
    mov [wc], 4
    mov [hc], 4
    mov [cc], 0
    call clear_pixels
    ret
  endp clear_b_pixels

  clear_be_pixels proc
    mov ax, [e_b+4]
    mov [xc], ax
    mov ax, [e_b+6]
    mov [yc], ax
    mov [wc], 4
    mov [hc], 4
    mov [cc], 0
    call clear_pixels
    ret
  endp clear_be_pixels

  mov_player proc
    call clear_p_pixels
    cmp [p_m], 0
    jne mov_player_continue
    ret
    mov_player_continue:
    cmp [p_d], 0
    je up_dd
    cmp [p_d], 1
    je down_dd
    cmp [p_d], 2
    je left_dd
    cmp [p_d], 3
    je right_dd
    ret
    up_dd:
    call get_u_status
    cmp [move_status], 0
    jne mov_player_ret
    sub [p_y], 2
    jmp mov_player_ret
    down_dd:
    call get_d_status
    cmp [move_status], 0
    jne mov_player_ret
    add [p_y], 2
    jmp mov_player_ret
    left_dd:
    call get_l_status
    cmp [move_status], 0
    jne mov_player_ret
    sub [p_x], 2
    jmp mov_player_ret
    right_dd:
    call get_r_status
    cmp [move_status], 0
    jne mov_player_ret
    add [p_x], 2
    mov_player_ret:
    mov [move_status], 0
    call draw_player
    ret
  endp mov_player

  mov_enemy proc
    call clear_e_pixels
    cmp [e_m], 0
    jne mov_enemy_continue
    ret
    mov_enemy_continue:
    cmp [e_d], 0
    je up_dde
    cmp [e_d], 1
    je down_dde
    cmp [e_d], 2
    je left_dde
    cmp [e_d], 3
    je right_dde
    ret
    up_dde:
    call get_ue_status
    cmp [move_status], 0
    jne mov_enemy_ret
    sub [e_y], 2
    jmp mov_enemy_ret
    down_dde:
    call get_de_status
    cmp [move_status], 0
    jne mov_enemy_ret
    add [e_y], 2
    jmp mov_enemy_ret
    left_dde:
    call get_le_status
    cmp [move_status], 0
    jne mov_enemy_ret
    sub [e_x], 2
    jmp mov_player_ret
    right_dde:
    call get_re_status
    cmp [move_status], 0
    jne mov_enemy_ret
    add [e_x], 2
    mov_enemy_ret:
    mov [move_status], 0
    call draw_enemy
    ret
  endp mov_enemy

  mov_bullet proc
    cmp [p_b], 0
    jne mov_bullet_continue
    ret
    mov_bullet_continue:
    call clear_b_pixels
    cmp [p_b+2], 0
    je up_ddd
    cmp [p_b+2], 1
    je down_ddd
    cmp [p_b+2], 2
    je left_ddd
    cmp [p_b+2], 3
    je right_ddd
    ret
    up_ddd:
    call get_ub_status
    cmp [move_status], 0
    jne mov_bullet_ret_u
    sub [p_b+6], 4
    jmp mov_bullet_ret
    down_ddd:
    call get_db_status
    cmp [move_status], 0
    jne mov_bullet_ret_d
    add [p_b+6], 4
    jmp mov_bullet_ret
    left_ddd:
    call get_lb_status
    cmp [move_status], 0
    jne mov_bullet_ret_l
    sub [p_b+4], 4
    jmp mov_bullet_ret
    right_ddd:
    call get_rb_status
    cmp [move_status], 0
    jne mov_bullet_ret_r
    add [p_b+4], 4
    jmp mov_bullet_ret
    mov_bullet_ret_u:
    call change_wall_b
    mov [p_b], 0
    jmp collapse
    mov_bullet_ret_d:
    call change_wall_t
    mov [p_b], 0
    jmp collapse
    mov_bullet_ret_l:
    call change_wall_r
    mov [p_b], 0
    jmp collapse
    mov_bullet_ret_r:
    call change_wall_l
    mov [p_b], 0
    collapse:
    call check_wall
    call redraw_wall
    ret
    mov_bullet_ret:
    mov [move_status], 0
    call draw_bullet
    ret
  endp mov_bullet

  mov_bullet_e proc
    cmp [e_b], 0
    jne mov_bullet_e_continue
    ret
    mov_bullet_e_continue:
    call clear_be_pixels
    cmp [e_b+2], 0
    je up_ddde
    cmp [e_b+2], 1
    je down_ddde
    cmp [e_b+2], 2
    je left_ddde
    cmp [e_b+2], 3
    je right_ddde
    ret
    up_ddde:
    call get_ube_status
    cmp [move_status], 0
    jne mov_bullet_e_ret_u
    sub [e_b+6], 4
    jmp mov_bullet_e_ret
    down_ddde:
    call get_dbe_status
    cmp [move_status], 0
    jne mov_bullet_e_ret_d
    add [e_b+6], 4
    jmp mov_bullet_e_ret
    left_ddde:
    call get_lbe_status
    cmp [move_status], 0
    jne mov_bullet_e_ret_l
    sub [e_b+4], 4
    jmp mov_bullet_e_ret
    right_ddde:
    call get_rbe_status
    cmp [move_status], 0
    jne mov_bullet_e_ret_r
    add [e_b+4], 4
    jmp mov_bullet_e_ret
    mov_bullet_e_ret_u:
    call change_wall_b
    mov [e_b], 0
    jmp collapsee
    mov_bullet_e_ret_d:
    call change_wall_t
    mov [e_b], 0
    jmp collapsee
    mov_bullet_e_ret_l:
    call change_wall_r
    mov [e_b], 0
    jmp collapsee
    mov_bullet_e_ret_r:
    call change_wall_l
    mov [e_b], 0
    collapsee:
    call check_wall
    call redraw_wall
    ret
    mov_bullet_e_ret:
    mov [move_status], 0
    call draw_bullet_e
    ret
  endp mov_bullet_e

  move_status db 0
  get_d_status proc
    mov ax, [p_x]
    sub ax, 8
    mov [chx], ax
    mov ax, [p_y]
    add ax, 15
    mov [chy], ax
    call check_point
    cmp [check_status], 0
    jne end_get_d_status

    add [chx], 13
    call check_point
    cmp [check_status], 0
    jne end_get_d_status

    mov [move_status], 0
    ret
    end_get_d_status:
    mov [move_status], 1
    ret
    ret
  endp get_d_status

  get_u_status proc
    mov ax, [p_x]
    sub ax, 8
    mov [chx], ax
    mov ax, [p_y]
    sub ax, 2
    mov [chy], ax
    call check_point
    cmp [check_status], 0
    jne end_get_u_status

    add [chx], 13
    call check_point
    cmp [check_status], 0
    jne end_get_u_status

    mov [move_status], 0
    ret
    end_get_u_status:
    mov [move_status], 1
    ret
  endp get_u_status

  get_r_status proc
    mov ax, [p_y]
    mov [chy], ax
    mov ax, [p_x]
    add ax, 15
    sub ax, 8
    mov [chx], ax
    call check_point
    cmp [check_status], 0
    jne end_get_r_status

    add [chy], 13
    call check_point
    cmp [check_status], 0
    jne end_get_r_status

    mov [move_status], 0
    ret
    end_get_r_status:
    mov [move_status], 1
    ret
  endp get_r_status

  get_l_status proc
    mov ax, [p_y]
    mov [chy], ax
    mov ax, [p_x]
    sub ax, 2
    sub ax, 8
    mov [chx], ax
    call check_point
    cmp [check_status], 0
    jne end_get_l_status

    add [chy], 13
    call check_point
    cmp [check_status], 0
    jne end_get_l_status

    mov [move_status], 0
    ret
    end_get_l_status:
    mov [move_status], 1
    ret
  endp get_l_status

  get_de_status proc
    mov ax, [e_x]
    sub ax, 8
    mov [chx], ax
    mov ax, [e_y]
    add ax, 15
    mov [chy], ax
    call check_point
    cmp [check_status], 0
    jne end_get_de_status

    add [chx], 13
    call check_point
    cmp [check_status], 0
    jne end_get_de_status

    mov [move_status], 0
    ret
    end_get_de_status:
    mov [move_status], 1
    ret
    ret
  endp get_de_status

  get_ue_status proc
    mov ax, [e_x]
    sub ax, 8
    mov [chx], ax
    mov ax, [e_y]
    sub ax, 2
    mov [chy], ax
    call check_point
    cmp [check_status], 0
    jne end_get_ue_status

    add [chx], 13
    call check_point
    cmp [check_status], 0
    jne end_get_ue_status

    mov [move_status], 0
    ret
    end_get_ue_status:
    mov [move_status], 1
    ret
  endp get_ue_status

  get_re_status proc
    mov ax, [e_y]
    mov [chy], ax
    mov ax, [e_x]
    add ax, 15
    sub ax, 8
    mov [chx], ax
    call check_point
    cmp [check_status], 0
    jne end_get_re_status

    add [chy], 13
    call check_point
    cmp [check_status], 0
    jne end_get_re_status

    mov [move_status], 0
    ret
    end_get_re_status:
    mov [move_status], 1
    ret
  endp get_re_status

  get_le_status proc
    mov ax, [e_y]
    mov [chy], ax
    mov ax, [e_x]
    sub ax, 2
    sub ax, 8
    mov [chx], ax
    call check_point
    cmp [check_status], 0
    jne end_get_le_status

    add [chy], 13
    call check_point
    cmp [check_status], 0
    jne end_get_le_status

    mov [move_status], 0
    ret
    end_get_le_status:
    mov [move_status], 1
    ret
  endp get_le_status

  get_db_status proc
    mov ax, [p_b+4]
    sub ax, 8
    mov [chx], ax
    mov ax, [p_b+6]
    add ax, 6
    mov [chy], ax
    call check_point
    call check_point_e
    call check_point_l
    cmp [check_status], 0
    jne end_get_db_status

    add [chx], 3
    call check_point
    call check_point_e
    call check_point_l
    cmp [check_status], 0
    jne end_get_db_status

    mov [move_status], 0
    ret
    end_get_db_status:
    mov [move_status], 1
    ret
  endp get_db_status

  get_ub_status proc
    mov ax, [p_b+4]
    sub ax, 8
    mov [chx], ax
    mov ax, [p_b+6]
    sub ax, 2
    mov [chy], ax
    call check_point
    call check_point_e
    call check_point_l
    cmp [check_status], 0
    jne end_get_ub_status

    add [chx], 3
    call check_point
    call check_point_e
    call check_point_l
    cmp [check_status], 0
    jne end_get_ub_status

    mov [move_status], 0
    ret
    end_get_ub_status:
    mov [move_status], 1
    ret
  endp get_ub_status

  get_rb_status proc
    mov ax, [p_b+6]
    mov [chy], ax
    mov ax, [p_b+4]
    add ax, 6
    sub ax, 8
    mov [chx], ax
    call check_point
    call check_point_e
    call check_point_l
    cmp [check_status], 0
    jne end_get_rb_status

    add [chy], 3
    call check_point
    call check_point_e
    call check_point_l
    cmp [check_status], 0
    jne end_get_rb_status

    mov [move_status], 0
    ret
    end_get_rb_status:
    mov [move_status], 1
    ret
  endp get_rb_status

  get_lb_status proc
    mov ax, [p_b+6]
    mov [chy], ax
    mov ax, [p_b+4]
    sub ax, 2
    sub ax, 8
    mov [chx], ax
    call check_point
    call check_point_e
    call check_point_l
    cmp [check_status], 0
    jne end_get_lb_status

    add [chy], 3
    call check_point
    call check_point_e
    call check_point_l
    cmp [check_status], 0
    jne end_get_lb_status

    mov [move_status], 0
    ret
    end_get_lb_status:
    mov [move_status], 1
    ret
  endp get_lb_status


  get_dbe_status proc
    mov ax, [e_b+4]
    sub ax, 8
    mov [chx], ax
    mov ax, [e_b+6]
    add ax, 6
    mov [chy], ax
    call check_point
    call check_point_l
    call check_point_p
    cmp [check_status], 0
    jne end_get_dbe_status

    add [chx], 3
    call check_point
    call check_point_l
    call check_point_p
    cmp [check_status], 0
    jne end_get_dbe_status

    mov [move_status], 0
    ret
    end_get_dbe_status:
    mov [move_status], 1
    ret
  endp get_dbe_status

  get_ube_status proc
    mov ax, [e_b+4]
    sub ax, 8
    mov [chx], ax
    mov ax, [e_b+6]
    sub ax, 2
    mov [chy], ax
    call check_point
    call check_point_l
    call check_point_p
    cmp [check_status], 0
    jne end_get_ube_status

    add [chx], 3
    call check_point
    call check_point_l
    call check_point_p
    cmp [check_status], 0
    jne end_get_ube_status

    mov [move_status], 0
    ret
    end_get_ube_status:
    mov [move_status], 1
    ret
  endp get_ube_status

  get_rbe_status proc
    mov ax, [e_b+6]
    mov [chy], ax
    mov ax, [e_b+4]
    add ax, 6
    sub ax, 8
    mov [chx], ax
    call check_point
    call check_point_l
    call check_point_p
    cmp [check_status], 0
    jne end_get_rbe_status

    add [chy], 3
    call check_point
    call check_point_l
    call check_point_p
    cmp [check_status], 0
    jne end_get_rbe_status

    mov [move_status], 0
    ret
    end_get_rbe_status:
    mov [move_status], 1
    ret
  endp get_rbe_status

  get_lbe_status proc
    mov ax, [e_b+6]
    mov [chy], ax
    mov ax, [e_b+4]
    sub ax, 2
    sub ax, 8
    mov [chx], ax
    call check_point
    call check_point_l
    call check_point_p
    cmp [check_status], 0
    jne end_get_lbe_status

    add [chy], 3
    call check_point
    call check_point_l
    call check_point_p
    cmp [check_status], 0
    jne end_get_lbe_status

    mov [move_status], 0
    ret
    end_get_lbe_status:
    mov [move_status], 1
    ret
  endp get_lbe_status

  chc db 0  ; check column
  chl db 0  ; check line
  chx dw 0  ; check x
  chy dw 0  ; check y
  check_status db 0
  check_point proc
    mov ax, [chx]
    mov cl, 16
    div cl
    mov [chc], al

    mov ax, [chy]
    div cl
    mov [chl], al

    call select_map
    mov cl, 16
    mov ax, 5 * 19
    mul [chl]
    add bx, ax
    mov ax, 5
    mul [chc]
    add bx, ax

    mov ax, [bx]
    cmp ax, 0
    je end_check_point

    cmp ax, 3
    je end_check_point

    mov al, [chc]
    mov ah, 0
    mul cl
    mov dl, [bx+3]
    mov dh, 0
    add ax, dx
    cmp ax, [chx]
    jg end_check_point

    sub ax, dx
    add ax, 16
    mov dl, [bx+4]
    mov dh, 0
    sub ax, dx
    cmp ax, [chx]
    jl end_check_point

    mov al, [chl]
    mov ah, 0
    mul cl
    mov dl, [bx+1]
    mov dh, 0
    add ax, dx
    cmp ax, [chy]
    jg end_check_point

    sub ax, dx
    add ax, 16
    mov dl, [bx+2]
    mov dh, 0
    sub ax, dx
    cmp ax, [chy]
    jl end_check_point

    mov [check_status], 1
    ret
    end_check_point:
    mov [check_status], 0
    ret
  endp check_point

  check_point_e proc
    mov ax, [e_x]

    cmp ax, [chx]
    jg end_checke_point

    add ax, 13
    cmp ax, [chx]
    jl end_checke_point

    mov ax, [e_y]

    cmp ax, [chy]
    jg end_checke_point

    add ax, 13
    cmp ax, [chy]
    jl end_checke_point

    mov [g_s], 1
    ret
    end_checke_point:
    ret
  endp check_point_e

  check_point_p proc
    mov ax, [p_x]

    cmp ax, [chx]
    jg end_checkp_point

    add ax, 13
    cmp ax, [chx]
    jl end_checkp_point

    mov ax, [p_y]

    cmp ax, [chy]
    jg end_checkp_point

    add ax, 13
    cmp ax, [chy]
    jl end_checkp_point

    mov [g_s], 2
    ret
    end_checkp_point:
    ret
  endp check_point_p

  check_point_l proc
    mov ax, 152

    cmp ax, [chx]
    jg end_checkl_point

    add ax, 13
    cmp ax, [chx]
    jl end_checkl_point

    mov ax, 176

    cmp ax, [chy]
    jg end_checkl_point

    add ax, 13
    cmp ax, [chy]
    jl end_checkl_point

    mov [g_s], 2
    ret
    end_checkl_point:
    ret
  endp check_point_l

  change_wall_b proc
    call select_map
    mov cl, 16
    mov ax, 5 * 19
    mul [chl]
    add bx, ax
    mov ax, 5
    mul [chc]
    add bx, ax
    cmp [bx], byte ptr 2
    je change_wall_b_ret
    add [bx+2], byte ptr 4
    change_wall_b_ret:
    ret
  endp change_wall_b

  change_wall_t proc
    call select_map
    mov cl, 16
    mov ax, 5 * 19
    mul [chl]
    add bx, ax
    mov ax, 5
    mul [chc]
    add bx, ax
    cmp [bx], byte ptr 2
    je change_wall_t_ret
    add [bx+1], byte ptr 4
    change_wall_t_ret:
    ret
  endp change_wall_t

  change_wall_l proc
    call select_map
    mov cl, 16
    mov ax, 5 * 19
    mul [chl]
    add bx, ax
    mov ax, 5
    mul [chc]
    add bx, ax
    cmp [bx], byte ptr 2
    je change_wall_l_ret
    add [bx+3], byte ptr 4
    change_wall_l_ret:
    ret
  endp change_wall_l

  change_wall_r proc
    call select_map
    mov cl, 16
    mov ax, 5 * 19
    mul [chl]
    add bx, ax
    mov ax, 5
    mul [chc]
    add bx, ax
    cmp [bx], byte ptr 2
    je change_wall_r_ret
    add [bx+4], byte ptr 4
    change_wall_r_ret:
    ret
  endp change_wall_r

  check_wall proc
    mov al, 0
    add al, [bx+1]
    add al, [bx+2]
    cmp al, 16
    jge need_delete_wall

    mov al, 0
    add al, [bx+3]
    add al, [bx+4]
    cmp al, 16
    jge need_delete_wall
    ret

    need_delete_wall:
    mov [bx], byte ptr 0
    check_wall_ret:
    ret
  endp check_wall

  redraw_wall proc
    mov al, [chc]
    mov [rx], al
    mov al, [chl]
    mov [ry], al
    call select_map
    call redraw_map_element
    redraw_wall_ret:
    ret
  endp redraw_wall

  redraw_grass proc
    mov [chc], 7
    mov [chl], 10
    call redraw_wall

    mov [chc], 11
    mov [chl], 10
    call redraw_wall

    ret
  endp redraw_grass

; ------- SOUNDS -------

  lvl_start dw lvl_start_beat, lvl_start_sound
  lvl_start_beat db 2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,2,2,4,1,1,1,1,1,1,1
  lvl_start_sound db 24,0,26,0,27,0,24,0,26,0,27,0,27,0,29,0,31,0,27,0,29,0,31,0,29,0,31,0,33,0,29,0,31,0,33,0,32,0,35,0
                  db 36,0,28,0,28,0,28,0,28,0,28,0ffh

  shooted_sound dw 9121

; ------- MAPS (19 * (12 + 1)) -------

  map_1 db 19 dup (2,0,0,0,0)
        db 2,0,0,0,0, 16 dup (1,0,0,0,0), 0,0,0,0,0, 2,0,0,0,0
        db 8 dup (2,0,0,0,0, 17 dup (1,0,0,0,0), 2,0,0,0,0)
        db 2,0,0,0,0, 6 dup (1,0,0,0,0), 3,0,0,0,0, 3 dup (2,0,0,0,0), 3,0,0,0,0, 6 dup (1,0,0,0,0), 2,0,0,0,0
        db 2,0,0,0,0, 6 dup (1,0,0,0,0), 0,0,0,0,0, 2,0,0,0,0, 0,0,0,0,0, 2,0,0,0,0, 7 dup (1,0,0,0,0), 2,0,0,0,0
        db 19 dup (2,0,8,0,0)

  map_2 db 19 dup (2,0,0,0,0)
        db 2,0,0,0,0, 16 dup (0,0,0,0,0), 0,0,0,0,0, 2,0,0,0,0
        db 8 dup (2,0,0,0,0, 17 dup (0,0,0,0,0), 2,0,0,0,0)
        db 2,0,0,0,0, 7 dup (0,0,0,0,0), 3 dup (1,0,0,0,0), 7 dup (0,0,0,0,0), 2,0,0,0,0
        db 2,0,0,0,0, 6 dup (0,0,0,0,0), 0,0,0,0,0, 1,0,0,0,0, 0,0,0,0,0, 1,0,0,0,0, 7 dup (0,0,0,0,0), 2,0,0,0,0
        db 19 dup (2,0,8,0,0)

  maps dw map_1, map_2

  include sprites.asm

end start