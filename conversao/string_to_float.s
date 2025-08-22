.include "./macros/macros.s"
.include "./constantes/constantes.s"


.text
.globl string_to_float

string_to_float:
    pushq %rbp
    movq %rsp, %rbp
    
    # ja que xmm1 e xmm2 são caller saved
    subq $8, %rsp
    movsd %xmm1, (%rsp) 
    subq $8, %rsp
    movsd %xmm2, (%rsp) 

    pushq %r15

    movq $0, %r15
    cvtsi2sd %r15, %xmm0
    
    popq %r15


    movb (%rdi), %bl

    cmpb $'+', %bl
    je positivo_string_to_float

    cmpb $'-', %bl
    je negativo_string_to_float
  
    jmp sem_sinal_string_to_float

    positivo_string_to_float:
        inc %rdi
        call extract_float_from_string 
        jmp epilogo_string_to_float

    negativo_string_to_float:
        inc %rdi
        call extract_float_from_string 

        movq $-1, %rax
        cvtsi2sd %rax, %xmm1

        mulsd %xmm1, %xmm0
        jmp epilogo_string_to_float
    
    sem_sinal_string_to_float:
        call extract_float_from_string 
    
    epilogo_string_to_float:
        addq $8, %rsp
        addq $8, %rsp
        popq %rbp
    
    ret




extract_float_from_string:
    pushq %rbp
    movq %rsp, %rbp

    while_antes_ponto_extract_float_from_string:
        movq $0, %rcx

        movb (%rdi), %cl # obtendo o caractere atual

        cmpb $'.', %cl 
        je fim_parte_antes_ponto_extract_float_from_string

        # validando se o caractere é um número
        cmpb $'0', %cl
        jl end_extracao_extract_float_from_string
        cmpb $'9', %cl
        jg end_extracao_extract_float_from_string


        sub $'0', %cl # obtendo o valor numerico em si em vez do ASCII
        cvtsi2sd %rcx, %xmm1
        
        # xmm0 = xmm0 * 10 + novo algarismo
        mulsd var_10_auxiliar, %xmm0
        addsd %xmm1, %xmm0

        incq %rdi
        jmp while_antes_ponto_extract_float_from_string
    fim_parte_antes_ponto_extract_float_from_string:

    incq %rdi

    movsd var_10_auxiliar, %xmm2
    
    while_depois_ponto_extract_float_from_string:
        movq $0, %rcx
        
        movb (%rdi), %cl # obtendo o caractere atual

        # validando se o caractere é um número
        cmpb $'0', %cl
        jl end_extracao_extract_float_from_string
        cmpb $'9', %cl
        jg end_extracao_extract_float_from_string

        sub $'0', %cl # obtendo o valor numerico em si em vez do ASCII
        cvtsi2sd %rcx, %xmm1

        # xmm0 = xmm0 +(novo algarismo/(10 ou 100 ou 1000...))
        divsd %xmm2, %xmm1
        addsd %xmm1, %xmm0

        mulsd var_10_auxiliar, %xmm2
        incq %rdi
        jmp while_depois_ponto_extract_float_from_string

    end_extracao_extract_float_from_string:
        popq %rbp
    ret
