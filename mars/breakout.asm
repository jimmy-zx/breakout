.include	"inc.s"
.include	"gdefs.s"

.text
.globl	main
main:
	jal	run
	li	$v0,10
	syscall

# vim: set noet ts=16 sts=16 sw=16:
