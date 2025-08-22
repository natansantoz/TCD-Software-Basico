.include "./macros/macros.s"
.include "./constantes/constantes.s"

.text
.globl fclose

fclose:
    /*
    *   Parametros
    *       rdi: descritor do arquivo
    *
    *   Sem retorno.
    */

    pushq %rbp
    movq %rsp, %rbp
    movq $SYS_close, %rax
    syscall
    popq %rbp
    ret
