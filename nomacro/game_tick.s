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

	.globl	game_tick
	.ent	game_tick
game_tick:
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

	# flip dy if collide
	jal	game_ball_testy	
	beq	$v0,$zero,nochangevy	
	jal	game_ball_move	
	jal	game_ball_break	
	jal	game_ball_unmove	
	la	$t0,ball_vy	
	lw	$t1,0($t0)	
	subu	$t1,$zero,$t1	# ball_vy = -ball_vy
	sw	$t1,0($t0)	
nochangevy:	# flip dx if collide
	jal	game_ball_testx	
	beq	$v0,$zero,nochangevx	
	jal	game_ball_move	
	jal	game_ball_break	
	jal	game_ball_unmove	
	la	$t0,ball_vx	
	lw	$t1,0($t0)	
	subu	$t1,$zero,$t1	# ball_vx = -ball_vx
	sw	$t1,0($t0)	# t1 = ball_vx
nochangevx:	# perform movement
	li	$a0,kBgColor	
	jal	game_render_ball	# remove the ball
	jal	game_ball_move	
	bne	$v0,$zero,finish	
	li	$a0,kBallColor	
	jal	game_render_ball	# render the ball
	li	$v0,0	
finish:
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
	.end	game_tick

	.ent	game_ball_move
game_ball_move:
	la	$t4,ball_x	
	lw	$t5,0($t4)	# $t5 = ball_x
	la	$t6,ball_y	
	lw	$t7,0($t6)	# $t7 = ball_y
	la	$t0,ball_vx	
	lw	$t1,0($t0)	# $t1 = ball_vx
	la	$t2,ball_vy	
	lw	$t3,0($t2)	# $t3 = ball_vy
	add	$t5,$t5,$t1	
	li	$v0,1	
	bgeu	$t5,252,game_ball_move_dontmove	# TODO: remove magic number
	add	$t7,$t7,$t3	
	li	$v0,1	
	bgeu	$t7,252,game_ball_move_dontmove	# TODO: remove magic number
	li	$v0,0	
	sw	$t5,0($t4)	
	sw	$t7,0($t6)	
game_ball_move_dontmove:
	jr	$ra	
	.end	game_ball_move

	.globl	game_ball_unmove
	.ent	game_ball_unmove
game_ball_unmove:
	la	$t4,ball_x	
	lw	$t5,0($t4)	# $t5 = ball_x
	la	$t6,ball_y	
	lw	$t7,0($t6)	# $t7 = ball_y
	la	$t0,ball_vx	
	lw	$t1,0($t0)	# $t1 = ball_vx
	la	$t2,ball_vy	
	lw	$t3,0($t2)	# $t3 = ball_vy
	sub	$t5,$t5,$t1	
	li	$v0,1	
	bgeu	$t5,252,game_ball_unmove_dontmove	# TODO: remove magic number
	sub	$t7,$t7,$t3	
	li	$v0,1	
	bgeu	$t7,252,game_ball_unmove_dontmove	# TODO: remove magic number
	li	$v0,0	
	sw	$t5,0($t4)	
	sw	$t7,0($t6)	
game_ball_unmove_dontmove:
	jr	$ra	
	.end	game_ball_unmove


# vim: set noet ts=16 sts=16 sw=16:
