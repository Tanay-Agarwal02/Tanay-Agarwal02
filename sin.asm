#sin(x) is calculated using Taylor series expansion
# x - x^3/3! +  x^5/5! - x^7/7! .... 
#to reduce calculation I used the property sin(x +/- 2npi) is equal to sin(x)
.data
		 .align  3
pi_const:        .double 3.14159265358979323846264338327 #constant
two_const:       .double 2.0                             #constant
low_limit:       .double 0.0                             #constant
one_const:       .double 1.0                             #constant
zero_const:      .double 0.0                             #constant
new_line:        .asciiz "\n"           

.text
.globl any_sin                     #global
any_sin:
	l.d $f0, 0($sp)                   #taking the 0th value from the stack\
	l.d $f2, zero_const               #loads 0 into f2
	l.d $f4, pi_const                 #loads the pi value
	l.d $f8, low_limit                #loads lower limit of 0 raidians into $f8
	l.d $f14, two_const               #loads the two constant into $f14
	mul.d $f10, $f4, $f14             # 2pi constant for future use and for upper limit of 2pi
	l.d $f18, one_const               # loads one into $f18
	li $t6, 0                         #counter for how many times input was subtracted by 2pi            
	
	c.lt.d $f0, $f8                   #checks if inputted value is less than the lower limit
	bc1t lower                        # if it is less than lower limit it branches to lower
	c.le.d $f0, $f10                  # checks if inputted value is less than 2pi ($f10) limit
	bc1f upper                        # if the condition is false program branches to upper
	b continue                        # branches to continue if value is between lower and upper limit
lower:
	add.d  $f0, $f0, $f10		  # if value is less than zero adds 2pi to put it inbetween zero and 2pi  
	c.lt.d $f0, $f8                   #checks if $f0 is less than lower limit
	bc1t lower                        #if the condition is true brach back to lower
	b continue                        #branches to continue when $f0 is greater than lower limit and less than upper limit
upper:
	sub.d  $f0, $f0, $f10             #subtracts inputted value by 2pi until $f0 is greater than lower limit and less than upper limit
	c.le.d $f0, $f10                  #loop condition
	bc1f upper                        #branches to upper if the less than condition is false
	b continue                        #branches to continue when $f0 is greater than lower limit and less than upper limit
continue:   
	c.le.d $f0, $f10                  #loop condition
	
	li $t5, 40                   #number of iterations of taylor series
	l.d $f4, one_const           #f4 - stores the order of taylor series term
	mov.d $f20, $f0              #moves $f0 (x) value into $f20 which will hold the final result of sin(x)
	mov.d $f6, $f0               #moves $f0 (x) into $f6 calculates the x^n
	l.d $f22,one_const           # $f22 calculutes the n! value
calculate_sin:
	beq $t5, 0, output                 #loop ends if $t5 equals 0, branches to output
	add.d $f4, $f4, $f14               #increments order of taylor series term by 2 (ex: from x to x^3)
	sub.d $f26, $f4, $f18              #$f26 is used to calculate factorial n
	mul.d $f6, $f6, $f0                #multiply f6 by x for sq
	mul.d $f6, $f6, $f0                #calculate the odd power (ex: from x to x^3)
	neg.d $f6, $f6                     #invert sign for every term of taylor series
	mul.d $f22, $f22, $f4              #$f22 contains factorial n. Step 1 of n! calculation
	mul.d $f22, $f22, $f26             #$f22 contains factorial n. Step 2 of n! calculation
	div.d $f24, $f6, $f22              #calcuates (-1)^(n-1) * x^n / n!
	add.d $f20, $f20, $f24             #adds result to $f20 which contains the series total         
	sub $t5, $t5, 1                    #increment loop counter by one
	b calculate_sin                    #branches back to loop until condition is met
output:
	s.d $f20 8($sp)	                   #stores result in stack space 8
exit:
	jr $ra                                  #jumps back to calling function
