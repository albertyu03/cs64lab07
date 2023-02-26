# print_array.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.data
	array: .word 1 2 3 4 5 6 7 8 9 10
	cout: .asciiz "The contents of the array in reverse order are:\n"
	blankspace: .asciiz " "
.text
printA:
	#a0: array (address), a1: array length
	#call print on all members? pass an offset

	#initialization:
	move $t0, $a0 #t0: base address for array
	move $t1, $a1 #t1: base length of array
	addi $t9, $t1, -1 #t9: indexes of array (incl 0), current iterator
	
	#store return address
	addiu $sp, $sp, -4
	sw $ra, 0($sp)	

	j loop

loop:
	#check iterator
	slt $t2, $t9, $zero #t2 has value (iterator < 0)
	li $t3, 1 #temp register t3 has value of 1
	beq $t2, $t3, endPrintA
	
	#form new address
	move $t2, $t9 #move iterator value to t2
	sll $t2, $t2, 2
	addu $a0, $t2, $t0 #create register address in a0
	jal printAddress

	#iterate
	addi $t9, $t9, -1	

	j loop

printAddress:
	#a0 contains address // print & return
	lw $a0, 0($a0) #load indexed # of array
	li $v0, 1
	syscall
	#print space
	la $a0, blankspace
	li $v0, 4
	syscall
	jr $ra 

endPrintA:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
main:  # DO NOT MODIFY THE MAIN SECTION
	li $v0, 4
	la $a0, cout
	syscall

	la $a0, array
	li $a1, 10

	jal printA

exit:
	li $v0, 10
	syscall
