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

.text

.globl	game_input
game_input:
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

	jal	kbd_keypressed	
	beq	$v0,$0,action_continue	
	jal	kbd_whichkey	
	beq	$v0,kKeyQuit,action_quit	
	beq	$v0,kKeyRestart,action_restart	
	li	$t0,-kPaddleV	
	beq	$v0,kKeyLeft,action_paddle	
	li	$t0,kPaddleV	
	beq	$v0,kKeyRight,action_paddle	

action_continue:
	li	$v0,0	
# 	fepilogue
	lw	$ra,20($fp)	
	lw	$fp,16($fp)	
	addi	$sp,$sp,24	
	jr	$ra	

action_quit:
	li	$v0,1	
# 	fepilogue
	lw	$ra,20($fp)	
	lw	$fp,16($fp)	
	addi	$sp,$sp,24	
	jr	$ra	

action_restart:
	li	$v0,2	
# 	fepilogue
	lw	$ra,20($fp)	
	lw	$fp,16($fp)	
	addi	$sp,$sp,24	
	jr	$ra	

action_paddle:
	la	$s0,paddle_x	
	lw	$s1,0($s0)	
	add	$s1,$s1,$t0	
	bgeu	$s1,224,action_continue	# TODO: remove magic number
	li	$a0,kBgColor	
	jal	game_render_paddle	# remove the previous paddle
	sw	$s1,0($s0)	# move the paddle
	li	$a0,kPaddleColor	
	jal	game_render_paddle	# add the new paddle
	j	action_continue	


# vim: set noet ts=16 sts=16 sw=16:
