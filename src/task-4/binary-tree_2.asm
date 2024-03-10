extern array_idx_2      ;; int array_idx_2

section .text
    global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

; HINT: folositi variabila importata array_idx_2 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test al functiei inorder_intruders.      

inorder_intruders:
    enter 0, 0                  ;setez stack frame-ul
                    ;[ebp +8]   struct node *node
                    ;[ebp + 12] struct node *parent
                    ;[ebp + 16] int *array
    cmp dword[ebp + 8], 0       ;verific daca am ajung pe un nod NULL,
    je gata                     ;caz in care se iese din recursivitate
    mov eax, [ebp + 8]          ;mut in eax adresa nodului curent
    push dword[ebp + 16]        ;pun pe stiva adresa de inceput a vectorului
    push eax                    ;pun pe stiva adresa nodului curent(care va fi
                                ;nod parinte pt functia apelata)
    push dword[eax + 4]         ;pun pe stiva adresa fiului stang al nodului curent, care
                                ;se gaseste la urmatoarea adresa dupa adresa de inceput a structurii
    call inorder_intruders      ;apelez recursiv inorder_intruders
    add esp, 12                 ;scot parametrii functiei de pe stiva

    mov ecx, [ebp + 12]         ;mut in ecx adresa de inceput a nodului parinte
    cmp ecx, 0                  ;verific ca exista nodul parinte
    je corect                   ;daca exista,
    mov eax, [ebp + 8]          ;mut in eax adresa nodului curent
    cmp eax, [ecx + 4]          ;compar adresa nodului curent cu adresa fiului stang al nodului parinte
    jne fiu_drept               ;daca sunt egale,
    mov ecx, dword[ecx]         ;mut in ecx valoarea numerica din nodul parinte,
                                ;gasita la adresa nodului parinte
    cmp dword[eax], ecx         ;compar valoarea numerica din nodul curent,
                                ;gasita la adresa nodului, cu valoarea din ecx
    jl corect                   ;daca e mai mica, nodurile sunt in ordine si nu avem nimic de consemnat
    jmp intruder                ;daca nu, inseamna ca am gasit un intrus

fiu_drept:                      ;nodul curent este fiu drept
    mov ecx, dword[ecx]         ;mut in ecx valoarea numerica din nodul parinte,
                                ;gasita la adresa nodului parinte
    cmp dword[eax], ecx         ;compar valoarea numerica din nodul curent,
                                ;gasita la adresa nodului, cu valoarea din ecx
    jg corect                   ;daca e mai mare, nodurile sunt in ordine si nu avem nimic de consemnat
    jmp intruder                ;daca nu,
    
intruder:                       ;inseamna ca am gasit un intrus
    mov ecx, dword[eax]         ;mut in ecx valoarea numerica din nodul curent, gasita la adresa nodului
    mov edx, [ebp + 16]         ;mut in edx adresa de inceput a vectorului
    add edx, [array_idx_2]      ;adun la edx offsetul pentru a ajunge la prima pozitie libera din vector
    mov [edx], ecx              ;mut la adresa curenta din vector valoarea din ecx 
    add dword[array_idx_2], 4   ;cresc offsetul cu o pozitie(un dword) 

corect:
    mov eax, [ebp + 8]          ;mut in eax adresa nodului curent
    push dword[ebp + 16]        ;pun pe stiva adresa de inceput a vectorului
    push eax                    ;pun pe stiva adresa nodului curent(care va fi
                                ;nod parinte pt functia apelata)
    push dword[eax + 8]         ;pun pe stiva adresa fiului stang al nodului curent, care se 
                                ;gaseste la a doua adresa dupa adresa de inceput a structurii
    call inorder_intruders      ;apelez recursiv inorder_intruders
    add esp, 12                 ;scot parametrii functiei de pe stiva

gata:
    leave                       ;refac baza stivei
    ret                         ;revin in functia apelanta
