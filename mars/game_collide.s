# 	.include	"inc1.s"




# vim: set noet ts=8 sts=8 sw=8:
# 	.include	"gdefs.s"
# display
.eqv	kWidth,256
.eqv	kHeight,256
.eqv	kBgColor,0x000000
.eqv	kFgColor,0xFFFFFF

# wall
.eqv	kTWallTMargin,20
.eqv	kWallWidth,4
.eqv	kWallColor,0xCCCCCC

# brick
.eqv	kBrickRow,4
.eqv	kBrickColumn,14
.eqv	kBrickTMargin,32	# the y-axis of the first brick
.eqv	kBrickLMargin,16	# the x-axis of the first brick
.eqv	kBrickHeight,5
.eqv	kBrickWidth,14
.eqv	kBrickVSpace,2
.eqv	kBrickHSpace,2
.eqv	kBrickColor1,0xA31E0A
.eqv	kBrickColor2,0xC2850A
.eqv	kBrickColor3,0x0A8533
.eqv	kBrickColor4,0xC2C229

# paddle
#.eqv	kPaddleInitX,0	# developer mode
#.eqv	kPaddleWidth,255	# developer mode
.eqv	kPaddleInitX,112
.eqv	kPaddleWidth,32
.eqv	kPaddleInitY,220
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
.eqv	kKeyPause,0x70

# life
.eqv	kLife,0x3

# vim: set noet ts=16 sts=16 sw=16:

# game_ball_testx() - Test whether collide in x-direction
#	call this function BEFORE movement
	.globl	game_ball_testx
	.ent	game_ball_testx
game_ball_testx:
	.frame	$fp,24,$ra
# 	fprol	24
	addiu	$sp,$sp,-24	
	sw	$a3,36($sp)	
	sw	$a2,32($sp)	
	sw	$a1,28($sp)	
	sw	$a0,24($sp)	
	sw	$ra,20($sp)	
	sw	$fp,16($sp)	
	move	$fp,$sp	
	la	$t0,ball_x	
	lw	$a0,0($t0)	# $a0 = ball_x
	addi	$a0,$a0,-1	# x = ball_x - 1
	la	$t0,ball_y	
	lw	$a1,0($t0)	# y = ball_y
	la	$t0,ball_vy	
	lw	$t1,0($t0)	# $t1 = ball_vy
	add	$a1,$a1,$t1	# y = ball_y + ball_vy
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
# 	fepil	24
	move	$sp,$fp	
	lw	$ra,20($sp)	
	lw	$fp,16($sp)	
	addiu	$sp,$sp,24	
	jr	$ra	
	.end	game_ball_testx

# game_ball_testy() - Test whether collide in y-direction
#	call this function BEFORE movement
	.globl	game_ball_testy
	.ent	game_ball_testy
game_ball_testy:
	.frame	$fp,24,$ra
# 	fprol	24
	addiu	$sp,$sp,-24	
	sw	$a3,36($sp)	
	sw	$a2,32($sp)	
	sw	$a1,28($sp)	
	sw	$a0,24($sp)	
	sw	$ra,20($sp)	
	sw	$fp,16($sp)	
	move	$fp,$sp	
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
# 	fepil	24
	move	$sp,$fp	
	lw	$ra,20($sp)	
	lw	$fp,16($sp)	
	addiu	$sp,$sp,24	
	jr	$ra	
	.end	game_ball_testy

# game_ball_break() - break the collided bricks
#	can this function AFTER movement and BEFORE re-render
	.globl	game_ball_break
	.ent	game_ball_break
game_ball_break:
	.frame	$fp,24,$ra
# 	fprol	24
	addiu	$sp,$sp,-24	
	sw	$a3,36($sp)	
	sw	$a2,32($sp)	
	sw	$a1,28($sp)	
	sw	$a0,24($sp)	
	sw	$ra,20($sp)	
	sw	$fp,16($sp)	
	move	$fp,$sp	

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

# 	fepil	24
	move	$sp,$fp	
	lw	$ra,20($sp)	
	lw	$fp,16($sp)	
	addiu	$sp,$sp,24	
	jr	$ra	
	.end	game_ball_break


# game_brick_break(x, y) - break a brick if the pixel at (x, y) is a brick
	.globl	game_brick_break
	.ent	game_brick_break
game_brick_break:
	.frame	$fp,60,$ra
# 	fprol	60
	addiu	$sp,$sp,-60	
	sw	$a3,72($sp)	
	sw	$a2,68($sp)	
	sw	$a1,64($sp)	
	sw	$a0,60($sp)	
	sw	$ra,56($sp)	
	sw	$fp,52($sp)	
	move	$fp,$sp	
# 	savesr	60
	sw	$s7,48($sp)	
	sw	$s6,44($sp)	
	sw	$s5,40($sp)	
	sw	$s4,36($sp)	
	sw	$s3,32($sp)	
	sw	$s2,28($sp)	
	sw	$s1,24($sp)	
	sw	$s0,20($sp)	

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
	la	$t0,cscore	
	lw	$t1,0($t0)	
	addi	$t1,$t1,1	
	sw	$t1,0($t0)	# cscore += 1
	jal	game_scoreupdate	
	# debug
	#move	$a0,$s0
	#move	$a1,$s1
	#li	$a2,0xFFFFFF
	#jal	plot_draw
	move	$a0,$s0	
	move	$a1,$s1	
	li	$a2,kBgColor	
	li	$a3,kBrickWidth	
	li	$t0,kBrickHeight	
	sw	$t0,16($fp)	
	jal	drawbox	# drawbox(x', y', kBgColor, kBrickWidth, kBrickHeight)
nodiscard:
# 	loadsr	60
	lw	$s7,48($sp)	
	lw	$s6,44($sp)	
	lw	$s5,40($sp)	
	lw	$s4,36($sp)	
	lw	$s3,32($sp)	
	lw	$s2,28($sp)	
	lw	$s1,24($sp)	
	lw	$s0,20($sp)	
# 	fepil	60
	move	$sp,$fp	
	lw	$ra,56($sp)	
	lw	$fp,52($sp)	
	addiu	$sp,$sp,60	
	jr	$ra	
	.end	game_brick_break

# vim: set noet ts=16 sts=16 sw=16:
