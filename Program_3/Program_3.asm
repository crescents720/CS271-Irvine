TITLE Program 2     (Program_3.asm)

; Author: Gregory Mankes
; Course / Project ID : CS271/Program_3           Date:4/23/16
; Description: This program will display the title and programmer's name and 
; greet the user. It will then prompt the user to enter any number of negative numbers
; until a non-negative number is entered. It will then calculate the avereage of those
; numbers
 

INCLUDE Irvine32.inc

LOWER_LIMIT=-100

.data

; (insert variable definitions here)
fiveSpaces		byte	"     ",0 														; five spaces constant string used for printing
programmer		byte	"Programmer: Greg Mankes", 0									; Programer Name
programTitle	byte	"Title: Program 3",0											; Program Title
intro_1			byte	"This program is an integer accumulator",0						; Greeting and description
userNamePrompt	byte	"What is your name? ",0											; prompt for users name	
userName		byte	33 DUP(0)														; Container for user's name
greeting		byte	"Hello, ",0														; greeting for after obtaining user's name
prompt_1		byte	"Please enter a number in the range of ",0
prompt_2		byte	"to -1 that will be accumulated and averaged.",0				; prompt
prompt_3		byte	"Enter a non-negative number when finished",0					; prompt

numberEntered	SDWORD	0																; container for sum of elements

numberPrompt_1	byte	"Number ",0														; prompt for number to be entered
numberPrompt_2	byte	" and -1): ",0													; prompt for number to be entered
numPromptMid	byte	" (between ",0

count 			DWORD	0																; starting count for number entered
average			SDWORD	0																; container for average

countString_1	byte	"You entered ",0
countString_2	byte	" valid numbers",0												; string for displaying the count
sumString		byte	"The sum of your valid numbers is: ",0							; string for displaying the sum
averageString	byte	"The rounded average is: ",0									; string for displaying rounded average
nothingEntered	byte	"There were no numbers entered, skipping calculation",0			; special string for when no numbers entered



resultString	byte	"Thank you for using the Integer Accumulator!",0				; String to print in farewell
farewell		byte	"Goodbye, ",0													; Farewell string
period			byte	".",0															; period at end of sentences


extraCredit_1	byte	"**EC: Numbered the lines during user input",0					; extra credit statement

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
	
	; Extra credit prompts
	mov 	edx, OFFSET extraCredit_1
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
	mov		eax, LOWER_LIMIT
	call	WriteInt
	call	Crlf
	
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	Crlf
	
	mov		edx, OFFSET prompt_3
	call 	WriteString
	call	Crlf
	
; Get User Data
	
	; Jump over trueblock
	jmp		Start

PushBack:
	add 	numberEntered, eax
	inc 	count

	; Post test loop for numbers in range
Start:	
	mov 	edx, OFFSET numberPrompt_1
	call	WriteString
	
	mov		eax, count
	inc		eax
	call	WriteDec
	
	mov		edx, OFFSET numPromptMid
	call	WriteString
	
	mov		eax, LOWER_LIMIT
	call	WriteInt
	mov 	edx, OFFSET numberPrompt_2
	call	WriteString
	call	ReadInt
	
	; if within range, jump back and add to count/sum
	; otherwise fall through
	cmp		eax, -1
	JG		finish
	cmp 	eax, LOWER_LIMIT
	JL		finish
	jmp 	PushBack

finish:

; Calculate Average
	
	; account for divide by 0 error
	mov 	ebx, count
	cmp		ebx, 0
	JE		NoNumbersEntered
	
	; Move the sum into the eax register and sign extend it for
	; accurate signed division
	mov		eax, numberEntered
	CDQ
	mov		ebx, count
	idiv	ebx
	mov		average, eax
	jmp 	DoneCalculating
	
NoNumbersEntered:
	mov		edx, OFFSET nothingEntered
	call 	WriteString
	call	Crlf
	call	Crlf

DoneCalculating:
; Display Average, Sum, and number of elements entered

	; Display count
	mov		edx, OFFSET countString_1
	call 	WriteString
	mov		eax, count
	call	WriteDec
	mov		edx, OFFSET countString_2
	call	WriteString
	call	Crlf
	
	; Display Sum
	mov		edx, OFFSET sumString
	call	WriteString
	mov		eax, numberEntered
	call	WriteInt
	call	Crlf
	
	; Display Average
	mov		edx, OFFSET averageString
	call	WriteString	
	mov		eax, average
	call	WriteInt
	call	Crlf
	call 	Crlf
	
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
	call 	Crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
