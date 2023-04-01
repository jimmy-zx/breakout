	.include	"inc1.s"
	.include	"gdefs.s"

.text

	.globl	game_tick
	.ent	game_tick
game_tick:
	.frame	$fp,56,$ra
	fprol	56
	savesr	56

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
	loadsr	56
	fepil	56
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
