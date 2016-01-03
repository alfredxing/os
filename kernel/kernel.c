#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include <kernel/tty.h>

void kernel_main() {
	// Initialize terminal
	terminal_initialize();

	printf("Hello world!\n\n"
		"This is the 05 kernel.\n"
		"It can't do anything yet except print!\n");
}
