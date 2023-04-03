.include	"inc.asm"
.include	"gdefs.s"

.text

# game_init() - initialize the game
# returns $v0 = 0 if successful
.globl	game_init
game_init:
	fprologue
	addi	$sp,$sp,-4
	addi	$fp,$fp,-4
	jal	plot_init
	bne	$v0,$zero,game_init_ret
	jal	kbd_init
	bne	$v0,$zero,game_init_ret
	li	$v0,0

	# draw background
	# draw(x=0, y=0, color=kBgColor, dx=kWidth, dy=kHeight)
	li	$a0,0
	li	$a1,0
	li	$a2,kBgColor
	li	$a3,kWidth
	li	$t0,kHeight
	sw	$t0,16($fp)
	jal	drawbox

game_init_ret:
	addi	$fp,$fp,4
	addi	$sp,$sp,4
	fepilogue
	jr	$ra

# vim: set noet ts=16 sts=16 sw=16:
