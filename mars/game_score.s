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

	.globl	game_scoreinit
	.ent	game_scoreinit
game_scoreinit:
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

	li	$a0,'S'	
	li	$a1,8	
	li	$a2,0	
	li	$a3,0xFF0000	
	jal	drawfont	# drawfont('S', 8, 0, 0xffffff)

	li	$a0,'c'	
	li	$a1,16	
	li	$a2,0	
	li	$a3,0xFFA500	
	jal	drawfont	# drawfont('S', 8, 0, 0xffffff)

	li	$a0,'o'	
	li	$a1,24	
	li	$a2,0	
	li	$a3,0xFF0000	
	jal	drawfont	# drawfont('S', 8, 0, 0xffffff)

	li	$a0,'r'	
	li	$a1,32	
	li	$a2,0	
	li	$a3,0x00FFFF	
	jal	drawfont	# drawfont('S', 8, 0, 0xffffff)

	li	$a0,'e'	
	li	$a1,40	
	li	$a2,0	
	li	$a3,0x0099FF	
	jal	drawfont	# drawfont('S', 8, 0, 0xffffff)

	li	$a0,':'
	li	$a1,48	
	li	$a2,0	
	li	$a3,0xffffff	
	jal	drawfont	# drawfont('S', 8, 0, 0xffffff)

	li	$a0,'/'	
	li	$a1,72	
	li	$a2,0	
	li	$a3,0xffffff	
	jal	drawfont	# drawfont('S', 8, 0, 0xffffff)

	li	$a0,'+'	
	li	$a1,104	
	li	$a2,0	
	li	$a3,0xffffff	
	jal	drawfont	# drawfont('S', 8, 0, 0xffffff)

# 	fepil	24
	move	$sp,$fp	
	lw	$ra,20($sp)	
	lw	$fp,16($sp)	
	addiu	$sp,$sp,24	
	jr	$ra	
	.end	game_scoreinit

	.globl	game_scoreupdate
	.ent	game_scoreupdate
game_scoreupdate:
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

	# cscore
	li	$a0,56	
	li	$a1,0	
	li	$a2,kBgColor	
	li	$a3,16	
	li	$t0,16	
	sw	$t0,16($sp)	
	jal	drawbox	# drawbox(56, 0, kBgColor, 16, 16)
	la	$t0,cscore	
	lw	$t1,0($t0)	
	div	$t1,$t1,10	
	mfhi	$s1	# s1 = score % 10
	mflo	$s0	# s0 = score // 10
	addi	$a0,$s0,'0'	
	li	$a1,56	
	li	$a2,0	
	li	$a3,0xffffff	
	jal	drawfont	# drawfont(score % 10 + '0', 56, 0, 0xffffff)
	addi	$a0,$s1,'0'	
	li	$a1,64	
	li	$a2,0	
	li	$a3,0xffffff	
	jal	drawfont	# drawfont(score // 10 + '0', 64, 0, 0xffffff)

	# max_score
	li	$a0,80	
	li	$a1,0	
	li	$a2,kBgColor	
	li	$a3,16	
	li	$t0,16	
	sw	$t0,16($sp)	
	jal	drawbox	# drawbox(56, 0, kBgColor, 16, 16)
	la	$t0,max_score	
	lw	$t1,0($t0)	
	div	$t1,$t1,10	
	mfhi	$s1	# s1 = score % 10
	mflo	$s0	# s0 = score // 10
	addi	$a0,$s0,'0'	
	li	$a1,80	
	li	$a2,0	
	li	$a3,0xffffff	
	jal	drawfont	# drawfont(score % 10 + '0', 56, 0, 0xffffff)
	addi	$a0,$s1,'0'	
	li	$a1,88	
	li	$a2,0	
	li	$a3,0xffffff	
	jal	drawfont	# drawfont(score // 10 + '0', 64, 0, 0xffffff)

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
	.end	game_scoreupdate

	.globl	game_lifeupdate
	.ent	game_lifeupdate
game_lifeupdate:
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

	# life
	li	$a0,112	
	li	$a1,0	
	li	$a2,kBgColor	
	li	$a3,8	
	li	$t0,16	
	sw	$t0,16($sp)	
	jal	drawbox	
	la	$t0,life	
	lw	$t1,0($t0)	
	addi	$a0,$t1,'0'	
	li	$a1,112	
	li	$a2,0	
	li	$a3,0xffffff	
	jal	drawfont	

# 	fepil	28
	move	$sp,$fp	
	lw	$ra,24($sp)	
	lw	$fp,20($sp)	
	addiu	$sp,$sp,28	
	jr	$ra	
	.end	game_lifeupdate

# vim: set noet ts=16 sts=16 sw=16:
