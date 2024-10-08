.data

array: .space 40
var: .asciiz"--------------------------------------------------------Project--------------------------------------------------------------------------\n"
var3: .asciiz"-------------------------------------------------------Binary Search--------------------------------------------------------------------\n"
var1: .asciiz "How many numbers do you want to enter in the array (Numbers should not be greater than 10) = "
Input: .asciiz "Enter a number = "
var2: .asciiz"You entered more than 10 values so program is finished :) "
backslash: .asciiz"\n"
contains: .asciiz "\nThis array contains following values =  \n"
search_number: .asciiz "\nEnter a number you want to search in an array =  "
f:.asciiz "  was found at array["
bracket_closed:	.asciiz	"]"
nf: .asciiz "   was not found in array"
var4: .asciiz "\n---------------------------------------------End of program------------------------------------------------------------------------------"


 
.text
.globl main
main:

li $v0 , 4		# Printing string
la $a0 , var
syscall

li $v0 , 4		# Printing string
la $a0 , var3
syscall



#--------------------------Functions-------------------------------------------

jal NumberOfIntegers				# Function for the user to enter how many numbers they want in an array
jal Taking_Input_Of_Array 		    # Function to take the input in an array
jal Integers_In_Array 		    	# Function to print the elements in an array
jal Sorting 		        		# Function to sort an array in ascending order
jal Integers_In_Array 		    	# Function to print the sorted array
jal Search_For_Integer		    	# Function that asks the user for a number they are searching for
jal Binary_Search		        	# Function to perform binary search algorithm
jal Search_results	    			# Function to print the result after the binary search
j Program_Finished 			        # Function to exit from the program
	



NumberOfIntegers:
	 
	  					
	li $v0, 4		# Printing string for the user input
	la $a0, var1 				
	syscall
		
	li $v0, 5 		# Taking input
	syscall
	move $t0, $v0 	
	

	bgt $t0 ,10 ,then  # This condition will check if user entered more than 10 values in array then the program will terminate
	b then2
	then:
	li $v0 , 4			# Printing string for the program is finished
	la $a0 , var2
	syscall

	li $v0 , 10			# End statement
	syscall

	b end

	then2:

	li $t1, 0 		
	li $t2, 1 		

	
	jr $ra 			# Return to main.

Taking_Input_Of_Array:
	 	
		
	li $v0, 4 			# Printing string for the array input
	la $a0, Input		
	syscall

	li $v0, 5 			# Taking input from the user
	syscall
	sw $v0, array($t1)  # Store the values in an Array
				 	
	addi $t1, $t1, 4  	#Array increment
	addi $t2, $t2, 1  	#Loop increment i++			

	ble $t2, $t0, Taking_Input_Of_Array	

	jr $ra 				
	
Integers_In_Array:
	
	li $t1, 0 		
	li $t2, 1 		
	
	 		
	li $v0, 4			# Printing string that array contains the following values
	la $a0, contains 			
	syscall
	
	Printing_The_Array:
		 	
		li $v0, 1 			# Print the values in an array
		lw $a0, array($t1)		
		syscall
		
				
		li $v0, 4 		# Printing \n
		la $a0, backslash 		
		syscall
	
		addi $t1, $t1, 4 	# Array increment
		addi $t2, $t2, 1	# Loop increment
		ble $t2, $t0, Printing_The_Array 	# if $t2 (integer counter) <= $t0 (total # of integers) then go to Printing_The_Array

		jr $ra				
		
Sorting:
	li $t2, 0				# i = 0 
	outer:
		addi $t2, $t2, 1 		
		la $a1, array 			# Load array address into $a1
		li $t1, 0 			    # array[x] = array[0]
		sub $t3, $t0, 1 		# $t3 = n - 1 (n = total # of integers)
		addi $t4, $t2, 1 		# j = i + 1
		ble $t2, $t3, inner 	# if i <= (n-1) then to inner
		jr $ra				    
	inner:
		lw $t5, 0($a1) 			# Example: a = 10
		lw $t6, 4($a1) 			# Example: b = 19
		bgt $t5, $t6, swap 		# if a > b: swap
        	j continue			# else  continue
	swap:
		sw $t6, 0($a1) 			# Example: a = 19
		sw $t5, 4($a1) 			# Example: b = 10
	continue:
		addi $a1, $a1, 4 		# Array[x+1]
		addi $t4, $t4, 1 		# j + 1
		bgt $t4, $t0, outer 	# if (j = i + 1) then go to outer
		j inner 				# else then go to inner
		
					
Search_For_Integer:				
			
	li $v0, 4					# Printing string for the user to search for the integer they are looking for
	la $a0, search_number			
	syscall
		
	li $v0, 5					# Taking input from the user
	syscall
	move $t0, $v0			
		
	li $t2, 0			# First element in the array: array[0]
	li $t4, 2 			# 2 is used to divide the elements in the array for the midpoi
	li $t6, 4			# For the Array increment

	jr $ra				
			
Binary_Search:
	bgt $t2, $t3, return	# if $t2(first element) > $t3(last element (n-1)): The number wasn't found and return to main
	middle:
		add $t7, $t2, $t3	# Store the sum of $t2(first element) and $t3(last element(n-1)) in $t7.
		div $t7, $t4 		# Midpoint = (first element + last element) / 2.
		mflo $t8			# Store the middle element in $t8.
		
		mult $t8, $t6		# Multiply the middle element by 4 to get the index for the array.
		mflo $t1			# Store the product in $t1.
		
		lw $t5, array($t1)	# Load the value of array[(middle) * 4] in $t5.
							
		bgt $t5, $t0, lower	# if middle element > x (users entered integer) then check the lower half of the array
		blt $t5, $t0, upper	# if middle element < x (users entered integer) then check the upper half of the array
		li $s0, 1			# The integer was found (1 = true)
		jr $ra				
	
	upper:					# Upper half of the array.
		add $t2, $t8, 1		# $t2 (first element) = $t8 (middle element) + 1
		j Binary_Search			
	
	lower:					# Lower half of the array.
		sub $t3, $t8, 1		# $t3 (last element (n-1)) = $t8 (middle element) - 1
		j Binary_Search		
	
	return:
		li $s0, 0			# The integer wasn't found (0 = false)
		jr $ra				

Search_results:
	beqz $s0, not_found	
	found:
	
			
		li $v0, 1		# Print the integer that user entered
		move $a0, $t0		
		syscall
			
				
		li $v0, 4		# Printing string for number is found
		la $a0, f			
		syscall

		div $t1, $t6		# Dividing the array by 4 to get the location of the number and store it in $a0 
		mflo $a0		

		li $v0, 1		# Printing the location of the number of an array
		syscall
			
			
		li $v0, 4			#Printing string to close the bracket ]
		la $a0, bracket_closed		
		syscall
	
		jr $ra			
	
	not_found:
				
			
		li $v0, 1		# Prints the user entered number
		move $a0, $t0		
		syscall
			
				
		li $v0, 4		# Printing string that number was not found
		la $a0, nf	
		syscall	
		
		jr $ra			
		
Program_Finished:
	
	li $v0, 4 			# Printing string that program is finished
	la $a0, var4		
	syscall
	
	li $v0, 10 		# Ends the program.
	syscall

end:
	li $v0 , 10 
	syscall