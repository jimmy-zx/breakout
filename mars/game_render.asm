.include	"inc.s"
.include	"gdefs.s"

.text

.globl	game_render
game_render:
	fprologue

	fepilogue
	jr	$ra

# game_render_paddle(color)
.globl	game_render_paddle
game_render_paddle:
	fprologue
	addi	$sp,$sp,-4
	addi	$fp,$fp,-4

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

	addi	$fp,$fp,4
	addi	$sp,$sp,4
	fepilogue
	jr	$ra

# game_render_ball(color)
.globl	game_render_ball
game_render_ball:
	fprologue
	addi	$sp,$sp,-4
	addi	$fp,$fp,-4

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

	addi	$fp,$fp,4
	addi	$sp,$sp,4
	fepilogue
	jr	$ra

# vim: set noet ts=16 sts=16 sw=16:
