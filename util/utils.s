.text
.globl limpar_buffer_temp_numero_int_string
.globl limpar_buffer_numero_int_string
.globl limpar_buffer_numero_double_string
.globl limpar_buffer_caractere
.globl limpar_buffer_entrada_usuario
.globl printar_quebra_linha


limpar_buffer_temp_numero_int_string:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r15

    leaq buffer_temp_numero_int_string, %r15
    movq $0, (%r15)
    movq $0, 8(%r15)
    movq $0, 16(%r15)
    movq $0, 24(%r15)
    movq $0, 32(%r15)

    popq %r15

    popq %rbp
    ret


limpar_buffer_numero_int_string:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r15

    leaq buffer_numero_int_string, %r15
    movq $0, (%r15)
    movq $0, 8(%r15)
    movq $0, 16(%r15)
    movq $0, 24(%r15)
    movq $0, 32(%r15)

    popq %r15
    popq %rbp
    ret


limpar_buffer_numero_double_string:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r15

    leaq buffer_temp_numero_int_string, %r15
    movq $0, (%r15)
    movq $0, 8(%r15)
    movq $0, 16(%r15)

    popq %r15
    popq %rbp
    ret


limpar_buffer_caractere:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r15

    leaq buffer_caractere, %r15
    movq $0, (%r15)
    
    popq %r15
    popq %rbp
    ret


limpar_buffer_entrada_usuario:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r15

    leaq buffer_entrada_usuario, %r15
    movq $0, 0(%r15)
    movq $0, 8(%r15)
    movq $0, 16(%r15)
    movq $0, 24(%r15)
    movq $0, 32(%r15)
    movq $0, 40(%r15)
    movq $0, 48(%r15)
    movq $0, 56(%r15)
    movq $0, 64(%r15)
    movq $0, 72(%r15)
    movq $0, 80(%r15)
    movq $0, 88(%r15)
    movq $0, 96(%r15)
    movq $0, 104(%r15)
    movq $0, 112(%r15)
    movq $0, 120(%r15)
    movq $0, 128(%r15)
    movq $0, 136(%r15)
    movq $0, 144(%r15)
    movq $0, 152(%r15)
    movq $0, 160(%r15)
    movq $0, 168(%r15)
    movq $0, 176(%r15)
    movq $0, 184(%r15)
    movq $0, 192(%r15)
    movq $0, 200(%r15)
    movq $0, 208(%r15)
    movq $0, 216(%r15)
    movq $0, 224(%r15)
    movq $0, 232(%r15)
    movq $0, 240(%r15)
    movq $0, 248(%r15)
    
    popq %r15
    popq %rbp
    ret


printar_quebra_linha:
    pushq %rbp
    movq %rsp, %rbp

    leaq quebra_linha_especificador, %rdi
    movq quebra_linha, %rsi
    pushq %r10
    pushq %r11
    call printf
    popq %r11
    popq %r10    

    popq %rbp
    ret
    