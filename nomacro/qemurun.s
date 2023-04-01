# 	.include	"inc1.s"




# vim: set noet ts=8 sts=8 sw=8:

.text
	.globl	main
	.ent	main
main:
	.frame	$fp,24,$ra
# 	fprol	24
	addiu	$sp,$sp,-24	
	sw	$a3,36($sp)	
	sw	$a2,32($sp)	
	sw	$a1,28($sp)	
	sw	$a0,24($sp)	
	sw	$ra,20($sp)	
	sw	$fp,16($sp)	
	move	$fp,$sp	
	move	$fp,$sp	
	jal	run	
# 	fepil	24
	move	$sp,$fp	
	lw	$ra,20($sp)	
	lw	$fp,16($sp)	
	addiu	$sp,$sp,24	
	jr	$ra	
	.end	main

# vim: set noet ts=16 sts=16 sw=16:
