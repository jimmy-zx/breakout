	.include	"inc1.s"
	.include	"gdefs.s"

.text

# game_init() - initialize the game
# returns $v0 = 0 if successful
	.globl	game_init
	.ent	game_init
game_init:
	.frame	$fp,24,$ra
	fprol	24

	jal	plot_init
	bne	$v0,$zero,game_init_ret
	jal	kbd_init
	bne	$v0,$zero,game_init_ret
	li	$v0,0

game_init_ret:
	fepil	24
	jr	$ra
	.end	game_init

# vim: set noet ts=16 sts=16 sw=16:
