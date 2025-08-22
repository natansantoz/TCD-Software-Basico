.include "./macros/macros.s"
.include "./constantes/constantes.s"

.text
.globl float_to_string

float_to_string:
    /*
    *   Parametros
    *       xmm0: numero a ser convertido
    *       rsi: endereço inicial do buffer 
    *
    *   O resultado estará no buffer_numero_double_string
    */

    pushq %rbp
    movq %rsp, %rbp

    pushq %rbx 
    pushq %r12 
    pushq %r13 
    pushq %r14 
    pushq %r15 

    
    if_eh_zero:
        ucomisd zero_flutuante_aux, %xmm0
        jne diferente_de_zero

        movb $'0', (%rsi)
        incq %rsi

        movb $'.', (%rsi)  
        incq %rsi

        movb $'0', (%rsi)
        incq %rsi

        movb $'\0', (%rsi)

        jmp epilogo_float_to_string

    diferente_de_zero:

    movq $0, %r10

    if_negativo:
    
        ucomisd zero_flutuante_aux, %xmm0
        jae flutuante_positivo                   
        
        movq $1, %r10
    
        movq $0, %r15
        cvtsi2sd %r15, %xmm1

        // # Negando
        subsd %xmm0, %xmm1              
        movsd %xmm1, %xmm0 

    flutuante_positivo:
        movsd %xmm0, %xmm2
        movq $0, %r15
        cvtsi2sd %r15, %xmm1
    while_extracao_parte_inteira:           # subtraimos 1 da parte inteira e incrementamos xmm1 ate o numero se tornar menor que zero
        
        movq $0, %r15
        cvtsi2sd %r15, %xmm5
        
        movq $0, %r15
        movq $1, %r15
        cvtsi2sd %r15, %xmm5
        
        ucomisd %xmm5, %xmm2            
        jb fim_extracao_parte_inteira               

        subsd %xmm5, %xmm2                     
        addsd %xmm5, %xmm1              
        jmp while_extracao_parte_inteira
        
    fim_extracao_parte_inteira:
    
    # usando int_to_string pra gerar o array de chars da parte inteira e transferindo 
    # ele de buffer_temp_numero_int_string pra buffer_numero_double_string
    call limpar_buffer_temp_numero_int_string
    
    cvttsd2si %xmm1, %rdi       # movendo a parte inteira do double pra rdi 

    cmpq $0, %rdi
    jne parte_inteira_diferente_zero

    movb $'-', (%rsi)   
    incq %rsi 
    movb $'0', (%rsi)
    incq %rsi
    jmp parte_inteira_igual_zero

    parte_inteira_diferente_zero:

    cmpq $1, %r10
    jne nao_inverter_sinal
    negq %rdi
    nao_inverter_sinal:

    pushq %rsi
    leaq buffer_temp_numero_int_string, %rsi  
    call int_to_string      
    popq %rsi

    leaq buffer_numero_int_string, %r14  
    leaq buffer_numero_double_string, %r12  

    while_copiando_parte_inteira:
        cmpq $0, (%r14)
        je fim_while_copiando_parte_inteira

        movb (%r14), %r13b
        movb %r13b, (%r12)

        incq %r14
        incq %r12

        jmp while_copiando_parte_inteira
    fim_while_copiando_parte_inteira:

    movq %r12, %rsi

    parte_inteira_igual_zero:

    movb $'.', (%rsi)
    incq %rsi

    subsd %xmm1, %xmm0  # xmm0 = parte decimal

    movq $0, %r8    # número casas decimais calculadas

    while_extracao_parte_decimal:

        cmpq $6, %r8
        jge fim_while_extracao_parte_decimal
        
        movq $0, %r15
        cvtsi2sd %r15, %xmm1

        movq $0, %r15

        movq $10, %r15
        cvtsi2sd %r15, %xmm1

        mulsd %xmm1, %xmm0 
        
        movq $0, %rbx

        movq $0, %r15
        cvtsi2sd %r15, %xmm5
        
        movq $0, %r15
        movq $1, %r15
        cvtsi2sd %r15, %xmm5

        while_extrair_digito_atual:
            ucomisd %xmm5, %xmm0
            jb fim_while_extrair_digito_atual

            subsd %xmm5, %xmm0
            incq %rbx
            jmp while_extrair_digito_atual

        fim_while_extrair_digito_atual:
        movq $0, %r13

        movb digitos(%rbx), %r13b
        movb %r13b, (%rsi)
        incq %rsi     
        incq %r8     

        jmp while_extracao_parte_decimal

    fim_while_extracao_parte_decimal:

    movb $0, (%rsi)

    epilogo_float_to_string:
        popq %r15
        popq %r14
        popq %r13
        popq %r12
        popq %rbx
        popq %rbp
        ret
