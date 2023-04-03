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
.data
	.globl	paddle_x
paddle_x:	.word	0

	.globl	paddle_y
paddle_y:	.word	0

	.globl	ball_x
ball_x:	.word	kBallInitX

	.globl	ball_y
ball_y:	.word	kBallInitY

	.globl	ball_vx
ball_vx:	.word	0

	.globl	ball_vy
ball_vy:	.word	0

	.globl	key_press
key_press:	.word	0

	.globl	pause
pause:	.word	0

	.globl	cscore
cscore:	.word	0

	.globl	max_score
max_score:	.word	0

	.globl	life
life:	.word	kLife

.text
# 	.include	"inc1.s"




# vim: set noet ts=8 sts=8 sw=8:

# run() - the main game loop
	.globl	run
	.ent	run
run:
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

	jal	game_init	
	bne	$v0,$zero,run_ret	
main_loop:
	jal	game_start	
game_round:
	jal	game_startround	
game_loop:
	jal	game_input	
	beq	$v0,1,run_end	
	beq	$v0,2,main_loop	
	la	$t0,life	
	lw	$t1,0($t0)	
	beq	$t1,0,game_norender	
	jal	game_tick	
	beq	$v0,$zero,game_next	
	la	$t0,life	
	lw	$t1,0($t0)	
	addi	$t1,$t1,-1	
	sw	$t1,0($t0)	
	bne	$t1,0,game_round	
	jal	game_menu_over	
game_next:
	jal	game_render	
game_norender:
	jal	game_sleep	
	j	game_loop	
game_end:
run_end:
	jal	game_deinit	
run_ret:
# 	fepil	24
	move	$sp,$fp	
	lw	$ra,20($sp)	
	lw	$fp,16($sp)	
	addiu	$sp,$sp,24	
	jr	$ra	
	.end	run

# vim: set noet ts=16 sts=16 sw=16:
