.include	"inc.asm"

.text
# getbox(x, y, dx, dy)
.globl	getbox
getbox:
	fprologue
			# 52($fp) = dy
			# 48($fp) = dx
			# 44($fp) = y
			# 40($fp) = x
			# 36($fp) = $ra
			# 32($fp) = old $fp
	addi	$sp,$sp,-16
	addi	$fp,$fp,-16
	sw	$s3,28($fp)
	sw	$s2,24($fp)
	sw	$s1,20($fp)
	sw	$s0,16($fp)
	addi	$s0,$a0,0	# $s0 = curx = x
	addi	$s1,$a1,0	# $s1 = cury = y
	add	$s2,$a0,$a2	# $s2 = maxx = x + dx
	add	$s3,$a1,$a3	# $s3 = maxy = y + dy
getbox_inner:
	addi	$a0,$s0,0	# $a0 = curx
	addi	$a1,$s1,0	# $a1 = cury
	lw	$a2,48($fp)	# $a2 = color
	jal	plot_get	# plot_get(curx, cury)
	bne	$v0,$zero,getbox_end
	addi	$s0,$s0,1	# $s0 = curx += 1
	blt	$s0,$s2,getbox_inner	# if (curx < maxx) goto inner

	addi	$s1,$s1,1	# $s1 = cury += 1
	lw	$s0,40($fp)	# $s0 = curx = x
	blt	$s1,$s3,getbox_inner	# if (cury < maxy) goto inner

	li	$v0,0
getbox_end:
	lw	$s0,16($fp)
	lw	$s1,20($fp)
	lw	$s2,24($fp)
	lw	$s3,28($fp)
	addi	$fp,$fp,16
	addi	$sp,$sp,16
	fepilogue
	jr	$ra

# vim: set noet ts=16 sts=16 sw=16:
