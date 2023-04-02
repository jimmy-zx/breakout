	.include	"gdefs.s"
	.include	"inc1.s"

	.globl	game_scoreinit
	.ent	game_scoreinit
game_scoreinit:
	.frame	$fp,24,$ra
	fprol	24

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

	fepil	24
	jr	$ra
	.end	game_scoreinit

	.globl	game_scoreupdate
	.ent	game_scoreupdate
game_scoreupdate:
	.frame	$fp,60,$ra
	fprol	60
	savesr	60

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
	div	$t1,10
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
	div	$t1,10
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

	loadsr	60
	fepil	60
	jr	$ra
	.end	game_scoreupdate

	.globl	game_lifeupdate
	.ent	game_lifeupdate
game_lifeupdate:
	.frame	$fp,28,$ra
	fprol	28

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

	fepil	28
	jr	$ra
	.end	game_lifeupdate

# vim: set noet ts=16 sts=16 sw=16:
