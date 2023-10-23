section .bss
toprint:	resb	1

section .data
lf:	db 0Ah

section .text
global _start
_start:
	mov eax, 0	;fibonacci numbers starts at 0, 1
	mov ebx, 1	;store this values in eax and ebx
	mov ecx, 30	;loop 30 times
	loop:
	add ebx, eax	;sum ebx and eax, store value in ebx
	push eax	;push eax to preserve it from function call
	push ebx	;push ebx to preserve it from function call
	push ecx	;push ecx to preserve it from function call
	call printnum	;call printnum, number to print in eax
	pop ecx		;restore ecx
	pop eax		;swap eax and ebx, restore them in the same order
	pop ebx		;as i pushed them onto the stack
	dec ecx		;decrement ecx
	test ecx, ecx	;test if ecx is 0
	jnz loop	;if not continue looping
	mov eax, 1	;finished the loop, prepare to call sys_exit(0)
	mov ebx, 0	;param for sys_exit()
	int 80h		;make the system call

;param number in eax
printnum:
	xor edi, edi	;used to count the number of digits
	divide:
	xor edx, edx	;put 0 in edx, used for the remainder
	mov ecx, 10	;divide by ten so put ten in ecx
	div ecx		;divide eax by ecx
	push edx	;push remainder onto the stack
	inc edi		;increment the digit counter
	test eax, eax	;test if eax is 0
	jnz divide	;if not continue dividing
	print:
	pop eax		;get remainder of the division into eax
	add eax, '0'	;add 48 to convert to ascii
	mov [toprint], eax	;mov the value in toprint
	mov ebx, 1	;mov 1 into ebx: stdout prepare for sys_write()
	mov ecx, toprint	;mov into ecx the memory address
	mov edx, 1	;mov 1 into edx, print one digit per time
	mov eax, 4	;system call number 4
	int 80h		;make system call
	dec edi		;decrement digit counter to know how many digits i have to print
	test edi, edi	;check if edi is 0
	jnz print	;if not print next digit
	mov eax, 4	;prepare to print line feed char
	mov ebx, 1	;stdout
	mov ecx, lf	;line feed memory address
	mov edx, 1	;print one char
	int 80h		;make system call
	ret		;return