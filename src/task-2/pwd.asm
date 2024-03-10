section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here

section .text
	global pwd
	extern strcmp
	extern strlen
	extern strcpy

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
	enter 0, 0
	push ebx				;salvez ebx	   ;	esp = ebp - 4	|
	push esi				;salvez esi    ;    esp = ebp - 8	|=> orice mai adaug dupa pe stiva 
	push edi				;salvez edi	   ;	esp = ebp - 12	|   se va afla de la ebp - 16 in jos

	mov esi, [ebp + 8]		;directories
		    ;[ebp + 12]      n
	mov edi, [ebp + 16]		;output
	xor ebx, ebx			;retine pozitia la care ma aflu in vector, i
	xor ecx, ecx			;retine numarul de nivele din ierarhia de directoare 

parcurgere:
	push ecx				;salvez ecx
	push dword [esi]		;pun pe stiva adresa stingului curent: directories[i] = *(directories + i)
	push back				;pun pe stiva adresa stingului ".."
	call strcmp				;apelez strcmp
	add esp, 8				;scot parametrii functiei de pe stiva
	pop ecx					;restaurez ecx
	cmp eax, 0				;verifica daca sunt egale
	je inapoi			
	push ecx				;salvez ecx
	push dword [esi]		;pun pe stiva adresa stingului curent
	push curr				;pun pe stiva adresa stingului "."
	call strcmp				;apelez strcmp
	add esp, 8				;scot parametrii functiei de pe stiva
	pop ecx					;restaurez ecx
	cmp eax, 0				;verifica daca sunt egale
	je next					;daca nu ma aflu in niciunul din cazurile de mai sus,
	push slash				;pun pe stiva adresa stingului "/"
	push dword [esi]		;pun pe stiva adresa stingului curent
	inc ecx					;incrementez numarul de nivele din ierarhia de directoare
	jmp next

inapoi:						;daca stingului curent este ".."
	cmp ecx, 0 				;verific sa nu ma aflu la radacina ierarhiei
	je next					
	add esp, 8				;sterg ultimele doua stinguri din ierarhie
	sub ecx, 1				;si incrementez numarul de nivele din ierarhie

next:					
	inc ebx					;incrementez pozitia
	add esi, 4				;trec la urmatorul string din vector
	cmp ebx, [ebp + 12]		;verific daca nu am ajuns la finalulul vectorului
	jl parcurgere
	push slash				;pun pe stiva adresa stingului "/"

	lea esi, [ebp - 16]		;il pun pe esi sa pointeze la prima adresa salvata pe stiva la pasul anterior
	xor ecx, ecx			;numar octeti ocupati pe stiva de adresele salvate
scrie:
	push ecx				;salvez ecx
	push dword[esi]			;pun pe stiva adresa stringului sursa
	push edi				;pun pe stiva adresa destinatie din output 
	call strcpy				;apelez strcpy
	add esp, 8				;scot parametii functiei de pe stiva
	push dword[esi]			;pun pe stiva adresa stringului sursa
	call strlen				;apelez strlen
	add esp, 4				;scot parametru functiei de pe stiva
	add edi, eax			;avansez in output la pozitia imediat urmatoare stingului introdus 
	sub esi, 4				;cobor cu esi la urmatoarea adresa salvata pe stiva
	pop ecx					;restaurez ecx
	add ecx, 4				;contorizez octetii
	cmp esi, esp			;verific daca am ajuns la final cu adresele 
	jge scrie

finalizare:
	add esp, ecx			;scot toate adresele de pe stiva
	pop edi					;restaurez edi
	pop esi					;restaurez esi
	pop ebx					;restaurez ebx
	leave					
	ret					