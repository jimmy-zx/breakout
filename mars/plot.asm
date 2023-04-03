.include	"inc.asm"

.eqv	kWidth,256	# number of pixels in x-axis
.eqv	kHeight,256	# number of pixels in y-axis

.data

plot_mem:
	.word	0x10040000	# display base address
plot_mem_max:
	.word	0x10080000

.text

.globl	plot_init
plot_init:
	li	$v0,0
	jr	$ra

.globl	plot_deinit
plot_deinit:
	jr	$ra

# plot_draw(x, y, color)
.globl	plot_draw
plot_draw:
			# $a0 = x
			# $a1 = y
			# $a2 = color
	li	$t0,kWidth	# $t0 = kWidth
	mul	$t0,$t0,$a1	# $t0 *= y
	add	$t0,$t0,$a0	# $t0 += x
	mul	$t0,$t0,4	# $t0 *= 4
	lw	$t1,plot_mem	# $t1 = &plot_mem
	add	$t1,$t1,$t0	# $t1 += $t0
	lw	$t2,plot_mem_max
	li	$v0,1
	bgt	$t1,$t2,plot_draw_end
	sw	$a2,($t1)	# *$t1 = color
	li	$v0,0	# $v0 = 0
plot_draw_end:
	jr	$ra	# return

# plot_get(x, y)
.globl	plot_get
plot_get:
	li	$t0,kWidth	# $t0 = kWidth
	mul	$t0,$t0,$a1	# $t0 *= y
	add	$t0,$t0,$a0	# $t0 += x
	mul	$t0,$t0,4	# $t0 *= 4
	lw	$t1,plot_mem	# $t1 = &plot_mem
	add	$t1,$t1,$t0	# $t1 += $t0
	lw	$v0,($t1)	# $v0 = *$t1 = color
	jr	$ra

# vim: set noet ts=16 sts=16 sw=16:
