#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include <kernel/vga.h>

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_colour;
uint16_t* terminal_buffer;

void terminal_clearline(size_t y) {
	for (size_t x = 0; x < VGA_WIDTH; x++) {
		const size_t index = y * VGA_WIDTH + x;
		terminal_buffer[index] = make_vgaentry(' ', terminal_colour);
	}
}

void terminal_initialize() {
	terminal_row = 0;
	terminal_column = 0;
	terminal_colour = make_colour(COLOUR_LIGHT_GREY, COLOUR_BLACK);
	terminal_buffer = (uint16_t*) 0xB8000;

	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		terminal_clearline(y);
	}
}

void terminal_setcolour(uint8_t colour) {
	terminal_colour = colour;
}

void terminal_scroll() {
	for (size_t y = 1; y < VGA_HEIGHT; y++) {
		terminal_clearline(y - 1);
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			const size_t new = (y - 1) * VGA_WIDTH + x;
			terminal_buffer[new] = terminal_buffer[index];
		}
	}

	terminal_row = VGA_HEIGHT - 1;
	terminal_column = 0;
	terminal_clearline(terminal_row);
}

void terminal_putentryat(char c, uint8_t colour, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = make_vgaentry(c, colour);
}

void terminal_putchar(char c) {
	// Check for newline
	if (c == '\n') {
		terminal_column = 0;
		if (++terminal_row == VGA_HEIGHT) {
			terminal_scroll();
		}
		return;
	}

	terminal_putentryat(c, terminal_colour, terminal_column, terminal_row);
	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		if (++terminal_row == VGA_HEIGHT) {
			terminal_scroll();
		}
	}
}

void terminal_write(const char* data, size_t size) {
	for (size_t i = 0; i < size; i++)
		terminal_putchar(data[i]);
}

void terminal_writestring(const char* data) {
	terminal_write(data, strlen(data));
}