.global main



.text


main:
  push {lr}

  mov r11, r0
  mov r12, r1
  bl init_mem
  tst r0, r0
  bne exit
  bl init_time
  tst r0, r0
  bne exit
  mov r0, r11
  mov r1, r12
  bl init_uart
  tst r0, r0
  bne exit
  bl canon
  bl model_init
  bl init_controller
  bl main_loop
  bl cleanup
  bl nocanon
  b exit

exit:
  pop {pc}


buff_print:
  push {r1-r7, lr}

  mov r6, #2
  mov r4, r1
  mov r3, #2
  mov r2, #0
  mov r1, #10

  1:
    udiv r7, r0, r1
    mls r3, r7, r1, r0
    cmp r3, #10
    addge r3, r3, #87
    addlt r3, r3, #48
    strb r3, [sp, #-1]!
    add r2, r2, #1
    movs r0, r7
  bne 1b

  mov r7, r6
  sub r6, r6, r2
  cmp r2, r7
  movlt r5, r7
  movge r5, r2
  mov r7, #48

  2:
    tst r6, r6
    ble 3f
    strb r7, [r4], #1
    sub r6, r6, #1
  b 2b

  3:
    tst r2, r2
    beq 4f
    ldrb r3, [sp], #1
    strb r3, [r4], #1
    sub r2, r2, #1
  b 3b

  4:
  mov r0, r5

  pop {r1-r7, pc}


zero_print:
  push {r0-r2, r7, lr}
  mov r1, r0
  bl string_length
  mov r2, r0
  mov r0, #1
  mov r7, #4
  svc #0
  pop {r0-r2, r7, pc}


string_length:
  push {r1-r2, lr}
  mov r1, r0

  1:
    ldrb r2, [r0]
    tst r2, r2
    addne r0, #1
  bne 1b

  sub r0, r0, r1
  pop {r1-r2, pc}


copy_string:
  push {r2-r3, lr}

  mov r2, #0

  1:
    ldrb r3, [r0, r2]
    strb r3, [r1, r2]
    tst r3, r3
    beq 2f
    add r2, r2, #1
  b 1b

  2:
  mov r0, r2

  pop {r2-r3, pc}


skip_lines:
  push {r1-r5, lr}

  tst r2, r2
  ble 4f
  cmp r0, r1
  bge 4f

  1:
  mov r5, r3

  2:
    ldrb r4, [r1], #-1
    cmp r4, #10
    beq 3f
    subs r5, r5, #1
    beq 3f
    cmp r0, r1
    bge 4f
  b 2b

  3:
    subs r2, #1
    bne 1b
    add r1, r1, #2

  4:
  mov r0, r1

  pop {r1-r5, pc}


compare_prefix:
  push {r1-r3, lr}

  1:
    ldrb r2, [r0], #1
    tst r2, r2
    beq 2f
    ldrb r3, [r1], #1
    cmp r2, r3
    bne 3f
  b 1b

  2:
  mov r0, #0
  b 4f

  3:
  mov r0, #1

  4:
  pop {r1-r3, pc}


canon:
  push {r0-r3, lr}

  mov r0, #1
  ldr r1, =termios_old
  bl tcgetattr
  mov r0, #60
  ldr r1, =termios_old
  ldr r2, =termios_new

  1:
    subs r0, #4
    ldr r3, [r1, r0]
    ldr r3, [r2, r0]
  bne 1b

  ldr r0, [r2, #12]
  mov r1, #-11
  and r0, r0, r1
  str r0, [r2, #12]
  mov r0, #1
  mov r1, #0
  ldr r2, =termios_new
  bl tcsetattr

  pop {r0-r3, pc}


nocanon:
  push {r0-r2, lr}

  mov r0, #1
  mov r1, #0
  ldr r2, =termios_old
  bl tcsetattr

  pop {r0-r2, pc}


kbdhit:
  push {r1-r12,lr}

  mov r0, #1
  ldr r1, =21531
  ldr r2, =kbdhit_n
  bl ioctl
  ldr r0, [r2]

  pop {r1-r12,pc}


reset_terminal:
  push {r0, lr}

  ldr r0, =reset_sequence
  bl zero_print

  pop {r0, pc}


clear_screen:
  push {r0-r1, lr}

  ldr r0, =clear_sequence
  mov r1, #2
  bl escape

  pop {r0-r1, pc}


set_cursor_position:
  push {r0-r3, lr}

  mov r2, r0
  mov r3, r1
  ldr r0, =vertical_offset_sequence
  mov r1, r2
  add r1, r1, #1
  bl escape
  ldr r0, =horizontal_offset_sequence
  mov r1, r3
  add r1, r1, #1
  bl escape

  pop {r0-r3, pc}


escape:
  push {r0-r2, r7, lr}

  mov r2, r0
  mov r7, r1
  ldr r0, =sequence
  ldr r1, =print_buf
  bl copy_string
  add r1, r1, r0
  mov r0, r7
  bl buff_print
  add r1, r1, r0
  mov r0, r2
  bl copy_string
  add r1, r1, r0
  ldr r0, =print_buf
  sub r2, r1, r0
  mov r1, r0
  mov r0, #1
  mov r7, #4
  svc #0

  pop {r0-r2, r7, pc}


init_mem:
  push {r1-r7, lr}

  ldr r0, =dev_mem
  ldr r1, =4098
  mov r7, #5
  svc #0
  tst r0, r0
  blt 2f
  ldr r1, =dev_mem_handle
  str r0, [r1]
  mov r0, #0
  b 3f

  2:
  ldr r0, =sudo_err
  bl zero_print
  mvn r0, #1

  3:
  pop {r1-r7,pc}


cleanup_mem:
  push {r0, r7, lr}

  ldr r0, =dev_mem_handle
  ldr r0, [r0]
  mov r7, #6
  svc #0

  pop {r0, r7, pc}


mmap_mem:
  push {r1-r7, lr}

  mov r5, r0
  mov r0, #0
  mov r1, #4096
  mov r2, #3
  mov r3, #1
  ldr r4, =dev_mem_handle
  ldr r4, [r4]
  mov r7, #192
  svc #0

  pop {r1-r7, pc}


init_time:
  push {r1, lr}

  ldr r0, =7936
  bl mmap_mem
  ldr r1, =rtc_mem_base
  str r0, [r1]
  mov r0, #0

  pop {r1, pc}


get_current_time:
  push {lr}

  ldr r0, =rtc_mem_base
  ldr r0, [r0]
  ldr r0, [r0, #20]
  
  pop {pc}


init_uart:
  push {r1, lr}

  bl parse_arguments
  tst r0, r0
  bne 1f
  ldr r0, =7200
  bl mmap_mem
  ldr r1, =ccu_mem
  str r0, [r1]
  ldr r0, =7208
  bl mmap_mem
  ldr r1, =uart_mem
  str r0, [r1]
  bl setup_uart
  mov r0, #0
  b 2f

  1:
  ldr r0, =usage_message
  bl zero_print
  mvn r0, #1

  2:
  pop {r1, pc}


parse_arguments:
  push {lr}

  cmp r0, #2
  bne 1f
  ldr r0, [r1, #4]
  ldrb r0, [r0]
  sub r0, r0, #48
  cmp r0, #1
  beq 2f
  cmp r0, #2
  beq 2f

  1:
  mvn r0, #1
  b 3f

  2:
  ldr r1, =uart_no
  str r0, [r1]
  mov r0, #0

  3:
  pop {pc}


setup_uart:
  push {r0-r4, lr}

  ldr r1, =uart_no
  ldr r1, [r1]
  cmp r1, #1
  ldreq r1, =17
  ldreq r4, =1024
  ldrne r1, =18
  ldrne r4, =2048
  mov r0, #1
  lsl r0, r0, r1
  ldr r1, =ccu_mem
  ldr r1, [r1]
  ldr r2, [r1, #108]
  orr r2, r2, r0
  str r2, [r1, #108]
  ldr r2, [r1, #728]
  orr r2, r2, r0
  str r2, [r1, #728]
  ldr r1, =uart_mem
  ldr r1, [r1]
  add r1, r1, r4
  mov r0, #155
  ldrb r2, [r1, #12]
  orr r2, r2, r0
  strb r2, [r1, #12]
  mov r0, #13
  strb r0, [r1, #0]
  mov r0, #0
  strb r0, [r1, #4]
  ldr r0, [r1, #8]
  orr r0, r0, #1
  str r0, [r1, #8]
  mov r0, #127
  ldrb r2, [r1, #12]
  and r2, r2, r0
  strb r2, [r1, #12]

  pop {r0-r4, pc}


poll_uart:
  push {lr}

  bl get_uart_offset
  ldrb r0, [r0, #20]
  and r0, r0, #1

  pop {pc}


recv_uart:
  push {lr}

  bl get_uart_offset
  ldrb r0, [r0, #0]

  pop {pc}


send_uart:
  push {r1-r2, lr}

  mov r1, r0
  bl get_uart_offset

  1:
    ldrb r2, [r0, #20]
    ands r2, r2, #32
  beq 1b

  strb r1, [r0, #0]

  pop {r1-r2, pc}


get_uart_offset:
  push {r1, lr}

  ldr r0, =uart_no
  ldr r0, [r0]
  cmp r0, #1
  ldreq r0, =1024
  ldrne r0, =2048
  ldr r1, =uart_mem
  ldr r1, [r1]
  add r0, r0, r1

  pop {r1, pc}


model_init:
  push {lr}

  ldr r0, =input
  ldrh r0, [r0]
  ldr r1, =input_buf
  strh r0, [r1]
  ldr r0, =message_buf
  ldr r1, =message_end
  str r0, [r1]
  ldr r0, =history_buf
  ldr r1, =history_end
  str r0, [r1]
  mov r0, #0
  ldr r1, =message_scroll
  str r0, [r1]
  ldr r1, =history_scroll
  str r0, [r1]
  ldr r0, =no_nick
  ldr r1, =self_nick
  bl copy_string
  ldr r0, =no_nick
  ldr r1, =other_nick
  bl copy_string
  mov r0, #0
  ldr r1, =online_flag
  str r0, [r1]
  ldr r0, =first_message
  bl add_log_to_history

  pop {pc}


init_controller:
  push {r0-r1, lr}

  ldr r0, =in_net_buf
  ldr r1, =in_net_buf_end
  str r0, [r1]

  pop {r0-r1, pc}


handle_ui_input:
  push {r0-r2, lr}

  cmp r0, #1
  bne 1f
  ldrb r0, [r1]
  cmp r0, #127
  beq 2f
  cmp r0, #13
  beq 5f
  cmp r0, #10
  beq 5f
  cmp r0, #32
  blt 7f
  cmp r0, #126
  bgt 7f
  ldr r1, =message_end
  ldr r2, [r1]
  strb r0, [r2], #1
  str r2, [r1]
  b 7f

  1:
  cmp r0, #3
  bne 7f
  ldrb r0, [r1]
  cmp r0, #27
  bne 7f
  ldrb r0, [r1, #1]
  cmp r0, #91
  bne 7f
  ldrb r0, [r1, #2]
  cmp r0, #65
  beq 3f
  cmp r0, #66
  beq 4f
  b 7f

  2:
  ldr r1, =message_end
  ldr r0, [r1]
  ldr r2, =message_buf
  cmp r0, r2
  beq 7f
  sub r0, r0, #1
  str r0, [r1]
  ldrb r2, [r0, #-1]!
  cmp r2, #13
  streq r0, [r1]
  b 7f

  3:
  ldr r1, =history_scroll
  cmp r1, #0
  beq 7f
  ldr r0, [r1]
  add r0, #2
  str r0, [r1]
  b 7f

  4:
  ldr r1, =history_scroll
  ldr r0, [r1]
  cmp r0, #0
  beq 7f
  sub r0, r0, #2
  str r0, [r1]
  b 7f

  5:
  ldr r1, =message_end
  ldr r1, [r1]
  ldr r2, =message_buf
  cmp r1, r2
  beq 7f
  mov r0, #0
  str r0, [r1]
  ldr r0, =message_buf
  mov r1, #0
  bl add_message_to_history
  bl run_user_command
  tst r0, r0
  beq 6f
  bl send_message
  bl log_error

  6:
  ldr r1, =message_end
  ldr r0, =message_buf
  str r0, [r1]

  7:
  pop {r0-r2, pc}


log_error:
  push {r0-r1, lr}

  tst r0, r0
  beq 1f

  ldr r0, =error_send
  bl add_log_to_history

  1:
  pop {r0-r1, pc}


process_input:
  push {r0-r2, lr}

  bl poll_uart
  tst r0, r0
  beq 3f
  bl recv_uart
  ldr r1, =in_net_buf
  ldr r2, =in_net_buf_end
  ldr r2, [r2]
  cmp r2, r1
  bne 1f
  cmp r0, #47
  bne 2f

  1:
  strb r0, [r2], #1
  ldr r0, =in_net_buf_end
  str r2, [r0]

  2:
  sub r0, r2, r1
  cmp r0, #2
  blt 3f
  ldrb r0, [r2, #-2]
  cmp r0, #10
  bleq run_command

  3:
  pop {r0-r2, pc}


run_user_command:
  push {r1, lr}

  ldr r0, =change_name
  ldr r1, =message_buf
  bl compare_prefix
  tst r0, r0
  beq 1f
  mov r0, #1
  b 2f

  1:
  ldr r0, =name_command
  bl string_length
  ldr r1, =message_buf
  add r0, r1, r0
  bl set_nick
  mov r0, #0
  b 2f

  2:
  pop {r1, pc}


set_nick:
  push {r0-r1, lr}

  ldr r1, =self_nick
  bl copy_string
  bl send_nick

  pop {r0-r1, pc}


send_message:
  push {r1-r2, lr}

  ldr r1, =out_net_buf
  ldr r0, =message_command
  bl copy_string
  add r1, r1, r0
  ldr r0, =message_buf
  bl copy_string
  add r1, r1, r0
  mov r0, #10
  str r0, [r1], #1
  bl write_checksum
  mov r2, #3

  1:
    bl send_buffer
    bl wait_ok
    tst r0, r0
    beq 2f
    subs r2, r2, #1
    beq 2f
  b 1b

  2:
  pop {r1-r2, pc}


send_nick:
  push {r0-r2, lr}

  ldr r1, =out_net_buf
  ldr r0, =name_command
  bl copy_string
  add r1, r1, r0
  ldr r0, =self_nick
  bl copy_string
  add r1, r1, r0
  mov r0, #10
  str r0, [r1], #1
  bl write_checksum
  mov r2, #3

  1:
    bl send_buffer
    bl wait_ok
    tst r0, r0
    beq 2f
    subs r2, r2, #1
    beq 2f
  b 1b

  2:
  pop {r0-r2, pc}


send_ok:
  push {r0-r1, lr}

  ldr r0, =ok_command
  ldr r1, =out_net_buf
  bl copy_string
  add r1, r1, r0
  mov r0, #10
  str r0, [r1], #1
  bl write_checksum
  bl send_buffer

  pop {r0-r1, pc}


send_sync:
  push {r0-r1, lr}

  ldr r0, =sync_command
  ldr r1, =out_net_buf
  bl copy_string
  add r1, r1, r0
  mov r0, #10
  str r0, [r1], #1
  bl write_checksum
  bl send_buffer

  pop {r0-r1,pc}


write_checksum:
  push {r0, r2-r3, lr}

  ldr r0, =out_net_buf
  mov r2, #0

  1:
    ldrb r3, [r0], #1
    add r2, r2, r3
    cmp r0, r1
  bne 1b

  strb r2, [r1], #1

  pop {r0, r2-r3, pc}


send_buffer:
  push {r0-r2, lr}

  ldr r2, =out_net_buf

  1:
    cmp r2, r1
    beq 2f
    ldrb r0, [r2], #1
    bl send_uart
  b 1b

  2:
  pop {r0-r2, pc}


wait_ok:
  push {r1-r2, lr}

  mov r0, #0
  ldr r1, =ok_flag
  str r0, [r1]
  ldr r2, =131072

  1:
    bl process_input
    ldr r0, [r1]
    tst r0, r0
    bne 2f
    subs r2, r2, #1
    beq 3f
  b 1b

  2:
  mov r0, #0
  b 4f

  3:
  mov r0, #1
  b 4f

  4:
  pop {r1-r2, pc}


add_offset_to_history:
  push {r3-r6, lr}

  cmp r3, #0
  beq 2f
  ldr r6, =ws_col
  ldrh r6, [r6]

  1:
    mov r0, #32
    str r0, [r1], #1
    subs r3, r3, #1
  bne 1b

  2:
  pop {r3-r6, pc}


add_message_to_history:
  push {r0-r9,lr}

  push {r0}
  bl string_length
  mov r5, r0
  add r5, r5, #2
  pop {r0}
  mov r2, r0
  push {r0}
  bl string_length
  mov r9, r0
  pop {r0}
  mov r3, r1
  cmp r3, #0
  beq 2f
  ldr r6, =ws_col
  ldrh r6, [r6]
  mov r4, r6
  mov r7, #2
  udiv r6, r6, r7
  cmp r3, r6
  bgt 1f
  sub r3, r4, r3
  sub r3, r3, #4
  b 3f

  1:
  mov r3, r6
  b 3f

  2:
  push {r4, r7}
  ldr r6, =ws_col
  ldrh r6, [r6]
  mov r4, r6
  mov r7, #2
  udiv r6, r6, r7
  pop {r4, r7}
  cmp r9, r6
  blt 1f
  mov r8, r6
  add r8, r8, #4
  b 4f

  1:
  mov r8, r9
  add r8, r8, #4
  b 4f

  3:
  ldr r8, =ws_col
  ldrh r8, [r8]
  sub r8, r8, r3

  4:
  sub r8, r8, #2
  udiv r7, r9, r8
  add r8, r8, #2
  ldr r4, =history_end
  ldr r1, [r4]
  bl add_offset_to_history
  ldr r0, =t_l_b
  bl copy_string
  add r1, r1, r0
  push {r8}
  sub r8, r8, #2

  1:
    ldr r0, =h_b
    bl copy_string
    add r1, r1, r0
    subs r8, r8, #1
  bne 1b

  pop {r8}
  ldr r0, =t_r_b
  bl copy_string
  add r1, r1, r0
  mov r0, #13
  str r0, [r1], #1
  mov r0, #10
  str r0, [r1], #1
 
  3:
  bl add_offset_to_history
  ldr r0, =v_b
  bl copy_string
  add r1, r1, r0
  mov r0, #32
  str r0, [r1], #1
  mov r0, r2
  push {r2}
  mov r2, r8
  sub r2, r2, #4
  bl copy_string
  pop {r2}
  add r2, r2, r8
  sub r2, r2, #4
  add r1, r1, r0
  push {r8}
  sub r8, r8, #4
  cmp r0, r8
  pop {r8}
  blt 1f
  b 2f

  1:
  cmp r0, #0
  beq 2f
  sub r0, r8, r0
  sub r0, r0, #4
  push {r0}

  1:
    push {r0}
    mov r0, #0x20
    str r0, [r1], #1
    pop {r0}
    subs r0, r0, #1
  bne 1b

  pop {r0}

  2:
  mov r0, #32
  str r0, [r1], #1
  ldr r0, =v_b
  bl copy_string
  add r1, r1, r0
  cmp r7, #0
  beq 4f
  subs r7, r7, #1
  b 3b

  4:
  mov r0, #13
  str r0, [r1], #1
  mov r0, #10
  str r0, [r1], #1
  bl add_offset_to_history
  ldr r0, =b_l_b
  bl copy_string
  add r1, r1, r0
  push {r8}
  sub r8, r8, #2

  1:
    ldr r0, =h_b
    bl copy_string
    add r1, r1, r0
    subs r8, r8, #1
  bne 1b

  pop {r8}
  ldr r0, =b_r_b
  bl copy_string
  add r1, r1, r0
  mov r0, #13
  str r0, [r1], #1
  mov r0, #10
  str r0, [r1], #1
  str r1, [r4]
  ldr r1, =history_scroll
  mov r0, #0
  str r0, [r1]

  pop {r0-r9, pc}


add_log_to_history:
  push {r0-r4, lr}

  mov r2, r0
  ldr r4, =history_end
  ldr r1, [r4]  
  mov r0, #13
  str r0, [r1], #1
  mov r0, #10
  str r0, [r1], #1
  mov r0, #32
  str r0, [r1], #1
  mov r0, r2
  bl copy_string
  add r1, r1, r0
  mov r0, #13
  str r0, [r1], #1
  mov r0, #10
  str r0, [r1], #1
  mov r0, #10
  str r0, [r1], #1
  str r1, [r4]
  ldr r1, =history_scroll
  mov r0, #0
  str r0, [r1]

  pop {r0-r4, pc}


run_command:
  push {r0-r2, lr}

  ldr r0, =in_net_buf_end
  ldr r0, [r0]
  mov r2, #0
  strb r2, [r0, #-2]
  ldr r1, =in_net_buf
  ldr r0, =message_command
  bl compare_prefix
  tst r0, r0
  beq 1f
  ldr r0, =name_command
  bl compare_prefix
  tst r0, r0
  beq 2f
  ldr r0, =ok_command
  bl compare_prefix
  tst r0, r0
  beq 3f
  ldr r0, =sync_command
  bl compare_prefix
  tst r0, r0
  beq 4f
  b 5f

  1:
  ldr r0, =message_command
  bl string_length
  add r1, r1, r0
  mov r0, r1
  bl string_length
  mov r3, r0
  mov r0, r1
  mov r1, r3
  bl add_message_to_history
  bl send_ok
  b 5f

  2:
  ldr r0, =name_command
  bl string_length
  add r1, r1, r0
  mov r0, r1
  ldr r1, =other_nick
  bl copy_string
  bl send_ok
  b 5f

  3:
  mov r0, #1
  ldr r1, =ok_flag
  str r0, [r1]
  b 5f

  4:
  bl get_current_time
  ldr r1, =last_sync_recv
  str r0, [r1]
  b 5f

  5:
  ldr r0, =in_net_buf
  ldr r1, =in_net_buf_end
  str r0, [r1]

  pop {r0-r2, pc}


check_sync_state:
  push {r0-r3, lr}

  bl get_current_time
  ldr r1, =last_sync_sent
  ldr r2, [r1]
  sub r2, r0, r2
  cmp r2, #1
  strge r0, [r1]
  blge send_sync
  ldr r1, =last_sync_recv
  ldr r2, [r1]
  sub r2, r0, r2
  ldr r3, =online_flag
  cmp r2, #5
  ble 2f
  b 3f

  2:
  ldr r2, [r3]
  tst r2, r2
  bne 3f

  4:
  mov r0, #1
  str r0, [r3]
  bl send_nick

  3:
  pop {r0-r3, pc}


main_loop:
  push {lr}

  ldr r12, =131072

  1:
    subs r12, #1
    bne 2f
    bl clear_screen
    bl get_window_size
    bl draw_window
    bl draw_history
    bl draw_input
    bl check_sync_state
    ldr r12, =131072

    2:
    bl process_input
    bl kbdhit
    tst r0, r0
  beq 1b

  mov r2, r0
  ldr r1, =key_buf
  mov r0, #0
  mov r7, #3
  svc #0
  ldr r1, =key_buf
  ldrb r2, [r1]
  cmp r2, #3
  beq 3f
  bl handle_ui_input
  b 1b

  3:
  pop {pc}


cleanup:
  push {lr}

  bl reset_terminal
  mov r0, #0
  mov r1, #0
  bl set_cursor_position

  pop {pc}


draw_divider:
  push {r0-r3, r7, lr}

  ldr r3, =ws_col
  ldrh r3, [r3]

  1:
    mov r0, #1
    ldr r1, =win_divider
    mov r2, #lwin_divider
    mov r7, #4
    svc #0
    subs r3, r3, #1
  bne 1b

  pop {r0-r3, r7, pc}


draw_window:
  push {r0-r3, r7, lr}

  mov r0, #0
  mov r1, #1
  bl set_cursor_position
  mov r0, #1
  ldr r1, =welcome_message
  mov r2, #lwelcome_message
  mov r7, #4
  svc #0
  ldr r3, =ws_col
  ldrh r3, [r3]
  ldr r0, =other_nick
  bl string_length
  mov r4, r0
  sub r3, r3, r4
  sub r3, r3, #1
  mov r0, #0
  mov r1, r3
  bl set_cursor_position
  mov r0, #1
  ldr r1, =other_nick
  mov r2, r4
  mov r7, #4
  svc #0
  mov r0, #1
  mov r1, #0
  bl set_cursor_position
  bl draw_divider
  ldr r0, =ws_row
  ldrh r0, [r0]
  sub r0, r0, #1
  sub r0, r0, #1
  mov r1, #0
  bl set_cursor_position
  bl draw_divider

  pop {r0-r3, r7, pc}


draw_input:
  push {r0-r3, r7, lr}

  ldr r0, =self_nick
  bl string_length
  mov r4, r0
  ldr r0, =ws_row
  ldrh r0, [r0]
  sub r0, r0, #1
  mov r1, #0
  push {r0, r1}
  bl set_cursor_position
  mov r0, #1
  ldr r1, =self_nick
  mov r2, r4
  mov r7, #4
  svc #0
  mov r0, #1
  ldr r1, =input
  mov r2, #2
  mov r7, #4
  svc #0
  pop {r0, r1}
  add r1, r1, r4
  add r1, r1, #2
  bl set_cursor_position
  ldr r0, =input_buf
  ldr r1, =message_end
  ldr r1, [r1]
  mov r2, #1
  ldr r3, =ws_col
  ldrh r3, [r3]
  sub r3, r3, r4
  sub r3, r3, #1
  bl skip_lines
  sub r2, r1, r0
  mov r1, r0
  mov r0, #1
  mov r7, #4
  svc #0

  pop {r0-r3, r7, pc}


draw_history:
  push {r0-r12, lr}

  ldr r10, =ws_row
  ldrh r10, [r10]
  sub r10, r10, #1
  sub r10, r10, #2
  mov r11, #0
  add r11, r11, #2
  ldr r0, =history_buf
  ldr r1, =history_end
  ldr r1, [r1]
  ldr r2, =history_scroll
  ldr r2, [r2]
  ldr r3, =ws_col
  ldrh r3, [r3]
  bl skip_lines
  mov r9, r0
  ldr r0, =history_buf
  mov r1, r9
  mov r2, r10
  ldr r3, =ws_col
  ldrh r3, [r3]
  bl skip_lines
  mov r8, r0
  sub r2, r9, r8
  mov r0, r11
  mov r1, #0
  bl set_cursor_position
  mov r0, #1
  mov r1, r8
  mov r7, #4
  svc #0

  pop {r0-r12, pc}


get_window_size:
  push {r0-r2, lr}

  mov r0, #0
  ldr r1, =21523
  ldr r2, =winsize
  bl ioctl

  pop {r0-r2, pc}



.data


sequence: .asciz "\033["
vertical_offset_sequence: .asciz "d"
horizontal_offset_sequence: .asciz "G"
clear_sequence: .asciz "J"
reset_sequence: .asciz "\033c"
dev_mem: .asciz "/dev/mem"
sudo_err: .asciz "Cannot open /dev/mem\n"
usage_message: .ascii "Usage: ./chat <uart num>\n"
input: .ascii "> "
no_nick: .asciz "noname"
error_send: .asciz "Error: Destination Host Unreachable."
first_message: .asciz "Команда 'name: nick' меняет ник."
welcome_message: .asciz "⭐ SUPER CHAT ⭐"
lwelcome_message = . - welcome_message
message_command: .asciz "/message "
name_command: .asciz "/name "
change_name: .asciz "name:"
ok_command: .asciz "/ok"
sync_command: .asciz "/sync"
t_l_b: .ascii "┌\0"
h_b: .ascii "─\0"
v_b: .ascii "│\0"
v_b_n: .ascii "│\n\0"
t_r_b: .ascii "┐\0"
b_l_b: .ascii "└\0"
b_r_b: .ascii "┘\0"
dash: .ascii "—\0"
win_divider: .ascii "─"
lwin_divider = . - win_divider



.bss


kbdhit_n: .space 4
termios_old: .space 60
termios_new: .space 60
print_buf: .space 1000
dev_mem_handle: .space 4
rtc_mem_base: .space 4
ccu_mem: .space 4
uart_mem: .space 4
uart_no: .space 4
online_flag: .space 4
message_scroll: .space 4
message_end: .space 2
input_buf: .space 2
message_buf: .space 1000000
history_scroll: .space 4
history_end: .space 4
history_buf: .space 1000000
self_nick: .space 256
other_nick: .space 256
last_sync_sent: .space 4
last_sync_recv: .space 4
ok_flag: .space 4
in_net_buf_end: .space 4
out_net_buf: .space 1000
in_net_buf: .space 1000
winsize:
ws_row: .space 2
ws_col: .space 2
ws_xpixel: .space 2
ws_ypixel: .space 2
key_buf: .space 10
