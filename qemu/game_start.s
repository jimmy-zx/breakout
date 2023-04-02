	.include	"gdefs.s"
	.include	"inc1.s"

.data
brick_colors:
	.word	kBrickColor1
	.word	kBrickColor2
	.word	kBrickColor3
	.word	kBrickColor4

.text

	.globl	game_start
	.ent	game_start
game_start:
	.frame	$fp,60,$ra
	fprol	60
	savesr	60

	# draw background
	# draw(x=0, y=0, color=kBgColor, dx=kWidth, dy=kHeight)
	li	$a0,0
	li	$a1,0
	li	$a2,kBgColor
	li	$a3,kWidth
	li	$t0,kHeight
	sw	$t0,16($fp)
	jal	drawbox

	la	$t0,cscore
	lw	$t1,0($t0)
	la	$t2,max_score
	lw	$t3,0($t2)
	ble	$t1,$t3,noupdatemaxscore
	sw	$t1,0($t2)
noupdatemaxscore:
	li	$t1,0
	sw	$t1,0($t0)
	jal	game_scoreinit
	jal	game_scoreupdate

	# draw top wall
	# draw(x=0, y=kTWallTMargin, color=kWallColor, dx=kWidth, dy=kWallWidth)
	li	$a0,0
	li	$a1,kTWallTMargin
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

	loadsr	60
	fepil	60
	jr	$ra
	.end	game_start

# vim: set noet ts=16 sts=16 sw=16:
