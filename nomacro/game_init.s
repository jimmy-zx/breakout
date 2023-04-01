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

# game_init() - initialize the game
# returns $v0 = 0 if successful
	.globl	game_init
	.ent	game_init
game_init:
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

	jal	plot_init	
	bne	$v0,$zero,game_init_ret	
	jal	kbd_init	
	bne	$v0,$zero,game_init_ret	
	li	$v0,0	

game_init_ret:
# 	fepil	24
	move	$sp,$fp	
	lw	$ra,20($sp)	
	lw	$fp,16($sp)	
	addiu	$sp,$sp,24	
	jr	$ra	
	.end	game_init

# vim: set noet ts=16 sts=16 sw=16:
