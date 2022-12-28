#This function calculates any integer root of a positive real number. 
#This uses the netwons method
#Equation used (derived by me) x(i+1) = x(i) - x(i)/n + r/(nx(i)^(n-1))
#r = inputted number
#n = root inputted
#x(0) = r (intialize)
.data
new_line:  .asciiz "\n"
tolerance: .double 0.0000000005           #tolerance = 5 * 10^-10
one_const:       .double 1.0              #constant
zero_const:      .double 0.0              #constant
max_const:       .double 1E30             #used to exit loop
.text
.globl any_root
any_root:
	l.d $f0, 0($sp)                   #taking the 0th value from the stack - r in equation at the top
	lw  $a1, 16($sp)                  # $a1 carries the integer root value from stack location 16
	l.d $f4, tolerance                #load tolderance
	l.d $f6, one_const                #$f6 will carry the abosulute value of the difference between x(i+1) and x(i) 
	l.d $f8, zero_const               # $f8 will be used to hold x(i) in the loop
	l.d $f10, zero_const              # $f10 will be used to hold x(i)/n in the loop
	l.d $f14, zero_const              # $f14 will be used to hold (nx(i)^(n-1)) in the loop
	l.d $f22, max_const               #used to exit loop if $f14 gets too big
	mov.d $f16, $f0                   # x(0) value or r                    
	move $t2, $a1			  # move $a1 value into $t2 to calculate x(i) ^ (n-1)
	sub $t2, $t2, 1                   # makes $t2 = n - 1
	mtc1.d $a1, $f2                   # converts n to double and assigns it to $f2
	cvt.d.w $f2, $f2		  # converts n to double and assigns it to $f2
calculate_root:                              
	c.le.d $f6, $f4                          #checks if $f6 is less than or equal to tolerance ($f4)
	bc1t output                              #jumps back to function if $f6 is not less than tolerance
	li $t3, 1                                #counter for calculating x ^ (n-1)                   
	mov.d $f8, $f0                           #sets $f8 to x(i) value
	mov.d $f14, $f0                          #sets $f14 to x(i) value
	div.d $f10, $f0, $f2                     #calculates x(i)/n and assigns it to $f10
continue:     					                           
	beq $t3, $t2, continue_2                 # loop for calculating x(i)^(n-1)
	mul.d $f14, $f14, $f8                    # $f14 gets multiplied by $f8 (x(i)) until loop ends
	add $t3, $t3, 1                          # increments $t3 until it is equal to $t2
	c.le.d $f14, $f22                        #checks if $f14 becomes too large
	bc1f continue_2                          #leave calculation due to $f14 being too large
	b continue                               #branches back to continue                                                          
continue_2:                                      #continues after x(i)^(n-1) is calculated
	mul.d $f14, $f2, $f14                    #calculates n * (x(i)^(n-1))
	div.d $f18, $f16, $f14                   #calculates r/n(x(i)^(n-1))
	sub.d $f0, $f0, $f10                     #calculates new x(i)
	add.d $f0, $f0, $f18			 #calculates r/(x(i)^(n-1))
	sub.d $f6, $f0, $f8                      #$f6 is equal to $x(i + 1) minus x(i)
	abs.d $f6, $f6                           #makes $f6 the absolute value of itself
        b calculate_root
output:                               
	mov.d $f20, $f0				  #moves $f0 to $f20
	s.d $f20 8($sp)                          #returns $f0 to stack
exit:
	jr $ra 					#return to main
