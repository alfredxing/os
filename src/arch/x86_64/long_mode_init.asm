global long_mode_start

section .text
bits 64
long_mode_start:
	; Call kernel.c main
	extern kernel_main
	call kernel_main

	cli
	hlt
