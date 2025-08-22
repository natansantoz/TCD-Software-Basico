.include "./macros/macros.s"
.include "./constantes/constantes.s"


.text
.globl printar_caractere

printar_caractere:

    pushq %rbp
    movq %rsp, %rbp

    pushq %rbx 
    pushq %r12 
    pushq %r13 
    pushq %r14 
    pushq %r15 


    movq $SYS_write, %rax
    movq $STDOUT, %rdi
    movq $buffer_caractere, %rsi
    movq $SIZE_BUFFER_CARACTERE, %rdx
    syscall

    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    popq %rbp
    ret
    