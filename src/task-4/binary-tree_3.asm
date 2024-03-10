section .text
    global inorder_fixing

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

; ATENTIE: DOAR in frunze pot aparea valori gresite! 
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

inorder_fixing:
    enter 0, 0                  ;setez stack frame-ul
                ;[ebp +8]       struct node *node
                ;[ebp + 12]     struct node *parent
    cmp dword[ebp + 8], 0       ;verific daca am ajung pe un nod NULL,
    je gata                     ;caz in care se iese din recursivitate
    mov eax, [ebp + 8]          ;mut in eax adresa nodului curent
    push eax                    ;pun pe stiva adresa nodului curent(care va fi
                                ;nod parinte pt functia apelata)
    push dword[eax + 4]         ;pun pe stiva adresa fiului stang al nodului curent, care
                                ;se gaseste la urmatoarea adresa dupa adresa de inceput a structurii
    call inorder_fixing         ;apelez recursiv inorder_fixing
    add esp, 8                  ;scot parametrii functiei de pe stiva

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
    jl corect                   ;daca e mai mica, nodurile sunt in ordine si nu avem nimic de reparat
    sub ecx, 1                  ;daca nu, scad din ecx 1
    jmp fixing                  ;si repar intrusul

fiu_drept:                      ;nodul curent este fiu drept
    mov ecx, dword[ecx]         ;mut in ecx valoarea numerica din nodul parinte,
                                ;gasita la adresa nodului parinte
    cmp dword[eax], ecx         ;compar valoarea numerica din nodul curent,
                                ;gasita la adresa nodului, cu valoarea din ecx
    jg corect                   ;daca e mai mare, nodurile sunt in ordine si nu avem nimic de consemnat
    add ecx, 1                  ;daca nu, adun la ecx 1
    jmp fixing                  ;si
    
fixing:                         ;repar intrusul
    mov dword[eax], ecx         ;mut pe prima pozitie de la adresa nodului curent
                                ;valoarea calculata in ecx

corect:
    mov eax, [ebp + 8]          ;mut in eax adresa nodului curent
    push eax                    ;pun pe stiva adresa nodului curent(care va fi
                                ;nod parinte pt functia apelata)
    push dword[eax + 8]         ;pun pe stiva adresa fiului stang al nodului curent, care se
                                ;gaseste la a doua adresa dupa adresa de inceput a structurii
    call inorder_fixing         ;apelez recursiv inorder_fixing
    add esp, 8                  ;scot parametrii functiei de pe stiva

gata:
    leave                       ;refac baza stivei
    ret                         ;revin in functia apelanta
