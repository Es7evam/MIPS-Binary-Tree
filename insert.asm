.data
	.align 2

str_start:	.asciiz "Digite os Valores a serem inseridos\n"
str_digite:	.asciiz "Valor: "
newline:	.asciiz " "

ptr_posicao:	.word 0
ptr_quantidade:	.word 0
ptr_index:	.word 0

.text
	
main:	#printa a string inicial.
	la $a0, str_start
	li $v0, 4
	syscall
	
	#Salto incondicional para o "salva_vetor" salvando o endereco
	jal salva_vetor
	
	#Salva o retorno de "salva_vetor" (de $v0) para $a0
	move $a0, $v0
	
	#Salto incondicional para o "print" salvando o endereco
	jal print
	
	#Sair do programa.
	li $v0, 10
	syscall
	
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

print:
	#Deslocamento de $sp em uma posicao para baixo
	addi $sp, $sp, -4
	sw $ra, 0($sp)	

	#Inicializa $t0
	move $t0, $zero

	#Coloca em $s0 o valor em $a0.
	move $s0, $a0
	
	startshow:
	
		#Impressão de um caractere de nova linha.
		la $a0, newline
		li $v0, 4
		syscall
		
		#Deslocamento de $sp na pilha
		addi $sp, $sp, -4
		addi $t0, $t0, 4
		
		#Criterio de parada
		beq $s0, $zero, endshow
		
		#Decrementa o numero de elementos
		addi $s0, $s0, -1
		
		#Armazena em $a0 o elemento do vetor apontado por $sp.
		lw $a0, 0($sp)
		
		#Imprime o valor inteiro armazenado em $a0.
		li $v0, 1
		syscall
		
		#Reinicia o laço.
		j startshow
		
	endshow:
		#Retorna $sp para a posição onde esta
		add $sp, $sp, $t0
		
		#Carrega para $ra o endereço de retorno
		lw $ra, 0($sp)
		
		#Sobe $sp uma posicao
		addi $sp, $sp, 4
		
		#Salto incondicional para $ra.
		jr $ra