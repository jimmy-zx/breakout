	.include	"inc1.s"

	.globl	main
	.ent	main
main:
	.frame	$fp,56,$ra
	fprol	56
	savesr	56
	jal	plot_init
	li	$a0,66
	li	$a1,50
	li	$a2,60
	li	$a3,0x66ccff
	jal	drawfont
	loadsr	56
	fepil	56
	jr	$ra
	.end	main
