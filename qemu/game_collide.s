	.include	"inc1.s"
	.include	"gdefs.s"

# game_ball_testx() - Test whether collide in x-direction
#	call this function BEFORE movement
	.globl	game_ball_testx
	.ent	game_ball_testx
game_ball_testx:
	.frame	$fp,24,$ra
	fprol	24
	la	$t0,ball_x
	lw	$a0,0($t0)	# $a0 = ball_x
	addi	$a0,$a0,-1	# x = ball_x - 1
	la	$t0,ball_y
	lw	$a1,0($t0)	# y = ball_y
	li	$a2,1	# dx = 1
	li	$a3,kBallHeight	# dy = kBallHeight
	la	$t0,ball_vx
	lw	$t1,0($t0)
	blt	$t1,0,game_ball_testx_test
game_ball_testx_right:
	addi	$a0,$a0,kBallWidth
	addi	$a0,$a0,1
game_ball_testx_test:
	jal	getbox
	fepil	24
	jr	$ra
	.end	game_ball_testx

# game_ball_testy() - Test whether collide in y-direction
#	call this function BEFORE movement
	.globl	game_ball_testy
	.ent	game_ball_testy
game_ball_testy:
	.frame	$fp,24,$ra
	fprol	24
	la	$t0,ball_x
	lw	$a0,0($t0)	# x = ball_x
	la	$t0,ball_y
	lw	$a1,0($t0)	# $a1 = ball_y
	addi	$a1,$a1,-1	# y = ball_y - 1
	li	$a2,kBallWidth	# dx = kBallWidth
	li	$a3,1	# dy = 1
	la	$t0,ball_vy
	lw	$t1,0($t0)
	blt	$t1,0,game_ball_testy_test
game_ball_testy_bottom:
	addi	$a1,$a1,kBallHeight
	addi	$a1,$a1,1
game_ball_testy_test:
	jal	getbox
	fepil	24
	jr	$ra
	.end	game_ball_testy

# game_ball_break() - break the collided bricks
#	can this function AFTER movement and BEFORE re-render
	.globl	game_ball_break
	.ent	game_ball_break
game_ball_break:
	.frame	$fp,24,$ra
	fprol	24

	# we only check the corners
	# top-left corner
	la	$t0,ball_x
	lw	$a0,0($t0)
	la	$t0,ball_y
	lw	$a1,0($t0)
	jal	game_brick_break
	# top-right corner
	la	$t0,ball_x
	lw	$a0,0($t0)
	addi	$a0,$a0,kBallWidth
	addi	$a0,$a0,-1
	la	$t0,ball_y
	lw	$a1,0($t0)
	jal	game_brick_break
	# bottom-left corner
	la	$t0,ball_x
	lw	$a0,0($t0)
	la	$t0,ball_y
	lw	$a1,0($t0)
	addi	$a1,$a1,kBallHeight
	addi	$a1,$a1,-1
	jal	game_brick_break
	# bottom-right corner
	la	$t0,ball_x
	lw	$a0,0($t0)
	addi	$a0,$a0,kBallWidth
	addi	$a0,$a0,-1
	la	$t0,ball_y
	lw	$a1,0($t0)
	addi	$a1,$a1,kBallHeight
	addi	$a1,$a1,-1
	jal	game_brick_break

	fepil	24
	jr	$ra
	.end	game_ball_break


# game_brick_break(x, y) - break a brick if the pixel at (x, y) is a brick
	.globl	game_brick_break
	.ent	game_brick_break
game_brick_break:
	.frame	$fp,56,$ra
	fprol	56
	savesr	56

	move	$s0,$a0
	move	$s1,$a1
	jal	plot_get	# plot_get(ball_x, ball_y)
	beq	$v0,kWallColor,nodiscard
	beq	$v0,kPaddleColor,nodiscard
	beq	$v0,kBgColor,nodiscard
	beq	$v0,kBallColor,nodiscard
findminx:
	addi	$a0,$s0,-1
	bgeu	$a0,256,findminy	# x - 1 < 0
	move	$a1,$s1
	jal	plot_get	# plot_get(ball_x - 1, ball_y)
	beq	$v0,kWallColor,findminy
	beq	$v0,kPaddleColor,findminy
	beq	$v0,kBgColor,findminy
	beq	$v0,kBallColor,findminy
	addi	$s0,$s0,-1	# x -= 1
	j	findminx
findminy:
	addi	$a1,$s1,-1
	bgeu	$a1,256,discard	# y - 1 < 0
	move	$a0,$s0
	jal	plot_get
	beq	$v0,kWallColor,discard
	beq	$v0,kPaddleColor,discard
	beq	$v0,kBgColor,discard
	beq	$v0,kBallColor,discard
	addi	$s1,$s1,-1	# y -= 1
	j	findminy
discard:
	move	$a0,$s0
	move	$a1,$s1
	li	$a2,kBgColor
	li	$a3,kBrickWidth
	li	$t0,kBrickHeight
	sw	$t0,16($fp)
	jal	drawbox	# drawbox(x', y', kBgColor, kBrickWidth, kBrickHeight)
nodiscard:
	loadsr	56
	fepil	56
	jr	$ra
	.end	game_brick_break

# vim: set noet ts=16 sts=16 sw=16:
