extern array_idx_1      ;; int array_idx_1

section .text
    global inorder_parc

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_parc(struct node *node, int *array);
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor in vectorul array.
;    @params:
;        node  -> nodul actual din arborele de cautare;
;        array -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!
; HINT: folositi variabila importata array_idx_1 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test.

inorder_parc:
    enter 0, 0                  ;setez stack frame-ul
                    ;[ebp +8]   struct node *node
                    ;[ebp + 12] int *array
    cmp dword[ebp + 8], 0       ;verific daca am ajung pe un nod NULL, 
    je gata                     ;caz in care se iese din recursivitate
    mov eax, [ebp + 8]          ;mut in eax adresa nodului curent
    push dword[ebp + 12]        ;pun pe stiva adresa de inceput a vectorului
    push dword[eax + 4]         ;pun pe stiva adresa fiului stang, care se gaseste la 
                                ;urmatoarea adresa dupa adresa de inceput a structurii
    call inorder_parc           ;apelez recursiv inorder_parc
    add esp, 8                  ;scot parametrii functiei de pe stiva
    
    mov edx, [ebp + 12]         ;mut in edx adresa de inceput a vectorului
    add edx, [array_idx_1]      ;adun la edx offsetul pentru a ajunge la prima pozitie libera din vector
    mov eax, [ebp + 8]          ;mut in eax adresa nodului curent
    mov ecx, dword[eax]         ;mut in ecx valoarea numerica din nod, gasita la adresa nodului
    mov [edx], ecx              ;mut la adresa curenta din vector valoarea din ecx 
    add dword[array_idx_1], 4   ;cresc offsetul cu o pozitie(un dword) 

    push dword[ebp + 12]        ;pun pe stiva adresa de inceput a vectorului
    push dword[eax + 8]         ;pun pe stiva adresa fiului drept, care se gaseste la a doua adresa
                                ;dupa adresa de inceput a structurii
    call inorder_parc           ;apelez recursiv inorder_parc
    add esp, 8                  ;scot parametrii functiei de pe stiva

gata:
    leave                       ;refac baza stivei
    ret                         ;revin in functia apelanta 