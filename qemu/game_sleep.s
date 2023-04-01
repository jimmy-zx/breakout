.include	"gdefs.s"
.include	"inc1.s"

	.globl	game_sleep
	.ent	game_sleep
game_sleep:
	.frame	$fp,24,$ra
	fprol	24
	li	$a0,10000
	jal	usleep
	fepil	24
	jr	$ra
	.end	game_sleep
