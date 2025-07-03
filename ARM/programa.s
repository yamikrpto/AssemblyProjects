.global _start

.section .text
_start:
    mov r0, #42     // (42 é o código de saída de sucesso)
    mov r7, #1      // syscall
    swi 0           // end
