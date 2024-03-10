section .data
	; declare global vars here
	vowels db 'aeiou'		;vocale

section .text
	global reverse_vowels
	extern strchr

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place

reverse_vowels:
	push dword[esp + 4]		;pun pe stiva adresa string
	pop edx					;aduc string in edx
	pusha					;pun pe stiva toate registrele
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	push edx				;pun pe stiva adresa string
	pop esi					;aduc string in esi
	xor edx, edx
	;const char* strchr (const char *str, int character)

parcurgere1:
	push dword[esi + ecx]	;pun 4 caractere din string pe stiva
	pop ebx				
	and ebx, 255			;le aduc in ebx si il pastrez pe primul	
	push ecx				;salvez ecx
	push ebx				;pregatesc parametrii functiei
	push vowels				
	call strchr				;verifica daca litera curenta se afla printre literele din vowels 
	add esp, 8				;in eax intoarce adresa din vowels unde o gaseste sau 0 
							;daca nu o gaseste(e consoana)
	pop ecx					;restaurez ecx
	cmp eax, 0				
	je not_found
	push eax				;daca e vocala, salvez adresa din eax pe stiva
not_found:
	add ecx, dword 1		;avansez in sting
	cmp byte[esi + ecx], 0	;verific daca am ajuns la finalul stringului
	jne parcurgere1

	xor ecx, ecx
parcurgere2:
	push dword[esi] 		;pun 4 caractere din string pe stiva
	pop ebx					;le aduc in ebx si il pastrez pe primul
	and ebx, 255	
	push ebx				;pregatesc parametrii functiei
	push vowels
	call strchr				;verifica daca litera curenta se afla printre literele din vowels
	add esp, 8				;in eax intoarce adresa din vowels unde o gaseste sau 0
							;daca nu o gaseste(e consoana)
	cmp eax, 0
	je consoana					
	pop edi					;daca e vocala,
	push word[esi]			;aduc in edi adresa din vowels salvata pentru ultima vocala din string
	pop ax					;aduc in ax doua caractere din sting incepand cu cel curent		
	push word[edi]		
	pop dx					;aduc in dx doua caractere din vowels incepand cu cea de care am nevoie
	xor al, al				;elimin primul caracter din ax
	xor dh, dh				;elimin a doua vocala din dx
	or ax, dx				;pun laolalta vocala si caracterul
	push ax
	pop word[esi]			;actualizez in sting
							;astfel am modificat doar vocala si am pastrat caracterul de dupa nemodificat
consoana:
	inc esi					;avansez in sting
	cmp byte[esi], 0		;verifica daca am ajuns la finalul stringului
	jne parcurgere2		
test:
	popa					;restaurez registrele
	ret