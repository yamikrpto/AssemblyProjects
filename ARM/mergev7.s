@ merge sort em assembly armv7 32-bit
@ implementação  simplificada

.data
array:      .word   12, 11, 13, 5, 6, 7    @ array exemplo para ordenação
arr_size:   .word   6                       @ tamanho do array
msg_antes:  .ascii  "Array antes: "
msg_antes_len = . - msg_antes
msg_depois: .ascii  "Array depois: "
msg_depois_len = . - msg_depois
nova_linha: .ascii  "\n"
espaco:     .ascii  " "
buffer:     .skip   20                      @ buffer para converter números para string

.text
.global _start

_start:
    @ imprime mensagem inicial
    mov     r0, #1                      @ fd = 1 (stdout)
    ldr     r1, =msg_antes              @ buffer
    mov     r2, #msg_antes_len          @ tamanho da mensagem
    mov     r7, #4                      @ syscall write
    swi     #0
    
    @ imprime array original
    bl      imprimir_array
    
    @ chama merge_sort(array, 0, arr_size-1)
    ldr     r0, =array                  @ r0 = endereço do array
    mov     r1, #0                      @ r1 = indice esquerdo = 0
    ldr     r2, =arr_size               @ carrega endereço do tamanho
    ldr     r2, [r2]                    @ r2 = tamanho do array
    sub     r2, r2, #1                  @ r2 = indice direito = tamanho-1
    bl      merge_sort
    
    @ imprime mensagem final
    mov     r0, #1                      @ fd = 1 (stdout)
    ldr     r1, =msg_depois             @ buffer
    mov     r2, #msg_depois_len         @ tamanho da mensagem
    mov     r7, #4                      @ syscall write
    swi     #0
    
    @ imprime array ordenado
    bl      imprimir_array
    
    @ termina programa
    mov     r0, #0                      @ status = 0 (sucesso)
    mov     r7, #1                      @ syscall exit
    swi     #0
    
@ merge_sort(array, esquerda, direita)
@ implementa o algoritmo mergesort recursivamente
@ parâmetros:
@   r0 = endereço do array
@   r1 = indice esquerdo (inicio)
@   r2 = indice direito (fim)
merge_sort:
    @ salva registradores na pilha
    push    {r4-r11, lr}               @ salva registradores e link register
    
    @ salva parâmetros em registradores
    mov     r4, r0                      @ r4 = endereço do array
    mov     r5, r1                      @ r5 = esquerda
    mov     r6, r2                      @ r6 = direita
    
    @ verifica caso base: se esquerda >= direita, retorna
    cmp     r5, r6
    bge     fim_merge_sort             @ se esquerda >= direita, retorna
    
    @ calcula meio = esquerda + (direita - esquerda) / 2
    sub     r7, r6, r5                  @ r7 = direita - esquerda
    lsr     r7, r7, #1                  @ r7 = (direita - esquerda) / 2
    add     r7, r5, r7                  @ r7 = esquerda + (direita - esquerda) / 2
    
    @ ordena primeira metade: merge_sort(array, esquerda, meio)
    mov     r0, r4                      @ array
    mov     r1, r5                      @ esquerda
    mov     r2, r7                      @ meio
    bl      merge_sort
    
    @ ordena segunda metade: merge_sort(array, meio+1, direita)
    mov     r0, r4                      @ array
    add     r1, r7, #1                  @ meio + 1
    mov     r2, r6                      @ direita
    bl      merge_sort
    
    @ combina as duas metades ordenadas: merge(array, esquerda, meio, direita)
    mov     r0, r4                      @ array
    mov     r1, r5                      @ esquerda
    mov     r2, r7                      @ meio
    mov     r3, r6                      @ direita
    bl      merge
    
fim_merge_sort:
    @ restaura registradores
    pop     {r4-r11, pc}                @ restaura registradores e retorna
    
