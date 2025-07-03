.data 
	localArquivo: .asciiz "/home/krpto/Downloads/1.txt"
	conteudoArquivo: .space 1024

.text

	addi $v0, $zero, 13 #solicita a abertura do arquivo
	la $a0, localArquivo #passa da ram pro reg
	addi $a1, $zero, 0 #leitura; 1 : escrita
	syscall #descritor fica em $v0
	
	add $s0, $zero, $v0 #copia o descritor
	
	add $a0, $zero, $s0 
	addi $v0,$zero, 14 #ler o conteudo do arquivo referenicado em $a0
	la $a1, conteudoArquivo #buffer que armazena o conteudo
	la $a2, 1024 #tamanho do buffer
	syscall
	
	addi $v0, $zero  4 #imprimindo o conteudo do aquivo
	add $a0, $zero, $a1
	syscall
	
	addi $v0, $zero, 16 #fechar arquivo
	move $a0, $s0
	syscall

	addi $v0, $zero, 10 #encerrar o programa 
	syscall