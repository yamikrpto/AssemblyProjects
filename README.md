# AssemblyProjects
Projetos Densevolvidos em assmebly para fins de diversão e apredizagem

Algoritmos em Assembly: Exemplos Práticos

Este repositório contém implementações de algoritmos clássicos em Assembly (x86/x64, NASM/GAS), focados em:

    Didática: Códigos comentados para facilitar o aprendizado.

    Eficiência: Uso de registradores e instruções de baixo nível.

    Aplicações: Desde operações básicas até técnicas usadas em sistemas embarcados e kernels.

Lista de Algoritmos (ARM e MIPS):

1. Busca e Ordenação

Merge Sort:Descrição:
Algoritmo de ordenação divide-and-conquer que:
    Divide o array em duas metades recursivamente.
    Combina as metades ordenadas em um único array.

Características em Assembly:
    Recursividade: Uso da pilha (stack) para gerenciar chamadas aninhadas.
    Eficiência: Complexidade O(n log n) mesmo no pior caso.
    Operações Críticas:
        Divisão do array (cálculo de índices via registradores).
        Merge com comparação e movimentação de dados entre memória/registradores.
        
Por que incluir?
    Demonstra manipulação avançada de memória (ponteiros, alocação estática/dinâmica).
    Desafio clássico para entender recursão em baixo nível.

2. Matemática Computacional

    Fibonacci Recursico: Geração da sequência com loops.

    Fatorial: Versões iterativa e recursiva.

    Delta: Verificação do delta de uma equação quadrática.

3. Manipulação de Strings

    String Length: Cálculo do tamanho com scasb.

    atoi/itoa: Conversão entre strings e números.

4. Controle de Fluxo

    Condicionais: Uso de jmp, je, jg para decisões.

    Loops: Implementação com loop e ecx.


5. Interrupções e Syscalls

    Hello World: Chamadas ao sistema para I/O.

    Leitura de Teclado: Uso de interrupções.
