.include "./macros/macros.s"
.include "./constantes/constantes.s"

.text
.globl fopen

fopen:
    /*
    *   Parametros
    *       rdi: nome do arquivo
    *       rsi: modo de abertura
    *
    *   Retorna o descritor do arquivo em %rax.
    */

    pushq %rbp
    movq %rsp, %rbp
    
    movq $1, %r15
    movb (%rdi, %r15, 1), %r14b

    cmpb $'\0', %r14b
    je case_composto 

    switch:
        case_r:
            movb (%rsi), %r12b   
            cmpb $'r', %r12b
            jne case_w
            movq $READ, %rsi
            jmp fim_switch_fopen

        case_w:
            movb (%rsi), %r12b   
            cmpb $'w', %r12b
            jne case_a
            movq $WRITE, %rsi
            jmp fim_switch_fopen

        case_a:
            movb (%rsi), %r12b   
            cmpb $'a', %r12b
            jne default
            movq $APPEND, %rsi
            jmp fim_switch_fopen

        case_composto:
            r_plus:
                movb (%rsi), %r12b   
                cmpb $'r', %r12b
                jne w_plus
                movq $R_READ_AND_WRITE, %rsi
                jmp fim_switch_fopen

            w_plus:
                movb (%rsi), %r12b   
                cmpb $'w', %r12b
                jne a_plus
                movq $W_READ_AND_WRITE, %rsi
                jmp fim_switch_fopen

            a_plus:
                movb (%rsi), %r12b   
                cmpb $'a', %r12b
                jne default
                movq $A_READ_AND_WRITE, %rsi
                jmp fim_switch_fopen

        default:
            movq $-1, %rax
            jmp epilogo_fopen
    fim_switch_fopen:

    movq $SYS_open, %rax
    movq $438, %rdx
    syscall
    
    epilogo_fopen:
        popq %rbp
        ret
        