global long_mode_start

section .text
bits 64
long_mode_start:
	; Print `OKAY` to screen
	mov rax, 0x022002690248
	mov qword [0xb8000], rax
	hlt