@ merge(array, esquerda, meio, direita)
@ combina duas subarrays ordenadas em uma única array ordenada
@ parâmetros:
@   r0 = endereço do array
@   r1 = indice esquerdo 
@   r2 = indice meio
@   r3 = indice direito
merge:
    push    {r4-r11, lr}               @ salva registradores
    
    @ salva parâmetros em registradores
    mov     r4, r0                      @ r4 = endereço do array
    mov     r5, r1                      @ r5 = esquerda
    mov     r6, r2                      @ r6 = meio
    mov     r7, r3                      @ r7 = direita
    
    @ calcula tamanhos dos subarrays
    sub     r8, r6, r5                  @ tamanho1 = meio - esquerda
    add     r8, r8, #1                  @ tamanho1 = meio - esquerda + 1
    sub     r9, r7, r6                  @ tamanho2 = direita - meio
    
    @ aloca espaço na pilha para arrays temporários
    add     r0, r8, r9                  @ r0 = tamanho1 + tamanho2
    lsl     r0, r0, #2                  @ r0 = (tamanho1 + tamanho2) * 4
    sub     sp, sp, r0                  @ aloca espaço na pilha
    
    @ posiciona ponteiros para os arrays temporários
    mov     r10, sp                     @ r10 = esq[0]
    add     r11, sp, r8, lsl #2         @ r11 = dir[0] = sp + tamanho1 * 4
    
    @ copia dados para esq[0..tamanho1-1]
    mov     r0, #0                      @ i = 0
