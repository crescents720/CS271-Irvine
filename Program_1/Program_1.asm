TITLE Program_1     (Program_1.asm)

; Author: Greg Mankes
; Course / Project ID  Program 1               Date: 4/7/16
; Description: This assignment is an introduction to the MASM programming language
; The Program will show the name and the program title to the screen as well as 
; ask the user to enter two numbers. We will be taking the sum, difference, produce
; and division of the integers and displaying it for the user.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

myName		 		byte 	"Gregory Mankes",0										; Name
programName			byte	"Program 1",0											; Program description
prompt_1			byte	"Please enter two numbers and I will show you the",0	; Prompt first line
prompt_2			byte	"sum, difference, product, quotient and remainder",0	; Prompt second line
firstNumber_prompt	byte	"First Number: ",0										; prompt asking for 1st number
secondNumber_prompt	byte	"Second Number: ",0										; prompt asking for 2nd number
firstNumber			dword	0														; First number entered
secondNumber		dword	0														; Second number entered
sum					dword 	0														; Sum variable
difference			dword	0														; Difference variable
product				dword	0														; product variable
quotient			dword	0														; quotient variable
remainder			dword	0														; remainder variable
sum_prompt			byte	" + ",0													; prompt for showing the sum
product_prompt		byte	" * ",0													; prompt for showing the product
difference_prompt	byte	" - ",0													; prompt for showing the difference
quotient_prompt		byte	" / ",0													; prompt for showing the quotient
remainder_prompt	byte	" remainder ",0											; prompt for showing the remainder
result_prompt		byte	" = ",0													; prompt for showing the results
goodbye				byte	"Good-bye!",0											; goodbye prompt

.code
main PROC

; Introduce the programmer
	mov 	edx, OFFSET myName
	call 	WriteString
	call	CrLf
	
	mov		edx, OFFSET programName
	call 	WriteString
	call	CrLf
	call 	CrLf
	
	mov		edx, OFFSET prompt_1
	call	WriteString
	call 	CrLf
	
	mov		edx, OFFSET prompt_2
	call	WriteString
	call 	CrLf
	call 	CrLf
	
; Get the numbers from the user

	mov 	edx, OFFSET firstNumber_prompt
	call	WriteString
	call 	ReadInt
	mov	firstNumber, eax
	
	call 	CrLf
	
	mov 	edx, OFFSET secondNumber_prompt
	call	WriteString
	call 	ReadInt
	mov		secondNumber, eax
	
	call 	CrLf
	
; perform addition
	
	mov 	eax, firstNumber
	mov		ebx, secondNumber
	add 	ebx, eax
	mov		sum, ebx

; perform subtraction

	mov 	eax, firstNumber
	mov		ebx, secondNumber
	sub 	eax, ebx
	mov		difference, eax

; perform multiplication

	mov 	eax, firstNumber
	mov		ebx, secondNumber
	mul 	ebx
	mov		product, eax
	
; perform division

	mov 	eax, firstNumber
	cdq
	mov		ebx, secondNumber
	div 	ebx	
	mov		quotient, eax
	mov		remainder, edx

; show result
	; addition result
	mov		eax, firstNumber
	call 	WriteDec
	mov		edx, OFFSET sum_prompt
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET result_prompt
	call 	WriteString
	mov		eax, sum
	call	WriteDec
	call 	CrLf
	
	; subtraction result
	mov		eax, firstNumber
	call 	WriteDec
	mov		edx, OFFSET difference_prompt
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET result_prompt
	call 	WriteString
	mov		eax, difference
	call	WriteDec
	call 	CrLf

	
	; product result
	mov		eax, firstNumber
	call 	WriteDec
	mov		edx, OFFSET product_prompt
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET result_prompt
	call 	WriteString
	mov		eax, product
	call	WriteDec
	call 	CrLf

	
	; division result
	mov		eax, firstNumber
	call 	WriteDec
	mov		edx, OFFSET quotient_prompt
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET result_prompt
	call 	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET remainder_prompt
	call	WriteString
	mov 	eax, remainder
	call	WriteDec
	call 	CrLf

	call 	CrLf

; say goodbye
	mov 	edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	
	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
