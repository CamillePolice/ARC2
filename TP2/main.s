			##################################
			#	     L3INFO - TP ARC2        #
			# 	 Manipulation de tableaux    #
			##################################
		
			.equ PRINT_INT, 1
			.equ PRINT_STRING, 4
			.equ READ_INT, 5
			.equ EXIT,	10

			.text
			.global main
			
			
lectureTableau:
			subi sp, sp, 8			#Reserve 2 int dans la pile 
			stw r8, 0(sp)			#Sauvegarde du contenu des registre
			stw r9, 4(sp)			#car utilisation de ceux ci
			
			add r8, zero, zero		#i=0
			

for_loop:
			bge r8, r6, end_for				#i<taille
			
			movia r4, msgNombre				
			addi r2, zero, PRINT_STRING		# Affichage du message "Entrez un nombre :\n"
			trap
			
			addi r2, zero, READ_INT			#Lecture de ce nombre
			trap
			 
			slli r9, r8, 2					#i = i*4 car tableau de int
			add r9, r9, r5					#acces a tableau[i]  (@tableau+ieme element)
			stw r2, 0(r9)					#tableau[i] = read_int (nombre lu)
			
			addi r8, r8, 1					#i++
			br for_loop						
end_for:
			ldw r8, 0(sp)
			ldw r9, 4(sp)					#Remettre le contenu des registres avant l'appel de la fonction
			addi sp, sp, 16
			ret
			
affichageTableau:
			subi sp, sp, 8			#Reserve 2 int dans la pile 
			stw r8, 0(sp)			#Sauvegarde du contenu des registre
			stw r9, 4(sp)			#car utilisation de ceux ci
			
			add r8, zero, zero		#i=0
			
for_loop2:
			bge r8, r6, end_for2			#i<taille
			
			slli r9, r8, 2					#i = i*4 car tableau de int
			add r9, r9, r5					#acces a tableau[i] (@tableau+ieme element)
			ldw r4, 0(r9)
			addi r2, zero, PRINT_INT
			trap
			
			addi r8, r8, 1					#i++
			br for_loop2		

end_for2:
			ldw r8, 0(sp)
			ldw r9, 4(sp)					#Remettre le contenu des registres 
			addi sp, sp, 16					#avant l'appel de la fonction
			ret
			
			
inversionTableau:
			subi sp, sp, 24			#Reserve 2 int dans la pile 
			stw r8, 0(sp)			#Sauvegarde du contenu des registre
			stw r9, 4(sp)			#car utilisation de ceux ci
			stw r10, 8(sp)
			stw r11, 12(sp)
			stw r12, 16(sp)
			stw r13, 20(sp)
			
			add r8, zero, zero		#tmp
			add r9, zero, zero		#i=0
			subi r10, r6, 1			#j=taille-1
			add r13, zero, zero		#tmp2
			
while:
			bge r9, r10, end_while
			
			slli r11, r9, 2					#i = i*4 car tableau de int
			add r11, r11, r5				#acces a tableau[i] (@tableau+ieme element)
			ldw r8, 0(r11)					#tmp = tableau[i]
			
			slli r12, r10, 2				#j = j*4 car tableau de int
			add r12, r12, r5				#acces a tableau[j] (@tableau+jeme element)
			ldw r13, 0(r12)					#tmp2 = @tableau[j]
			stw r13, 0(r11)					#@tableau[i] = tmp2
			
			stw r8, 0(r12)					#tableau[j] = tmp
			
			addi r9, r9, 1					#i++
			subi r10, r10, 1				#j--
			br while
			
end_while:
			ldw r8, 0(sp)			
			ldw r9, 4(sp)			
			ldw r10, 8(sp)			#Remettre le contenu des registres
			ldw r11, 12(sp)			#avant l'appel de la fonction
			ldw r12, 16(sp)			
			ldw r13, 20(sp)
			addi sp, sp, 28
			ret
			
main:
			# Affichage du message "Lecture du tableau"
			movia	r4, msgLecture
			addi	r2,	zero, PRINT_STRING
			trap
			
			# Lecture du tableau
			movia r5, tableau				# affectation de l'adresse du tableau dans r4
			addi r6, r0, 10					# affectation de la taille du tableau dans r5
			call lectureTableau
			
			# Affichage du message "Inversion du tableau veuillez patientez...\n"
			movia r4, msgInversion
			addi r2, zero, PRINT_STRING
			trap
			
			# Inversion du tableau
			movia r5, tableau				# affectation de l'adresse du tableau dans r4
			addi r6, r0, 10					# affectation de la taille du tableau dans r5
			call inversionTableau
			
			
			# Affichage du message "Affichage du tableau"
			movia	r4, msgAffiche
			addi	r2,	zero, PRINT_STRING
			trap

			# Affichage du tableau
			movia r5, tableau				# affectation de l'adresse du tableau dans r4
			addi r6, r0, 10					# affectation de la taille du tableau dans r5
			call affichageTableau

			
			# On rend la main au système.
			addi	r2, zero, EXIT
			trap
			

	
			.data
msgLecture: .asciz "Lecture du tableau.\n"
msgAffiche: .asciz "\nAffichage du tableau."
msgNombre: 	.asciz "Entrez un nombre :"
msgInversion:	.asciz "\nInversion du tableau veuillez patientez... "

			# Tableau de 10 éléments
tableau:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0