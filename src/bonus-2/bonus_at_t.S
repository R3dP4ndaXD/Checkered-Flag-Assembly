#include "positions.h"

.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

.macro substract position, value
	movl 16(%ebp), %eax				//mut in eax lungimea vectorilor	
	movl \position, %ecx			//mut in ecx pozitia
	mul %ecx						//inmultesc la lungime pozitia	
	movl $10, %ecx 					//mut in ecx lungimea de referinta
	div %ecx						//impart produsul din eax la ecx 
	movl %eax, %ecx					//mut in ecx rezultatul final al calculelor
	movl \value, %eax				//mut in eax valoarea
	sub %eax, (%ebx, %ecx, 4)		//scad de la pozitia din ecx a vectorului v numarul din eax
.endm


add_vect:
	pushl	%ebp
	movl 	%esp, %ebp
										   	//8(%ebp)  int *v1
										   	//12(%ebp) int *v2
											//16(%ebp) int n
											//20(%ebp) int *v

	pushl %esi								//salvez esi 
	pushl %edi								//salvez edi
	pushl %ebx								//salvez ebx
	xor %ecx, %ecx							//contor pozitie in vectori
	xor %edx, %edx
	movl 8(%ebp), %esi 						//mut in esi adresa de inceput a vectorului v1
	movl 12(%ebp), %edi 					//mut in edi adresa de inceput a vectorului v2
	movl 20(%ebp), %ebx 					//mut in edi adresa de inceput a vectorului v

aduna:
	movl (%esi, %ecx, 4), %eax				//mut in eax numarul de pe pozitia curenta din v1
	add (%edi, %ecx, 4), %eax 				//adun la eax numarul de pe pozitia curenta din v2
	movl %eax, (%ebx, %ecx, 4)				//mut pe pozitia curenta din v numarul calculat in eax
	addl $1, %ecx 							//incrementez pozitia
	cmp 16(%ebp), %ecx						//verifica daca am ajuns cu pozitia in afara vectorilor
	jl aduna								//daca nu, repet procesul

	substract $FIRST_POSITION, $FIRST_VALUE		//folosecsc macro-ul pentru cele 3 seturi de
	substract $SECOND_POSITION, $SECOND_VALUE	//define-uri (pozitie, valoare) din fisierul header
	substract $THIRD_POSITION, $THIRD_VALUE

	popl %ebx								//restaurez ebx
	popl %edi								//restaurez edi
	popl %esi								//restaurez esi
	leave
	ret
