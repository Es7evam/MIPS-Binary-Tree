# Integrantes:	Estevam Fernandes Arantes 976
#		Henrique Andrews Prado Marques 9771463
#		Osmar Bohr Horng Chen 9288359
#		Willian Gonzaga Leodegario 9771293

.data 
	.align 2
nl:		.asciiz "\n"
opcao1: 	.asciiz "\nInserção - Aperte 1"
opcao2: 	.asciiz "\nPercorrimento pré-ordem - Aperte 2"
opcao3: 	.asciiz "\nPercorrimento em-ordem - Aperte 3"
opcao4: 	.asciiz "\nPercorrimento pós-ordem - Aperte 4"
opcao5: 	.asciiz "\nSair - Aperte 5"
input_opcao:	.asciiz "\n\nEscolha uma opção:"
vazia: 		.asciiz "Árvore está vazia"

.text

opcoes:	#Imprimindo opções
	la $a0, opcao1
	li $v0, 4
	syscall
	
	la $a0, opcao2
	li $v0, 4
	syscall
	
	la $a0, opcao3
	li $v0, 4
	syscall
	
	la $a0, opcao4
	li $v0, 4
	syscall
	
	la $a0, opcao5
	li $v0, 4
	syscall
	
input:
	la $a0, input_opcao	#Imprime input_opcao
	li $v0, 4
	syscall
	
	li $v0, 5		#
	syscall
	
	move $t0, $v0
	
	beq $t0, 1, insercao
	beq $t0, 2, pre_ordem
	beq $t0, 3, em_ordem
	beq $t0, 4, pos_ordem
	beq $t0, 5, sair
	
	li $v0, 4           #Caso selecionado algo aleatório
	la $a0, nl          #printa nl
	syscall

	j input         #Vota para o início de input

insercao:
	
pre_ordem:

em_ordem:

pos_ordem:

sair:	#sair do programa
	li $v0, 10
	syscall