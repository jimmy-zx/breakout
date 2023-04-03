# 	.include	"inc1.s"




# vim: set noet ts=8 sts=8 sw=8:

# drawstr(x, y, color, str, strlen)
	.globl	drawstr
	.ent	drawstr
drawstr:
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
	.end	drawstr

# vim: set noet ts=16 sts=16 sw=16:
