			.equ PRINT_INT,		1
			.equ PRINT_STRING,	4
			.equ READ_INT,		5
			.equ EXIT,		10

			.text

			####################################
			# Fonction rechercheDichotomique() #
			####################################
rechercheDichotomique:
			subi sp, sp, 16							#Reserve 3 int dans la pile 
			#Sauvegarde du contenu des registres
			stw r8, 0(sp)							#r8 = pos	
			stw r9, 4(sp)							#r9 = adresse de tab[pos]     pos est la ieme valeur
			stw r10, 8(sp)							#r10 = tab[pos]
			stw ra, 12(sp)							#enregistre la valeur du registre de retour dans la pile
			
			add r8, zero, zero						#initialisation du registre pour pos 
			
			bge r7, r6, end_if1						#if(debut>fin)
			addi r2, r0, -1							#valeur de retour = -1
			br return								#branchement sur le return 
			
end_if1:
			sub r8,r7,r6							#fin-debut
			srli r8, r8, 1							#(fin-debut) / 2
			add r8, r6, r8							#pos = debut + (fin-debut) / 2
			
			slli r9, r8, 2							#pos*4 pour avoir la bonne adresse car on est sur un int
			add r9, r5, r9							#(@tab+pos)
			ldw r10, 0(r9)							#acces a tab[pos] 
			bne r10, r4, end_if2					#if(tab[pos] == val)
			
			add r2, r8, r0							#valeur de retour = pos
			br return								#branchement sur le return
			
end_if2:
			bge r10, r4, end_if3					#if(tab[pos]<val)
			addi r6, r8, 1							
			call rechercheDichotomique				#rechercheDichotomique(val, tab, pos+1, fin)
			br return								#branchement sur le return
			
end_if3:
			subi r7, r8, 1								
			call rechercheDichotomique				#rechercheDichotomique(val, tab, debut, pos-1)
			br return								#branchement sur le return

return: 	
			ldw r8, 0(sp)								
			ldw r9, 4(sp)							#Remettre le contenu des registres
			ldw r10, 8(sp)							#avant l'appel de la fonction
			ldw ra, 12(sp)							#enregistre de la valeur de la pile dans le registre de retour
			addi sp, sp, 16								
			ret										
		
			##############################
			#       Fonction main()      #
			##############################
			.globl main
main:	
			
boucle:
			bne r0,r0, fin_boucle						#while(1)
			movia	r4, msgNb							#printf("\n-----------------------------------------------\nEntrez un nombre:")
			addi	r2, zero, PRINT_STRING
			trap
			
			addi	r2, zero, READ_INT					#lire entier
			trap
			
			addi r4, r2, 0								#r4 = val 
			movia r5, tableau							#r5 = *tab
			addi r6, r0, 0								#r6 = debut
			addi r7, r0, 99								#r7 = fin
			
			call rechercheDichotomique					#appel de la fonction
			
			movia r3, pos
			stw r2, 0(r3)								
			bge r2, r0, else							#if(pos<0)
			
			movia r4, msgErreur
			addi r2, zero, PRINT_STRING					#printf("\n/\\ Nombre non trouve /\\")
			trap
			br end_if
else:
			movia r4, msgPos
			addi r2, zero, PRINT_STRING					#printf("\nLa position du nombre est: ")
			trap
			movia r3, pos
			ldw r4, 0(r3)
			addi r2, zero, PRINT_INT					#printf(pos)
			trap
end_if:
			br	boucle
fin_boucle:

			.data
val: 		.skip 4
pos:		.skip 4
msgNb:		.asciz "\n-----------------------------------------------\nEntrez un nombre:"
msgErreur:	.asciz "\n/\\ Nombre non trouve /\\"
msgPos:		.asciz "\nLa position du nombre est: "
