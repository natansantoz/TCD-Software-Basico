.include "./macros/macros.s"
.include "./constantes/constantes.s"

.text
.globl string_to_int


string_to_int:
    push %rbp
    push %rbx
    push %rcx

    movb (%rdi), %bl # obtendo o primeiro byte (sinal do numero) 

    cmpb $'+', %bl
    je positivo_string_to_int

    cmpb $'-', %bl
    je negativo_string_to_int
  
    jmp sem_sinal_string_to_int

    positivo_string_to_int:
        inc %rdi
        call extract_int_from_string 
        jmp epilogo_string_to_int

    negativo_string_to_int:
        inc %rdi
        call extract_int_from_string 
        imul $-1, %rax
        jmp epilogo_string_to_int
    
    sem_sinal_string_to_int:
        call extract_int_from_string 
  
    epilogo_string_to_int:
        pop %rcx
        pop %rbx
        pop %rbp
    ret



extract_int_from_string:
    push %rbp
    push %rbx

    movq $0, %rax

    while_extract_int_from_string:
        movb (%rdi), %cl 

        # validando se o caractere é um número
        cmpb $'0', (%rdi)
        jl end_while_extract_int_from_string
        cmpb $'9', (%rdi)
        jg end_while_extract_int_from_string
        
        movb (%rdi), %cl

        sub $'0', %cl # obtendo o valor numerico do caractere

        # rax = rax*10 + novoNumero
        movq $10, %rbx
        mulq %rbx
        movzbl %cl, %ecx
        addq %rcx, %rax 

        inc %rdi # avançando o ponteiro para o proximo caracatere 

        cmpb $0, (%rdi) # verificando se é o fim da string
        jne while_extract_int_from_string
    end_while_extract_int_from_string:

    pop %rbx    
    pop %rbp
    ret

