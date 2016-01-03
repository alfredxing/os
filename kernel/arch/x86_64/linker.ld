ENTRY(start)

SECTIONS {
	. = 4K;

	.boot BLOCK(4K) : ALIGN(4K)
	{
		*(.multiboot)
	}

	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.text)
	}
}
