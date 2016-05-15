TITLE Program_5     (Program_5.asm)

; Author: Gregory Mankes
; Course / Project ID: CS271/Program 5                 Date: 3/14/16
; Description: This program generates random numbers in the range [100.. 999],
;			   displays the original list, sorts the list, and calculates the
;			   median value. Finally, it displays the list sorted in descending order.

INCLUDE Irvine32.inc

; (insert constant definitions here)
min=10
max=200

lo=100
hi=999
.data

programName		byte	"Program 5: Sorting Random Integers",0
programmer		byte	"Gregory Mankes",0

intro_1			byte	"This program generates random numbers in the range [100..999],",0
intro_2			byte	"displays the original list, sorts the list, and calculates the",0
intro_3			byte	"median value. Finally, it displays the list sorted in descending order.",0

prompt_1		byte	"How many numbers should be generated? [",0
dotdotdot		byte	"...",0
prompt_2		byte	"]: ",0

out_of_range	byte	"Invalid input",0

numElements		DWORD	0
array			DWORD	max		DUP(?)

unSortedTitle	byte	"The Unsorted Random Numbers are: ",0
sortedTitle		byte	"The Sorted Random Numbers are: ",0

spaces			byte	"   ",0

medianString	byte	"The median is: ",0

goodbye			byte	"Results cerified by Gregory Mankes. Goodbye.",0


.code
main PROC

	; Introduce the user
	push	OFFSET intro_3
	push	OFFSET intro_2
	push	OFFSET intro_1
	push 	OFFSET programName
	push	OFFSET programmer
	call 	introduction

	; Get the user data
	push	OFFSET out_of_range
	push 	OFFSET prompt_2
	push	OFFSET dotdotdot
	push	OFFSET prompt_1
	push	OFFSET numElements
	call 	getData
	
	; Fill the array with random integers
	call	Randomize
	push	numElements
	push	OFFSET array
	call	fillArray
	
	; Show all of the elements in the array
	push	OFFSET spaces
	push	OFFSET unSortedTitle
	push	numElements
	push	OFFSET array	
	call	displayList
	
	; Sort the array
	push	numElements
	push	OFFSET array
	call	sortList
	
	; Display the newly sorted array
	push	OFFSET spaces
	push	OFFSET sortedTitle
	push	numElements
	push	OFFSET array	
	call	displayList
	
	; Calculate and display the median
	push	OFFSET medianString
	push	numElements
	push	OFFSET array
	call	displayMedian
	
	; say goodbye
	push 	OFFSET goodbye
	call	farewell

	exit	; exit to operating system
main ENDP


;Procedure to introduce the user and state the purpose of
;	the program.
;Receives: offset of: programName, programmer, intro_1, intro_2, intro_3
;	are passed in on the stack
;Returns: nothing
;Preconditions: the strings are set up
;Registers Changed: none
introduction PROC
	push	ebp
	mov		ebp, esp
	
	; save edx
	push	edx
	
	; prompt the user
	mov		edx, [ebp+8]
	call	WriteString
	call	Crlf
	
	mov		edx, [ebp+12]
	call	WriteString
	call	Crlf
	call	Crlf
	
	mov		edx, [ebp+16]
	call	WriteString
	call	Crlf
	
	mov		edx, [ebp+20]
	call	WriteString
	call	Crlf
	
	mov		edx, [ebp+24]
	call	WriteString
	call	Crlf
	call 	Crlf
	
	; restore edx
	pop		edx
	pop 	ebp
	ret 20
introduction ENDP

;Procedure to get the data from the user within the specified range.
;Receives: the offsets of: the numElements variable, the prompt strings (1 and 2),
;	the dotdotdot string, and the out_of_range string on the system stack
;Returns: The number of elements to be generated in the variable passed in by reference
;Preconditions: The elements must be passed in system stack in the correct order
;Registers Changed: none
getData PROC
	push	ebp
	mov		ebp, esp
	; save eax and edx
	push	edx
	push	eax

	jmp		getData_validate
getData_pushBack:
	; Tell the user that the input is out of range
	mov		edx, [ebp+24]
	call	WriteString
	call	Crlf

getData_validate:
	; Prompt the user
	mov		edx, [ebp+12]
	call	WriteString
	mov		eax, min
	call	WriteDec
	mov		edx, [ebp+16]
	call	WriteString
	mov		eax, max
	call	WriteDec
	mov 	edx, [ebp+20]
	call	WriteString
	; Get the user's input
	call	ReadInt
	; Compare it to the global boundaries
	cmp		eax, min
	jl		getData_pushBack
	cmp		eax, max
	jg		getData_pushBack
	
	; The input is valid, move it into the numElements passed by reference
	mov		edx, [ebp+8]
	mov		[edx] ,eax
	
	call Crlf
	call Crlf
	
	; restore eax and edx
	pop		eax
	pop		edx
	pop		ebp
	ret 20
getData	ENDP

;Procedure to fill the array with random numbers
;Receives: the offset of the start of the array and the number of elements
; 	passed by value on the system stack
;Returns: the array is filled in memory
;Preconditions: the Irvine32 libary function Randomize is called to seed
; 	the pseudorandom number generator
;Registers Changed: none
fillArray PROC
	push	ebp
	mov		ebp, esp
	
	; Save general registers
	push	eax
	push	ecx
	
	; Save edi
	push	edi
	
	
	mov		ecx, [ebp+12]
	mov		edi, [ebp+8]
fillArray_loop:
	; Prime RandomRange procedure
	mov		eax, hi
	sub		eax, lo
	sub		eax, 1
	call	RandomRange
	add		eax, lo
	mov		[edi], eax
	add		edi, 4
	loop	fillArray_loop
	
	; restore edi
	pop		edi
	; Restore general registers
	pop		ecx
	pop		eax
	
	pop		ebp
	ret 8
fillArray ENDP

;Procedure to sort the array of random integers
;Receives: The offset of the array of integers and the number of elements
; 	in the array passed on the system stack
;Returns: A sorted array in memory
;Preconditions: The array and number of elements are passed in the correct order
;	on the stack
;Registers Changed: none
sortList PROC
	push 	ebp
	mov		ebp, esp
	
	; save registers
	push	edx
	push	ebx
	push 	eax
	push	ecx
	push 	esi
	push	edi
	
	; Selection Sort
	
	; Prime Outer Loop
	mov		ecx, [ebp+12]
	sub		ecx, 1
	mov		esi, [ebp+8]
	mov		edx, 0
	
	; Outer Loop
	; use eax to have address of highest element
sortList_outerLoop:	
	mov		eax, esi
	
	; Save the outer loop's ecx
	push 	ecx
	
	; Inner loop

	; set inner loop index to be outer loop index + 1
	mov		edi, esi
	add		edi, 4
	
	; set inner loop counter to be total count - currentIndex - 1
	mov		ebx, [ebp+12]
	sub		ebx, 1
	sub		ebx, edx
	mov		ecx, ebx

sortList_innerLoop:
	; Put the value of the max index into ebx
	mov		ebx, [eax]
	; compare the value of the max index to edi
	cmp		ebx, [edi]
	; if it doesn't need to be updated, jump
	jge		sortList_dontUpdateMaxIndex
	; else, we update the max so far to be edi
	mov		eax, edi
	
sortList_dontUpdateMaxIndex:	
	; increment the pointer to the current element and loop
	add		edi, 4
	loop	sortList_innerLoop
	
	
	; restore outer loop ecx
	pop		ecx
	
	push	eax
	push	esi
	call	exchange
	
	; increment current index and loop
	inc		edx	
	add		esi, 4
	loop	sortList_outerLoop
	
	; restore registers
	pop 	edi
	pop		esi
	pop		ecx
	pop		eax
	pop		ebx
	pop		edx
	
	pop 	ebp
	ret 8
sortList ENDP

;Procedure to exchange to elements in memory. Used for sorting.
;Receives: the offsets of two elements to be exchanged on the stack
;Returns: an array where the two elements are exchanged in memory
;Preconditions: the two offsets are passed on the stack
;Registers Changed: none
exchange PROC
	push	ebp
	mov		ebp, esp
	; Save off registers
	push	eax
	push	ebx
	push	edx
	
	; put i and j into eax and ebx
	mov		eax, [ebp+8]
	mov		ebx, [ebp+12]
	; use edx as temp for list[i]
	mov		edx, [eax]
	; exchange list[j] and temp
	xchg	edx, [ebx]
	; move temp to list[i]
	mov		[eax],edx
	
	; Restore registers
	pop		edx
	pop		ebx
	pop		eax
	pop		ebp
	ret 8
exchange ENDP

;Procedure to calculate and display the median
;Receives: the offset of: the array and the median string as well as
;	the value of the number of elements passed on the stack
;Returns: nothing
;Preconditions: The array is sorted.
;	The array and number of elements are passed on the stack
; 	in the correct order
;Registers Changed: none
displayMedian PROC
	push	ebp
	mov		ebp, esp
	
	; Save registers
	push	eax
	push	edx
	push	ebx
	push	esi
	push	edi
	
	; Display the median string
	mov		edx, [ebp+16]
	call	WriteString
	
	mov		esi, [ebp+8]
	
	; Divide the number of elements by 2
	mov		edx, 0
	mov		eax, [ebp+12]
	mov		ebx, 2
	div		ebx
	
	; Compare the remainder to 1
	cmp		edx, 1
	; Jump if the number is odd and we dont need to calculate the average
	je		displayMedian_noCalculation
	
	; multiply the index by 4
	mov		ebx, 4
	mov		edx, 0
	mul		ebx
	
	; add the sized index to the source operand
	add		esi, eax
	sub		esi, 4
	
	; set the other index to be the current and then add so we have the next element
	mov		edi, esi
	add 	edi, 4
	
	; get the average of the two elements
	mov 	edx, 0
	mov		eax, [edi]
	add		eax, [esi]
	mov		ebx, 2
	div		ebx
	
	; jump to the end so we can display it
	jmp		displayMedian_end
	
displayMedian_noCalculation:
	; multiply the index by 4
	mov		ebx, 4
	mov		edx, 0
	mul		ebx
	
	; add the sized index to the source operand
	add		esi, eax
	; move this to eax so that we can print the median
	mov		eax, [esi]

displayMedian_end:
	
	call	WriteDec
	call	Crlf


	; Restore Registers
	pop		edi
	pop		esi
	pop		ebx
	pop		edx
	pop		eax
	
	pop		ebp
	ret 12
displayMedian ENDP

;Procedure to display a list of integers
;Receives: the offsets of: the array, the string describing the array, 
;	a string so we can space the elements, as well as the number of elements
;	passed by value on the stack
;Returns: nothing
;Preconditions: everything is passed on the stack in the correct order
;Registers Changed: none
displayList PROC
	push	ebp
	mov		ebp, esp

	; Save eax, ecx, edx, ebx and esi
	push 	eax
	push	ecx
	push	edx
	push	ebx
	push	esi

	; Show Title
	mov		edx, [ebp+16]
	call	WriteString
	call	Crlf
	
	; Prime Loop
	mov		ecx, [ebp+12]
	mov		esi, [ebp+8]
	mov		ebx, 0
	
displayList_loop:	
	; Display the current element
	mov		eax, [esi]
	call	WriteDec
	mov		edx, [ebp+20]
	call	WriteString
	; find out how many elments we have printed
	inc		ebx
	; increment our index counter
	add		esi, 4
	
	; Determine if we need to go to the next line
	cmp		ebx, 10
	jl		displayList_sameLine
	
	; We need a new line, call Crlf and reset the line counter
	call	Crlf
	mov		ebx,0
	
displayList_sameLine:
	loop	displayList_loop
	
	call	Crlf
	call	Crlf
	
	; Restore eax, ecx, edx, ebx and esi
	pop 	esi
	pop		ebx
	pop		edx
	pop		ecx
	pop		eax
	
	pop		ebp
	ret		16
displayList ENDP

;Procedure to say goodbye
;Receives: offset of goodbye is on the system stack	
;Returns: nothing
;Preconditions: the goodbye string is set up
;Registers Changed: none
farewell PROC
	push	ebp
	mov		ebp, esp
	push	edx
	
	mov		edx, [ebp+8]
	call	WriteString
	call 	Crlf
	
	pop		edx
	pop		ebp
	ret		4
farewell ENDP


END main
