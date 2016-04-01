TITLE Program Template     (AddTwo.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCoce:DWORD
.data

; (insert variable definitions here)

.code
main PROC
	mov eax,5
	add eax,6

	INVOKE ExitProcess,0
main ENDP

; (insert additional procedures here)

END main
