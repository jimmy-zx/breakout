	.include	"inc1.s"

.text
# drawbox(x, y, color, dx, dy)
	.globl	drawbox
	.ent	drawbox
drawbox:
	.frame	$fp,56,$ra
	fprol	56
	savesr	56
			# 56($fp) = dy
			# 52($fp) = dx
			# 48($fp) = color
			# 44($fp) = y
			# 40($fp) = x
			# 36($fp) = $ra
			# 32($fp) = old $fp
	move	$s0,$a0	# $s0 = curx = x
	move	$s1,$a1	# $s1 = cury = y
	add	$s2,$a0,$a3	# $s2 = maxx = x + dx
	lw	$a3,72($fp)	# $a3 = dy
	add	$s3,$a1,$a3	# $s3 = maxy = y + dy
drawbox_inner:
	addi	$a0,$s0,0	# $a0 = curx
	addi	$a1,$s1,0	# $a1 = cury
	lw	$a2,64($fp)	# $a2 = color
	jal	plot_draw	# plot_draw(curx, cury, color)
	bne	$v0,$zero,drawbox_end
	addi	$s0,$s0,1	# $s0 = curx += 1
	blt	$s0,$s2,drawbox_inner	# if (curx < maxx) goto inner

	addi	$s1,$s1,1	# $s1 = cury += 1
	lw	$s0,56($fp)	# $s0 = curx = x
	blt	$s1,$s3,drawbox_inner	# if (cury < maxy) goto inner

	li	$v0,0
drawbox_end:
	loadsr	56
	fepil	56
	jr	$ra
	.end	drawbox

# vim: set noet ts=16 sts=16 sw=16:
