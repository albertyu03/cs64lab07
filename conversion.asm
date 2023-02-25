# conversion.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.text
conv:
  #store initial return address
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  #intializing variables
  li $t0, 0 #t0: z
  li $t9, 0 #t9: iterator (i)  

  #going to loop
  j loop

loop:
  #checking iterator ($t9) / jumping out
  slti $t8, $t9, 8 #temp register t8 holds (t9 < 8)
  li $t7, 0 #temp register
  beq $t7, $t8, return
  
  #changing z
  move $t1, $a0 #x goes in t1
  li $t7, 8 #put 8 in temp register
  mult $t1, $t7
  mflo $t2 #put 8*x in t2
  sub $t0, $t0, $t2 #subtract 8*x from z
  add $t0, $t0, $a1 #add y to z

  #checking (x>=2)
  slti $t7, $a0, 2 #(checking if x < 2) --> result in temp register t7
  #well defined jump to sub
  jal subCheck  

  #add 1 to x
  addi $a0, $a0, 1  

  #adding to iterator
  addi $t9, $t9, 1
  j loop
 
subCheck:
  #$ra should have return address to loop
  #t7 should have the value of (x<2)
  beq $zero, $t7, subtr
  jr $ra

subtr:
  #called in the case (x<2) == 0
  addi $a1, $a1, -1
  jr $ra

return:
  #put z in v0
  move $v0, $t0
  #restore original address
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra
    

main:  # DO NOT MODIFY THE MAIN SECTION
    li $a0, 5
    li $a1, 7

    jal conv

    move $a0, $v0
    li $v0, 1
    syscall

exit:
	li $v0, 10
	syscall
