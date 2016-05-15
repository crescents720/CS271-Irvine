TITLE Program 4     (Program_4.asm)

; Author: Gregory Mankes
; Course / Project ID                 Date: 3/1/16
; Description: This progarm calculates composite numbers
;	The user will enter any integer in the range of [1...400].
;	The user enters a number n and the program verifies that 1 <= n <= 400.
;	If n is out of range, the user is reprompted until they enter a number
;	in the specified range. The program calculates and displays all of the
;	composite numbers up until the nth composite. The composites are displayed
;	10 composites per line and with 3 spaces between the numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)
UPPER_LIMIT=400

.data

programName		byte	"Program 4: Composite Numbers",0
programmer		byte	"Gregory Mankes",0

intro_1			byte	"Enter the number of composite numbers you would like to see.",0
intro_2			byte	"I'll accept orders for up to ",0
intro_3			byte	" numbers.",0

number_prompt_1	byte	"Enter the number of composites to display [1...",0
number_prompt_2	byte	"]: ",0

theNumber		DWORD	0				; Number entered by the user
theNumberGood	DWORD	0				; The number is a good number (in the range)

toCheck			DWORD	0				; The current number to check
theNumberComp	DWORD	0				; The number is composite

count			DWORD	0				; How many elements we have on the current line

out_of_range	byte	"Out of range. Try again",0

spaces			byte	"   ",0

goodbye			byte	"Results cerified by Gregory Mankes. Goodbye.",0


.code
main PROC
	; Introduce the user
	call 	introduction
	
	; get the data from the user
	call	getUserData
	
	; show the composite numbers
	call	showComposites
	
	; say goodbye
	call	farewell

	exit	; exit to operating system
main ENDP


;Procedure to introduce the user and state the purpose of
;	the program.
;Receives: programName, programmer, intro_1, intro_2, intro_3
;	are global variables
;Returns: nothing
;Preconditions: the strings are set up
;Registers Changed: eax and edx
introduction PROC
	; Introduce the user
	mov		edx, OFFSET programName
	call 	WriteString
	call 	Crlf
	
	mov		edx, OFFSET	programmer
	call	WriteString
	call	Crlf
	
	mov 	edx, OFFSET intro_1
	call	WriteString
	call	Crlf
	
	mov 	edx, OFFSET intro_2
	call	WriteString
	mov		eax, UPPER_LIMIT
	call 	WriteDec
	mov		edx, OFFSET intro_3
	call	WriteString
	call	Crlf
	
	ret
introduction ENDP


;Procedure to get the user's data and validate it
;Receives: number_prompt_1, number_prompt_2, theNumberGood, theNumber
;	are global variables
;Returns: the valid number entered by the user in theNumber
;Preconditions: the strings to print are set up
;Registers Changed: eax and edx
getUserData PROC
	
getUserData_kickback:	
	mov		edx, OFFSET number_prompt_1			; Prompt the user for a number in range
	call	WriteString
	mov		eax, UPPER_LIMIT
	call	WriteDec
	mov		edx, OFFSET number_prompt_2
	call	WriteString
	call 	ReadInt
	mov		theNumber, eax						; Get the number and store in a variable
	call 	validate							; Call the validate function
	cmp		theNumberGood,0						; use a boolean to determine whether this is a valid entry
	je		getUserData_kickback				; if it isn't, kickback to the start
	
	call	Crlf
	
	ret
getUserData ENDP


;Procedure to validate the number entered by the user
;Receives: theNumber, a global variable entered by the user
;Returns: theNumberGood, a global variable to determine
;	if the number is in the range
;Preconditions: theNumber has been entered by the user
;Registers Changed: edx
validate PROC
	
	cmp		theNumber, 1						; if the number is less than 1 or greater than 400
	JL		validate_wrong						; jump to branch that sets theNumberGood to 0
	cmp		theNumber, UPPER_LIMIT
	JG		validate_wrong
	mov		theNumberGood, 1					; otherwise set theNumberGood to 1 and jump to the end
	jmp		validate_end
validate_wrong:
	mov 	theNumberGood, 0
	mov		edx, OFFSET out_of_range			; print an error message when the number is out of range
	call	WriteString
	call 	Crlf
validate_end:
	ret
	
validate ENDP


;Procedure to calculate and show the composites that 
;	are less than or equal to the number the user entered
;Receives: theNumber, spaces, theNumberComp, count toCheck are global variables
;Returns: nothing
;Preconditions: The number has been entered by the user in the valid
;	range
;Registers Changed: eax, ecx, edx
showComposites PROC
	cmp		theNumber, 4						; if the number is less than 4, it is not composite
	jl		showComposites_end					; jump over everything in this case
	
	mov		ecx, theNumber						; make theNumber the count
	sub		ecx, 3								; subtract 3 from this (because 1,2,3 are not composite)
	
	mov		toCheck, 3							; prime the toCheck variable
	
showComposites_loop:
	
	inc		toCheck								; increment toCheck and save off ecx for inside isComposite
	push	ecx
	call 	isComposite							; call isComposite
	pop		ecx
	cmp		theNumberComp,0						; if the number is not composite, jump over printing the number
	je		showComposites_dont_print_num

	mov		eax, toCheck						; print the number and 3 spaces
	call	WriteDec
	mov		edx, OFFSET	spaces
	call	WriteString

	inc		count
	cmp		count, 10							; if we have printed 10 numbers on this line, go to the next line
	jl		showComposites_dont_print_num
	sub		count, 10
	call	Crlf
	
showComposites_dont_print_num:	
	
	
	loop	showComposites_loop
	
showComposites_end:	

	call	Crlf
	ret
	
showComposites ENDP


;Procedure to check whether the current number to check is composite
;Receives: toCheck, theNumberComp are global variables
;Returns: theNumberComp is set to 1 if the number is composite,
;	0 otherwise
;Preconditions: theNumber is in the range and greater than or equal
;	to 4
;Registers Changed: eax, ebx, ecx, edx
isComposite PROC

	; divide the number by 2
	mov 	edx, 0
	mov		eax, toCheck
	mov		ebx, 2
	div		ebx
	
	; place that number in the ecx register
	mov		ecx, eax
	inc		ecx
	
isComposite_loop:
	; If we divide by 1, we will always have no remainder
	; jump to the end of the loop if this is the case
	cmp		ecx, 1
	je		isComposite_loop_end
	mov		edx,0							; Set up for integer division
	mov		eax, toCheck
	div		ecx
	cmp		edx, 0							; compare the remainder to 0
	je		isComposite_numberComposite		; if 0, the number is composite
	
	
isComposite_loop_end:	
	loop	isComposite_loop
	mov		theNumberComp,0					; if we reach this far, the number is not composite
	jmp		isComposite_end
	
isComposite_numberComposite:
	mov		theNumberComp, 1
	
isComposite_end:	
	ret
isComposite ENDP

;Procedure to say goodbye
;Receives: goodbye is a global variable	
;Returns: nothing
;Preconditions: the goodbye string is set up
;Registers Changed: edx
farewell PROC
	mov		edx, OFFSET goodbye
	call	WriteString
	call	Crlf
	ret
farewell ENDP


END main
