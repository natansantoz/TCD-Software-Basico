.include "./macros/macros.s"
.include "./constantes/constantes.s"


.text
.globl fscanf


fscanf:
    pushq %rbp
    movq %rsp, %rbp

    movq $2, %r12 # contador pra saber qual o argumento da vez 

    movq %rbp, %r15
    addq $32, %r15  # r15 apontará pros argumentos excedentes que vem pela pilha. 

    movq $0, %r10 # "flag" que valerá 1 quando o primeiro argumento da pilha for utilizado. A partir desse momento, todos os argumentos serão obtidos da pilha

    
    while_fscanf:
        cmpb $0, (%rdi)
        je fim_while_fscanf

        movb (%rdi), %r13b
        
        usar_rsi_fscanf:
            cmpq $2, %r12
            jne usar_rdx_fscanf
            movq %rsi, %rbx
            jmp argumento_da_vez_setado_fscanf
            
        usar_rdx_fscanf:
            cmpq $3, %r12
            jne usar_rcx_fscanf
            movq %rdx, %rbx
            jmp argumento_da_vez_setado_fscanf
          
        usar_rcx_fscanf:
            cmpq $4, %r12
            jne usar_r8_fscanf
            movq %rcx, %rbx
            jmp argumento_da_vez_setado_fscanf

        usar_r8_fscanf:
            cmpq $5, %r12
            jne usar_r9_fscanf
            movq %r8, %rbx
            jmp argumento_da_vez_setado_fscanf

        usar_r9_fscanf:
            cmpq $6, %r12
            jne pegar_da_pilha_fscanf
            movq %r9, %rbx
            jmp argumento_da_vez_setado_fscanf


        pegar_da_pilha_fscanf:
            movq (%r15), %rbx
            movq $1, %r10       # a partir de agora, todos os argumentos serão obtidos da pilha

        argumento_da_vez_setado_fscanf:

        movb (%rdi), %r13b

        cmpb $'%', %r13b
        je switch_fscanf

        call limpar_buffer_caractere
        movb %r13b, buffer_caractere

        
        push_caller_regs

        call printar_caractere

        pop_caller_regs 

        jmp fim_switch_fscanf

        switch_fscanf:
            incq %rdi

            cmpq $1, %r10
            jne nao_incrementar_ponteiro_argumentos_pilha_fscanf
            addq $8, %r15

            nao_incrementar_ponteiro_argumentos_pilha_fscanf:

            movb (%rdi), %r14b

            case_char_fscanf:
                cmpb $'c', %r14b
                jne case_float_fscanf
                incq %r12
                
                pushq %rsi
                
                push_caller_regs


                movq %rax, %rdi

                pushq %rax
                call limpar_buffer_entrada_usuario

                call ler_entrada_fscanf
                popq %rax
                
                # substituindo o espaço por \0
                movq %r11, %rdi            
                leaq buffer_entrada_usuario, %rsi          
                addq %rdi, %rsi          
                decq %rsi           
                movb $0, (%rsi)       
                

                # movendo o caractere pro endereço da variavel  
                leaq buffer_entrada_usuario, %r11          
                movb (%r11), %r10b
                movb %r10b, (%rbx)  
                
                pop_caller_regs 
                
                popq %rsi

                jmp fim_switch_fscanf
            case_float_fscanf:
                cmpb $'l', %r14b
                jne case_int_fscanf
                
                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'f', %r14b
                je eh_float_fscanf

                nao_float_fscanf:
                    movb (%rdi), %r14b
                    jmp case_int_fscanf

                eh_float_fscanf:

                incq %r12

                incq %rdi
                
                pushq %rsi

                push_caller_regs
                                
                movq %rax, %rdi
                
                pushq %rax
                call limpar_buffer_entrada_usuario

                call ler_entrada_fscanf
                popq %rax
                
                # substituindo o espaço por \0
                movq %r11, %rdi            
                leaq buffer_entrada_usuario, %rsi          
                addq %rdi, %rsi          
                decq %rsi           
                movb $0, (%rsi)     
                
                pop_caller_regs 


                push_caller_regs

                subq $128, %rsp

                push_regs_ponto_flutuante
                
                leaq buffer_entrada_usuario, %rdi

                pushq %rbx 
                call string_to_float
                popq %rbx 
                movsd %xmm0, (%rbx)

                pop_regs_ponto_flutuante

                addq $128, %rsp       

                pop_caller_regs 

                popq %rsi
                jmp fim_switch_fscanf
            
            case_int_fscanf:
                cmpb $'d', %r14b
                jne teste_i_fscanf
                je eh_int_fscanf
                
                teste_i_fscanf:
                    cmpb $'i', %r14b
                    jne case_short_fscanf

                eh_int_fscanf:

                incq %r12

                pushq %rsi
                
                push_caller_regs

                movq %rax, %rdi
                
                pushq %rax
                call limpar_buffer_entrada_usuario

                call ler_entrada_fscanf
                popq %rax
                
                # substituindo o espaço por \0
                movq %r11, %rdi            
                leaq buffer_entrada_usuario, %rsi          
                addq %rdi, %rsi          
                decq %rsi           
                movb $0, (%rsi)           
                
                pop_caller_regs 

                push_caller_regs
                leaq buffer_entrada_usuario, %rdi

                call string_to_int

                movl %eax, (%rbx)
            
                pop_caller_regs 

                popq %rsi
                jmp fim_switch_fscanf

            case_short_fscanf:
                cmpb $'h', %r14b
                jne case_long_int_fscanf
                incq %r12

                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'d', %r14b
                jne case_long_int_fscanf

                incq %rdi

                pushq %rsi
                
                push_caller_regs

                movq %rax, %rdi
                
                pushq %rax
                call limpar_buffer_entrada_usuario

                call ler_entrada_fscanf
                popq %rax

                # substituindo o espaço por \0
                movq %rax, %rdi            
                leaq buffer_entrada_usuario, %rsi          
                addq %rdi, %rsi          
                decq %rsi           
                movb $0, (%rsi)           
                
                pop_caller_regs 

                push_caller_regs
                leaq buffer_entrada_usuario, %rdi

                call string_to_int

                movw %ax, (%rbx)

                pop_caller_regs 

                popq %rsi
                jmp fim_switch_fscanf

            case_long_int_fscanf:
                cmpb $'l', %r14b
                jne case_string_fscanf
                incq %r12

                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'d', %r14b
                jne case_string_fscanf

                incq %rdi

                pushq %rsi
                
                push_caller_regs

                movq %rax, %rdi
                
                pushq %rax
                call limpar_buffer_entrada_usuario

                call ler_entrada_fscanf
                popq %rax

                # substituindo o espaço por \0
                movq %rax, %rdi            
                leaq buffer_entrada_usuario, %rsi          
                addq %rdi, %rsi          
                decq %rsi           
                movb $0, (%rsi)           
                
                pop_caller_regs 


                push_caller_regs
                leaq buffer_entrada_usuario, %rdi

                call string_to_int

                movq %rax, (%rbx)

                pop_caller_regs 


                popq %rsi
                jmp fim_switch_fscanf

            case_string_fscanf:        
                cmpb $'s', %r14b
                jne case_nao_suportado_fscanf
                incq %r12

                pushq %rsi
                
                push_caller_regs

                movq %rax, %rdi
                
                pushq %rax
                call limpar_buffer_entrada_usuario

                call ler_entrada_fscanf
                popq %rax

                # substituindo o \n por \0
                movq %rax, %rdi            
                decq %rdi            
                leaq buffer_entrada_usuario, %r11
                addq %rdi, %r11          
                movb $0, (%r11)       


                pop_caller_regs 
                
                movq $0, %r11

                leaq buffer_entrada_usuario, %r11    
                movq $0, %r12
                
                while_transferindo_entre_buffers_fscanf:
                    
                    cmpq $0, (%r11)
                    je fim_while_transferindo_entre_buffers_fscanf
                    
                    movb (%r11), %r12b
                    movb %r12b, (%rbx)

                    incq %r11
                    incq %rbx

                    jmp while_transferindo_entre_buffers_fscanf

                fim_while_transferindo_entre_buffers_fscanf:

                movb $0, (%rbx)
                
                popq %rsi
                jmp fim_switch_fscanf

            case_nao_suportado_fscanf:
                pushq %rsi
                leaq mensagem_especificador_nao_suportado, %rsi

                call limpar_buffer_caractere
                movb $10, %bl # \n
                movb %bl, buffer_caractere
                
                push_caller_regs

                call printar_caractere

                pop_caller_regs 
            
                while_impressao_nao_suportado_fscanf:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_nao_suportado_fscanf

                    call limpar_buffer_caractere

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs

                    call printar_caractere

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_nao_suportado_fscanf
                fim_while_impressao_nao_suportado_fscanf:

                call limpar_buffer_caractere
                movb $10, %bl # \n
                movb %bl, buffer_caractere
                
                push_caller_regs

                call printar_caractere

                pop_caller_regs 

                popq %rsi
        fim_switch_fscanf:
        incq %rdi
        jmp while_fscanf
    fim_while_fscanf:


    popq %rbp
    ret


ler_entrada_fscanf:
    pushq %rbp
    movq %rsp, %rbp
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    movq $0, %r14
    movq $0, %r11

    leaq buffer_caractere, %r12
    leaq buffer_entrada_usuario, %r13

    movq %rax, %r15
    while_ler_entrada_fscanf:
        movq %r15, %rax

        cmpb $32, %r14b
        je fim_while_ler_entrada_fscanf

        pushq %r11
        movq $SYS_read, %rax
        movq $buffer_caractere, %rsi
        movq $SIZE_BUFFER_CARACTERE, %rdx
        syscall
        popq %r11


        incq %r11

        movq $0, %r14
        movb (%r12), %r14b
        movb %r14b, (%r13)

        incq %r13

        jmp while_ler_entrada_fscanf

    fim_while_ler_entrada_fscanf:
    
    
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp
    ret
    