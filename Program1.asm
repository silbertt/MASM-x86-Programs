TITLE Program1CS271    (Program1CS271.asm)

; Author: Teage Silbert
; Course / Project ID:Program1CS271               Date:10/8/15
; Description: Display my name and program title, display user instructions
; to input two numbers and calculate the sum, difference, product, quotient and remainder
; as well as a terminating message

INCLUDE Irvine32.inc

.data

intro			BYTE	"       Teage Silbert    Program1 CS271", 0 	;to show name and program title
instruct		BYTE	"For this program I will ask you for two numbers and show you the sum, difference, product, quotient, and remainder ", 0
num1			DWORD	? 		;to get first integer from user
num2			DWORD	?		;to get second integer from user
obNum1			BYTE	"Please enter first number",0 	 ;to get first number
obNum2			BYTE	"Please enter second number", 0		;to get second number
calc			DWORD	?		;to calculate necessary outputs
sumOut			BYTE	" + ", 0	; to show sum
equals			BYTE	" = ", 0    ; to show totals
diffOut			BYTE	" - ", 0		;to show difference
prodOut			BYTE	" * ", 0 	;to show product
quotOut			BYTE	" / ", 0 	;to show quotient
remOut			BYTE	" Remainder is ", 0 	;to show remainder
termMsg			BYTE	"Thanks for the help, goodbye ", 0 	;to display terminating message

.code
main PROC

;Introduce program and give description
	mov		edx, OFFSET	intro
	call	WriteString
	call	CrLf
	call 	CrLf
	mov		edx, OFFSET	instruct
	call 	WriteString
	call	CrLf
	
;get user numbers
	mov		edx, OFFSET	obNum1
	call	WriteString
	call 	CrLf
	call	ReadInt
	mov		num1, eax
	mov		edx, OFFSET obNum2
	call	WriteString
	call	CrLf
	call	ReadInt
	mov		num2, eax

;calculate and show sum
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET sumOut
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		eax, num1
	add 	eax, num2
	mov		calc, eax
	mov		edx, OFFSET equals
	call	WriteString
	call	WriteDec
	call	CrLf
	
;calculate and output difference	
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET	diffOut
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		eax, num1
	sub		eax, num2
	mov		calc, eax
	mov		edx, OFFSET equals
	call	WriteString
	call	WriteInt
	call	CrLf	
	
;calculate and output product
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET	prodOut
	call	WriteString
	mov		eax, num2
	call 	WriteDec
	mov		eax, num1
	mov		ebx, num2
	mul		ebx
	mov		calc, eax
	mov		edx, OFFSET equals
	call	WriteString
	call	WriteDec
	call	CrLf
	
;calculate and output quotient and remainder
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET	quotOut
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		eax, num1
	cdq
	mov		ebx, num2
	div		ebx
	mov		calc, eax
	mov		num2, edx
	mov		edx, OFFSET equals
	call	WriteString
	call	WriteDec
	mov		eax, num2
	mov		edx, OFFSET remOut	
	call	WriteString
	call	WriteDec
	call	CrLf

;show terminating message
	mov		edx, OFFSET termMsg
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main