	.include	"inc1.s"

.text
# getbox(x, y, dx, dy)
	.globl	getbox
getbox:
	fprol	56
	savesr	56
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
	loadsr	56
	fepil	56
	jr	$ra

# vim: set noet ts=16 sts=16 sw=16:
