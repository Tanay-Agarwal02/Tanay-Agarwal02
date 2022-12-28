# exp(x) is calculated by Taylor series as: exp(x) = 1 + x/1! + x^2/2! + x^3/3! + ........
# STEP1 To converge fast, the x value is folded to a number between -0.5 and +0.5, by recursively dividing it by 2 till the -0.5 < 0.5 < 0.5
# STEP2: Taylor series is applied
# STEP3: Result of Taylor series is squared the number of time, the x value was divided by 2 in STEP1
.data
		 .align 3
low_limit:       .double -0.50           #lower limit
high_limit:      .double  0.50           #upper limit
two_const:       .double 2.0            #constant
one_const:       .double 1.0            #constant
zero_const:      .double 0.0            #constant
new_line:        .asciiz "\n"           

.text
.globl any_exp                     #global
any_exp:
	l.d $f0, 0($sp)                   #taking the 0th value from the stack\
	l.d $f2, zero_const               #loads 0 into f2
	l.d $f8, low_limit                #loads 0.75 into $f8
	l.d $f10, high_limit              #loads 1.5 into $f10
	l.d $f14, two_const
	l.d $f18, one_const
	li $t6, 0                         #counter             
	
	c.le.d $f0, $f8			#Checks if x<-0.5 and branches to lower if condition is met
	bc1t lower
	c.le.d $f0, $f10		#Checks if x < 0.5 and branches to upper if condition is not met
	bc1f upper
	b continue
lower:					#STEP1A: normalize x value when x< -0.5
	div.d $f0, $f0, $f14              #divides $f0 by two until $f0 is greater than -0.5
	add $t6, $t6, 1                   #adds counter $t6 by 1
	c.le.d $f0, $f8                   #checks if $f0 is less than -0.5
	bc1t lower                        #if the condition is true brach back to lower
	b continue                        #branches to continue when done
upper:					#STEP1B: normalize x value when x > 0.5
	div.d  $f0, $f0, $f14             #divides $f0 by two until $f0 is less than 0.5
	add $t6, $t6, 1                   #adds counter $t6 by 1
	c.le.d $f0, $f10                  #loop condition
	bc1f upper                        #branches to upper if the less than condition is false
	b continue                        #branches to continue when done
continue:
	li $t5, 15                   	#number of iterations of taylor series
	l.d $f4, one_const           	#f4 - iteration count
	l.d $f20,one_const          	#$f20 carries exp value
	l.d $f6, one_const           	# $f6 stores x^n
	l.d $f22,one_const		# $f22 stores n! value
calculate_exp:				#STEP2
	beq $t5, 0, final_calc          #if number of iterations is over then exit
	mul.d $f6, $f6, $f0             #calculate x^n
	div.d $f24, $f6, $f22		# calculate x^n/n!
	add.d $f20, $f20, $f24   	#add to Taylor series sum          
	add.d $f4, $f4, $f18		#increment series counter by 1
	mul.d $f22, $f22, $f4		# calcualte n!
	sub $t5, $t5, 1			# decrement loop counter
	b calculate_exp
final_calc:				#STEP3
	beqz $t6, output		#if $$t6 = 0, exit loop
	mul.d $f20, $f20, $f20		#Square the result
	sub $t6, $t6, 1			#decrement loop counter
	b final_calc
output:
	s.d $f20 8($sp)			#store final result in stack
exit:
	jr $ra                          #jumps back to main
