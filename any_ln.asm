# natural log or ln(x) is calculated using Taylor series given as:
# ln(1+x) = x - (x^2/2) + (x^3/3) - (x^4/4).... (x^n/n)
#domain of x is (-1,1] 
#STEP1: keep on dividing or multiplying x value by 2 until it is between 0.5 and 1.5, update final result by ln(2) everytime a multiply or divide is done
#STEP2: calculate ln(x) using the equation above
.data
		 .align 3
ln_2:            .double 0.693147180559945309417  #ln(2) value
low_limit:       .double 0.5                      #lower limit
high_limit:      .double 1.50                     #upper limit
two_const:       .double 2.0                      #constant
one_const:       .double 1.0                      #constant
zero_const:      .double 0.0                      #constant
new_line:        .asciiz "\n"           
.text
.globl any_ln                     #global
any_ln:
	l.d $f0, 0($sp)                   #taking the 0th value from the stack\
	l.d $f2, zero_const               #loads 0 into f2
	l.d $f8, low_limit                #loads 0.5 into $f8
	l.d $f10, high_limit              #loads 1.5 into $f10
	l.d $f14, two_const		  #loads 2 into $f14	
	l.d $f16, ln_2		          #loads ln_2 into $f16
	l.d $f18, one_const		  #loads one into $f18

        mov.d $f20, $f18	          #$f20 stores the final value of taylor series sum, moving first term into taylor series
	c.le.d $f0, $f8 	  	  #checks if x less than 0.5
	bc1t lower			  #branches to lower if condition is true
	c.lt.d  $f0, $f10		  #checks if x is less than 1.5
	bc1f upper  			  #branhces to upper if condition is false
	b continue			  #branches to continue if x is between 0.5 and 1.5
lower:
	mul.d $f0, $f0, $f14              #multplies $f0 by 2
	sub.d $f2, $f2, $f18              #$f2 stores the number of times multiplaction is done
	c.le.d $f0, $f8		 	  #check if $f0 (x) is less than equal lower limit (0.5)
	bc1t lower			  #branches to lower if condition is true
	mul.d $f20, $f2, $f16 		  #multiplying $f2 by $f16 or sum = sum - i * ln(2)
	b continue			  #branches to continue 
upper:
	div.d  $f0, $f0, $f14             #divides $f0 by 2
	add.d $f2, $f2, $f18              #$f2 stores the number of times division is done
	c.le.d $f0, $f10                  #check if $f0 (x) is less than equal lower limit (0.5)
	bc1f upper			  #branches to upper if condition is false
	mul.d $f20, $f2, $f16 		  #multiplying $f2 by $f16 or sum = sum + i * ln(2)
	b continue			  #branches to continue 
continue:
	sub.d $f0, $f0, $f18              #$f0 is x
	li $t5, 15                        #number of iterations of taylor series
	mov.d $f4, $f18                   #loads one into f4 - taylor series polynomial count
	add.d $f20, $f20, $f0             #$f20 carries final taylor series sum
	mov.d $f6, $f0                    #moves $f0 (x) value into $f6
	neg.d $f22, $f18                  #$f22 is equal to -1
calculate_ln:
	beq $t5, 0, output                  #if number of iterations is over then go to output
	mul.d $f6, $f6, $f0		    #multiply $f6 by $f0 (x)
	mul.d $f6, $f6, $f22		    #multiply $f6 by $f22 or -1 to invert sign for every term
	add.d $f4, $f4, $f18		    #increment the polynomial term counter by one
	div.d $f24, $f6, $f4		    #calculate x^n/n
	add.d $f20, $f20, $f24		    #add to taylor series sum
	sub $t5, $t5, 1			    #decrement loop counter
	b calculate_ln			    #branch back to calculate_ln
output:
	s.d $f20 8($sp)			    #store result in stack slot 8
exit:
	jr $ra                                  #jumps back to main

