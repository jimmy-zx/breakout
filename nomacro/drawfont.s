# 	.include	"inc1.s"




# vim: set noet ts=8 sts=8 sw=8:

# drawfont(ch, x, y, color)
	.globl	drawfont
	.ent	drawfont
drawfont:
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

	li	$s0,7	# dx
	li	$s1,0	# dy
	mul	$s2,$a0,64	# ptr = ch * 16 * sizeof(char)
	la	$t0,font_begin	
	add	$s2,$s2,$t0	# ptr = font_begin + ch * 16
	move	$s3,$a1	# screen_x = x
	move	$s4,$a2	# screen_y = y
	move	$s5,$a3	# color = color

drawfont_loop:
	li	$t0,1	# scn = 1
	sllv	$t0,$t0,$s0	# scn = (1 << x)
	lw	$t1,0($s2)	# present = *ptr
	and	$t1,$t1,$t0	# present = *ptr & (1 << h)
	beq	$t1,$0,drawfont_next	# if (!present) goto next
	move	$a0,$s3	
	move	$a1,$s4	
	move	$a2,$s5	
	jal	plot_draw	# plot_draw(screen_x, screen_y, color)
drawfont_next:
	addi	$s0,$s0,-1	# dx += 1
	addi	$s3,$s3,1	# screen_x += 1
	bne	$s0,0,drawfont_loop	
	li	$s0,7	# dx = 0
	lw	$s3,60($sp)	# screen_x = x
	addi	$s1,$s1,1	# dy += 1
	addi	$s4,$s4,1	# screen_y += 1
	addi	$s2,$s2,4	# ptr += 1 WORD
	blt	$s1,16,drawfont_loop	

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
	.end	drawfont

# vim: set noet ts=16 sts=16 sw=16:
