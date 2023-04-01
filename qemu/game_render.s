	.include	"inc1.s"
	.include	"gdefs.s"

.text

.globl	game_render
game_render:
	jr	$ra

# game_render_paddle(color)
	.globl	game_render_paddle
	.ent	game_render_paddle
game_render_paddle:
	.frame	$fp,28,$ra
	fprol	28

	# draw(x=*paddle_x, y=*paddle_y, color=color,
	#      dx=kPaddleWidth, dy=kPaddleHeight)
	addi	$a2,$a0,0
	la	$t0,paddle_x
	lw	$a0,0($t0)
	la	$t1,paddle_y
	lw	$a1,0($t1)
	li	$a3,kPaddleWidth
	li	$t3,kPaddleHeight
	sw	$t3,16($fp)
	jal	drawbox

	fepil	28
	jr	$ra
	.end	game_render_paddle

# game_render_ball(color)
	.globl	game_render_ball
	.ent	game_render_ball
game_render_ball:
	.frame	$fp,28,$ra
	fprol	28

	# draw(x=*ball_x, y=*ball_y, color=color,
	#      dx=kBallWidth, dy=kBallHeight)
	addi	$a2,$a0,0
	la	$t0,ball_x
	lw	$a0,0($t0)
	la	$t1,ball_y
	lw	$a1,0($t1)
	li	$a3,kBallWidth
	li	$t3,kBallHeight
	sw	$t3,16($fp)
	jal	drawbox

	fepil	28
	jr	$ra
	.end	game_render_ball

# vim: set noet ts=16 sts=16 sw=16:
