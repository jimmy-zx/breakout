# .include	"inc.s"



# vim: set noet ts=16 sts=16 sw=16:
# .include	"gdefs.s"
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

# game_ball_testx() - Test whether collide in x-direction
#	call this function BEFORE movement
.globl	game_ball_testx
game_ball_testx:
# 	fprologue
	addi	$sp,$sp,-24	# stack (24)
	sw	$fp,16($sp)	# backup old $fp
	addi	$fp,$sp,0	# setup new $fp
	sw	$a3,36($fp)	# 36($fp) = $a3
	sw	$a2,32($fp)	# 32($fp) = $a2
	sw	$a1,28($fp)	# 28($fp) = $a1
	sw	$a0,24($fp)	# 24($fp) = $a0
	sw	$ra,20($fp)	# 20($fp) = $ra
			# 16($fp) = old $fp
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
# 	fepilogue
	lw	$ra,20($fp)	
	lw	$fp,16($fp)	
	addi	$sp,$sp,24	
	jr	$ra	

# game_ball_testy() - Test whether collide in y-direction
#	call this function BEFORE movement
.globl	game_ball_testy
game_ball_testy:
# 	fprologue
	addi	$sp,$sp,-24	# stack (24)
	sw	$fp,16($sp)	# backup old $fp
	addi	$fp,$sp,0	# setup new $fp
	sw	$a3,36($fp)	# 36($fp) = $a3
	sw	$a2,32($fp)	# 32($fp) = $a2
	sw	$a1,28($fp)	# 28($fp) = $a1
	sw	$a0,24($fp)	# 24($fp) = $a0
	sw	$ra,20($fp)	# 20($fp) = $ra
			# 16($fp) = old $fp
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
# 	fepilogue
	lw	$ra,20($fp)	
	lw	$fp,16($fp)	
	addi	$sp,$sp,24	
	jr	$ra	

# game_ball_break() - break the collided bricks
#	can this function AFTER movement and BEFORE re-render
.globl	game_ball_break
game_ball_break:
# 	fprologue
	addi	$sp,$sp,-24	# stack (24)
	sw	$fp,16($sp)	# backup old $fp
	addi	$fp,$sp,0	# setup new $fp
	sw	$a3,36($fp)	# 36($fp) = $a3
	sw	$a2,32($fp)	# 32($fp) = $a2
	sw	$a1,28($fp)	# 28($fp) = $a1
	sw	$a0,24($fp)	# 24($fp) = $a0
	sw	$ra,20($fp)	# 20($fp) = $ra
			# 16($fp) = old $fp

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

# 	fepilogue
	lw	$ra,20($fp)	
	lw	$fp,16($fp)	
	addi	$sp,$sp,24	
	jr	$ra	


# game_brick_break(x, y) - break a brick if the pixel at (x, y) is a brick
.globl	game_brick_break
game_brick_break:
# 	fprologue
	addi	$sp,$sp,-24	# stack (24)
	sw	$fp,16($sp)	# backup old $fp
	addi	$fp,$sp,0	# setup new $fp
	sw	$a3,36($fp)	# 36($fp) = $a3
	sw	$a2,32($fp)	# 32($fp) = $a2
	sw	$a1,28($fp)	# 28($fp) = $a1
	sw	$a0,24($fp)	# 24($fp) = $a0
	sw	$ra,20($fp)	# 20($fp) = $ra
			# 16($fp) = old $fp
	addi	$sp,$sp,-12	
	addi	$fp,$fp,-12	
	sw	$s1,24($fp)	
	sw	$s0,20($fp)	

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
	lw	$s0,20($fp)	
	lw	$s1,24($fp)	
	addi	$fp,$fp,12	
	addi	$sp,$sp,12	
# 	fepilogue
	lw	$ra,20($fp)	
	lw	$fp,16($fp)	
	addi	$sp,$sp,24	
	jr	$ra	

# vim: set noet ts=16 sts=16 sw=16:
