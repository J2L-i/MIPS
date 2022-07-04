#Money Calculator 
#Includes bonus points of multiplying and dividing with decimal.
#Prints the user inputs on one line.
#Rounds the decimal when there is 3 decimals.

.data
num1: 	.asciiz "\nEnter 1st Number: "
oper: 	.asciiz "Select Operator: "
num2: 	.asciiz "\nEnter 2nd Number: "
equal: 	.asciiz "Result: "
remain: 	.asciiz "\nRemainder: "
end: 		.asciiz "\nFinished"
illegal:	.asciiz "\nIllegal operation!\n"
MyNum1: 	.word 0
MyNum2: 	.word 0
result: 	.word 0
MyNumStr1:  .space 12
MyNumStr2:  .space 12
MyResultStr: .space 24
operator:	.byte	0

.text   
main:

# Get the first number
	la	$a0, num1
	la	$a2, MyNumStr1
	la	$a3, MyNum1
	jal	GetInput
	
# Get the operator
		la	$a0, oper
	la	$a1, operator
	jal	GetOperator
	

# Grt the second number
	la	$a0, num2
	la	$a2, MyNumStr2
	la	$a3, MyNum2
	jal	GetInput

# Perform an operation between 2 numbers
# Depending on operator	
	la	$s1, MyNum1
	lw	$a0, 0($s1)
	la	$s1, MyNum2
	lw	$a1, 0($s1)
	lb	$s0, operator
	
# Check if operation is addition
	bne	$s0, '+', CheckSubtraction
	jal	AddNumb
	j	PrintResult
	
# Check if operation is subtraction
CheckSubtraction:
	bne	$s0, '-', CheckMultiplication
	jal	SubNumb
	j	PrintResult
	
# Check if operation is multiplication
CheckMultiplication:
	bne	$s0, '*', CheckDivision
	jal	MultNumb
	j	PrintResult
	
# Check if operation is division
CheckDivision:
	bne	$s0, '/', IllegalOperator
	jal	DivNumb
	j	PrintResult

# If none of the operations then print error message	
IllegalOperator:
	la	$a0, illegal
	li	$v0, 4
	syscall
	j	ExitProgram

# Print the result line
PrintResult:

# Print result	
	li	$v0, 4
	la 	$a0, equal 
	syscall

# Print 1st number
	la	$a0, MyNum1	
	jal	DisplayNumb
	
# Print opertor
	la	$a0, operator
	lb	$a0, 0($a0)
	li	$v0, 11
	syscall
	
# Print second number
	la	$a0, MyNum2
	jal	DisplayNumb
	
# Print equal sign
	li	$a0, '='
	li	$v0, 11
	syscall
	
# Print result
	la	$a0, result
	jal	DisplayNumb
	
# Print newline
	li	$a0, '\n'
	li	$v0, 11
	syscall

#Exit with finished message
ExitProgram:
	li 	$v0, 4
	la 	$a0, end
	syscall

	li 	$v0, 10
	syscall



#The input number will be stored at address pointing by $a3
# $a0 holds the pointer to prompt message
# $a2 holds the pointer to string where to receive the input
# $a1 will hold the length of the string
# There is no check for incorrect characters
# Negative values are not accepted
GetInput:
# Prompt message
	li	$v0, 4
	syscall
  
# Read in the string
	li	$a1, 12
	move	$a0, $a2
	li	$v0, 8
	syscall
	
# Loop every character in the string and extract it as a digit
	li	$t0, 0
	li	$t2, 2
Loop1:
	lb	$t1, 0($a2)
	beq	$t1, 0, EndInput			# Check if end of string
	beq	$t1, 10, EndInput			# Check if newline
	beq	$t1, '.', DecimalPoint		# Check if decimal point
	subi	$t1, $t1, 48			# Convert char to value
	mul	$t0, $t0, 10			# Multiply number by 10 to move current digits forward
	add	$t0, $t0, $t1			# Add the digit to last place
	addi	$a2, $a2, 1				# Point to next character
	j	Loop1
	
# After the decimal point only 2 digits are significant
DecimalPoint:
	lb	$t1, 1($a2)				
	beq	$t1, 0, EndInput
	beq	$t1, 10, EndInput
	subi	$t1, $t1, 48
	mul	$t0, $t0, 10
	add	$t0, $t0, $t1
	add	$a2, $a2, 1
	subi	$t2, $t2, 1				# Count the digits after decimal point
	beq	$t2, 0, Rounding			# If 2, then go to rounding
	j	DecimalPoint
	
Rounding:
	lb	$t1, 1($a2)
	beq	$t1, 0, EndInput			# No rounding if no digits after the two
	beq	$t1, 10, EndInput
	blt	$t1, 53, EndInput			# No rounding if less than 5 is the next digit
	beq	$t1, 53, CheckFurther		# If 5 then check further
	addi	$t0,  $t0, 1			# If gretaer than 5, add 1 to last digit
	j	EndInput
	
CheckFurther:
	lb	$t1, 2($a2)				# Read character after 5
	beq	$t1, 0, CheckOdd			# If no character, then check the previous us odd or even
	beq	$t1, 10, CheckOdd
	addi	$t0, $t0, 1				# If there is a character then greater than 5, so add 1 to last digit
	j	EndInput
	
CheckOdd:
	andi	$t1, $t0, 1				# And number with 1
	bne	$t1, 1, EndInput			# If result is 1 then it is odd
	addi	$t0, $t0, 1				# If odd, then increment by 1

# In case that there were no 2 digits after decimal point, put two zeroes
EndInput:
	beq	$t2, 0, ExitInput
	mul	$t0, $t0, 10
	subi	$t2,$t2, 1
	j	EndInput


ExitInput:
# Store value in memory	
	sw	$t0, 0($a3)

	jr	$ra



# Input the operator
GetOperator:
	
	li	$v0, 4
	syscall
  
	li	$v0, 12
	syscall
	sb	$v0, 0($a1)
	
	jr	$ra


# Add the two numbers in $a0 and $a1 and store them in result
# no impact to floating point representation
AddNumb: 
	
	add	$v0, $a0, $a1
	la	$t0, result
	sw	$v0, 0($t0)
	
	jr	$ra
	

# Subtract the two numbers in $a0 and $a1 and store them in result
#no impact to floating point representation
SubNumb: 
	
	sub	$v0, $a0, $a1
	la	$t0, result
	sw	$v0, 0($t0)
	
	jr	$ra
	
  
# Multiply the two numbers in $a0 and $a1 and store them in result
# As mul operation is not allowed, multiplication is done by addition in a loop
MultNumb: 
	
	li	$t0, 0

# Add $a0 to result $a1 times
Loop2:
	beq	$a1, 0, Div100
	add	$t0, $t0, $a0
	subi	$a1, $a1, 1
	j	Loop2

# As there are 2 decimal digits at both operands, the result will have 4 of them
# But only 2 are allowed, so the result will be divided by 100 in a loop
Div100:
	move	$t1, $t0
	li	$t0, 0
Loop3:
	blt	$t1, 100, RoundMult
	subi	$t1, $t1, 100
	addi	$t0, $t0, 1
	j	Loop3
	
# Round the 2 left digits
RoundMult:
	blt	$t1, 50, EndMult				# If remainder less than 50, no rounding
	beq	$t1, 50, CheckOddMult			# If 50, then check if last digit is odd
	addi	$t0, $t0, 1					#If greater than 50 add 1 to last digit
	j	EndMult
	
CheckOddMult:
	andi	$t1, $t0, 1
	bne	$t1, 1, EndMult
	add	$t0, $t0, 1  
		
# Store the number in memory
EndMult:
	la	$t1, result
	sw	$t0, 0($t1)
	
  	jr	$ra
  	
# Divide two numbers in $a0 and $a1
# As div command is not allowed, division is done with subtraction in a loop  	      
DivNumb: 
	
	li	$t0, 0
	li	$t2, 0

# Subtract the second number from first until it become less then second number
Loop4:
	blt	$a0, $a1, Mul100
	addi	$t0, $t0, 1
	sub	$a0, $a0, $a1
	j	Loop4
	
# Multiply this result by 100, as this is the whole part of the result
Mul100:
	li	$t1, 100
	move	$t3, $t0
	li	$t0, 0
Loop5:
	beq	$t1, 0, CalcDec1
	add	$t0, $t0, $t3,
	subi	$t1, $t1, 1
	j	Loop5
	
# Multiply by 10 what remained from the first number, to try to divide further
CalcDec1:
	li	$t1, 10
	move	$t3, $a0
	li	$a0, 0
LoopDec1:
	beq	$t1, 0, DivDec1
	add	$a0, $a0, $t3
	subi	$t1, $t1, 1
	j	LoopDec1
	
# Subtract the second number from first until it become less than it
DivDec1:
	blt	$a0, $a1, Dec1
	addi	$t2, $t2, 1
	sub	$a0, $a0, $a1
	j	DivDec1
	
# Multiply the result by 10, as this is the first decimal digit
Dec1:
	li	$t1, 10
	move	$t3, $t2
	li	$t2, 0
LoopDec11:
	beq	$t1, 0, AddDec1
	add	$t2, $t2, $t3
	subi	$t1, $t1, 1
	j	LoopDec11
	
# Add it to the final result
AddDec1:
	add	$t0, $t0, $t2

# Multiply by 10 what remained from first number, to divide further for second digit	
	li	$t2, 0
	li	$t1, 10
	move	$t3, $a0
	li	$a0, 0
LoopDec2:
	beq	$t1, 0, DivDec2
	add	$a0, $a0, $t3
	subi	$t1, $t1, 1
	j	LoopDec2
	
# Subtract the second number from first until it will be less than it
DivDec2:
	blt	$a0, $a1, AddDec2
	sub	$a0, $a0, $a1
	add	$t2, $t2, 1
	j	DivDec2
	
# Add the last digit to result
AddDec2:
	add	$t0, $t0, $t2
	
	
# Store result in memory
EndDiv:
	la	$t1, result
	sw	$t0, 0($t1)
	
  	jr	$ra
	
  

# DisplayNumb
# Displays The number with 2 digits precision
# There are no leading zeroes, even when number is less than 1
# It prints negative numbers too (Result of subtraction)
DisplayNumb: 
# Save registers that will be changed 
	
	lw	$t1, 0($a0)
	la	$t0, MyResultStr
	li	$t4, 0
	li	$t5, 0

# Check if number is negative		
	bge	$t1, 0, PrintNumb
	mul	$t1, $t1, -1
	li	$t5, 1						# Set a flag if negative

PrintNumb:
	
	li	$t2, 10						# Set $t2 to 10

Loop6:
	beq	$t4, 2, PrintPoint				# Check if two digits are processed
	div	$t1, $t2						# Divide number by 10
	mflo	$t1							# Keep the quotient
	mfhi  $t3							# Get the remainder
	add	$t3, $t3, 48					# Convert it to character
	sb	$t3, 0($t0)						# Store it into string
	addi	$t0, $t0, 1
	addi	$t4, $t4, 1
	j	Loop6

# Put the decimal point into string	
PrintPoint:
	li	$t3, '.'
	sb	$t3, 0($t0)
	addi	$t0, $t0, 1
	addi	$t4, $t4, 1
	
# Store remained digits into string
Loop7:
	beq	$t1, 0, CheckSign					# Until there is a remainder
	div	$t1, $t2						# Divide number by 10
	mflo	$t1							# Keep the quotient
	mfhi  $t3							# Get the remainder
	add	$t3, $t3, 48					# Convert it to chracter
	sb	$t3, 0($t0)						# Store reminder in string
	addi	$t0, $t0, 1
	addi	$t4, $t4, 1
	j	Loop7

# Check sign, if negative add '-' to string
CheckSign:
	beq	$t5, 0, DisplayChars
	li	$a0, '-'
	li	$v0, 11
	syscall

# As we added the digits from back to the string, they are in reversed order
# Loop backwards to print character by character to get correct output
DisplayChars:
	beq	$t4, 0, EndDisplay
	lb	$a0, -1($t0)
	li	$v0, 11
	syscall
	subi	$t4, $t4, 1
	subi	$t0, $t0, 1
	j	DisplayChars
	
	
EndDisplay:
	
	jr	$ra
