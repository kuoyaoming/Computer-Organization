	.data
result:		.word	0x00000000
msg1:		.asciiz	"input an integer N : "
	.text
main:
	li		$v0,	4
	la		$a0,	msg1
	syscall

	li		$v0,	5
	syscall
	move	$a0,	$v0

	move	$v0,	$a0
	li		$t0,	1

multi:
	mul		$t0,	$t0,	$a0
	mflo	$t0
	sub		$a0,	1
	bgt		$a0,	1,	multi

done:
	move	$a1,	$t0
	li		$v0,	10
	syscall