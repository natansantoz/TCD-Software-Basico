.include "./macros/macros.s"
.include "./constantes/constantes.s"


.text
.globl fprintf

fprintf:
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
    addq $88, %r15  # r15 apontará pros argumentos excedentes que vem pela pilha. 16 + 72 =88 8 devido ao rbp no prologo, 8 devido ao endereço de retorno na pilha e 72 dos reg caller saved 

    movq $0, %r10 # "flag" que valerá 1 quando o primeiro argumento da pilha for utilizado. A partir desse momento, todos os argumentos são obtidos da pilha


    while_fprintf:
        cmpb $0, (%rdi)
        je fim_while_fprintf

        movb (%rdi), %r13b
        
        cmpb $'%', %r13b
        jne char_atual_nao_eh_porcentagem_fprintf
        
        incq %rdi
        movb (%rdi), %r13b
        cmpb $'f', %r13b
        je usar_registradores_de_ponto_flutuante_fprintf

        resetar_rdi_fprintf:
            decq %rdi
        
        char_atual_nao_eh_porcentagem_fprintf:

        usar_rsi_fprintf:
            cmpq $2, %r12
            jne usar_rdx_fprintf
            movq %rsi, %rbx
            jmp argumento_da_vez_setado_fprintf
            
        usar_rdx_fprintf:
            cmpq $3, %r12
            jne usar_rcx_fprintf
            movq %rdx, %rbx
            jmp argumento_da_vez_setado_fprintf
          
        usar_rcx_fprintf:
            cmpq $4, %r12
            jne usar_r8_fprintf
            movq %rcx, %rbx
            jmp argumento_da_vez_setado_fprintf

        usar_r8_fprintf:
            cmpq $5, %r12
            jne usar_r9_fprintf
            movq %r8, %rbx
            jmp argumento_da_vez_setado_fprintf

        usar_r9_fprintf:
            cmpq $6, %r12
            jne pegar_da_pilha_fprintf

            movq %r9, %rbx
            jmp argumento_da_vez_setado_fprintf


        usar_registradores_de_ponto_flutuante_fprintf:
        decq %rdi
        
        usar_xmm0_fprintf:
            cmpq $0, %r11
            jne usar_xmm1_fprintf
            movsd %xmm0, %xmm8
            incq %r11
            jmp argumento_da_vez_setado_fprintf
            
        usar_xmm1_fprintf:
            cmpq $1, %r11
            jne usar_xmm2_fprintf
            movsd %xmm1, %xmm8
            incq %r11
            jmp argumento_da_vez_setado_fprintf
          
        usar_xmm2_fprintf:
            cmpq $2, %r11
            jne usar_xmm3_fprintf
            movsd %xmm2, %xmm8
            incq %r11
            jmp argumento_da_vez_setado_fprintf

        usar_xmm3_fprintf:
            cmpq $3, %r11
            jne usar_xmm4_fprintf
            movsd %xmm3, %xmm8
            incq %r11
            jmp argumento_da_vez_setado_fprintf

        usar_xmm4_fprintf:
            cmpq $4, %r11
            jne usar_xmm5_fprintf
            movsd %xmm4, %xmm8
            incq %r11
            jmp argumento_da_vez_setado_fprintf

        usar_xmm5_fprintf:
            cmpq $5, %r11
            jne usar_xmm6_fprintf
            movsd %xmm5, %xmm8
            incq %r11
            jmp argumento_da_vez_setado_fprintf

        usar_xmm6_fprintf:
            cmpq $6, %r11
            jne usar_xmm7_fprintf
            movsd %xmm6, %xmm8
            incq %r11
            jmp argumento_da_vez_setado_fprintf

        usar_xmm7_fprintf:
            cmpq $7, %r11
            jne pegar_da_pilha_fprintf
            movsd %xmm7, %xmm8
            incq %r11
            jmp argumento_da_vez_setado_fprintf

        pegar_da_pilha_fprintf:
            movq (%r15), %rbx
            movsd (%r15), %xmm8
            movq $1, %r10       # a partir de agora, todos os argumentos serão obtidos da pilha

        argumento_da_vez_setado_fprintf:

        movb (%rdi), %r13b

        cmpb $'%', %r13b
        je switch_fprintf

        call limpar_buffer_caractere
        movb %r13b, buffer_caractere


        push_caller_regs
        
        movq %rax, %rdi
        call printar_caractere_fprintf

        pop_caller_regs 

        jmp fim_switch_fprintf

        switch_fprintf:
            incq %rdi
            
            cmpq $1, %r10
            jne nao_incrementar_ponteiro_argumentos_pilha_fprintf
            addq $8, %r15

            nao_incrementar_ponteiro_argumentos_pilha_fprintf:

            movb (%rdi), %r14b

            case_char_fprintf:
                cmpb $'c', %r14b
                jne case_float_fprintf
                incq %r12

                call limpar_buffer_caractere
                movb %bl, buffer_caractere

                push_caller_regs
                
                movq %rax, %rdi
                call printar_caractere_fprintf

                pop_caller_regs 
            
                jmp fim_switch_fprintf
            case_float_fprintf:
                cmpb $'f', %r14b
                jne case_int_fprintf

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
                while_impressao_flutuante_fprintf:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_flutuante_fprintf

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs
                    movq %rax, %rdi
                    call printar_caractere_fprintf

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_flutuante_fprintf
                fim_while_impressao_flutuante_fprintf:
                popq %r10

                popq %rsi
                jmp fim_switch_fprintf

            case_int_fprintf:
                cmpb $'d', %r14b
                jne teste_i_fprintf
                je eh_int_fprintf
                
                teste_i_fprintf:
                    cmpb $'i', %r14b
                    je eh_int_fprintf
                    jne case_short_fprintf

                eh_int_fprintf:
                
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
                
                while_impressao_inteiro_fprintf:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_inteiro_fprintf

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs
                    
                    movq %rax, %rdi
                    call printar_caractere_fprintf

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_inteiro_fprintf
                fim_while_impressao_inteiro_fprintf:

                popq %rsi
                jmp fim_switch_fprintf

            case_short_fprintf:
                cmpb $'h', %r14b
                jne case_long_int_fprintf
                incq %r12

                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'d', %r14b
                jne case_long_int_fprintf

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
                
                while_impressao_short_fprintf:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_short_fprintf

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs
                    
                    movq %rax, %rdi
                    call printar_caractere_fprintf

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_short_fprintf
                fim_while_impressao_short_fprintf:

                popq %rsi
                jmp fim_switch_fprintf

            case_long_int_fprintf:
                cmpb $'l', %r14b
                jne case_string_fprintf
                incq %r12

                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'d', %r14b
                jne case_string_fprintf

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
                
                while_impressao_long_fprintf:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_long_fprintf

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs
                    
                    movq %rax, %rdi
                    call printar_caractere_fprintf

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_long_fprintf
                fim_while_impressao_long_fprintf:

                popq %rsi
                jmp fim_switch_fprintf

            case_string_fprintf:        
                cmpb $'s', %r14b
                jne case_nao_suportado_fprintf
                incq %r12

                while_impressao_string_fprintf:
                    cmpb $0, (%rbx)
                    je fim_while_impressao_string_fprintf

                    call limpar_buffer_caractere
                    movb (%rbx), %dl
                    movb %dl, buffer_caractere
                    
                    push_caller_regs
                    
                    movq %rax, %rdi
                    call printar_caractere_fprintf

                    pop_caller_regs 
                    
                    incq %rbx
                    jmp while_impressao_string_fprintf
                fim_while_impressao_string_fprintf:

                jmp fim_switch_fprintf

            case_nao_suportado_fprintf:
                pushq %rsi
                leaq mensagem_especificador_nao_suportado, %rsi

                call limpar_buffer_caractere
                movb $10, %bl # \n
                movb %bl, buffer_caractere
                
                push_caller_regs
                
                movq %rax, %rdi
                call printar_caractere_fprintf

                pop_caller_regs 
            
                while_impressao_nao_suportado_fprintf:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_nao_suportado_fprintf

                    call limpar_buffer_caractere

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs
                    
                    movq %rax, %rdi
                    call printar_caractere_fprintf

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_nao_suportado_fprintf
                fim_while_impressao_nao_suportado_fprintf:

                call limpar_buffer_caractere
                movb $10, %bl # \n
                movb %bl, buffer_caractere
                
                push_caller_regs
                
                movq %rax, %rdi
                call printar_caractere_fprintf

                pop_caller_regs 

                popq %rsi
        fim_switch_fprintf:
        incq %rdi
        jmp while_fprintf
    fim_while_fprintf:

    popq %rbp
    ret


printar_caractere_fprintf:
    pushq %rbp
    movq %rsp, %rbp

    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    movq $SYS_write, %rax
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
