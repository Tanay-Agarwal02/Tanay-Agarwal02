.data
main_frame_number:      .space 4 #to store navigating number in
main_frame_question:    .asciiz "\n\nInput 1 for Natural Log\nInput 2 for Natural Exponent\nInput 3 for Cosine\nInput 4 for any Integer Root\nInput 5 for Sin\nInput 6 to Exit\n" #function prompt
question_1:             .asciiz "\nInput any real number greater than zero\n" #ln prompt 1
question_2:             .asciiz "\nInput any real number\n"		      #ln prompt 2
question_3:             .asciiz "\nInput any real number in radians\n"        #prompt for cos
question_4:             .asciiz "\nInput any real number greater than 0\n"    #prompt 1 for any root 
question_5:             .asciiz "\nInput any real number in radians\n"        #prompt for sin 
question_6:		.asciiz "\nInput positive integer Root. Example: 2 for square root, 3 for cube root\n" #prompt 2 for any root 
answer_1:		.asciiz "\nYour answer is below:\n" #prints when number is calculated
			.align 3 #aligns next data to double
fp1:                    .double 0.0 #for checking inputs for greater than or less than zero values
.text 
main:                   #main
back_to_question:                   			  #loops back to choices if user inputs wrong choice or wants to continue
	l.d $f6, fp1     	    			  #loads 0 into $f6
	la $a0, main_frame_question                       #load address of the main question into $a0
	li $v0, 4
	syscall						  #prints question
#reads user_input
	li $v0, 5 #asks user to input value from one to six
	syscall
#moves inputted value to $t6
	move $t6, $v0                                     #moves the $v0 value into t6 for later use
#checks if user inputted value in range of one to 6
	beq $t6, 6, exit                #checks if $t6 is equal to 6 so program can quit
	blt $t6, 1, back_to_question   	#checks user input is less than 1 in terms of ascii
	bgt $t6, 6, back_to_question   	#checks user input is greater than 7 in terms of ascii
#question prompt
	beq $t6, 1, ln                  #branches to ln calculator
	beq $t6, 2, exp                 #branches to exponent calculator
	beq $t6, 3  cos                 #branches to cos calculator
	beq $t6, 4, any_r               #branches to any root calculator
	beq $t6, 5, sin                 #branches to branches to sin calculator
        b exit                          #branches to exit
ln:
# Prompt user
input_number_for_ln:                     
	la $a0, question_1              #asks for any real number greater than 0
	li $v0, 4
	syscall
#input double
	li $v0,7                        #user inputs number
	syscall
	c.le.d $f0, $f6                 #if user inputs number less than 0 branches back to input_number_for_ln
	bc1t input_number_for_ln        #branch to input_number_for_ln if condition is true
	
	addiu $sp, $sp, -28                  # allocates two words worth of stack space by moving stack 2 words down
  	s.d $f0, 0($sp)                      # stores $f0 into stack slot 0 in terms of word space
    	sw $t6, 20($sp)                      #stores $t6 into stack slot 20 in terms of word space
    	sw $ra, 24($sp)                      # stores $ra into stack slot 24 in terms of word space
    	jal any_ln                           # jumps to ln file
    	l.d $f0, 0($sp)                      #loads stack pointer slot 0 value into $f0
    	l.d $f2, 8($sp)		             #loads the stack pointer slot 8 value into $f2	     
    	lw $t6, 20($sp)                      #loads the stack pointer slot 20 value into $t6
    	lw $ra, 24($sp)                      #loads the stack pointer slot 24 value into $ra
    	addiu $sp, $sp, 28                   # resets stack
    	
    	la $a0, answer_1                     #prints out answer prompt
	li $v0, 4
	syscall
    	mov.d $f12,  $f2                     #moves calculated value stored in $f2 to $f12 for printing
    	li $v0, 3                            #prints number calculated
    	syscall
	b back_to_question                   #branches back to question 
exp:
#prompt user
	la $a0, question_2                   #asks user for any real number
	li $v0, 4
	syscall
#input double
	li $v0,7			     #section to input real number for exponetial calculation
	syscall
	
	addiu $sp, $sp, -28                  # allocates two words worth of stack space by moving stack 2 words down
  	s.d $f0, 0($sp)                      # stores $f0 into stack slot 0 in terms of word space
    	sw $t6, 20($sp)			     #stores $t6 into stack slot 20 in terms of word space
    	sw $ra, 24($sp)			     # stores $ra into stack slot 24 in terms of word space
    	jal any_exp                          # jumps to the print line function
    	l.d $f0, 0($sp)                      #loads stack pointer slot 0 value into $f0
    	l.d $f2, 8($sp)			     #loads the stack pointer slot 8 value into $f2
    	lw $t6, 20($sp)			     #loads the stack pointer slot 20 value into $t6
    	lw $ra, 24($sp)			     #loads the stack pointer slot 24 value into $ra
    	addiu $sp, $sp, 28                   # resets stack
	
	la $a0, answer_1              	     #prints out answer prompt       
	li $v0, 4
	syscall
	mov.d $f12,  $f2		     #moves calculated value stored in $f2 to $f12 for printing
    	li $v0, 3			     #prints number calculated
    	syscall
	b back_to_question		     #branches back to question 
