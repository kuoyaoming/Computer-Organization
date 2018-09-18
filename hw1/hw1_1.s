.data
	p1:		.asciiz "Enter a number to find its factorial: "
	p2:		.asciiz "/nThe factorial of the number is "
	num:	.word	0
	ans:	.word	0
	
.text
	.globl main
	main:
		li $v0, 4
		la $a0, p1
		syscall
		
		li $v0, 5
		syscall
		
		sw $v0, num
		
		lw $a0, num
		jal fact
		sw $v0, ans
		
		li $v0, 4
		la $a0, p2
		syscall
		
		li $v0, 1
		lw $a0, ans
		syscall
		
		li $v0, 10
		syscall
		
.globl fact
fact:
	subu $sp, $sp, 8
	sw $ra, ($sp)
	sw $s0, 4($sp)
	
	li $v0, 1
	beq $a0, 0, done
	
	move $s0, $a0
	sub $a0, $a0, 1
	jal fact
	
	mul $v0, $s0, $v0
	
	done:
		lw $ra, ($sp)
		lw $s0, 4($sp)
		addu $sp, $sp, 8
		jr $ra
		