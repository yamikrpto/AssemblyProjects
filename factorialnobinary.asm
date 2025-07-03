

.text
.globl main

main:
    addi $t0, $zero, 5    # $t0 = n = 5 (número para calcular o fatorial)
    addi $t5, $zero, 1    # $t5 = resultado = 1 (agora usando $t5)
    
loop:
    beq $t0, $zero, fim   # Se n = 0, vai para fim
    add $t2, $zero, $t5   # $t2 = cópia do resultado atual
    addi $t3, $zero, 1    # $t3 = contador para multiplicação
    
mult:
    beq $t3, $t0, prox    # Se contador = n, termina esta multiplicação
    add $t5, $t5, $t2     # Adiciona resultado a si mesmo (usando $t5)
    addi $t3, $t3, 1      # Incrementa contador
    j mult                # Volta para mult
    
prox:
    addi $t0, $t0, -1     # Decrementa n
    j loop                # Volta para loop
    
fim:
    # O resultado (120) está em $t5

