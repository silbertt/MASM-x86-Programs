TITLE Program3 CS271    (Program3CS271-TeageSilbert.asm)

; Author:Teage Silbert (silbertt@oregonstate.edu)
; Course / Project ID: CS271-400 Program3      Date:10/27/15
; Description: This program will greet the user, obtain the users name and 
; ask them to input as many negative numbers between -100 and -1, it will then
; sum the numbers and give the average 

INCLUDE Irvine32.inc

MIN = -100	;to define lower limit
MAX = -1	;to define upper limit


.data

intro			BYTE	"Welcome to the negative numbers game!", 0		;to use for the intro of the program
getName			BYTE	"Would you please give me your name?", 0		;to prompt user for their name
userIntro		BYTE	"Thank you and welcome ", 0						;to use with user inputted name
description		BYTE	"Enter as many numbers as you would like between -100 and -1 (inclusive)", 0	;to inform user how to use program
descript2		BYTE	"When you are done enter a non-negative integer", 0		;to inform user how to end entering numbers
userNums		SDWORD	?		;to use to hold total of user inputted numbers
temp			SDWORD	?		;to use during validation of user number
accum			SDWORD	1		;to assist in incrementing the number of valid integers entered
userName		BYTE	33		DUP(0)	;to hold the users name
newNum			BYTE	"Enter Number ", 0 	;to prompt user to enter another number
notValid		BYTE	"I'm sorry that number is less than -100, please enter a valid number", 0 ;to use if user enters and invalid number
outro			BYTE	"Thank you for your input, below are your statistics", 0 	;to use when user enters a non-negative integer
space			BYTE	". ", 0 	;for extra credit output formatting
numUsed			BYTE	"You entered ", 0 	;to output number of valid numbers
numUsed1		BYTE	" valid numbers", 0		;to output number of valid numbers
total			BYTE	"Sum of values is: ", 0 	;for output of total amount
avg				BYTE	"The rounded average is: ", 0	;for output of rounded average
ExtraC			BYTE	"**EC: Number Lines During User Input", 0 	;for extra credit
exitMsg			BYTE	"Thanks for you assistance ", 0		;exit message of program
 

.code
main PROC

; this will serve to introduce the user to the program, obtain their name
; and show an additional intro with their name
mov 	EDX, offset intro
call	WriteString
call 	CrLf
call	CrLf
mov		EDX, offset	ExtraC
call	WriteString 
call 	CrLf
call	CrLf 
mov		EDX, offset	getName
call	WriteString
call	CrLf
mov		EDX, offset	userName
mov		ECX, 32
call	ReadString	
call 	CrLf
mov		EDX, offset userIntro
call	WriteString
mov		EDX, offset	userName
call 	WriteString
call	CrLf
mov		EDX, offset	description
call	WriteString
call	CrLf
mov		EDX, offset	descript2	
call 	WriteString
call 	CrLf

;this will be used to get the user numbers
GetNums:
mov		EDX, offset	newNum
call	WriteString
mov		EAX, accum
call	WriteDec
mov		EDX, offset	space
call	WriteString
call	ReadInt

;this will be used as validation mechanism for the user inputted number
Validate:
mov		temp, EAX
cmp		temp, MIN
jl		Invalid
cmp		temp, MAX
jg		gameOver
inc		accum
add		userNums, EAX
jmp		GetNums;

;this will be used if the number entered is less than -100
Invalid:
mov 	EDX, offset notValid
call	WriteString
call	CrLf
jmp		GetNums

;to be used if user enters a number greater than -1
gameOver:
mov		EBX, accum
sub		EBX, 1	;need to subtract one as there is one extra accumulation for EC
mov		accum, EBX
mov		EDX, offset	outro
call 	WriteString
call	CrLf
mov		EDX, offset numUsed
call 	WriteString
mov		EAX, accum
call	WriteDec
mov		EDX, offset numUsed1
call	WriteString
call 	CrLf
mov		EDX, offset	total
call	WriteString
mov		EAX, userNums
call	WriteInt	
call	CrLf
mov		EDX, offset avg		
call	WriteString
mov		EAX, userNums
cdq	
idiv	accum
call	WriteInt
call	CrLf
mov		EDX, offset exitMsg
call	WriteString
mov		EDX, offset userName
call	WriteString
call	CrLf


	exit	; exit to operating system
main ENDP


END main