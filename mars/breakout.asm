	.include	"inc.asm"

.text
	.globl	main
main:
	fprologue
	jal	run
	fepilogue
	li	$v0,10
	syscall

# vim: set noet ts=16 sts=16 sw=16:
