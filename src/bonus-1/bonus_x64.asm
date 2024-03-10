section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	push	rbp
	mov 	rbp, rsp
									;rdi  int *v1
									;rsi  int n1
									;rdx  int *v2
									;rcx  int n2
									;r8   int *v

	xor r9, r9	    				;counter pentru v1
	xor r10, r10					;counter pentru v2
	xor r11, r11					;counter pentru v

scrie_v1_v2:
	mov eax, [rdi + 4 * r9]			;mut in eax numarul de 4 octeti de pe pozitia curenta din v1
	mov [r8 + 4 * r11], eax 		;mut pe pozitia curenta din v numarul din eax
	mov eax, [rdx + 4 * r10]		;mut in eax numarul de 4 octeti de pe pozitia curenta din v2
	mov [r8 + 4 * (r11 + 1)], eax	;mut pe urmatoarea pozitie din v numarul din eax
	inc r9							;incrementez pozitia din v1
	inc r10							;incrementez pozitia din v2
	add r11, 2						;cresc cu 2 pozitia din v
	cmp r9, rsi						;verific daca am ajuns la finalul lui v1
	je scrie_v2						;daca nu,
	cmp r10, rcx					;verific daca am ajuns la finalul lui v2
	je scrie_v1						;daca nu,
	jmp scrie_v1_v2					;continui cu scrierea in paralel

scrie_v2:							;am ajuns la finalul lui v1
	cmp r10, rcx					;verific daca am ajuns si la finalul lui v2
	je gata							;daca nu,
	mov eax, [rdx + 4 * r10]		;mut in eax numarul de 4 octeti de pe pozitia curenta din v2
	mov [r8 + 4 * r11], eax			;mut pe pozitia curenta din v numarul din eax
	inc r10							;incrementez pozitia din v2
	inc r11							;incrementez pozitia din v
	jmp scrie_v2					;continui cu scrierea din v2

scrie_v1:							;am ajuns la finalul lui v2
	cmp r9, rsi						;verific daca am ajuns si la finalul lui v1
	je gata							;daca nu,
	mov eax, [rdi + 4 * r9]			;mut in eax numarul de 4 octeti de pe pozitia curenta din v1
	mov [r8 + 4 * r11], eax			;mut pe pozitia curenta din v numarul din eax
	inc r9							;incrementez pozitia din v1
	inc r11							;incrementez pozitia din v
	jmp scrie_v1					;continui cu scrierea din v1

gata:								;am terminat de scris
	leave
	ret								
