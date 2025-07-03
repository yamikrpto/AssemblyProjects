.global _start

.section .data
    format:     .asciz "NOTAS:\n100: %d\n50: %d\n20: %d\n10: %d\n5: %d\n2: %d\nMOEDAS:\n1: %d\n0.50: %d\n0.25: %d\n0.10: %d\n0.05: %d\n0.01: %d\n"

.section .bss
    note100:    .skip 4
    note50:     .skip 4
    note20:     .skip 4
    note10:     .skip 4
    note5:      .skip 4
    note2:      .skip 4
    coin1:      .skip 4
    coin50:     .skip 4
    coin25:     .skip 4
    coin10:     .skip 4
    coin5:      .skip 4
    coin1c:     .skip 4

.section .text
_start:
    // Inicializamos o valor fixo em centavos (517.12 -> 51712 centavos)
    MOV R0, #51712   // Valor em centavos (51712)

    // Calcular as notas (100, 50, 20, 10, 5, 2)
    MOV R1, #100
    BL calculate_notes
    MOV R1, #50
    BL calculate_notes
    MOV R1, #20
    BL calculate_notes
    MOV R1, #10
    BL calculate_notes
    MOV R1, #5
    BL calculate_notes
    MOV R1, #2
    BL calculate_notes

    // Calcular as moedas (1, 50, 25, 10, 5, 1)
    MOV R1, #100      // Moeda de 1 (1.00 = 100 centavos)
    BL calculate_coins
    MOV R1, #50       // Moeda de 0.50 (50 centavos)
    BL calculate_coins
    MOV R1, #25       // Moeda de 0.25 (25 centavos)
    BL calculate_coins
    MOV R1, #10       // Moeda de 0.10 (10 centavos)
    BL calculate_coins
    MOV R1, #5        // Moeda de 0.05 (5 centavos)
    BL calculate_coins
    MOV R1, #1        // Moeda de 0.01 (1 centavo)
    BL calculate_coins

    // Exibir o resultado
    LDR R0, =format
    LDR R1, =note100
    LDR R2, [R1]       // Carregar número de notas de 100
    MOV R3, R2         // Armazenar no registrador temporário
    // Aqui faríamos um procedimento para imprimir em R0, o formato com a quantidade de cada nota e moeda
    // ... (a parte de impressão depende do sistema, então isso é omisso)

    // Finalizar o programa
    MOV R7, #1         // Sistema de chamada para saída
    SWI 0              // Chamada de sistema (exit)
    
// Função para calcular o número de notas
calculate_notes:
    // R0 = valor restante em centavos
    // R1 = valor da nota (por exemplo, 100, 50, 20...)
    SDIV R2, R0, R1    // R2 = quantidade de notas (quociente)
    MUL R3, R2, R1     // R3 = valor total das notas
    SUB R0, R0, R3     // R0 = valor restante
    LDR R4, =note100    // Carregar endereço da variável note100
    STR R2, [R4]       // Armazenar quantidade de notas em note100
    BX LR              // Retorna da função

// Função para calcular o número de moedas
calculate_coins:
    // R0 = valor restante em centavos
    // R1 = valor da moeda em centavos (por exemplo, 100, 50, 25...)
    SDIV R2, R0, R1    // R2 = quantidade de moedas (quociente)
    MUL R3, R2, R1     // R3 = valor total das moedas
    SUB R0, R0, R3     // R0 = valor restante
    LDR R4, =coin1     // Carregar endereço da variável coin1
    STR R2, [R4]       // Armazenar quantidade de moedas em coin1
    BX LR              // Retorna da função
