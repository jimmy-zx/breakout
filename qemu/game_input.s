	.include	"inc1.s"
	.include	"gdefs.s"

.text

	.globl	game_input
	.ent	game_input
game_input:
	.frame	$fp,24,$ra
	fprol	24

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
	b	action_ret

action_quit:
	li	$v0,1
	b	action_ret

action_restart:
	li	$v0,2
	b	action_ret

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

action_ret:
	fepil	24
	jr	$ra
	.end	game_input


# vim: set noet ts=16 sts=16 sw=16:
