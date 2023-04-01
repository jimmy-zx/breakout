# .include	"inc.s"



# vim: set noet ts=16 sts=16 sw=16:

.text
# run()
.globl	run
run:
# 	fprologue
	addi	$sp,$sp,-24	# stack (24)
	sw	$fp,16($sp)	# backup old $fp
	addi	$fp,$sp,0	# setup new $fp
	sw	$a3,36($fp)	# 36($fp) = $a3
	sw	$a2,32($fp)	# 32($fp) = $a2
	sw	$a1,28($fp)	# 28($fp) = $a1
	sw	$a0,24($fp)	# 24($fp) = $a0
	sw	$ra,20($fp)	# 20($fp) = $ra
			# 16($fp) = old $fp
	addi	$sp,$sp,-4	
	addi	$fp,$fp,-4	
	jal	plot_init	
	bne	$v0,$zero,run_exit	

	li	$a0,0	
	li	$a1,0	
	li	$a2,0x66ccff	
	li	$a3,0x30	
	li	$t0,0x20	
	sw	$t0,16($fp)	
	jal	drawbox	
	bne	$v0,$zero,run_exit	

	jal	plot_deinit	
	li	$v0,0	
run_exit:
	addi	$sp,$sp,4	
	addi	$fp,$fp,4	
# 	fepilogue
	lw	$ra,20($fp)	
	lw	$fp,16($fp)	
	addi	$sp,$sp,24	
	jr	$ra	

# vim: set noet ts=16 sts=16 sw=16:
