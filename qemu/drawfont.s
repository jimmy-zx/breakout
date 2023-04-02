	.include	"inc1.s"

# drawfont(ch, x, y, color)
	.globl	drawfont
	.ent	drawfont
drawfont:
	.frame	$fp,56,$ra
	fprol	56
	savesr	56

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

	loadsr	56
	fepil	56
	jr	$ra
	.end	drawfont

# vim: set noet ts=16 sts=16 sw=16:
