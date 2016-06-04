TITLE Program_6_A     (Program_6_A.asm)

; Author: Greg Mankes
; Course / Project ID: CS271/Program 6              Date:5/29/16
; Description: The project implements and tests our own ReadVal and WriteVal procedures for unsigned integers.
;	It uses macros and lower level programming to do so.

INCLUDE Irvine32.inc

LOWER_BOUND=47
UPPER_BOUND=58

; (insert constant definitions here)
displayString	MACRO	addrOfBuffer
	push	edx
	mov		edx, addrOfBuffer
	call	WriteString
	pop		edx
ENDM

getString	MACRO		addrOfBuffer, bufferSize, promptAddr, addrOfUserInputSize
	push	edx
	push	ecx
	push	eax
	
	mov 	edx, promptAddr
	call	WriteString
	
	; Setup for read string
	mov		edx, addrOfBuffer
	mov		ecx, bufferSize
	call	ReadString
	; Get the number of characters entered by the user and place them in memory
	mov		edx, addrOfUserInputSize
	mov		[edx],eax
	
	pop		eax
	pop		ecx
	pop 	edx
ENDM

.data

; (insert variable definitions here)
assignmentPrompt	byte		"Programming Assignment 6: Designing low-level I/O Procedures",0dh,0ah,
								"Written by Greg Mankes",0

intro				byte		"Please provide 10 unsigned decimal integers.",0dh,0ah,
								"Each number needs to be small enough to fit inside a 32 bit register.",0dh,0ah,
								"After you have finished inputting the raw numbers I will display a list",0dh,0ah,
								"of the integers, their sum, and the average value.",0
buffer 				byte  		128		DUP(0)														;The string entered by the user (shouldnt be longer than 10 chars)
userInputSize		DWORD		0																	;This is the amount of digits the user entered
getStringPrompt		byte		"Please enter an unsigned integer: ",0								;Prompt for entering in numbers
errorPrompt			byte		"ERROR: You did not enter an unsigned number or it was too big",0
array				DWORD		10		DUP(0)
enteredVal			DWORD		0
sum					DWORD		0
comma				byte		", ",0
displayArrStr		byte		"The numbers you entered were: ",0
sumString			byte		"The sum was: ",0
averageString		byte		"The average was: ",0
goodByeString		byte		"GoodBye!",0

.code
main PROC
	
	; Test Program in main.
	; Uses the procedures and macros that are required
	
	; Show Programmer Name and Program Name
	mov		edx, OFFSET assignmentPrompt
	call	WriteString
	call	Crlf
	call	Crlf
	
	; Prompt user
	mov		edx, OFFSET	intro
	call	WriteString
	call	Crlf
	call	Crlf
	
	; Prime loop
	mov		ecx, 10
	mov		esi, OFFSET array
enterValues:
	; Call library function 10 times
	push	OFFSET	errorPrompt
	push	OFFSET	userInputSize
	push	OFFSET	getStringPrompt
	push	SIZEOF	buffer
	push	OFFSET	buffer
	push	OFFSET 	enteredVal
	call	ReadVal
	
	; Add the entered value to the sum, enter it to the array,
	; increment the array pointer and loop
	mov		eax, enteredVal
	add		sum, eax
	mov		[esi], eax
	add		esi, 4
	loop	enterValues
	
	call	Crlf
	mov		edx, OFFSET displayArrStr
	call	WriteString
	call	Crlf
	
	; Prime print loop
	mov		ecx, 10
	mov		edi, OFFSET array
	
	; Use the library function to print the values
	; also use another function to zero out the buffer
	; that is used to copy the decimal numbers to a string
displayValues:
	
	; Zero out the buffer
	push	11
	push	OFFSET buffer
	call	zeroOutBuffer
	
	; call the library function
	push	OFFSET buffer
	push	[edi]
	call	WriteVal
	
	; go to the next element in the array
	add		edi, 4
	
	; if we are not at the last element, print a comma
	cmp		ecx, 1
	je 		displayValues_loop
	mov		edx, OFFSET comma
	call	WriteString
	
displayValues_loop:
	loop	displayValues
	
	call	Crlf
	
	; calculate average
	mov		eax, sum
	mov		edx, 0
	mov		ebx, 10
	
	div 	ebx
	
	mov		edx, OFFSET sumString
	call	WriteString
	
	;;;;;;;; NOTE: used the built functions to print average and sum
	
	;;; Sum
	; Zero out the buffer
	push	11
	push	OFFSET buffer
	call	zeroOutBuffer
	
	; call the library function to print the sum
	push	OFFSET buffer
	push	sum
	call	WriteVal
	
	call Crlf
	mov		edx, OFFSET	averageString
	call	WriteString
	
	;;; Average
	; Zero out the buffer
	push	11
	push	OFFSET buffer
	call	zeroOutBuffer
	
	; call the library function to print the average
	push	OFFSET buffer
	push	eax
	call	WriteVal
	
	call	Crlf
	call	Crlf
	
	; Say goodbye
	mov		edx, OFFSET goodByeString
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP

;Procedure to read the value entered by the user
;Receives: (in the following order)
			; offset of a variable that will hold the entered value
			; offset of string buffer to copy from
			; size of string buffer to copy from
			; offset of a prompt to display to user
			; offset of a variable that will contain the number of characters
					; entered by user
			; offset of an error message
;Returns: the value entered by the user in the passed in variable
;Preconditions: none
;Registers Changed: none
ReadVal		PROC
	push 	ebp
	mov		ebp, esp
	; Save registers
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	
	jmp		ReadVal_Start
	; If there is an error, come back here
ReadVal_errorPushBack:
	mov		edx, [ebp+28]
	call	WriteString
	call	Crlf
	
ReadVal_Start:
	getString [ebp+12],[ebp+16],[ebp+20],[ebp+24]
	mov		edx, [ebp+24]
	mov		ecx, [edx]
	cmp		ecx, 10
	ja		ReadVal_errorPushBack
	
	; Prime the loop for conversion
	cld
	mov		esi, [ebp+12]
	mov		ebx, 0
	
ReadVal_loopTop:
	; Load the byte into al
	lodsb
	
	; if the byte > 57 or the byte < 48, the number is invalid, restart
	cmp		al,LOWER_BOUND
	jbe		ReadVal_errorPushBack
	cmp		al,UPPER_BOUND	
	jae		ReadVal_errorPushBack
	
	; Save off ecx since we need extra registers
	push	ecx
	
	sub		al, 48
	
	; Swap the values of ebx and al, since we need eax for multiplication
	mov		edx,0
	mov		dl, al
	mov		eax, ebx
	mov		ebx, 0
	mov		bl, dl
	
	mov		ecx, 10
	mov		edx,0
	mul		ecx
	
	; restore ecx
	pop		ecx
	
	; If there was overflow into EDX, then the number is too large
	cmp		edx,0
	jne		ReadVal_errorPushBack
	
	; move the number back into the accumulator
	mov		edx,0
	mov		dl, bl
	mov		ebx, eax
	mov		eax, 0
	mov		al, dl
	
	; add the number to the accumulator
	add		ebx, eax
	JC		ReadVal_errorPushBack
	
	loop 	ReadVal_loopTop
	
	;When we are done, we move the number in ebx to the passed in value
	mov		eax, [ebp+8]
	mov		[eax], ebx
	
	; Restore Registers
	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	pop		ebp
	ret		24
ReadVal		ENDP

;Procedure to print the value that is passed in on the stack
;Receives: (in the following order)
			; value of a variable that needs to be printed
			; offset of a buffer that has been cleared out.
;Returns: nothing
;Preconditions: the buffer must be cleared out with the provided function zeroOutBuffer
;Registers Changed: none
WriteVal	PROC
	push 	ebp
	mov		ebp, esp
	; Save registers
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	

	; Get the number into eax
	mov		eax, [ebp+8]
	
	; setup ecx 
	mov		ecx, 0
	
	; We need to count how many elements the number will have in order to go backwards
WriteVal_counting_loop:	
	inc		ecx
	mov		edx, 0
	mov 	ebx, 10
	div		ebx
	
	cmp		eax, 0
	jne		WriteVal_counting_loop
	
	
	; Set up the registers so that edi points to last element in string
	; We will be using the remainders and going backwards
	std
	mov		edi, [ebp+12]
	; Add the amount of elements to the destination pointer
	add		edi, ecx
	dec 	edi
	
	; Get the number into eax
	mov		eax, [ebp+8]

	
WriteVal_loop_Top:	
	; Zero out edx for division
	mov		edx, 0
	
	; Divide by 10
	mov		ebx, 10
	div		ebx
		
	; save quotient, and convert remainder to ASCII
	push 	eax
	add		edx, 48
	
	; Place ascii char in al and send to buffer
	mov		eax, 0
	mov		al, dl
	stosb
	
	; restore quotient for continuing division
	pop		eax
	
	cmp		eax,0
	jne		WriteVal_loop_Top
	
	displayString	[ebp+12]
	
	
	; Restore Registers
	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	pop		ebp
	
	ret 	8
WriteVal	ENDP

;Procedure to clear out the buffer that will be used for printing
;Receives: (in the following order)
			; offset of the buffer to be cleared out
			; the amount of elements in the buffer to be cleared out
;Returns: a cleared out buffer in memory
;Preconditions: none
;Registers Changed: none
zeroOutBuffer	PROC
	push 	ebp
	mov		ebp, esp
	push	ecx
	push	eax
	push	edi

	mov		ecx, [ebp+12]
	mov		edi, [ebp+8]
	
zeroOutBuffer_loop_top:
	
	mov		eax, 0
	mov		[edi], eax
	inc		edi
	
	loop	zeroOutBuffer_loop_top
	
	pop 	edi
	pop		eax
	pop 	ecx
	pop		ebp
	ret	8
zeroOutBuffer	ENDP


END main
