.data
game_over_str:
	.ascii	"Game over!"
press_restart_str:
	.ascii	"Press r to restart."
press_quit_str:
	.ascii	"Press q to quit."
.text
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
# 	.include	"inc1.s"




# vim: set noet ts=8 sts=8 sw=8:

	.globl	game_menu_over
	.ent	game_menu_over
game_menu_over:
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

	# draw background
	# draw(x=0, y=0, color=kBgColor, dx=kWidth, dy=kHeight)
	li	$a0,0	
	li	$a1,0	
	li	$a2,kBgColor	
	li	$a3,kWidth	
	li	$t0,kHeight	
	sw	$t0,16($fp)	
	jal	drawbox	

	# draw "Game over!"
	li	$a0,0	
	li	$a1,16	
	li	$a2,kFgColor	
	la	$a3,game_over_str	
	li	$t0,10	
	sw	$t0,16($sp)	
	jal	drawstr	

	# draw "Press r to restart"
	li	$a0,0	
	li	$a1,32	
	li	$a2,kFgColor	
	la	$a3,press_restart_str	
	li	$t0,19	
	sw	$t0,16($sp)	
	jal	drawstr	

	# draw "Press q to quit"
	li	$a0,0	
	li	$a1,48	
	li	$a2,kFgColor	
	la	$a3,press_quit_str	
	li	$t0,19	
	sw	$t0,16($sp)	
	jal	drawstr	

	jal	game_scoreinit	
	jal	game_scoreupdate	
	jal	game_lifeupdate	

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
	.end	game_menu_over


# vim: set noet ts=16 sts=16 sw=16:
