# Data Area
.data
    buffer: .space 100
    input_prompt:   .asciiz "Enter string:\n"
    output_prompt:   .asciiz "Output:\n"
    convention: .asciiz "Convention Check\n"
    newline:    .asciiz "\n"

.text

# DO NOT MODIFY THE MAIN PROGRAM
main:
    la $a0, input_prompt    # prompt user for string input
    li $v0, 4
    syscall

    li $v0, 8       # take in input
    la $a0, buffer
    li $a1, 100
    syscall
    move $s0, $a0   # save string to s0

    ori $s1, $0, 0
    ori $s2, $0, 0
    ori $s3, $0, 0
    ori $s4, $0, 0
    ori $s5, $0, 0
    ori $s6, $0, 0
    ori $s7, $0, 0

    move $a0, $s0
    jal SwapCase

    add $s1, $s1, $s2
    add $s1, $s1, $s3
    add $s1, $s1, $s4
    add $s1, $s1, $s5
    add $s1, $s1, $s6
    add $s1, $s1, $s7
    add $s0, $s0, $s1

    la $a0, output_prompt    # give Output prompt
    li $v0, 4
    syscall

    move $a0, $s0
    jal DispString

    j Exit

DispString:
    addi $a0, $a0, 0
    li $v0, 4
    syscall
    jr $ra

ConventionCheck:
    addi    $t0, $0, -1
    addi    $t1, $0, -1
    addi    $t2, $0, -1
    addi    $t3, $0, -1
    addi    $t4, $0, -1
    addi    $t5, $0, -1
    addi    $t6, $0, -1
    addi    $t7, $0, -1
    ori     $v0, $0, 4
    la      $a0, convention
    syscall
    addi    $v0, $zero, -1
    addi    $v1, $zero, -1
    addi    $a0, $zero, -1
    addi    $a1, $zero, -1
    addi    $a2, $zero, -1
    addi    $a3, $zero, -1
    addi    $k0, $zero, -1
    addi    $k1, $zero, -1
    jr      $ra
    
Exit:
    ori     $v0, $0, 10
    syscall

# COPYFROMHERE - DO NOT REMOVE THIS LINE

# YOU CAN ONLY MODIFY THIS FILE FROM THIS POINT ONWARDS:
SwapCase:
	#add return to stack
	addiu $sp, $sp, -4
	sw $ra, 0($sp)		   
	
 	#add initial address to stack
	addiu $sp, $sp, -4
	sw $a0, 0($sp)	


	j loop
    # Do not remove this line - it should be the last line in your function code
    jr $ra

loop:
	#stack design: address is always on top	
	#pulling initial from stack
	#array address:
	lw $a0, 0($sp)
	addiu $sp, $sp, 4

	#check for character
	li $a3, 1

	jal changeCharacter

	#putting initials on stack
	#next array address:
	addiu $sp, $sp, -4
	addiu $a0, $a0, 1
	sw $a0, 0($sp)

	#a3 = 0 --> is a character
	jal checkChar
	j loop
	
changeCharacter:
	#takes in address in a0
	lb $a1, 0($a0) #put character in a1 	
	#check if null terminating character
	beq $a1, $zero, EOS

	addiu $sp, $sp, -4
	sw $ra, 0($sp) #store return address in stack
		

	jal checkUpper
	move $t5, $v0 #t5 contains isUpper
	jal checkLower
	move $t6, $v0 #t6 contains isLower		
	#if nor isUpper && isLower --> invalid char
	nor $t2, $t5, $t6
	li $t8, -2
	bne $t2, $t8, return	
	
	li $a3, 0 #fulfills character requirement	
	#print initial
	jal printChar
	#conversion
	jal convert
	#print newline
	jal printNewLine
	#print final
	jal printChar
	#print endline
	jal printNewLine	
	
	#return
	j return
printNewLine:
	move $t9, $a0
	la $a0, newline
	li $v0, 4
	syscall
	move $a0, $t9
	
	jr $ra

printChar:
	move $t9, $a0
	li $v0, 11
	move $a0, $a1
	syscall
	move $a0, $t9 #move back
	
	jr $ra

convert:
	#ra links back to changeCharacter
	li $t3, 1
	beq $t5, $t3, UpperToLower
	beq $t6, $t3, LowerToUpper
	#should be making the jump before this line
	jr $ra
	

checkUpper:
	slti $t0, $a1, 65
	slti $t1, $a1, 91
	#for it to be uppercase, has to be !(<65) and (<91)
	#so, t0 = 0, t1 = 1
	nor $t0, $t0, $zero
	sub $t0, $zero, $t0
	and $t0, $t0, $t1
	move $v0, $t0		
	
	jr $ra

checkLower:
	slti $t0, $a1, 97
	slti $t1, $a1, 123	
	nor $t0, $t0, $zero
	sub $t0, $zero, $t0
	and $t0, $t0, $t1
	move $v0, $t0

	jr $ra

UpperToLower:
	addi $a1, $a1, 32
	sb $a1, 0($a0)
	jr $ra	

LowerToUpper:
	addi $a1, $a1, -32
	sb $a1, 0($a0)
	jr $ra


return:
	lw $ra, 0($sp) #pop return address off stack
	addiu $sp, $sp, 4
	jr $ra

EOS:
	#access element in stack
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	#should jump us all the way back to main

checkChar:
	beq $a3, $zero, isChar
	#not char case --> just return
	jr $ra	

isChar:
	#store ra
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	#check convention
	jal ConventionCheck
	#pop ra
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	#jump out	
	jr $ra
	

