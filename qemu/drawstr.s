	.include	"inc1.s"

# drawstr(x, y, color, str, strlen)
	.globl	drawstr
	.ent	drawstr
drawstr:
	.frame	$fp,56,$ra
	fprol	56
	savesr	56
	move	$s0,$a0	# screenx
	move	$s1,$a1	# screeny
	move	$s2,$a2	# color
	move	$s3,$a3	# str
	lw	$t0,72($sp)	# $t0 = strlen
	add	$s4,$s3,$t0	# maxstr
loop:
	lb	$a0,0($s3)
	#lw	$a0,0($s3)
	#srl	$a0,$a0,24
	move	$a1,$s0
	move	$a2,$s1
	move	$a3,$s2
	jal	drawfont	# drawfont(str[0], screenx, screeny)
	addi	$s0,$s0,8	# screenx += 8
	addi	$s3,$s3,1	# (char *)str += 1
	blt	$s3,$s4,loop

	loadsr	56
	fepil	56
	jr	$ra
	.end	drawstr

# vim: set noet ts=16 sts=16 sw=16:
