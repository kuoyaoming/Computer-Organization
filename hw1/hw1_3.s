main:
	li		$a0,	10

	move	$v0,	$a0
	li		$t0,	0
	li		$v0,	1

fib:
	add		$t1,	$t0,	$v0
	move	$t0,	$v0
	move	$v0,	$t1
	sub		$a0,	$a0,	1
	bgt		$a0,	1,		fib

done:
	move	$s2,	$v0
	li		$v0,	10
	syscall