cos:
#prompt user
	la $a0, question_3	   	     #prints out question 3 prompt asking user for input in radians
	li $v0, 4			     
	syscall
#input double
	li $v0,7			     #allows user to input radian value in double
	syscall
	
	addiu $sp, $sp, -28                  # allocates two words worth of stack space by moving stack 2 words down
  	s.d $f0, 0($sp)                      # stores $f0 into stack slot 0 in terms of word spacespace
    	sw $t6, 20($sp)			     #stores $t6 into stack slot 20 in terms of word space
    	sw $ra, 24($sp)			     # stores $ra into stack slot 24 in terms of word space
    	jal any_cos                          # jumps to the print line function
    	l.d $f0, 0($sp)                      #loads stack pointer slot 0 value into $f0
    	l.d $f2, 8($sp)			     #loads the stack pointer slot 8 value into $f2
    	lw $t6, 20($sp)                      #loads the stack pointer slot 20 value into $t6
    	lw $ra, 24($sp)			     #loads the stack pointer slot 24 value into $ra
    	addiu $sp, $sp, 28                   # resets stack
    	
    	la $a0, answer_1		     #prints out answer prompt      
	li $v0, 4
	syscall
    	mov.d $f12,  $f2		     #moves calculated value stored in $f2 to $f12 for printing
    	li $v0, 3
    	syscall
	b back_to_question		     #branches back to question 
any_r:
root_ask:
#prompt user
	la $a0, question_6                   #asks user to input positive integer root
	li $v0, 4
	syscall
#input desired Root
	li $v0,5			     #allows user to input positive integer root that is greater than 0
	syscall
	move $t1, $v0	
	blt $t1, 1, root_ask 		     #if user inputted value less than 1 branches back to root ask
number_input:
#prompt user
	la $a0, question_4                   #asks user input positive root value
	li $v0, 4
	syscall
#input double
	li $v0,7			     #allows user to real number value
	syscall
	c.le.d $f0, $f6			     #checks if real number value is less than or equal to 0
	bc1t number_input		     #if condition is true asks user again for positive real number
	
        addiu $sp, $sp, -28                   # allocates two words worth of stack space by moving stack 2 words down
  	s.d $f0, 0($sp)                       # stores $f0 into stack slot 0 in terms of word spacespace
    	sw $t1, 16($sp)			      #stores $t1 into stack slot 16 in terms of word space
    	sw $t6, 20($sp)			      #stores $t6 into stack slot 20 in terms of word space
    	sw $ra, 24($sp)			      # stores $ra into stack slot 24 in terms of word space
    	jal any_root                          # jumps to the print line function
    	l.d $f0, 0($sp)                       #loads stack pointer slot 0 value into $f0
    	l.d $f2, 8($sp)			      #loads the stack pointer slot 8 value into $f2
    	lw $a1, 16($sp)			      #loads the stack pointer slot 16 value into $a1
    	lw $t6, 20($sp)			      #loads the stack pointer slot 20 value into $t6
    	lw $ra, 24($sp)			      #loads the stack pointer slot 24 value into $ra
    	addiu $sp, $sp, 28                    # resets stack
    	
    	la $a0, answer_1	              #prints out answer prompt  
	li $v0, 4			     
	syscall
    	mov.d $f12,  $f2		      #moves calculated value stored in $f2 to $f12 for printing		      
    	li $v0, 3
    	syscall				      #prints out calcualted number
	b back_to_question		      #branches back to question
sin:
#prompt user
	la $a0, question_5		      #asks user to input real number in radians
	li $v0, 4		   
	syscall
#input double
	li $v0,7		              #allows user to input real number in radians
	syscall
	
	addiu $sp, $sp, -28                 # allocates two words worth of stack space by moving stack 2 words down
  	s.d $f0, 0($sp)                     # stores $f0 into stack slot 0 in terms of word spacespace
    	sw $t6, 20($sp)		            #stores $t6 into stack slot 20 in terms of word space
    	sw $ra, 24($sp)			    # stores $ra into stack slot 24 in terms of word space
    	jal any_sin                         # jumps to the print line function
    	l.d $f0, 0($sp)                     #loads stack pointer slot 0 value into $f0
    	l.d $f2, 8($sp)			    #loads the stack pointer slot 8 value into $f2
    	lw $t6, 20($sp)			    #loads the stack pointer slot 20 value into $t6
    	lw $ra, 24($sp)			    #loads the stack pointer slot 24 value into $ra
    	addiu $sp, $sp, 28                  # resets stack
    	
    	la $a0, answer_1		   #prints out answer prompt  
	li $v0, 4
	syscall				   #moves calculated value stored in $f2 to $f12 for printing
    	mov.d $f12,  $f2		   
    	li $v0, 3			    #prints out calcualted number
    	syscall
	b back_to_question		    #branches back to question
exit:
# Terminate program
li $v0, 10
syscall

