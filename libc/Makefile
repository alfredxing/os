ARCH ?= x86_64
TARGET ?= $(ARCH)-elf

ifneq ($(OVERRIDE), 1)
	CC := $(TARGET)-gcc
	LD := $(TARGET)-ld
	ASM := nasm
	AR := $(TARGET)-ar
endif

CFLAGS ?= -O2
CPPFLAGS ?=
LDFLAGS ?=
LIBS ?=

DESTDIR ?= ../sysroot
PREFIX ?= /usr/local
EXEC_PREFIX ?= $(PREFIX)
INCLUDEDIR ?= $(PREFIX)/include
LIBDIR ?= $(EXEC_PREFIX)/lib

CLFAGS := $(CFLAGS) -Wall -Wextra
CPPFLAGS := $(CPPFLAGS) -Iinclude
LIBK_CFLAGS := $(CFLAGS) -ffreestanding -fbuiltin
LIBK_CPPFLAGS := $(CPPFLAGS)

ARCHDIR := arch/$(ARCH)

include $(ARCHDIR)/make.config

CFLAGS := $(CFLAGS) $(ARCH_CFLAGS)
CPPFLAGS := $(CPPFLAGS) $(ARCH_CPPFLAGS)
LIBK_CFLAGS := $(LIBK_CFLAGS) $(KERNEL_ARCH_CFLAGS)
LIBK_CPPFLAGS := $(LIBK_CPPFLAGS) $(KERNEL_ARCH_CPPFLAGS)

FREEOBJS := \
	$(ARCH_FREEOBJS) \
	$(patsubst %.c, %.o, $(wildcard *.c)) \
	$(patsubst %.c, %.o, $(wildcard */*.c))

HOSTEDOBJS := \
	$(ARCH_HOSTEDOBJS)

OBJS := \
	$(FREEOBJS) \
	$(HOSTEDOBJS)

LIBK_OBJS := $(FREEOBJS:.o=.libk.o)

BINARIES = libc.a libg.a libk.a

all: $(BINARIES)

.PHONY: all clean install headers libs

libc.a: $(OBJS)
	$(AR) rcs $@ $(OBJS)

libg.a:
	$(AR) rcs $@

libk.a: $(LIBK_OBJS)
	$(AR) rcs $@ $(LIBK_OBJS)

%.o: %.c
	$(CC) -c $< -o $@ -std=gnu11 $(CFLAGS) $(CPPFLAGS)

%.o: %.asm
	$(ASM) -felf64 $< -o $@

%.libk.o: %.c
	$(CC) -c $< -o $@ -std=gnu11 $(LIBK_CFLAGS) $(LIBK_CPPFLAGS)

%.libk.o: %.asm
	$(ASM) -felf64 $< -o $@

clean:
	rm -rf $(BINARIES) $(OBJS) $(LIBK_OBJS) *.o */*.o */*/*.o

install: headers libs

headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -RTv include $(DESTDIR)$(INCLUDEDIR)

libs: $(BINARIES)
	mkdir -p $(DESTDIR)$(LIBDIR)
	cp $(BINARIES) $(DESTDIR)$(LIBDIR)
