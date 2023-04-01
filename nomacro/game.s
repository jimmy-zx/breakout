# .include "inc1.s"




# vim: set noet ts=8 sts=8 sw=8:

.data

	.globl	paddle_x
paddle_x:	.word	0

	.globl	paddle_y
paddle_y:	.word	0

	.globl	ball_x
ball_x:	.word	0

	.globl	ball_y
ball_y:	.word	0

	.globl	ball_vx
ball_vx:	.word	0

	.globl	ball_vy
ball_vy:	.word	0

.text

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
game_loop:
	jal	game_input	
	beq	$v0,1,run_end	
	beq	$v0,2,main_loop	
	jal	game_tick	
#	bne	$v0,$zero,game_end
	jal	game_render	
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
