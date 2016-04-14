TITLE Program 2     (Program_2.asm)

; Author: Gregory Mankes
; Course / Project ID : CS271/Program_2           Date:4/14/16
; Description: This progeam will display the title and programmer's name and 
; greet the user. It will then prompt the user to enter the number of 
; fibonacci numbers to be displayed in the range 1-46. After which it will 
; calculate and the display the fibonacci sequence on the console.
 

INCLUDE Irvine32.inc

UPPER_LIMIT=46

.data

; (insert variable definitions here)
fiveSpaces		byte	"     ",0 														; five spaces constant string used for printing
programmer		byte	"Programmer: Greg Mankes", 0									; Programer Name
programTitle	byte	"Title: Program 2",0											; Program Title
intro_1			byte	"This program displays the Fibonacci Sequence",0				; Greeting and description
userNamePrompt	byte	"What is your name? ",0											; prompt for users name	
userName		byte	33 DUP(0)														; Container for user's name
greeting		byte	"Hello, ",0														; greeting for after obtaining user's name
prompt_1		byte	"Please enter a number of elements from 1 to ",0
prompt_2		byte	"that should be displayed on the screen.",0							; prompt

numberEntered	DWORD	?																; container for number of elements
numberPrompt_1	byte	"Number of elements (between 1 and ",0							; prompt for number to be entered
numberPrompt_2	byte	"): ",0															; prompt for number to be entered
outOfRange		byte	"The number you entered was out of range!",0					; message stating that the user entered the wrong number
firstNum	 	DWORD	0 																; fibonacci firstNum
secondNum		DWORD	1 																; fibonacci secondNum
currentFib		DWORD	1																; current Fibonacci number

resultString	byte	"Results ceriftied by Greg Mankes",0							; String to print in farewell
farewell		byte	"Goodbye, ",0													; Farewell string
period			byte	".",0															;period at end of sentences


.code
main PROC

; Introduction
	mov 	edx, OFFSET programmer
	call	WriteString
	call	Crlf
	
	mov		edx, OFFSET programTitle
	call	WriteString
	call	Crlf
	call	Crlf
	
	
	mov 	edx, OFFSET userNamePrompt
	call	WriteString
	
	mov 	edx, OFFSET userName
	mov 	ecx, 32
	call	ReadString
	call 	Crlf
	
	mov		edx, OFFSET	greeting
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call	WriteString
	call 	Crlf
	
	mov 	edx, OFFSET intro_1
	call	WriteString
	call 	Crlf
	
	call 	Crlf
	
; User Instructions
	
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		eax, UPPER_LIMIT
	call	WriteDec
	call	Crlf
	
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	Crlf
	
; Get User Data

	; Jump over the error message first time here
	jmp		Start
	
	; Error message only displayed if we are out of bounds
PushBack:	
	mov 	edx, OFFSET outOfRange
	call	WriteString
	call	Crlf
	
	; Post test loop for numbers in range
Start:	
	mov 	edx, OFFSET numberPrompt_1
	call	WriteString
	mov		eax, UPPER_LIMIT
	call	WriteDec
	mov 	edx, OFFSET numberPrompt_2
	call	WriteString
	call	ReadInt
	
	cmp		eax, 1
	JL		PushBack
	cmp 	eax, UPPER_LIMIT
	JG		PushBack
	
	mov 	numberEntered, eax

; Display Fibonacci Sequence
	call 	Crlf
	
	mov		ecx, numberEntered
	mov 	ebx, 0
	jmp 	Top
	
NextLine:	
	; Reset our line counter and call Crlf if we've printed 5 times
	; Then jump back to the loop point
	call	Crlf
	sub		ebx, 5
	jmp		LoopLine
	
Top:
	mov		eax, currentFib
	
	call	WriteDec
	mov		edx, OFFSET fiveSpaces
	call	WriteString
	
	; add the two numbers together
	mov		edx, firstNum
	add		edx, secondNum
	
	;store in current fib
	mov		currentFib, edx
	
	;make first num the old second num
	mov		edx, secondNum
	mov		firstNum, edx
	
	;finally move currentFib into secondNum
	mov		edx, currentFib
	mov		secondNum, edx
	
	;find out how many times we've printed
	inc 	ebx
	cmp		ebx, 5
	JGE		NextLine
	
	
LoopLine:
	loop	Top	

	call	Crlf
; Farewell
	
	mov		edx, OFFSET resultString
	call	WriteString
	call	Crlf
	
	mov		edx, OFFSET farewell
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call 	WriteString

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
