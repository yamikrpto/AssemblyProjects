.data 
	saudacao: .asciiz "Olá. Nesse programa iremos calcular o valor de DELTA de uma equação quadrática. \nA seguir informe o que for pedido.\n"
	qvalora: .asciiz "Qual valor da varíavel A dessa equação? "
	qvalorb: .asciiz  "Qual valor da varíavel B dessa equação? "
	qvalorc: .asciiz   "Qual valor da varíavel C dessa equação? "
	saida: .asciiz "O resultado de DELTA é : "
.text
	addi $v0, $zero, 4
	la $a0, saudacao #imrpime a saudacao
	syscall 
	
	addi $v0, $zero, 4
	la $a0, qvalora #imprime a mensagem de qvalora
	syscall
	
	addi $v0, $zero, 5 #pede o int da vairavel de A
	syscall
	
	add $t0, $zero, $v0 #armazea A em t0
	addi $v0, $zero, 4
	la $a0, qvalorb #imprime a mensagem de qvalorb
	syscall
	
	addi $v0, $zero, 5 #pede o int da variavel de B
	syscall
	
	add $t1, $zero, $v0 #armazena B em t1
	addi $v0 ,$zero, 4
	la $a0, qvalorc  #imprime a mensagem de qvalorc
	syscall 
	
	addi $v0, $zero, 5 #pede o int da variavel C
	syscall
	
	add $t2, $zero, $v0 #armazena C em t2
	addi $v0, $zero, 4
	la $a0, saida #imprime a mensagem de saida
	syscall
	
	#Calculo de DELTA = b² - 4*a*c
	
	mul $t5,$t1,$t1 #multplica B por B
	
	li $s1, 4 #carrega 4 em s1
	mul $t4, $s1, $t0 #multiplica 4 por A
	mul $t4, $t4, $t2 #multiplica (4*a) por C
	
	sub $a0, $t5, $t4 #subtrai b² por 4ac
	
	 addi $v0, $zero, 1 #imprime o resultado
	 syscall 
	
	
	addi $v0, $zero, 10
	syscall
	
	