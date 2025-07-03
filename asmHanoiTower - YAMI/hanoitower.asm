	.data

    pDiscos: .asciiz "Quantos discos tem seu problema? "
    rMovimentos: .asciiz "A quantidade mínima de movimentos é:" 
    erro1: .asciiz "Erro. O programa somente suporta de 1 a 5 discos"
    erro2: .asciiz "Erro. Não há discos para mover"
    msgMoverDisco: .asciiz "\nMover o disco "
    msgDaTorre: .asciiz " da torre "
    msgParaTorre: .asciiz " para a torre "

	.text
	.globl main

main:
    addi $v0, $zero, 4           #chama impressao da string
    la $a0, pDiscos              #carrega a string para o reg responsavel por imprimir string
    syscall                      #executa a impressao de pDiscos
    
    addi $v0, $zero, 5           #captura numero de discos 
    syscall
    
    add $t0, $zero, $v0          #salva num de discos em t0
    
    li $a1, 'A'                  #armazena o identificador da torre A em $a1
    li $a3, 'B'                  #armazena o identificador da torre B em $a2
    li $a2, 'C'                  #armazena o identificador da torre C em $a3
    
    #calcular 2^n - 1
    #desloca 1 para a esquerda n vezes para calcular 2^n
    addi $t1, $zero, 1           #$t1 = 1
    sllv $t1, $t1, $t0           #$t1 = 1 << n  (equivalente a 2^n)

    #subtrair 1 para obter 2^n - 1
    addi $t1, $t1, -1            #$t1 = 2^n - 1
    
    
    #verifica se num de discos é válido
    blez $t0, erro_2             # se n_discos <= 0, vai para erro_2
    #verifica se o número de discos é maior que 5
    addi $t3, $zero, 6           #$t3 recebe 6
    bge $t0, $t3, erro_1         #se n_discos >= 6, vai para erro_1
    
    #a partir daqui, o número de discos é válido
    addi $v0, $zero, 4           #chama impressão da string
    la $a0, rMovimentos          #carrega a string para o registrador responsável por imprimir (a0)
    syscall                     
    
    addi $v0, $zero, 1
    add $a0, $zero, $t1          # mpressão da quantidade mínima de movimentos
    syscall
    
    add $a0, $zero, $t0
        
    jal TorreHanoi
    
    addi $v0, $zero, 10
    syscall

erro_1:
    addi $v0, $zero, 4           #ler string
    la $a0, erro1                #passa erro1 para a0 onde será lida
    syscall
    
    addi $v0, $zero, 10
    syscall


erro_2:
    addi $v0, $zero, 4           #ler string
    la $a0, erro2                #passa erro2 para a0 onde será lida
    syscall
    
    addi $v0, $zero, 10
    syscall
    
# função recursiva da Torre de Hanoi

TorreHanoi:
    #entradas:
    #$a0 -> n (número de discos)
    #$a1 -> origem (torre de origem)
    #$a3 -> auxiliar (torre auxiliar)
    #$a2 -> objetivo (torre de destino)
               
    #salva os registradores que serão usados na função para preservar seu valor
    addi $sp, $sp, -20           #desloca o ponteiro da pilha para alocar espaço
    sw   $ra, 0($sp)             #salva o endereço de retorno
    sw   $s0, 4($sp)             #salva o registrador $s0
    sw   $s1, 8($sp)             #salva o registrador $s1
    sw   $s2, 12($sp)            #salva o registrador $s2
    sw   $s3, 16($sp)            #salva o registrador $s3

    #copia os valores dos parâmetros passados para os registradores de preservação
    add $s0, $a0, $zero          #número de discos (em $a0) para $s0
    add $s1, $a1, $zero          #torre de origem (em $a1) para $s1
    add $s2, $a2, $zero          #torre de destino (em $a2) para $s2
    add $s3, $a3, $zero          #torre auxiliar (em $a3) para $s3

    addi $t1, $zero, 1           #carrega o valor 1 em $t1 para comparar com o número de discos
    beq $s0, $t1, saida          # número de discos == 1, pula para a parte 'saida'

recusivo1:        
    addi $a0, $s0, -1            #n-1
    add $a1, $s1, $zero          #passa torre de origem para $a1
    add $a2, $s3, $zero          #passa torre objetivo para $a2
    add $a3, $s2, $zero          #passa torre de auxiliar para $a3

    jal TorreHanoi               #hanoi recursivamente

    j saida                      #após a primeira chamada recursiva, pula para 'saida'

recursivo2:
    addi $a0, $s0, -1            #n-1
    add $a1, $s3, $zero          # passa torre objetivo para $a1
    add $a2, $s2, $zero          # passa estaca de auxiliar para $a2
    add $a3, $s1, $zero          #passa estaca de origem para $a3
    jal TorreHanoi               #hanoi recursivamente

fim_TorreHanoi:
#restaura todos os valores e retorna a funcao com  jump register uncoditionally
    lw   $ra, 0($sp)             
    lw   $s0, 4($sp)             
    lw   $s1, 8($sp)             
    lw   $s2, 12($sp)            
    lw   $s3, 16($sp)            
    addi $sp, $sp, 20           
    jr $ra                      

saida:
    li $v0, 4                   #imprime string
    la $a0, msgMoverDisco       #carrega o endereço de msgMoverDisco em $a0
    syscall                     #exibe a mensagem
   
    li $v0, 1                   #imprime int
    add $a0, $s0, $zero          # passa o número do disco (em $s0) para $a0
    syscall                     # exibe o número do disco
    
    li $v0, 4                   #imprime string
    la $a0, msgDaTorre          #carrega o endereço de msgDaTorre em $a0
    syscall                     #exibe a mensagem 
    
    li $v0, 11                  #imprime char
    add $a0, $s1, $zero          #passa o identificador da torre de origem (em $s1) para $a0
    syscall                     #exibe o char da torre de origem
    
    li $v0, 4            
    la $a0, msgParaTorre        #carrega o endereço de msgParaTorre' (texto " to rod") em $a0
    syscall                 
    
    li $v0, 11                  #imprime char
    add $a0, $s2, $zero          #passa o identificador da torre de destino (em $s2) para $a0
    syscall                 
    
    beq $s0, $t1, fim_TorreHanoi #número de discos ==  1, termina a execução 
    j recursivo2                #caso contrário, continua para a segunda chamada recursiva
