.include "./macros/macros.s"
.include "./constantes/constantes.s"

.text
.globl int_to_string


int_to_string:
    /*
    *   Parametros
    *       rdi: numero a ser convertido
    *       rsi: endereço inicial do buffer 
    *
    *   Retorna rsi apontando pra posicao inicial da string montada no buffer
    */

    pushq %rbp
    movq %rsp, %rbp

    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    call limpar_buffer_temp_numero_int_string
    call limpar_buffer_numero_int_string
    leaq buffer_temp_numero_int_string, %rsi
    
    movq %rdi, %rax     # cópia do inteiro

    cmpq $0, %rax
    jge positivo

    negq %rax
    movq $1, %r14

    positivo:
    
    addq $38, %rsi      # apontando pro fim do buffer pra ja montar com os digitos na ordem 
    movb $0, (%rsi)
    decq %rsi

    movq $0, %r15

    incq %r15           # contador numero de caracteres no buffer
    
    movq $10, %r12

    while_conversao_int_to_string:
        movq $0, %rdx 
        movq $0, %r13 
        idiv %r12

        movb digitos(%rdx), %r13b
        movb %r13b, (%rsi)
        decq %rsi      

        incq %r15           # contador numero de caracteres no buffer

        cmpq $0, %rax
        jg while_conversao_int_to_string

    fim_while_conversao_int_to_string:
    
    cmpq $1, %r14
    jne nao_add_sinal 

    movb $'-', (%rsi)
    incq %r15           # contador numero de caracteres no buffer
    jmp sinal_adicionado
    
    nao_add_sinal:
        incq %rsi     

    sinal_adicionado:

    pushq %rsi

    leaq buffer_numero_int_string, %r13 
    
    while_transferindo_entre_buffers:
    
        cmpq $0, (%rsi)
        je fim_while_transferindo_entre_buffers
        
        movb (%rsi), %r12b
        movb %r12b, (%r13)

        incq %rsi
        incq %r13

        jmp while_transferindo_entre_buffers

    fim_while_transferindo_entre_buffers:

    movb $0, (%r13)

    popq %rsi

    movq %r15, %rax        # quantidade de caracteres escrita no buffer 

    epilogo:
        popq %r15
        popq %r14
        popq %r13
        popq %r12
        popq %rbx
        popq %rbp
        ret
        