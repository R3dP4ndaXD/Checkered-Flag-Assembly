global get_words
global compare_func
global sort

section .data
    delims db " ,.", 10, 0  ;delimitatori
    max dd 100              ;lungimea maxima a unui cuvant

section .text
    extern strtok
    extern strncpy
    extern strncmp
    extern qsort
    extern strlen

compare_func:
    push ebp                ;pun pe stiva vechiul ebp
    mov ebp, esp            ;fac epb sa pointeza la varful stivei
            ;[ebp + 8]      ;adresa unui element din vector, adr1
            ;[ebp + 12]     ;adresa altui element din vector, adr2
            
    mov edx,  [ebp + 12]    ;pun in edx adresa adr2                 
    push dword[edx]         ;pun pe stiva valoarea stocata la adr2
                            ;aceasta fiind de fapt adresa de inceput a cuvantului 2
    call strlen             ;apelez strlen
    add esp, 4              ;scot parametru functiei de pe stiva
    push eax                ;salvez pe stiva lungimea intoarsa in eax

    mov ecx, [ebp + 8]      ;pun in ecx adresa adr1
    push dword[ecx]         ;pun pe stiva valoarea stocata la adr1
                            ;aceasta fiind de fapt adresa de inceput a cuvantului 1
    call strlen             ;apelez strlen
    add esp, 4              ;scot parametru functiei de pe stiva
    pop edx                 ;aduc in edx lungimea stringului 2 salvata pe stiva 
    sub eax, edx            ;scad din lungimea stingului 1 returnata de ultimul apel
                            ;in eax lungimea gasita in edx 
    je criteriu2            ;daca nu sunt egale,
    leave                   ;restaurez vechiul ebx
    ret                     ;revin in functia apelanta

criteriu2:                  ;in caz de egalitate
    mov ecx,  [ebp + 8]     ;pun in ecx adresa adr1
    mov edx,  [ebp + 12]    ;pun in edx adresa adr2 
    push dword[max]         ;pun pe stiva lungime maxim posibil regasita la adresa max
    push dword[edx]         ;pun pe stiva adresa de inceput a cuvantului 2 gasita la adresa adr2
    push dword[ecx]         ;pun pe stiva adresa de inceput a cuvantului 1 gasita la adresa adr1
    call strncmp            ;apelez strncmp
    add esp, 12             ;scot parametrii functiei de pe stiva
                            ;rezultatul apelulului e intors in eax
    leave                   ;restaurez vechiul ebp
    ret                     ;revin in functia apelanta

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru sortarea cuvintelor 
;  dupa lungime si apoi lexicografic
sort:
    enter 0, 0
                ;[ebp + 8]  char **words
                ;[ebp + 12] int number_of_words
                ;[ebp + 16] int size
    push compare_func       ;pun pe stiva adresa functiei de comparare
    push dword[ebp + 16]    ;pun pe stiva marimea unui element din vectorul de cuvintele
    push dword[ebp + 12]    ;pun pe stiva numarul de de cuvinte
    push dword[ebp + 8]     ;pun pe stiva adresa de inceput a vectorului de cuvinte
    call qsort              ;apelez qsort
    add esp, 12             ;scot parametrii functiei de pe stiva
    leave                   ;refac ebp
    ret                     ;revin in functia apelanta

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    push ebx                ;salvez ebx
    push esi                ;salvez esi
    push edi                ;salvez edi
    mov esi, [ebp + 8]      ;char *s
    mov edi, [ebp + 12]     ;char **words
            ;[ebp + 16]     int number_of_words

    push delims             ;pun pe stiva adresa delimitatorilor
    push esi                ;pun pe stiva adresa textului
    call strtok             ;apelez strtok
                            ;functia intoarce in eax adresa de inceput a primului token(cuvant)
    add esp, 8              ;scot parametrii functiei de pe stiva

while:
    push dword[max]         ;pun pe stiva lungimea maxima pe care o poate avea un cuvant 
    push eax                ;pun pe stiva adresa cuvantului sursa 
    push dword[edi]         ;pun pe stiva adresa destinatie gasita la pozitia
                            ;curenta din vectorul de cuvinte
    call strncpy            ;apelez strncpy
    add esp, 12             ;scot parametrii functiei de pe stiva
    add edi, 4              ;avansez la urmatoarea pozitie din vectorul de cuvinte
    push delims             ;pun pe stiva adresa delimitatorilor
    push 0                  ;pun pe stiva NULL
    call strtok             ;apelez strtok
                            ;functia intoarce in eax adresa de inceput a urmatorului token(cuvant)
    add esp, 8              ;scot parametrii functiei de pe stiva
    cmp eax, 0              ;verific daca functia a intors NULL, caz in care am ajuns la final
    jne while               
    
finalizare:
    pop edi                 ;restaurez edi
    pop esi                 ;restaurez esi
    pop ebx                 ;restaurez ebx
    leave                   ;refac ebp
    ret                     ;revin in functia apelanta
