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

.text

	.globl	game_input
	.ent	game_input
game_input:
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

	la	$t0,key_press	
	lw	$t1,0($t0)	# t1 = press
	la	$t2,pause	
	lw	$t3,0($t2)	# t3 = pause
	jal	kbd_keypressed	
	beq	$v0,$0,action_nokey	
	jal	kbd_whichkey	
	beq	$v0,kKeyQuit,action_quit	
	beq	$v0,kKeyRestart,action_restart	
	beq	$v0,kKeyPause,action_pause	
action_gamemove:
	li	$t0,-kPaddleV	
	beq	$v0,kKeyLeft,action_paddle	
	li	$t0,kPaddleV	
	beq	$v0,kKeyRight,action_paddle	
action_continue:
	li	$v0,0	
	b	action_ret	

action_nokey:
	beq	$t1,$0,action_continue	
	li	$t1,0	
	sw	$t1,0($t0)	
	b	action_continue	

action_quit:
	li	$v0,1	
	b	action_ret	

action_restart:
	li	$v0,2	
	b	action_ret	

action_pause:	bne	$t1,$0,action_continue	# ignore continuous press
	li	$t1,1	
	sw	$t1,0($t0)	
	not	$t3,$t3	# pause = !pause
	sw	$t3,0($t2)	
	b	action_continue	

action_paddle:
	la	$s0,paddle_x	
	lw	$s1,0($s0)	
	add	$s1,$s1,$t0	
	bltu	$s1,4,action_continue	
	bgeu	$s1,224,action_continue	# TODO: remove magic number
	li	$a0,kBgColor	
	jal	game_render_paddle	# remove the previous paddle
	sw	$s1,0($s0)	# move the paddle
	li	$a0,kPaddleColor	
	jal	game_render_paddle	# add the new paddle
	j	action_continue	

action_ret:
# 	fepil	24
	move	$sp,$fp	
	lw	$ra,20($sp)	
	lw	$fp,16($sp)	
	addiu	$sp,$sp,24	
	jr	$ra	
	.end	game_input


# vim: set noet ts=16 sts=16 sw=16:
