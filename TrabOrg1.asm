# Integrantes:	Estevam Fernandes Arantes 976
#		Henrique Andrews Prado Marques 9771463
#		Osmar Bohr Horng Chen 9288359
#		Willian Gonzaga Leodegario 9771293

.data 
	.align 2
	.asciiz
#Opções				
opcao0:		"\nEscolha uma das opções abaixo:\n"
opcao1: 	"\n1) Inserção"
opcao2: 	"\n2) Percorrimento pré-ordem"
opcao3:		"\n3) Percorrimento em-ordem"
opcao4: 	"\n4) Percorrimento pós-ordem"
opcao5: 	"\n5) Sair"
input_opcao:	"\n\n Opção:"

#Mensagens
error_input:	"\nOpção inválida"
vazia: 		"\nÁrvore está vazia"
str_start:	"\nDigite os Valores a serem inseridos\n"
str_digite:	"Valor: "
newline:	" "

ptr_posicao:	.word 0
ptr_quantidade:	.word 0
ptr_index:	.word 0	 

.text

opcoes:	#Imprimindo opções
	la $a0, opcao0
	li $v0, 4
	syscall

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
	
	li $v0, 12		#Aquisição de entrada
	syscall
	
	move $t0, $v0
	
	beq $t0, '1', insercao
	beq $t0, '2', pre_ordem
	beq $t0, '3', em_ordem
	beq $t0, '4', pos_ordem
	beq $t0, '5', sair
	
	li $v0, 4           	#Caso selecionado algo aleatório
	la $a0, error_input 	#printa error_input
	syscall

	j input         	#Vota para o início de input

insercao:
	#printa a string inicial.
	la $a0, str_start
	li $v0, 4
	syscall
	
	#Salto incondicional para o "salva_vetor" salvando o endereco
	jal salva_vetor
	
	#Salva o retorno de "salva_vetor" (de $v0) para $a0
	move $a0, $v0
	
	j opcoes	
salva_vetor:
	#Carrega 0 em $s0
	la $t0, ptr_posicao
	lw $s0, 0($t0)
	
	#Carrega 0 em $s1
	la $t1, ptr_quantidade
	lw $s1, 0($t1)
	
	#Armazena na pilha o endereco de retorno
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	startload:
		addi, $sp, $sp, -4
		lw $t0, 0($sp)
		
		bne $t0, $zero, load
		
		#Imprime na tela
		la $a0, str_digite
		li $v0, 4
		syscall
		
		#Adquire um inteiro do teclado.
		li $v0, 5
		syscall
		
		#Condição de parada
		beq $v0, $zero, endload
		
		#Incrementa o contador
		addi $s1, $s1, 1
		
		#Salva na pilha o valor em $v0
		sw $v0, 0($sp)
		
		addi $sp, $sp, 4
		
	load:
		#Imprime na tela
		la $a0, str_digite
		li $v0, 4
		syscall
		
		#Adquire um inteiro do teclado.
		li $v0, 5
		syscall
		
		#Condição de parada
		beq $v0, $zero, endload
		
		#carrega o endereco da raiz em $s2
		addi $s2, $sp, -4
		
		#carrega o valor da raiz
		lw $t0, 0($s2)
		
		#Carrega 0 em $s3
		la $t3, ptr_index
		lw $s3, 0($t3)
		
		#faz $s3 apontar para o primeiro elemento da arvore (relativo a $sp)
		addi $s3, $s3, -4
		
		findPlace:
			#dobra o valor de $s3
			add $s3, $s3, $s3 
			
			#checa se o no vai pra esquerda ou pra direita
			blt $v0, $t0, go
			
			goRight:
				#aponta pro no relativo a direita
				addi $s3, $s3, -4
					
			go:
				#faz $s2 apontar pro endereco absoluto do no
				add $s2, $sp, $s3
				#carrega o valor do no
				lw $t0, 0($s2)
			
			#se $t0 nao estiver vazio, continua a recursao
			bne $t0, $zero, findPlace
		
		#Incrementa o contador
		addi $s1, $s1, 1
		
		#Salva na pilha o valor em $v0
		sw $v0, 0($s2)
		
		#Repete o laco.
		j load
		
	endload:
		#Retorna $sp para a posição onde esta o endereço de retorno
		add $sp, $sp, $s0

		#Carrega para $ra o endereco de retorno		
		lw $ra, 0($sp)
		
		#Sobe $sp uma posicao
		addi $sp, $sp, 4
		
		#Coloca o valor de $s1 em $v0
		move $v0, $s1

		#Salto incondicional para em $ra.		
		jr $ra
pre_ordem:

	j opcoes
em_ordem:

	j opcoes
pos_ordem:

	j opcoes
sair:	#sai do programa
	li $v0, 10
	syscall
