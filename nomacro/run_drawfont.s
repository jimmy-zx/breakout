# 	.include	"inc1.s"




# vim: set noet ts=8 sts=8 sw=8:

	.globl	main
	.ent	main
main:
	.frame	$fp,56,$ra
# 	fprol	56
	addiu	$sp,$sp,-56	
	sw	$a3,68($sp)	
	sw	$a2,64($sp)	
	sw	$a1,60($sp)	
	sw	$a0,56($sp)	
	sw	$ra,52($sp)	
	sw	$fp,48($sp)	
	move	$fp,$sp	
# 	savesr	56
	sw	$s7,44($sp)	
	sw	$s6,40($sp)	
	sw	$s5,36($sp)	
	sw	$s4,32($sp)	
	sw	$s3,28($sp)	
	sw	$s2,24($sp)	
	sw	$s1,20($sp)	
	sw	$s0,16($sp)	
	jal	plot_init	
	li	$a0,66	
	li	$a1,50	
	li	$a2,60	
	li	$a3,0x66ccff	
	jal	drawfont	
# 	loadsr	56
	lw	$s7,44($sp)	
	lw	$s6,40($sp)	
	lw	$s5,36($sp)	
	lw	$s4,32($sp)	
	lw	$s3,28($sp)	
	lw	$s2,24($sp)	
	lw	$s1,20($sp)	
	lw	$s0,16($sp)	
# 	fepil	56
	move	$sp,$fp	
	lw	$ra,52($sp)	
	lw	$fp,48($sp)	
	addiu	$sp,$sp,56	
	jr	$ra	
	.end	main
