# 	.include	"inc1.s"




# vim: set noet ts=8 sts=8 sw=8:
# 	.include	"gdefs.s"
# display
.eqv	kWidth,256
.eqv	kHeight,256
.eqv	kBgColor,0x000000

# wall
.eqv	kWallWidth,4
.eqv	kWallColor,0xCCCCCC

# brick
.eqv	kBrickRow,4
.eqv	kBrickColumn,16
.eqv	kBrickTMargin,16	# the y-axis of the first brick
.eqv	kBrickLMargin,1	# the x-axis of the first brick
.eqv	kBrickHeight,5
.eqv	kBrickWidth,14
.eqv	kBrickVSpace,2
.eqv	kBrickHSpace,2
.eqv	kBrickColor1,0xA31E0A
.eqv	kBrickColor2,0xC2850A
.eqv	kBrickColor3,0x0A8533
.eqv	kBrickColor4,0xC2C229

# paddle
# .eqv	kPaddleInitX,112
.eqv	kPaddleInitX,0
.eqv	kPaddleInitY,220
# .eqv	kPaddleWidth,32
.eqv	kPaddleWidth,255
.eqv	kPaddleHeight,4
.eqv	kPaddleColor,0x0A85C2
.eqv	kPaddleV,4

# ball
.eqv	kBallInitX,125
.eqv	kBallInitY,200
.eqv	kBallInitVX,1
.eqv	kBallInitVY,-1
.eqv	kBallWidth,4
.eqv	kBallHeight,4
.eqv	kBallColor,0xFFFFFF

# keyboard
.eqv	kKeyQuit,0x71
.eqv	kKeyLeft,0x61
.eqv	kKeyRight,0x64
.eqv	kKeyRestart,0x72

# vim: set noet ts=16 sts=16 sw=16:

.text

.globl	game_render
game_render:
	jr	$ra	

# game_render_paddle(color)
	.globl	game_render_paddle
	.ent	game_render_paddle
game_render_paddle:
	.frame	$fp,28,$ra
# 	fprol	28
	addiu	$sp,$sp,-28	
	sw	$a3,40($sp)	
	sw	$a2,36($sp)	
	sw	$a1,32($sp)	
	sw	$a0,28($sp)	
	sw	$ra,24($sp)	
	sw	$fp,20($sp)	
	move	$fp,$sp	

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

# 	fepil	28
	move	$sp,$fp	
	lw	$ra,24($sp)	
	lw	$fp,20($sp)	
	addiu	$sp,$sp,28	
	jr	$ra	
	.end	game_render_paddle

# game_render_ball(color)
	.globl	game_render_ball
	.ent	game_render_ball
game_render_ball:
	.frame	$fp,28,$ra
# 	fprol	28
	addiu	$sp,$sp,-28	
	sw	$a3,40($sp)	
	sw	$a2,36($sp)	
	sw	$a1,32($sp)	
	sw	$a0,28($sp)	
	sw	$ra,24($sp)	
	sw	$fp,20($sp)	
	move	$fp,$sp	

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

# 	fepil	28
	move	$sp,$fp	
	lw	$ra,24($sp)	
	lw	$fp,20($sp)	
	addiu	$sp,$sp,28	
	jr	$ra	
	.end	game_render_ball

# vim: set noet ts=16 sts=16 sw=16:
