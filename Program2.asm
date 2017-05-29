TITLE Program2 CS271    (Program2CS271-TeageSilbert.asm)

; Author:Teage Silbert (silbertt@oregonstate.edu)
; Course / Project ID  CS271-400 - Program2(Fibonacci Numbers)               
; Date: 10/14/15
; Description: This program will allow the user the number of iterations to choose to go through the fibonacci numbers

INCLUDE Irvine32.inc

MIN = 1		;to define lower limit input
MAX = 46	;to define upper limit input

.data

intro		BYTE 	"Fibonacci Numbers", 0		;to show name of program
progName	BYTE	"Written By :Teage Silbert", 0 		;introduce programmer
getName		BYTE	"What is your name? ", 0		;obtain user name
nameIntro	BYTE	"Lets run a little program with Fibonacci numbers ", 0 	;to use with user name
intRange	BYTE	"Please enter an integer between 1-46: ", 0 	;to ask user for a number	
userNum		DWORD	?	;to use for user input
outOfRange	BYTE	"That number is not in the valid range, please re-enter (1-46)", 0 ;if number is out of range
num1		DWORD	1	;to assist in calculating fib numbers
num2		DWORD	0	;to assist in calculating fib numbers
temp		DWORD	?	;to assist in calculating fib numbers
counter		DWORD	2	;for assistance in spacing the output
range		DWORD	6	;to help with spacing
outro		BYTE	"Well that was impressive, have a nice day ", 0 		; exit message 
userName	BYTE	33		DUP(0)		;to obtain users name
space		BYTE	"       ", 0 ;for formatting output

.code
main PROC

;introduce program to user and obtain name
	mov 	EDX, OFFSET intro
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET progName
	call	WriteString
	call 	CrLf
	call 	CrLf
	mov 	EDX, OFFSET getName
	call	WriteString
	mov		EDX, OFFSET	userName
	mov		ECX, 32
	call	ReadString
	mov		EDX, OFFSET nameIntro
	call	WriteString
	mov		EDX, OFFSET	userName
	call	WriteString
	call 	CrLf
	call	CrLf
	mov		EDX, OFFSET intRange
	call	WriteString
	call	ReadInt
	mov		userNum, EAX	
	jmp		Validate

;if user number is out of range	
Invalid:
	mov		EDX, OFFSET outOfRange
	call	WriteString
	call	ReadInt	
	mov		userNum, EAX	

;to check if user number is out of range and if not print first digit of fib nums
Validate:
	cmp		EAX, MAX
	jg		Invalid
	cmp		EAX, MIN
	jl		Invalid
	mov		ECX, userNum
	mov		EAX, MIN
	call 	WriteDec
	mov		EDX, OFFSET space
	call 	WriteString
	dec		ECX			;first printed number is outside the loop so need to decrement by 1
	jmp		FibNums

	
;for program output to put 5 outputs per line
ClearLine:
	mov		EAX, MIN
	mov		counter, EAX
	cmp		ECX, MIN
	je		ExitMsg		;to prevent infinite loop by skipping ECX = 0 in FibNums
	call	CrLf
	dec		ECX		;need to decrement as it will not be done in the fibnums loop
	
;to calculate the fibonacci numbers
FibNums:
	
	mov		temp, EBX 
	mov		EAX, num1 
	add		EAX, num2 
	mov		EBX, num1 
	mov		num2, EBX 
	mov		num1, EAX 
	call	WriteDec 
	mov		EDX, OFFSET	space
	call	WriteString
	inc		counter
	mov		EAX, counter
	cmp		EAX, range
	je		ClearLine	
	loop	FibNums

;to display exit message including users name 
ExitMsg:
	call	CrLf
	mov		EDX, OFFSET	outro
	call	WriteString
	mov		EDX, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf
	
	exit	; exit to operating system
main ENDP


END main