	.include	"inc1.s"
	.include	"gdefs.s"

.text

	.globl	game_input
	.ent	game_input
game_input:
	.frame	$fp,24,$ra
	fprol	24

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
