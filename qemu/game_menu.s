.data
game_over_str:
	.ascii	"Game over!"
press_restart_str:
	.ascii	"Press r to restart."
.text
	.include	"gdefs.s"
	.include	"inc1.s"

	.globl	game_menu_over
	.ent	game_menu_over
game_menu_over:
	.frame	$fp,60,$ra
	fprol	60
	savesr	60

	# draw background
	# draw(x=0, y=0, color=kBgColor, dx=kWidth, dy=kHeight)
	li	$a0,0
	li	$a1,0
	li	$a2,kBgColor
	li	$a3,kWidth
	li	$t0,kHeight
	sw	$t0,16($fp)
	jal	drawbox

	# draw "Game over!"
	li	$a0,0
	li	$a1,16
	li	$a2,kFgColor
	la	$a3,game_over_str
	li	$t0,10
	sw	$t0,16($sp)
	jal	drawstr

	# draw "Press r to restart"
	li	$a0,0
	li	$a1,32
	li	$a2,kFgColor
	la	$a3,press_restart_str
	li	$t0,19
	sw	$t0,16($sp)
	jal	drawstr

	jal	game_scoreinit
	jal	game_scoreupdate
	jal	game_lifeupdate

	loadsr	60
	fepil	60
	jr	$ra
	.end	game_menu_over


# vim: set noet ts=16 sts=16 sw=16:
