TITLE Program5 CS271     (Program5-TeageSilbert.asm)

; Author:Teage Silbert   (silbertt@oregonstate.edu)
; Course / Project ID: CS271-400 Program 5                Date: 11/12/15
; Description:

INCLUDE Irvine32.inc

MIN = 10	;low number user can enter
MAX = 200	;high number user can enter
LO = 100	;low number of random number range
HI = 999	;high number of random number range

.data

intro 		BYTE		"Random Number Sorter		By:Teage Silbert", 0					;for intro
intro2		BYTE		"This program will have you enter a number, it will then", 0		;for intro
intro3		BYTE		"generate the specified number of random integers, show them", 0	;for intro	
intro4		BYTE		"and then sort them and show them again along with the median", 0	;for intro
unsorted	BYTE		"The unsorted array is:", 0											;for output about array
sortedAry	BYTE		"The sorted array is:", 0											;for output about array
medianInfo	BYTE		"The median of the array is: ", 0									;to assist in displaying the median
userNum		DWORD		?		;for user inputted number
userInput	BYTE		"Please enter a number between 10-200", 0		;to request user inputted
invalid		BYTE		"I'm sorry that is not a valid number", 0		;if number is invalid
userArray	DWORD	MAX		DUP(?)		;to store user numbers	
spacer		BYTE		"   ", 0		;for output purposes
counter		DWORD	10					;for output purposes



.code
main PROC

	call	randomize	
	call 	introduction
		
	push	OFFSET userNum
	call	getData

	push	userNum
	push	OFFSET userArray
	call	fillArray

	push	OFFSET	unsorted
	push	OFFSET	spacer
	push	userNum
	push	OFFSET userArray
	call	displayList

	push	userNum
	push	OFFSET userArray
	call	sortList

	push	OFFSET sortedAry
	push	OFFSET spacer
	push	userNum
	push	OFFSET userArray
	call	displayList
	
	push	OFFSET	medianInfo
	push	userNum
	push	OFFSET	userArray
	call	dispMedian


	exit	; exit to operating system
main ENDP

;Discription: This will output the information on how to use the program to the user
;Receives: intro strings on the stack
;Returns: Nothing	
;Preconditions: None
;Regs Changed: ESP, EBP, EDX
introduction	PROC

	mov		EDX, OFFSET	intro
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET	intro2
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET intro3
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET	intro4
	call	WriteString
	call	CrLf

	ret	
introduction	ENDP


;Discription: This will obtain the user input and validate the entry
;Receives:Output information addresses on the stack
;Returns: user inputted number
;Preconditions: None
;Regs Changed: ESP, EBP, EDX, EBX
getData		PROC

	push	EBP
	mov		EBP, ESP

;to obtain the number from the user
getNum:
	mov		EDX, OFFSET	userInput
	call	WriteString
	call	CrLf
	call	ReadInt	
	call 	CrLf
	mov		userNum, EAX	

;check validation of number
validate:
	cmp		EAX, MIN
	jl		outOfRange	
	cmp		EAX, MAX
	jg		outOfRange
	jmp		valid

;if number is out of range
outOfRange:
	mov		EDX, OFFSET	invalid
	call	WriteString
	call	CrLf
	jmp		getNum

;if number is valid
valid:
	mov		EBX, [EBP + 8]
	mov		[EBX], EAX
	pop		EBP

	ret 4
getData		ENDP

;Discription: to fill an array with a predefined number of random numbers
;Receives: address of array, value of element to be put in array
;Returns: address of array, value of elements to be put in array
;Preconditions: user has entered a valid number of elements for array
;Regs Changed: EAX, EDI
fillArray 	PROC

	push 	EBP
	mov		EBP, ESP
	mov		EDI, [EBP + 8]		;move list address into EDI
	mov		ECX, [EBP + 12]		;move number of user numbers into loop counter

moreNums:
	mov		EAX, 900			;set range for random numbers
	call	RandomRange			;generate random number and move into EAX
	add		EAX, LO				;add LO part of range to ensure rand num is in range
	mov		[EDI], EAX
	add		EDI, 4
	loop	moreNums	

	pop		EBP

	ret 8
fillArray	ENDP

;Discription: display the elements within the array
;Receives: address of list, number of values in array, address of title to display
;Returns: address of list, number of values in array, address of title to display
;Preconditions: user has input a valid number of elements for array and the array has been filled
;Regs Changed: ECX, EDX, EBX, EAX, EDI
displayList		PROC	

	push	EBP
	mov		EBP, ESP
	mov		EDI, [EBP + 8]		;move address of list to EDI
	mov		ECX, [EBP + 12]		;move number of values used to ECX
	mov		EDX, [EBP + 20]		;move title of into EDX
	mov		EBX, 10
	call	WriteString
	call 	CrLf
	mov		EDX, [EBP + 16]		;move address of 'spacer' to EDX
	jmp		printList


;	to use every time ten numbers have been printed to clear the line
break:
	call 	CrLf
	mov		EBX, 10
	cmp		ECX, 1	
	je		finish		;to avoid infinite loop
	dec		ECX
	jmp		printList

printList:
	mov		EAX, [EDI]
	add		EDI, 4
	call	WriteDec
	call	WriteString
	dec		EBX
	cmp		EBX, 0
	je		break
	loop	printList
	call	CrLf
finish:

	pop		EBP

	call 	CrLf

	ret 16
displayList		ENDP

;Discription: to sort the array from largest to smallest	
;Receives: address of array, value of number of elements in the array
;Returns: address of array, value of number of elements in the array
;Preconditions: array has been filled
;Regs Changed:  ECX, EAX, EDX, EBX, ESI
sortList	PROC


	push	EBP
	mov		EBP, ESP	
	mov		EDI, [EBP + 8]	;move address of array into EDI
	mov		ECX, [EBP + 12]	;move number of elements in array into ECX
	dec		ECX			
	mov		EBX, 0	;k

;outer loop 
L1:

	push	ECX				;outer loop counter pushed onto stack
	mov		EAX, EBX		; i (i=k)
	mov		EDX, EAX
	inc		EDX				; j (k+1)

	mov		ECX, [EBP + 12] ; to move inner loop counter into ECX
	sub		ECX, EDX		; inner loop will need to get smaller each iteration through

	;inner loop	
L2:
	mov		ESI, [EDI + EDX*4]	;move element at j into ESI and compare to 
	cmp		ESI, [EDI + EAX*4]	;element at i
	jg		switch
	inc		EDX		;to test next element
	jmp		continue

switch:

	mov		EAX, EDX	;move i to j if greater than
	inc		EDX			;to test next element

continue:
	loop	L2
	
	;push the elements onto the stack and pop them off but into
	;the opposite position, swapping them (i.e. exchange(array[k], array[i]))
	push	[EDI + EBX*4] 	;k
	push	[EDI + EAX*4]	;i
	pop		[EDI + EBX*4]	;pop i into what was k
	pop		[EDI + EAX*4]	;pop k into what was i

	inc		EBX				;increment i & k
	pop		ECX
	loop	L1


	pop		EBP

	ret 8
sortList		ENDP

;Discription: calculates and outputs the median of the array
;Receives: address of array, value of elements in the array, address of output 
;Returns: address of array, value of elements in array, address of output
;Preconditions: array has been filled and sorted
;Regs Changed: EAX, ECX, EDX, EBX
dispMedian		PROC	

	push 	EBP
	mov		EBP, ESP
	mov		EDI, [EBP + 8]	;mov address of array into EDI
	mov		EAX, [EBP + 12] ;mov number of elements into ECX
	mov		EDX, [EBP + 16] ;mov address of 'medianInfo' to EDX
	call	WriteString
	
	mov		ECX, 2
	cdq
	div		ECX			;to determine if the array has an odd or even number of elements
	cmp		EDX, 0			;to check if even
	je		evenNums		;if even jump to calculate average of the two 
	mov		EBX, EAX	
	mov		EAX, [EDI + EBX*4]
	call	WriteDec
	call	CrLf
	jmp		completed		;skip 'evenNnums' if number of elements is odd
	
	;if there are an even amount of nums in array
	evenNums:
	mov		EBX, EAX
	mov		EAX, [EDI + EBX*4]	;to add first of two numbers
	dec		EBX					;to get next number in array (need to work backwards)
	add		EAX, [EDI + EBX*4]
	div		ECX
	call	WriteDec
	call	CrLf
	
	;to use to skip over 'evenNums' if original is odd
	completed:
	call	CrLf
	
	pop		EBP

	ret 	12
dispMedian		ENDP

END main