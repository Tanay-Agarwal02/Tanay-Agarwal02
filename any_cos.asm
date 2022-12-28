#cos(x) is calculated using Taylor series expansion
# 1 - x^2/2! +  x^4/4! - x^6/6! .... 
#to reduce calculation I used the property cos(x +/- 2npi) is equal to cos(x) t0 fold the x value betwewen 0 and 2pi				
.data
		 .align  3						#aligns memory to double
pi_const:        .double 3.14159265358979323846264338327		#pi
two_const:       .double 2.0                         #constant		# 2
low_limit:       .double 0.0                         #constant		# 0 (lower limit to which x is folded
one_const:       .double 1.0                         #constant		# 1
zero_const:      .double 0.0                         #constant		#  0
new_line:        .asciiz "\n"           

.text
.globl any_cos                     		#global
any_cos:
	l.d $f0, 0($sp)                   	#load x value from the stack
	l.d $f2, zero_const              	#loads 0 into f2
	l.d $f4, pi_const			#loads the pi value
	l.d $f8, low_limit                	#loads 0 (lower limit of folded x value)
	l.d $f14, two_const			#loads 2 in $f14
	mul.d $f10, $f4, $f14             	# loads 2pi in $f10
	l.d $f18, one_const			# loads 1 in $f18
	li $t6, 0                         	#counter             
	
	c.lt.d $f0, $f8				# check if x < 0
	bc1t lower				# brach to lower
	c.le.d $f0, $f10			# check if x >= 2pi
	bc1f upper				# brach to upper
	b continue				# continue if 0 =< x  < 2pi
lower:
	add.d  $f0, $f0, $f10			# x -> x + 2pi
	c.lt.d $f0, $f8                   	#checks if $f0 is less than 0
	bc1t lower                        	#if the condition is true brach back to lower
	b continue                        	#branches to continue when done
upper:
	sub.d  $f0, $f0, $f10 			# x ->x - 2pi
	c.le.d $f0, $f10                 	# check if x < 2pi
	bc1f upper                        	#branches to upper if the less than condition is false
	b continue                        	#branches to continue when done
continue: 
	li  $t5, 40                 		#number of iterations of taylor series  (first 40 terms get enough accuracy if x is between 0 and 2pi)
	l.d $f4, zero_const           		#f4 tracks the polynomial term
	l.d $f20, one_const          		#loads one into $f20; #f20 has final Taylor series sum
	l.d $f6, one_const           		#sets $f6 to 1 (first term of Taylor series)
	l.d $f22, one_const         		# $f22 stores n! value (initialized to 1)
calculate_cos:
	beq   $t5, 0, output                  	#if number of iterations is over then exit
	add.d $f4, $f4, $f14			# increment polynomial term by 2
	sub.d $f26, $f4, $f18			# $f26 -> $f4 - 1
	mul.d $f6, $f6, $f0			# multiply $f6 by x
	mul.d $f6, $f6, $f0			# multiply $f6 by x
	neg.d $f6, $f6				# invert sign of #f6 every iteration
	mul.d $f22, $f22, $f4			# multiply $f22 by n 
	mul.d $f22, $f22, $f26			# multiply $f22 by n-1 to get n!
	div.d $f24, $f6, $f22			# get x^n/n!
	add.d $f20, $f20, $f24   		# add polynomial term to overall Taylor series          
	sub   $t5, $t5, 1			# decrement loop counter
	b calculate_cos
output:
	s.d $f20 8($sp)				#store final result in tack
exit:
	jr $ra                                  #jumps back to main
