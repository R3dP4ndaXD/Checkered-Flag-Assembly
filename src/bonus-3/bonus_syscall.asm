section .rodata
	max_len dd 100
	str1 db "Marco", 0
	str2 db "Polo", 0
	str1_len dd 5
	str2_len dd 4
section .bss
	fdin resd 1
	fdo resd 1
	buffer1 resb 101
	buffer2 resb 101
	len1 resd 1
	len2 resd 1

section .rodata:
	; taken from fnctl.h
	O_RDONLY	equ 00000
	O_WRONLY	equ 00001
	O_TRUNC		equ 01000
	O_CREAT		equ 00100
	S_IRUSR		equ 00400
	S_IRGRP		equ 00040
	S_IROTH		equ 00004

section .text
	global	replace_marco
	extern strncpy
	extern strncmp

;; void replace_marco(const char *in_file_name, const char *out_file_name)
;  it replaces all occurences of the word "Marco" with the word "Polo",
;  using system calls to open, read, write and close files.

replace_marco:
	push	ebp
	mov 	ebp, esp
	push ebx
	push esi
	push edi

	; Open file 
	mov ecx, 0 ; FILEMODE_R
	mov ebx, [ebp + 8]
	mov edx, 01FFh
	mov eax, 5  ;__NR_open
	int 80h  ; syscall
	mov [fdin],eax

	; create file 
	mov ecx, 01FFh ; FILEMODE_R
	mov ebx, [ebp + 12]
	mov eax, 8  ;__NR_open
	int 80h  ; syscall
	mov [fdo],eax

test1:
	; Read file data
	mov ebx, [fdin]
	mov ecx, buffer1
	mov edx, [max_len]
	mov eax,3  ; __NR_read
	int 80h
	mov [len1], eax
test2:

	xor ebx, ebx
	xor eax, eax
	mov dword[len2], 0
	mov esi, buffer1
	add esi, [len1]
	mov [esi], byte 0
	mov esi, buffer1
	mov edi, buffer2

parcurgere:
	cmp byte[esi], 77
	jne no_replace
test:
	push dword[str1_len]
	push str1
	push esi
	call strncmp
	add esp, 12
	cmp eax, 0
	jne no_replace
	push dword[str2_len]
	push str2
	push edi
	call strncpy
	add esp, 12
	add esi, [str1_len]
	add edi, [str2_len]
	add ebx, [str1_len]
	mov edx, [str2_len]
	add [len2], edx
	cmp ebx, [len1]
	jl parcurgere

no_replace:
	mov al, [esi]
	mov [edi], al
	inc dword[len2]
	inc ebx
	inc esi
	inc edi
	cmp ebx, [len1]
	jl parcurgere
	mov dword[edi], 0
test3:
	; Write to file
	mov edx,[len2]
	mov ecx, buffer2
	mov ebx, [fdo]
	mov eax,4 ; __NR_write
	int 80h
test4:

	; Close file
	mov ebx,[fdin]
	mov eax,6 ; __NR_close
	int 80h 

	mov ebx,[fdo]
	mov eax,6 ; __NR_close
	int 80h 
test5:

	pop edi
	pop esi
	pop ebx
	leave
	ret