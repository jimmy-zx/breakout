.include	"inc.s"

.globl game_sleep
game_sleep:
	fprologue
	
	li	$a0,20
	li	$v0,32
	syscall
	
	fepilogue
	jr	$ra
