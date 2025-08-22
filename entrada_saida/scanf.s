.include "./macros/macros.s"
.include "./constantes/constantes.s"


.text
.globl scanf

scanf:
    pushq %rbp
    movq %rsp, %rbp
    
    movq $2, %r12 # contador pra saber qual o argumento da vez 

    movq %rbp, %r15
    addq $32, %r15  
    movq $0, %r10 # "flag" que valerá 1 quando o primeiro argumento da pilha for utilizado. A partir desse momento, todos os argumentos serão obtidos da pilha

    
    while_scanf:
        cmpb $0, (%rdi)
        je fim_while_scanf

        movb (%rdi), %r13b
        
        usar_rsi_scanf:
            cmpq $2, %r12
            jne usar_rdx_scanf
            movq %rsi, %rbx
            jmp argumento_da_vez_setado_scanf
            
        usar_rdx_scanf:
            cmpq $3, %r12
            jne usar_rcx_scanf
            movq %rdx, %rbx
            jmp argumento_da_vez_setado_scanf
          
        usar_rcx_scanf:
            cmpq $4, %r12
            jne usar_r8_scanf
            movq %rcx, %rbx
            jmp argumento_da_vez_setado_scanf

        usar_r8_scanf:
            cmpq $5, %r12
            jne usar_r9_scanf
            movq %r8, %rbx
            jmp argumento_da_vez_setado_scanf

        usar_r9_scanf:
            cmpq $6, %r12
            jne pegar_da_pilha_scanf
            movq %r9, %rbx
            jmp argumento_da_vez_setado_scanf


        pegar_da_pilha_scanf:
            movq (%r15), %rbx
            movq $1, %r10       # a partir de agora, todos os argumentos serão obtidos da pilha

        argumento_da_vez_setado_scanf:

        movb (%rdi), %r13b

        cmpb $'%', %r13b
        je switch_scanf

        call limpar_buffer_caractere
        movb %r13b, buffer_caractere

        
        push_caller_regs

        call printar_caractere

        pop_caller_regs 

        jmp fim_switch_scanf

        switch_scanf:
            incq %rdi

            cmpq $1, %r10
            jne nao_incrementar_ponteiro_argumentos_pilha_scanf
            addq $8, %r15

            nao_incrementar_ponteiro_argumentos_pilha_scanf:

            movb (%rdi), %r14b

            case_char_scanf:
                cmpb $'c', %r14b
                jne case_float_scanf
                incq %r12
                
                pushq %rsi
                
                push_caller_regs

                call ler_entrada

                # substituindo o \n por \0
                movq %rax, %rdi            
                leaq buffer_entrada_usuario, %r11
                addq $1, %r11          
                movb $0, (%r11)       

                # movendo o caractere pro endereço da variavel  
                leaq buffer_entrada_usuario, %r11          
                movb (%r11), %r10b
                movb %r10b, (%rbx)  
                
                pop_caller_regs 
                
                popq %rsi

                jmp fim_switch_scanf
            case_float_scanf:
                cmpb $'l', %r14b
                jne case_int_scanf
                
                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'f', %r14b
                je eh_float

                nao_float:
                    movb (%rdi), %r14b
                    jmp case_int_scanf

                eh_float:

                incq %r12

                incq %rdi
                
                pushq %rsi

                push_caller_regs

                pushq %rbx 
                call ler_entrada
                popq %rbx 
                
                decq %rax
                movq %rax, %rdi   
                

                leaq buffer_entrada_usuario, %rsi          
                addq %rdi, %rsi          
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
                jmp fim_switch_scanf
            
            case_int_scanf:
                cmpb $'d', %r14b
                jne teste_i_scanf
                je eh_int_scanf
                
                teste_i_scanf:
                    cmpb $'i', %r14b
                    jne case_short_scanf

                eh_int_scanf:

                incq %r12

                pushq %rsi
                
                push_caller_regs
                
                call ler_entrada
                
                # substituindo o \n por \0
                movq %rax, %rdi            
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
                jmp fim_switch_scanf

            case_short_scanf:
                cmpb $'h', %r14b
                jne case_long_int_scanf
                incq %r12

                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'d', %r14b
                jne case_long_int_scanf

                incq %rdi

                pushq %rsi
                
                push_caller_regs

                call ler_entrada

                # substituindo o \n por \0
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
                jmp fim_switch_scanf

            case_long_int_scanf:
                cmpb $'l', %r14b
                jne case_string_scanf
                incq %r12

                movq %rdi, %rdx
                incq %rdx

                movb (%rdx), %r14b
                
                cmpb $'d', %r14b
                jne case_string_scanf

                incq %rdi

                pushq %rsi
                
                push_caller_regs

                call ler_entrada

                # substituindo o \n por \0
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
                jmp fim_switch_scanf

            # não sabia se era obrigatório pra esse trabalho. como é simples, implementei mesmo assim.
            case_string_scanf:        
                cmpb $'s', %r14b
                jne case_nao_suportado_scanf
                incq %r12
                
                pushq %rsi
                
                push_caller_regs

                call ler_entrada

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
                
                while_transferindo_entre_buffers_scanf:
                    
                    cmpq $0, (%r11)
                    je fim_while_transferindo_entre_buffers_scanf
                    
                    movb (%r11), %r12b
                    movb %r12b, (%rbx)

                    incq %r11
                    incq %rbx

                    jmp while_transferindo_entre_buffers_scanf

                fim_while_transferindo_entre_buffers_scanf:

                movb $0, (%rbx)
                
                popq %rsi
                jmp fim_switch_scanf

            case_nao_suportado_scanf:
                pushq %rsi
                leaq mensagem_especificador_nao_suportado, %rsi

                call limpar_buffer_caractere
                movb $10, %bl # \n
                movb %bl, buffer_caractere
                
                push_caller_regs

                call printar_caractere

                pop_caller_regs 
            
                while_impressao_nao_suportado_scanf:
                    cmpb $0, (%rsi)
                    je fim_while_impressao_nao_suportado_scanf

                    call limpar_buffer_caractere

                    movb (%rsi), %bl
                    movb %bl, buffer_caractere
                    
                    push_caller_regs

                    call printar_caractere

                    pop_caller_regs 
                    
                    incq %rsi
                    jmp while_impressao_nao_suportado_scanf
                fim_while_impressao_nao_suportado_scanf:

                call limpar_buffer_caractere
                movb $10, %bl # \n
                movb %bl, buffer_caractere
                
                push_caller_regs

                call printar_caractere

                pop_caller_regs 

                popq %rsi
        fim_switch_scanf:
        incq %rdi
        jmp while_scanf
    fim_while_scanf:

    popq %rbp
    ret


ler_entrada:
    pushq %rbp
    movq %rsp, %rbp

    movq $SYS_read, %rax
    movq $STDIN, %rdi
    movq $buffer_entrada_usuario, %rsi
    movq $256, %rdx
    syscall

    popq %rbp
    ret
