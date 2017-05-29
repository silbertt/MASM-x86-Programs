TITLE Program4 CS271    (Program4CS271-TeageSilbert.asm)

; Author:Teage Silbert (silbertt@oregonstate.edu)
; Course / Project ID: CS271-400 Program4      Date:11/5/15
; Description: This program will ask a user to input a number between
; 1-400 (inclusive), and then utilizing procedures determine if all of
; the numbers up to and including the specified number are composite 
; numbers, outputting only the composite numbers

; **Data Validation will be used**

INCLUDE Irvine32.inc

UPPERLIMIT = 400
LOWERLIMIT = 1

.data

greeting1	BYTE	"Composite Numbers          By: Teage Silbert", 0				;part of intro to program
greeting2	BYTE	"Please enter a number between 1-400 (inclusive) and the", 0	;part of intro to program
greeting3	BYTE	"program will print out all of the composite numbers up to", 0	;part of intro to program
greeting4	BYTE	"and including (if composite) the number entered", 0			;part of intro to program
getNumber	BYTE	"Please enter a number: ", 0									;to obtain user number
outro		BYTE	"Thank you for your assistance, have a good day!", 0			;to user for exit msg
notValid	BYTE	"I'm sorry that is not a valid number", 0						;if user input is invalid
divisor		DWORD	?		;to use to determine if a number is prime
userNum		DWORD	?		;to use for user number
start		DWORD	2		;first number to check for composite
remainder	DWORD	?		;to check if there is a remainder
spacer		BYTE	"   ", 0	;for output spacing purposes
numPrinted	DWORD	10		;used to count number of items printed on a line	

.code
main PROC

call intro
call getData
call showComposites
call exitMsg

	exit	; exit to operating system
main ENDP

;Discription: This will output the information on how to use the program to the user
;Receives: Nothing
;Returns: Output of purpose and how to use program
;Preconditions: None
;Regs Changed: EDX, but can be changed directly after use
intro PROC

mov		EDX, offset greeting1
call	WriteString
call	CrLf
call 	CrLf
mov		EDX, offset greeting2
call	WriteString
call	CrLf
mov		EDX, offset greeting3
call	WriteString
call	CrLf
mov		EDX, offset	greeting4
call	WriteString
call	CrLf


	ret
intro ENDP


;Discription: This will obtain a number from the user and ensure it is valid
;Receives: integer from user
;Returns: nothing
;Preconditions: none
;Regs Changed:EDX, EAX
getData PROC

;to obtain and validate data
validate:
mov		EDX, offset getNumber
call	WriteString
call	ReadInt
mov		userNum, EAX
call	CrLf
cmp		EAX, UPPERLIMIT
jg		InvData
cmp		EAX, LOWERLIMIT
jl		InvData
jmp		goodData

;if data is invalid
InvData:
mov		EDX, offset	notValid
call	WriteString
call	CrLf
jmp		validate

;to be able to skip InvData if data is valid
goodData:

	ret
getData ENDP


;Discription: This procedure cycles through all of the numbers, determines if they are prime or composite, and then
;prints all of the composite numbers
;Receives: nothing
;Returns: nothing
;Preconditions: user has entered a valid number
;Regs Changed:EAX, ECX, EDX, EBX

showComposites PROC
mov		EAX, userNum
sub		EAX, 1	;starting at two for simplicity of formula being used to calculate composites
mov		userNum, EAX
mov		ECX, userNum

;outer loop to determine if a number is composite and print it
L1:

push	ECX
mov		divisor, 2
mov		ECX, start

;inner loop to determine if number is composite
isComposite:

mov		EBX, divisor
mov		EAX, start
cdq		
div		EBX
mov		remainder, EDX
cmp		start, EBX
je		dontPrint	
cmp		remainder, 0
je		printComps
inc		divisor
loop	isComposite
pop	ECX

Looper:
loop	L1

;if the number is composite jump to this sub-routine to print the number
printComps:

mov		EAX, start
call	WriteDec
mov		EDX, offset spacer
call	WriteString
dec		numPrinted
cmp		numPrinted, 0
je		clearLine	;for output, if 5 numbers have printed, clear the line 
jmp		finishPrint	

;to clear the line after 5 numbers have been printed
clearLine:

call	CrLf
mov		numPrinted, 10

;to complete the printing of composite numbers, if skipping the clearline sub-routine is necessary
finishPrint:

pop		ECX
cmp		ECX, 1
je		finish	;need to skip to end of procedure otherwise L1 would be asked to loop twice causing an infinite loop
inc		start
jmp		Looper  ;was receiving error that looping was too far, needed to be able to jump to the loop

;if the number is prime jump to this subroutine to not print it
dontPrint:

pop		ECX
inc		start
jmp		Looper	;was receiving error that looping was too far, needed to be able to jump to the loop

;sub-procedure to skip final loop as it causes an infinite loop
finish:

	ret
showComposites ENDP

;Discription: This procedure displays an exit message for the program
;Receives: nothing
;Returns: nothing
;Preconditions: all numbers have been cycled through, determined to be composite or prime and composites printed to screen
;Regs Changed:EDX
exitMsg PROC

call 	CrLf
mov		EDX, offset outro
call	WriteString
call	Crlf

	ret
exitMsg ENDP


END main