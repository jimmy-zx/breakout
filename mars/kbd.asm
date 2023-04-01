.data

kbd_mem:
	.word	0xffff0000

.text

.globl	kbd_init
kbd_init:
	jr	$ra

.globl	kbd_deinit
kbd_deinit:
	jr	$ra

.globl	kbd_keypressed
kbd_keypressed:
	lw	$t0,kbd_mem
	lw	$v0,0($t0)
	jr	$ra

.globl	kbd_whichkey
kbd_whichkey:
	lw	$t0,kbd_mem
	lw	$v0,4($t0)
	jr	$ra

# vim: set noet ts=16 sts=16 sw=16:
