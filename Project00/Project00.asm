TITLE Dog Years     (Project00.asm)

; Author: Greg Mankes
; Course / Project ID Demo #0                 Date:
; Description:

INCLUDE Irvine32.inc

DOG_FACTOR = 7

.data
userName	byte	33 DUP(0)	; string to be entered by user
userAge 	dword 	?			; integer to be entered by user
intro_1 	byte 	"Hello, my name is Lassie, and I'm here to tell you your age in dog years!",0
prompt_1 	byte 	"Whats your name? ",0
intro_2 	byte	"Nice to meet you",0
prompt_2	byte	"How old are you? ",0
dogAge 		dword	?
result_1	byte	"Wow.. thats ",0
result_2	byte 	" in dog years",0
goodBye		byte	"Good-Bye, ",0


.code
main PROC

; introduce the programmer
	mov 	edx, OFFSET	intro_1
	call	WriteString
	call	CrLf
	
; get users name
	mov 	edx, OFFSET prompt_1
	call 	WriteString
	
	mov		edx, OFFSET userName
	mov		ecx, 32
	call 	ReadString
	
	mov 	edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call 	CrLf

; get users age
	mov		edx, OFFSET	prompt_2
	call 	WriteString
	call	ReadInt
	mov		userAge, eax
	

; calculate user's dog years
	mov		eax, userAge
	mov		ebx, DOG_FACTOR
	mul		ebx
	mov		dogAge, eax
	
; report result
	mov		edx, OFFSET result_1
	call	WriteString
	mov 	eax, dogAge
	call	WriteDec
	mov		edx, OFFSET result_2
	call	WriteString
	call	CrLf
	
; say goodBye
	
	mov 	edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET	userName
	call	WriteString
	call	CrLf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
