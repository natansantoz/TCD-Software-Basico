.include "./macros/macros.s"
.include "./constantes/constantes.s"


.text
.globl printf



printf:
    /*
    *   Parametros
    *       rdi: String contendo ou não os especificadores
    *       Os demais argumentos estão, respectivamente, nos registradores rsi, rdx,... e os excedentes na pilha.
    *   Sem retorno.
    */

    pushq %rbp
    movq %rsp, %rbp
    
    movq $2, %r12 # contador pra saber qual o argumento da vez 
    movq $0, %r11 # contador pra saber qual o argumento float da vez

    movq %rbp, %r15
    addq $88, %r15  # r15 apontará pros argumentos excedentes que vem pela pilha.

    movq $0, %r10 # "flag" que valerá 1 quando o primeiro argumento da pilha for utilizado. A partir desse momento, todos os argumentos serão obtidos da pilha


    while_printf:
        cmpb $0, (%rdi)
        je fim_while_printf

        movb (%rdi), %r13b
        
        cmpb $'%', %r13b
        jne char_atual_nao_eh_porcentagem
        
        incq %rdi
        movb (%rdi), %r13b
        cmpb $'f', %r13b
        je usar_registradores_de_ponto_flutuante

        resetar_rdi:
            decq %rdi
        
        char_atual_nao_eh_porcentagem:

        usar_rsi:
            cmpq $2, %r12
            jne usar_rdx
            movq %rsi, %rbx
            jmp argumento_da_vez_setado
            
        usar_rdx:
            cmpq $3, %r12
            jne usar_rcx
            movq %rdx, %rbx
            jmp argumento_da_vez_setado
          
        usar_rcx:
            cmpq $4, %r12
            jne usar_r8
            movq %rcx, %rbx
            jmp argumento_da_vez_setado

        usar_r8:
            cmpq $5, %r12
            jne usar_r9
            movq %r8, %rbx
            jmp argumento_da_vez_setado

        usar_r9:
            cmpq $6, %r12
            jne pegar_da_pilha

            movq %r9, %rbx
            jmp argumento_da_vez_setado


        usar_registradores_de_ponto_flutuante:
        decq %rdi

        usar_xmm0:
            cmpq $0, %r11
            jne usar_xmm1
            movsd %xmm0, %xmm8
            incq %r11
            jmp argumento_da_vez_setado
            
        usar_xmm1:
            cmpq $1, %r11
            jne usar_xmm2
            movsd %xmm1, %xmm8
            incq %r11
            jmp argumento_da_vez_setado
          
        usar_xmm2:
            cmpq $2, %r11
            jne usar_xmm3
            movsd %xmm2, %xmm8
            incq %r11
            jmp argumento_da_vez_setado

        usar_xmm3:
            cmpq $3, %r11
            jne usar_xmm4
            movsd %xmm3, %xmm8
            incq %r11
            jmp argumento_da_vez_setado

        usar_xmm4:
            cmpq $4, %r11
            jne usar_xmm5
            movsd %xmm4, %xmm8
            incq %r11
            jmp argumento_da_vez_setado

        usar_xmm5:
            cmpq $5, %r11
            jne usar_xmm6
            movsd %xmm5, %xmm8
            incq %r11
            jmp argumento_da_vez_setado

        usar_xmm6:
            cmpq $6, %r11
            jne usar_xmm7
            movsd %xmm6, %xmm8
            incq %r11
            jmp argumento_da_vez_setado

        usar_xmm7:
            cmpq $7, %r11
            jne pegar_da_pilha
            movsd %xmm7, %xmm8
            incq %r11
            jmp argumento_da_vez_setado

        pegar_da_pilha:
            movq (%r15), %rbx
            movsd (%r15), %xmm8
            movq $1, %r10       # a partir de agora, todos os argumentos serão obtidos da pilha

        argumento_da_vez_setado:

        movb (%rdi), %r13b

        cmpb $'%', %r13b
        je switch_printf

        call limpar_buffer_caractere
        movb %r13b, buffer_caractere


        push_caller_regs

        call printar_caractere

        pop_caller_regs 

        jmp fim_switch_printf

        switch_printf:
            incq %rdi
            
            cmpq $1, %r10
            jne nao_incrementar_ponteiro_argumentos_pilha
            addq $8, %r15

            nao_incrementar_ponteiro_argumentos_pilha:

            movb (%rdi), %r14b

            case_char:
                cmpb $'c', %r14b
                jne case_float
                incq %r12

                call limpar_buffer_caractere
                movb %bl, buffer_caractere

                push_caller_regs

                call printar_caractere

                pop_caller_regs 
            
                jmp fim_switch_printf
            case_float:
                cmpb $'f', %r14b
                jne case_int

                pushq %rsi
            
                movsd %xmm8, %xmm0


                leaq buffer_numero_double_string, %rsi
                
                push_caller_regs

                subq $128, %rsp
                
                push_regs_ponto_flutuante
                
                call limpar_buffer_numero_double_string

                call float_to_string

                pop_regs_ponto_flutuante

                addq $128, %rsp       

                pop_caller_regs 

                leaq buffer_numero_double_string, %rsi
                
                pushq %r10
                while_impressao_flutuante:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_flutuante

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs

                    call printar_caractere

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_flutuante
                fim_while_impressao_flutuante:
                popq %r10

                popq %rsi
                jmp fim_switch_printf

            case_int:
                cmpb $'d', %r14b
                jne teste_i
                je eh_int
                
                teste_i:
                    cmpb $'i', %r14b
                    je eh_int
                    jne case_short

                eh_int:
                
                incq %r12

                pushq %rsi

                push_caller_regs

                leaq buffer_temp_numero_int_string, %rsi
                movq $0, %rdi

                movq %rbx, %rdi

                call limpar_buffer_temp_numero_int_string
                call limpar_buffer_numero_int_string

                call int_to_string

                pop_caller_regs 

                leaq buffer_numero_int_string, %rsi
                
                while_impressao_inteiro:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_inteiro

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs

                    call printar_caractere

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_inteiro
                fim_while_impressao_inteiro:

                popq %rsi
                jmp fim_switch_printf

            case_short:
                cmpb $'h', %r14b
                jne case_long_int
                incq %r12

                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'d', %r14b
                jne case_long_int

                incq %rdi

                pushq %rsi

                push_caller_regs

                leaq buffer_temp_numero_int_string, %rsi
                movq $0, %rdi
                movq  %rbx, %rdi
            
                call limpar_buffer_temp_numero_int_string
                call limpar_buffer_numero_int_string

                call int_to_string

                pop_caller_regs 

                leaq buffer_numero_int_string, %rsi
                
                while_impressao_short:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_short

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs

                    call printar_caractere

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_short
                fim_while_impressao_short:

                popq %rsi
                jmp fim_switch_printf

            case_long_int:
                cmpb $'l', %r14b
                jne case_string
                incq %r12

                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'d', %r14b
                jne case_string

                incq %rdi

                pushq %rsi

                push_caller_regs

                call limpar_buffer_temp_numero_int_string
                call limpar_buffer_numero_int_string

                leaq buffer_temp_numero_int_string, %rsi
                movq %rbx, %rdi

                call int_to_string

                pop_caller_regs 

                leaq buffer_numero_int_string, %rsi
                
                while_impressao_long:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_long

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs

                    call printar_caractere

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_long
                fim_while_impressao_long:

                popq %rsi
                jmp fim_switch_printf

            case_string:        
                cmpb $'s', %r14b
                jne case_nao_suportado
                incq %r12

                while_impressao_string:
                    cmpb $0, (%rbx)
                    je fim_while_impressao_string

                    call limpar_buffer_caractere
                    movb (%rbx), %dl
                    movb %dl, buffer_caractere
                    
                    push_caller_regs

                    call printar_caractere

                    pop_caller_regs 
                    
                    incq %rbx
                    jmp while_impressao_string
                fim_while_impressao_string:

                jmp fim_switch_printf

            case_nao_suportado:
                pushq %rsi
                leaq mensagem_especificador_nao_suportado, %rsi

                call limpar_buffer_caractere
                movb $10, %bl # \n
                movb %bl, buffer_caractere
                
                push_caller_regs

                call printar_caractere

                pop_caller_regs 
            
                while_impressao_nao_suportado:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_nao_suportado

                    call limpar_buffer_caractere

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs

                    call printar_caractere

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_nao_suportado
                fim_while_impressao_nao_suportado:

                call limpar_buffer_caractere
                movb $10, %bl # \n
                movb %bl, buffer_caractere
                
                push_caller_regs

                call printar_caractere

                pop_caller_regs 

                popq %rsi
        fim_switch_printf:
        incq %rdi
        jmp while_printf
    fim_while_printf:

    popq %rbp
    ret



