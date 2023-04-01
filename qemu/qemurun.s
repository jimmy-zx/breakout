	.include	"inc1.s"

.text
	.globl	main
	.ent	main
main:
	.frame	$fp,24,$ra
	fprol	24
	move	$fp,$sp
	jal	run
	fepil	24
	jr	$ra
	.end	main

# vim: set noet ts=16 sts=16 sw=16:
