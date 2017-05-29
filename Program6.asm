TITLE Program6A-CS271    (Program6ACS271-TeageSilbert.asm)

; Author:Teage Silbert
; CS271 - Program 6A                Date:12/6/15
; Description: This program will ask the user for 10 numbers, take
; them as a string, convert them to dwords, do input validation
; output the sum and average of the numbers

INCLUDE Irvine32.inc

MAX = 4294967295	;Max number for 32 bit register, for input validation
MIN = 1				;Min unnsigned for 32 bit regist, for input validation
MAXLENGTH = 10		;Max length of string for number in 32 bit reg, for input validation

;Discription: This macro prints out a string
;Receives: Offset to a string 
;Returns: Nothing	
;Preconditions: None
;Regs Changed: EDX

displayString MACRO buffer

push 	EDX
mov		EDX, buffer
call	WriteString 
call	CrLf
pop		EDX

ENDM

;Discription: This macro asks the user for a string of numbers
;Receives: receives the offset of a string for output as well as another string for user input 
;Returns: number in string form	
;Preconditions: None
;Regs Changed: EDX, EAX, ECX

getString	MACRO 	output, number, retnumber

		displayString	output

mov		EDX, OFFSET	number
mov		ECX, (SIZEOF number) - 1 
call	ReadString	
mov		retnumber, EAX

		
ENDM

.data

intro		BYTE	"Program 6A: Designing low-level I/O procedures", 0		;to provide user information
intro2		BYTE	"Written By: Teage Silbert", 0		;to provide user information
intro3		BYTE	"Please enter 10 unsigned integers between 1 and 4,294,967,295", 0	;to provide information to user
intro4		BYTE	"After the information has been entered the sum and average will be displayed", 0	;to provide information to user
getNum		BYTE	"Please enter a number:", 0		;to prompt user for input
invalid		BYTE	"I'm sorry you entered invalid input, please try again", 0		;to inform user of incorrect input
stringNum	BYTE	20	DUP(?)	;to obtain user numbers in string form
numArray	DWORD	10	DUP(?)	;to hold numeric values
singleNum	DWORD	?		;to hold numbers before moving them to array
tempString	BYTE	10	DUP(0)	;to hold temp value before moving to dwords
sum			DWORD	?		;to hold the sum of the array
avg			DWORD	?		;to hold the average of the array
sumByte		BYTE	"The sum of your numbers is:", 0		;to display the sum of the numbers
avgByte		BYTE	"The average of your numbers is:", 0	;to display the average of the numbers
stringArry	BYTE	1000	DUP(?)	;to hold numbers in string form from array
numsEntered	BYTE	"The numbers you entered are:", 0	;to inform user of numbers used	
stringSize	BYTE	1000	DUP(?)	;to hold the size of the string


.code
main PROC

		displayString	OFFSET intro	;to display intro to user
		displayString	OFFSET intro2
		displayString	OFFSET intro3
		displayString	OFFSET intro4	
		
		push	OFFSET	tempString	;+28
		push	OFFSET	invalid		;+24
		push	OFFSET	getNum		;+20
		push	OFFSET 	numArray	;+16			
		push	OFFSET 	stringNum	;+12
		push	singleNum			;+8
		call	readVal
		
		push 	OFFSET	stringSize	;+20
		push	OFFSET	numsEntered	;+16
		push	OFFSET	numArray	;+12
		push	OFFSET	stringArry	;+8
		call	writeVal
		
		
		push	OFFSET	sumByte		;+16	
		push	OFFSET	avgByte		;+12
		push	OFFSET	numArray	;+8
		call	calculate


	exit	; exit to operating system
main ENDP


;Discription: This will ask the user to input 10 numbers in string form
;and convert them to numeric data and store it in an array
;Receives: array to store numeric values in, string to store user number in,
;Returns: Nothing	
;Preconditions: None
;Regs Changed: ESP, EBP, EDX, EDI, ECX, EAX, EBX

readVal PROC

	push	EBP
	mov		EBP, ESP
	mov		EDI, [EBP + 16]	;will be array for storing numeric values
	mov		ECX, 10	;to keep a loop of how many numbers are entered
	call	CrLf
	
startInput:
	
	push	ECX		;so that only 10 valid iterations are completed
	
repeater:				
	mov		ESI, [EBP + 12]	;points to user number in string form
	
getInput:
	
	getString	[EBP + 20],	stringNum, [EBP + 8] ;to obtain input from user
	mov		ECX, [EBP + 8]	;move length of number into ECX for new loop
	mov		EDX, 0
	cmp		ECX, 10			;check to see if length is invalid
	jg		notValid
	cld		;set direction flag
	
InnerL:
	LODSB	;load byte into AL reg
	cmp		AL, 48
	jl		notValid
	cmp		AL, 57
	jg		notValid
	jmp		Continue
	
notValid:
	displayString	[EBP + 24]
	jmp		repeater		;to get new valid input
	
Continue:

	sub		AL, 48	;get actual numerical value from string in EAX/AL
	push	EAX			;to store current number
	push	ECX	
	mov		EAX, EDX	
	mov		ECX, 10
	mul		ECX			;multiply current digit(s) by 10 to move the digits 
	mov		EDX, EAX	;put value back into EDX before popping
	pop		ECX
	pop		EAX
	movsx	EBX, AL
	add		EDX, EBX
	loop	InnerL
	
numValidation:
	
	
	mov		EAX, EDX
	cmp		EAX, 4294967295
	ja		notValid
	cmp		EAX, MIN
	jb		notValid
	mov		[EDI], EAX	;move number into array
	add		EDI, 4
	pop		ECX
	dec		ECX			;manually decrement ECX, distance to far to loop
	cmp		ECX, 0
	je		endProcess
	jmp		startInput

endProcess:	
	
	pop 	EBP
	
	ret 28
readVal	ENDP

;Discription: This will calculate the sum and average of the users input
;Receives: array of numbers 
;Returns: Nothing	
;Preconditions: numbers in string form converted to number and stored in array
;Regs Changed: EBP, ESP, EDI, ECX, EAX, EDX

calculate	PROC	

	push	EBP
	mov		EBP, ESP
	mov		EDI, [EBP + 8] ;to move array to EDI
	mov		ECX, 10
	mov		EAX, 0
	
sumNums:
	add		EAX, [EDI]	;to accumulate total of the array
	add		EDI, 4		;to move to next item in the array
	loop	sumNums
	displayString [EBP + 16]
	call	writedec
	call	crlf
	
averageNums:
	mov		EDX, 0	;clear edx to ensure proper division
	mov		ECX, 10
	div		ECX		;divide EAX by 10
	displayString [EBP + 12]
	call	writedec
	call	crlf

	pop		EBP

	ret 16
calculate	ENDP

;Discription: This will take the offset of the the array and convert it back to a string
;Receives: offset of array of dwords, offset of string, offset of byte string for output purposes
;Returns: Nothing	
;Preconditions: numbers in array
;Regs Changed: EBP, ESP, EDI, ECX, EAX, EDX, ESI

writeVal 	PROC
	
	push	EBP
	mov		EBP, ESP
	mov		ESI, [EBP + 12] ;move number array (dword form) to ESI
	mov		EDI, [EBP + 8]	;move number array (string form) to EDI
	displayString	[EBP + 16]	;for output purposes
	mov		EBX, 10		;to use as divisor/multiplier
	mov		ECX, 10
	
start:
	
	push	ECX
	mov		EAX, [ESI]	;move first number into EAX
	cmp		EAX, 0
	mov		ECX, 0
	je 		addup		;if number is 0 

convert:
	
	cdq
	div		EBX	
	push	EDX			;push remainder onto stack
	inc		ECX
	cmp		EAX, 0
	je		popNums
	jmp		convert
	
popNums:
	pop		EAX			;pop off stack to get into proper order
	add		EAX, 48
	cld
	stosb
	loop	popNums
	
addup:	

	mov		AL, " "		;to hold a space between numbers
	cld
	stosb
	add		ESI, 4
	pop		ECX
	loop 	start
	mov		ECX, 1000
	mov		EBX, 0
	mov		EDX, 1
	
	
nextChar:	
	
	displayString  [EBP + 8]	;to display numbers
	
	pop		EBP
	
	ret	20
writeVal	ENDP


END main