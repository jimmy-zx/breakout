.include	"gdefs.s"
.include	"inc.s"

.data
brick_colors:
	.word	kBrickColor1
	.word	kBrickColor2
	.word	kBrickColor3
	.word	kBrickColor4

.text

.globl	game_start
game_start:
	fprologue
	addi	$sp,$sp,-4	# allocate stack for arg4
	addi	$fp,$fp,-4

	# draw top wall
	# draw(x=0, y=0, color=kWallColor, dx=kWidth, dy=kWallWidth)
	li	$a0,0
	li	$a1,0
	li	$a2,kWallColor
	li	$a3,kWidth
	li	$t0,kWallWidth
	sw	$t0,16($fp)
	jal	drawbox

	# draw left wall
	# draw(x=0, y=0, color=white, dx=kWallWidth, dy=kHeight)
	li	$a0,0
	li	$a1,0
	li	$a2,kWallColor
	li	$a3,kWallWidth
	li	$t0,kHeight
	sw	$t0,16($fp)
	jal	drawbox

	# draw right wall
	# draw(x=kWidth-kWallWidth, y=0, color=white, dx=kWallWidth, dy=kHeight)
	li	$a0,kWidth
	addi	$a0,$a0,-kWallWidth
	li	$a1,0
	li	$a2,kWallColor
	li	$a3,kWallWidth
	li	$t0,kHeight
	sw	$t0,16($fp)
	jal	drawbox

	addi	$sp,$sp,-8	# allocate stack for $s0,$s1
	addi	$fp,$fp,-8
	sw	$s0,24($fp)
	sw	$s1,20($fp)

	# draw the bricks
	li	$s0,0	# col = 0
	li	$s1,0	# row = 0
brick_loop:
	# drawbox(x=kBrickLMargin + col * (kBrickWidth + kBrickHSpace),
	#      y=kBrickTMargin + row * (kBrickHeight + kBrickVSpace),
	#      color=*(brick_colors + row * sizeof(char)),
	#      dx=kBrickWidth, dy=kBrickHeight)
	li	$a0,kBrickWidth
	li	$t0,kBrickHSpace
	add	$a0,$a0,$t0	# $a0 = kBrickWidth + kBrickHSpace
	mul	$a0,$a0,$s0	# $a0 = col * (kBrickWidth + kBrickHSpace)
	addi	$a0,$a0,kBrickLMargin	# x = kBrickLMargin + col * (kBrickWidth + kBrickHSpace)
	li	$a1,kBrickHeight
	li	$t0,kBrickVSpace
	add	$a1,$a1,$t0	# $a1 = kBrickHeight + kBrickVSpace
	mul	$a1,$a1,$s1	# $a1 = row * (kBrickHeight + kBrickVSpace)
	addi	$a1,$a1,kBrickTMargin	# y = kBrigkTMargin + col * (kBrickHeight + kBrickVSpace)
	la	$t1,brick_colors
	li	$t2,4
	mul	$t2,$s1,$t2	# $t2 = 4 * row
	add	$t2,$t1,$t2	# $t2 = brick_colors + 4 * row
	lw	$a2,0($t2)	# color = *($gp + brick_colors + 4 * row)
	li	$a3,kBrickWidth	# dx = kBrickWidth
	li	$t0,kBrickHeight
	sw	$t0,16($fp)	# dy = kBrickHeight
	jal	drawbox

	addi	$s0,$s0,1	# col += 1
	addi	$t0,$s0,-kBrickColumn	# t0 = col - kNumColumn
	blt	$t0,$zero,brick_loop	# if (col < kNumColumn) goto brick_loop
	addi	$s1,$s1,1	# row += 1
	xor	$s0,$s0,$s0	# col = 0
	addi	$t0,$s1,-kBrickRow	# t0 = row - kNumRow
	blt	$t0,$zero,brick_loop	# if (row < kNumRow) goto brick_loop

	# initialize paddle location
	la	$t0,paddle_x
	li	$t1,kPaddleInitX
	sw	$t1,0($t0)
	la	$t0,paddle_y
	li	$t1,kPaddleInitY
	sw	$t1,0($t0)
	# draw the paddle
	li	$a0,kPaddleColor
	jal	game_render_paddle

	# initialize ball location
	la	$t0,ball_x
	li	$t1,kBallInitX
	sw	$t1,0($t0)
	la	$t0,ball_y
	li	$t1,kBallInitY
	sw	$t1,0($t0)
	la	$t0,ball_vx
	li	$t1,kBallInitVX
	sw	$t1,0($t0)
	la	$t0,ball_vy
	li	$t1,kBallInitVY
	sw	$t1,0($t0)
	# draw the ball
	li	$a0,kBallColor
	jal	game_render_ball

	lw	$s1,20($fp)
	lw	$s0,24($fp)
	addi	$fp,$fp,8
	addi	$sp,$sp,8

	addi	$fp,$fp,4
	addi	$sp,$sp,4
	fepilogue
	jr	$ra

# vim: set noet ts=16 sts=16 sw=16:
