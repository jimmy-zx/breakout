# 	.include	"inc1.s"




# vim: set noet ts=8 sts=8 sw=8:

.text
# getbox(x, y, dx, dy)
	.globl	getbox
getbox:
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
			# 52($fp) = dy
			# 48($fp) = dx
			# 44($fp) = y
			# 40($fp) = x
			# 36($fp) = $ra
			# 32($fp) = old $fp
	move	$s0,$a0	# $s0 = curx = x
	move	$s1,$a1	# $s1 = cury = y
	add	$s2,$a0,$a2	# $s2 = maxx = x + dx
	add	$s3,$a1,$a3	# $s3 = maxy = y + dy
getbox_inner:
	addi	$a0,$s0,0	# $a0 = curx
	addi	$a1,$s1,0	# $a1 = cury
	jal	plot_get	# plot_get(curx, cury)
	bne	$v0,$zero,getbox_end	
	addi	$s0,$s0,1	# $s0 = curx += 1
	blt	$s0,$s2,getbox_inner	# if (curx < maxx) goto inner

	addi	$s1,$s1,1	# $s1 = cury += 1
	lw	$s0,56($fp)	# $s0 = curx = x
	blt	$s1,$s3,getbox_inner	# if (cury < maxy) goto inner

	li	$v0,0	
getbox_end:
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

# vim: set noet ts=16 sts=16 sw=16:
