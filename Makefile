PROJECTS := libc kernel
SYSTEM_HEADER_PROJECTS := libc kernel

export ARCH ?= x86_64
export TARGET ?= $(ARCH)-elf

ifneq ($(OVERRIDE), 1)
	export MAKE := make -j
	export CC := $(TARGET)-gcc
	export LD := $(TARGET)-ld
	export ASM := nasm
	export AR := $(TARGET)-ar
	export OVERRIDE = 1
endif

export PREFIX ?= /usr
export EXEC_PREFIX ?= $(PREFIX)
export BOOTDIR ?= /boot
export LIBDIR ?= $(EXEC_PREFIX)/lib
export INCLUDEDIR ?= $(PREFIX)/include

CFLAGS ?=
CPPFLAGS ?=
export CFLAGS := $(CFLAGS) -O2
export CPPFLAGS := $(CPPFLAGS)

PWD := $(shell pwd)
SYSROOT := $(PWD)/sysroot
export CC := $(CC) --sysroot=$(SYSROOT)
export LD := $(LD) --sysroot=$(SYSROOT)

# Workaround for -elf targets
ifeq ($(findstring -elf, $(TARGET)), -elf)
	export CC := $(CC) -isystem=$(INCLUDEDIR)
endif

ISOFILE := os.iso

.PHONY: all headers clean iso vbox

all: build

clean:
	rm -rf sysroot
	rm -f $(ISOFILE)
	for PROJECT in $(PROJECTS); do \
		$(MAKE) -C $$PROJECT clean; \
	done

headers:
	mkdir -p $(SYSROOT)
	for PROJECT in $(SYSTEM_HEADER_PROJECTS); do \
		DESTDIR="$(SYSROOT)" $(MAKE) -C $$PROJECT headers; \
	done

build: headers
	for PROJECT in $(PROJECTS); do \
		DESTDIR="$(SYSROOT)" $(MAKE) -C $$PROJECT install; \
	done

iso: build
	mkdir -p isodir/boot/grub
	cp sysroot/boot/kernel.bin isodir/boot/kernel.bin
	cp boot/grub/grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(ISOFILE) isodir

vbox: iso
	vboxmanage controlvm OS reset
