ARCH ?= x86_64
TARGET ?= $(ARCH)-elf

ifneq ($(OVERRIDE), 1)
	MAKE := make
	CC := $(TARGET)-gcc
	LD := $(TARGET)-ld
	ASM := nasm
	AR := $(TARGET)-ar
endif

CFLAGS ?= -O2
CPPFLAGS ?=
LDFLAGS ?=
LIBS ?=

SYSROOT ?= ../sysroot
DESTDIR ?= $(SYSROOT)
PREFIX ?= /usr/local
EXEC_PREFIX ?= $(PREFIX)
BOOTDIR ?= $(EXEC_PREFIX)/boot
INCLUDEDIR ?= $(PREFIX)/include

CFLAGS := $(CFLAGS) -ffreestanding -fbuiltin -Wall -Wextra
CPPFLAGS := $(CPPFLAGS) -Iinclude
LDFLAGS := $(LDFLAGS)
LIBS :=  $(LIBS) -nostdlib -lk -lgcc

ARCHDIR := arch/$(ARCH)

include $(ARCHDIR)/make.config

KERNEL_OBJS := \
	kernel.o \
	$(patsubst %.c, %.o, $(wildcard kernel/*.c))
OBJS := $(KERNEL_ARCH_OBJS) $(KERNEL_OBJS)

all: kernel.bin

.PHONY: all clean headers install

kernel.bin: $(OBJS) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(OBJS) $(LDFLAGS) $(LIBS)

%.o: %.c
	$(CC) -c $< -o $@ -std=gnu11 $(CFLAGS) $(CPPFLAGS)

%.o: %.asm
	$(ASM) -felf64 $< -o $@

clean:
	rm -f kernel.bin $(OBJS) *.o */*.o */*/*.o

install: headers kernel.bin
	mkdir -p $(DESTDIR)$(BOOTDIR)
	cp kernel.bin $(DESTDIR)$(BOOTDIR)

headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -RTv include $(DESTDIR)$(INCLUDEDIR)