loop_copia_esq:
    cmp     r0, r8                      @ i < tamanho1?
    bge     prep_copia_dir              @ se i >= tamanho1, pula para dir[]
    
    add     r1, r5, r0                  @ r1 = esquerda + i
    ldr     r2, [r4, r1, lsl #2]        @ r2 = array[esquerda + i]
    str     r2, [r10, r0, lsl #2]       @ esq[i] = r2
    
    add     r0, r0, #1                  @ i++
    b       loop_copia_esq
    
prep_copia_dir:
    mov     r0, #0                      @ j = 0
    
loop_copia_dir:
    cmp     r0, r9                      @ j < tamanho2?
    bge     prep_merge                  @ se j >= tamanho2, pula para a combinação
    
    add     r1, r6, r0                  @ r1 = meio + j
    add     r1, r1, #1                  @ r1 = meio + 1 + j
    ldr     r2, [r4, r1, lsl #2]        @ r2 = array[meio + 1 + j]
    str     r2, [r11, r0, lsl #2]       @ dir[j] = r2
    
    add     r0, r0, #1                  @ j++
    b       loop_copia_dir
    
prep_merge:
    mov     r0, #0                      @ i = 0 (índice para esq[])
    mov     r1, #0                      @ j = 0 (índice para dir[])
    mov     r2, r5                      @ k = esquerda (índice para array original)
    
loop_merge:
    @ verifica se ainda temos elementos em ambos arrays
    cmp     r0, r8                      @ i >= tamanho1?
    bge     copy_rest_dir               @ se i >= tamanho1, copia resto de dir[]
    
    cmp     r1, r9                      @ j >= tamanho2?
    bge     copy_rest_esq               @ se j >= tamanho2, copia resto de esq[]
    
    @ compara esq[i] e dir[j]
    ldr     r3, [r10, r0, lsl #2]       @ r3 = esq[i]
    ldr     r12, [r11, r1, lsl #2]      @ r12 = dir[j]
    
    cmp     r3, r12                     @ esq[i] <= dir[j]?
    bgt     copy_from_dir               @ se esq[i] > dir[j], copia de dir[]
    
    @ copia de esq[] para array[]
    str     r3, [r4, r2, lsl #2]        @ array[k] = esq[i]
    add     r0, r0, #1                  @ i++
    b       next_elem
    
copy_from_dir:
    @ copia de dir[] para array[]
    str     r12, [r4, r2, lsl #2]       @ array[k] = dir[j]
    add     r1, r1, #1                  @ j++
    
next_elem:
    add     r2, r2, #1                  @ k++
    b       loop_merge
    
copy_rest_esq:
    @ copia elementos restantes de esq[]
    cmp     r0, r8                      @ i >= tamanho1?
    bge     fim_merge                   @ se acabaram os elementos, termina
    
    ldr     r3, [r10, r0, lsl #2]       @ r3 = esq[i]
    str     r3, [r4, r2, lsl #2]        @ array[k] = esq[i]
    
    add     r0, r0, #1                  @ i++
    add     r2, r2, #1                  @ k++
    b       copy_rest_esq
    
copy_rest_dir:
    @ copia elementos restantes de dir[]
    cmp     r1, r9                      @ j >= tamanho2?
    bge     fim_merge                   @ se acabaram os elementos, termina
    
    ldr     r12, [r11, r1, lsl #2]      @ r12 = dir[j]
    str     r12, [r4, r2, lsl #2]       @ array[k] = dir[j]
    
    add     r1, r1, #1                  @ j++
    add     r2, r2, #1                  @ k++
    b       copy_rest_dir
    
fim_merge:
    @ desaloca espaço na pilha
    add     r0, r8, r9                  @ r0 = tamanho1 + tamanho2
    lsl     r0, r0, #2                  @ r0 = (tamanho1 + tamanho2) * 4
    add     sp, sp, r0                  @ restaura pilha
    
    @ restaura registradores
    pop     {r4-r11, pc}

@ função para imprimir o array
imprimir_array:
    push    {r4-r8, lr}
    
    ldr     r4, =array                  @ r4 = endereço base do array
    mov     r5, #0                      @ i = 0
    ldr     r6, =arr_size               @ carrega endereço do tamanho
    ldr     r6, [r6]                    @ r6 = tamanho do array
    
loop_imprime:
    cmp     r5, r6
    bge     fim_imprime
    
    @ carrega valor do array[i]
    ldr     r0, [r4, r5, lsl #2]        @ r0 = array[i]
    
    @ converte para string
    ldr     r1, =buffer
    bl      int_para_ascii              @ r0 = comprimento da string resultante
    mov     r7, r0                      @ salva o comprimento
    
    @ imprime número
    mov     r0, #1                      @ fd = stdout
    ldr     r1, =buffer
    mov     r2, r7                      @ comprimento da string
    mov     r7, #4                      @ syscall write
    swi     #0
    
    @ imprime espaço
    mov     r0, #1                      @ fd = stdout
    ldr     r1, =espaco
    mov     r2, #1                      @ comprimento do espaço
    mov     r7, #4                      @ syscall write
    swi     #0
    
    add     r5, r5, #1                  @ i++
    b       loop_imprime
    
fim_imprime:
    @ imprime nova linha
    mov     r0, #1                      @ fd = stdout
    ldr     r1, =nova_linha
    mov     r2, #1                      @ comprimento da nova linha
    mov     r7, #4                      @ syscall write
    swi     #0
    
    pop     {r4-r8, pc}

@ converte inteiro para string ascii
@ parâmetros:
@   r0 = valor a converter
@   r1 = buffer para armazenar resultado
@ retorna:
@   r0 = comprimento da string resultante
int_para_ascii:
    push    {r4-r8, lr}
    
    mov     r4, r0                      @ r4 = valor a converter
    mov     r5, r1                      @ r5 = endereço do buffer
    mov     r6, #0                      @ r6 = posição no buffer
    
    @ verifica caso especial: valor = 0
    cmp     r4, #0
    bne     converte_valor
    
    @ valor = 0
    mov     r7, #'0'
    strb    r7, [r5]                    @ buffer[0] = '0'
    mov     r0, #1                      @ retorna comprimento = 1
    b       fim_int_para_ascii
    
converte_valor:  
    @ tratamento para valores negativos
    cmp     r4, #0
    bge     loop_converte
    
    neg     r4, r4                      @ r4 = -r4
    mov     r7, #'-'
    strb    r7, [r5, r6]                @ buffer[pos] = '-'
    add     r6, r6, #1                  @ pos++
    
loop_converte:  
    @ extrai dígito e converte para ascii
    mov     r7, #10
    udiv    r8, r4, r7                  @ r8 = valor / 10
    mul     r7, r8, r7                  @ r7 = (valor / 10) * 10
    sub     r7, r4, r7                  @ r7 = valor % 10
    
    add     r7, r7, #'0'                @ converte para ASCII
    strb    r7, [r5, r6]                @ buffer[pos] = dígito
    add     r6, r6, #1                  @ pos++
    
    mov     r4, r8                      @ valor = valor / 10
    cmp     r4, #0
    bne     loop_converte               @ se valor != 0, continua
    
    @ r6 agora contém o comprimento da string
    mov     r0, r6

fim_int_para_ascii:
    pop     {r4-r8, pc}