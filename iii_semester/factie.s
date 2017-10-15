.global main


.text
main:
	push {lr}

	ldr r1, =cells_count
	ldr r1, [r1]

	printing_background:
		push {r1}
		ldr	r0, =blue_cell
		bl printf
		pop {r1}
		subs r1, r1, #1
		bne printing_background

	ldr r2, =input_number
	ldr r2, [r2]
	mov r1, #1

	calculating_factorial:
		muls r1, r1, r2
		subs r2, r2, #1
		bne calculating_factorial

	mov r4, #0
	push {r4}
	mov r4, #1000

	stacking_triples:
		ldr r3, =0x418938  @ (2^32 // 1000) + 1
		umull r9, r3, r1, r3  @ r3 = r1 // 1000
		mul r2, r3, r4
		sub r2, r1, r2  @ r2 = reminder
		push {r2}
		movs r1, r3
		bne stacking_triples

	ldr r0, =center_sequence
	bl printf

	printing_triples:
		pop {r1}
		cmp r1, #0
		beq printing_reset
		ldr r0, =output
		bl printf
		b printing_triples

	printing_reset:
		ldr r0, =reset_sequence
		bl printf

	pop {pc}


.data
	input_number:		.word	14
	cells_count:		.word	158 * 46
	blue_cell:			.ascii	"\033[44m \0"
	center_sequence:	.ascii	"\033[23;75f\0"
	reset_sequence:		.ascii	"\033[75;0f\033[0m\0"
	output:				.ascii	"\033[1;35;44;5m%lu \0"

