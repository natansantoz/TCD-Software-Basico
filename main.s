# Trabalho 3 - SB Natã Teixeira Santos de Oliveira

.include "./macros/macros.s"
.include "./constantes/constantes.s"


.section .data
    .globl digitos
    .globl potencias_dez
    .globl variavel_string_scanf
    .globl dez_flutuante_aux
    .globl um_flutuante_aux
    .globl zero_flutuante_aux
    .globl var_10_auxiliar
    .globl quebra_linha
    .globl quebra_linha_especificador
    .globl mensagem_char_printf
    .globl mensagem_float_printf
    .globl mensagem_inteiro_printf
    .globl mensagem_short_printf
    .globl mensagem_long_printf
    .globl mensagem_string_printf
    .globl mensagem_string_pela_pilha_printf
    .globl variavel_inteiro_excedente_scanf
    .globl mensagem_pre_todos_os_valore_printf
    .globl mensagem_todos_os_valore_printf
    .globl mensagem_fscanf
    .globl mensagem_final_scanf
    .globl string_char_scanf
    .globl string_float_scanf
    .globl string_inteiro_scanf
    .globl string_short_scanf
    .globl string_long_scanf
    .globl string_string_scanf
    .globl variavel_char_scanf
    .globl variavel_float_scanf
    .globl variavel_inteiro_scanf
    .globl variavel_inteiro2_scanf
    .globl variavel_short_scanf
    .globl variavel_long_scanf
    .globl numero_teste_float_pilha1
    .globl numero_teste_int
    .globl nome_arquvo_leitura_fscanf
    .globl nome_arquvo_leitura
    .globl nome_arquvo_escrita
    .globl string_scanf
    .globl string_exibir_resultado_scanf
    .globl v1_double_scanf
    .globl v2_inteiro_scanf
    .globl mensagem_especificador_nao_suportado
    .globl modo_leitura_r
    .globl modo_leitura_r_plus
    .globl modo_escrita_w
    .globl modo_escrita_w_plus
    .globl modo_append_a
    .globl modo_append_a_plus


    digitos:                                .byte   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    potencias_dez:                          .quad   1000000, 100000, 10000, 1000, 100, 10, 1

    variavel_string_scanf:                  .string ""

    dez_flutuante_aux:                      .double 10.0         
    um_flutuante_aux:                       .double 1.0           
    zero_flutuante_aux:                     .double 0.0        
    var_10_auxiliar:                        .double 10.0

    quebra_linha:                           .string "\n"
    quebra_linha_especificador:             .string "%c"
    mensagem_char_printf:                   .asciz "Digite um char: "
    mensagem_float_printf:                  .asciz "Digite um float: "
    mensagem_inteiro_printf:                .asciz "Digite um inteiro: "
    mensagem_short_printf:                  .asciz "Digite um short: "
    mensagem_long_printf:                   .asciz "Digite um long: "
    mensagem_string_printf:                 .asciz "Digite uma string: "
    mensagem_string_pela_pilha_printf:      .asciz "Digite outro inteiro (esse argumento será passado pela pilha): "
    variavel_inteiro_excedente_scanf:       .quad   0


    mensagem_pre_todos_os_valore_printf:    .asciz "\nValores informados: \n"
    mensagem_todos_os_valore_printf:        .asciz "Char: %c \nFloat: %f \nInteiro: %d \nShort: %hd \nLong: %ld \nString: %s \nInteiro pela pilha: %d \n"
    mensagem_fscanf:                        .asciz "%d %d"
    mensagem_final_scanf:                   .asciz "\nValores lidos do arquivo leitura-fscanf.txt: %d %d"


    string_char_scanf:                      .asciz "%c"
    string_float_scanf:                     .asciz "%lf"
    string_inteiro_scanf:                   .asciz "%d"
    string_short_scanf:                     .asciz "%hd"
    string_long_scanf:                      .asciz "%ld"
    string_string_scanf:                    .asciz "%s"


    variavel_char_scanf:                    .byte   0
    variavel_float_scanf:                   .double 0
    variavel_inteiro_scanf:                 .quad   0
    variavel_inteiro2_scanf:                .quad   0
    variavel_short_scanf:                   .quad   0
    variavel_long_scanf:                    .quad   0


    numero_teste_float_pilha1:              .double -123.456

    numero_teste_int:                       .quad   -99

    nome_arquvo_leitura_fscanf:             .string "leitura-fscanf.txt"
    nome_arquvo_leitura:                    .string "arquivo_onde_conteudo_foi_escrito.txt"
    nome_arquvo_escrita:                    .string "escrita.txt"


    string_scanf:                           .asciz "%s"
    string_exibir_resultado_scanf:          .asciz "%s"

    v1_double_scanf:                        .double 99.2
    v2_inteiro_scanf:                       .quad   0

    mensagem_especificador_nao_suportado:   .asciz "Não foi possível imprimir toda a string. Há especificadores inválidos ou que não são contemplados nesse trabalho."

    modo_leitura_r:                         .string "r"
    modo_leitura_r_plus:                    .string "r+"
    modo_escrita_w:                         .string "w"
    modo_escrita_w_plus:                    .string "w+"
    modo_append_a:                          .string "a"
    modo_append_a_plus:                     .string "a+"

    
.section .bss
    .globl buffer_caractere
    .globl buffer_numero_int_string
    .globl buffer_temp_numero_int_string
    .globl buffer_numero_double_string
    .globl buffer_entrada_usuario

    .lcomm buffer_caractere,                SIZE_BUFFER_CARACTERE
    .lcomm buffer_numero_int_string,        40
    .lcomm buffer_temp_numero_int_string,   40
    .lcomm buffer_numero_double_string,     24
    .lcomm buffer_entrada_usuario,          256


.section .text
.globl _start


_start:
    # ------------------------------ OBTENDO O CHAR ------------------------------
    leaq    mensagem_char_printf, %rdi
    pushq   %r10
    pushq   %r11
    call    printf
    popq    %r11
    popq    %r10    


    leaq    string_char_scanf, %rdi
    leaq    variavel_char_scanf, %rsi
    pushq   %r10
    pushq   %r11
    call    scanf
    popq    %r11
    popq    %r10    


    call    printar_quebra_linha


    # ------------------------------ OBTENDO O FLOAT ------------------------------
    leaq    mensagem_float_printf, %rdi
    pushq   %r10
    pushq   %r11
    call    printf
    popq    %r11
    popq    %r10    
    

    leaq    string_float_scanf, %rdi
    leaq    variavel_float_scanf, %rsi
    pushq   %r10
    pushq   %r11
    call    scanf
    popq    %r11
    popq    %r10   


    call    printar_quebra_linha


    # ------------------------------ OBTENDO O INTEIRO ------------------------------
    leaq    mensagem_inteiro_printf, %rdi
    pushq   %r10
    pushq   %r11
    call    printf
    popq    %r11
    popq    %r10
    

    leaq    string_inteiro_scanf, %rdi
    leaq    variavel_inteiro_scanf, %rsi
    pushq   %r10
    pushq   %r11
    call    scanf
    popq    %r11
    popq    %r10   


    call    printar_quebra_linha


    # ------------------------------ OBTENDO O SHORT ------------------------------
    leaq    mensagem_short_printf, %rdi
    pushq   %r10
    pushq   %r11
    call    printf
    popq    %r11
    popq    %r10    


    leaq    string_short_scanf, %rdi
    leaq    variavel_short_scanf, %rsi
    pushq   %r10
    pushq   %r11
    call    scanf
    popq    %r11
    popq    %r10   


    call    printar_quebra_linha


    # ------------------------------ OBTENDO O LONG ------------------------------
    leaq    mensagem_long_printf, %rdi
    pushq   %r10
    pushq   %r11
    call    printf
    popq    %r11
    popq    %r10    


    leaq    string_long_scanf, %rdi
    leaq    variavel_long_scanf, %rsi
    pushq   %r10
    pushq   %r11
    call    scanf
    popq    %r11
    popq    %r10    


    call    printar_quebra_linha


    # ------------------------------ OBTENDO A PRIMEIRA STRING ------------------------------
    leaq    mensagem_string_printf, %rdi
    pushq   %r10
    pushq   %r11
    call    printf
    popq    %r11
    popq    %r10    


    leaq    string_string_scanf, %rdi
    leaq    variavel_string_scanf, %rsi
    pushq   %r10
    pushq   %r11
    call    scanf
    popq    %r11
    popq    %r10   


    call printar_quebra_linha

    
    # ------------------------------ OBTENDO A SEGUNDA STRING ------------------------------
    leaq    mensagem_string_pela_pilha_printf, %rdi
    pushq   %r10
    pushq   %r11
    call    printf
    popq    %r11
    popq    %r10    


    leaq    string_inteiro_scanf, %rdi
    leaq    variavel_inteiro_excedente_scanf, %rsi
    pushq   %r10
    pushq   %r11
    call    scanf
    popq    %r11
    popq    %r10    


    call printar_quebra_linha


    # ------------------------------ exibindo todos os valores informados: ------------------------------
    leaq    mensagem_pre_todos_os_valore_printf, %rdi
    pushq   %r10
    pushq   %r11
    call    printf
    popq    %r11
    popq    %r10    


    leaq    mensagem_todos_os_valore_printf, %rdi
    movq    variavel_char_scanf, %rsi
    movsd   variavel_float_scanf, %xmm0
    movslq  variavel_inteiro_scanf, %rdx 
    movswq  variavel_short_scanf, %rcx
    movslq  variavel_long_scanf, %r8
    leaq    variavel_string_scanf, %r9


    subq    $8, %rsp  # alocando espaço na pilha pro argumento excedente
    movslq  variavel_inteiro_excedente_scanf, %rax 
    movq    %rax, 0(%rsp) 
    push_caller_regs
    call    printf
    pop_caller_regs     
    addq    $8, %rsp   


    # ------------------------------ abrindo o arquivo e escrevendo o conteudo lido do termninal ------------------------------
    leaq    nome_arquvo_leitura, %rdi
    leaq    modo_escrita_w_plus, %rsi
    call    fopen


    leaq    mensagem_todos_os_valore_printf, %rdi
    movq    variavel_char_scanf, %rsi
    movsd   variavel_float_scanf, %xmm0
    movslq  variavel_inteiro_scanf, %rdx 
    movswq  variavel_short_scanf, %rcx
    movslq  variavel_long_scanf, %r8
    leaq    variavel_string_scanf, %r9


    subq    $8, %rsp  # alocando espaço na pilha pro argumento excedente
    movslq  variavel_inteiro_excedente_scanf, %rbx
    movq    %rbx, 0(%rsp) 
    push_caller_regs
    call    fprintf
    pop_caller_regs     
    addq    $8, %rsp   


    movq    %rax, %rdi
    call    fclose



    # ------------------------------ lendo de arquivo e printando no terminal ------------------------------
    leaq    nome_arquvo_leitura_fscanf, %rdi
    leaq    modo_leitura_r, %rsi
    call    fopen


    movq    $0, %rdi
    movq    $0, %rsi
    movq    $0, %rdx
    movq    $0, %rcx
    movq    $0, %r8
    movq    $0, %r9


    leaq    mensagem_fscanf, %rdi
    leaq    variavel_inteiro_scanf, %rsi
    leaq    variavel_inteiro2_scanf, %rdx
    push_caller_regs
    call    fscanf
    pop_caller_regs  


    leaq    mensagem_final_scanf, %rdi
    movq    variavel_inteiro_scanf, %rsi
    movq    variavel_inteiro2_scanf, %rdx 
    push_caller_regs
    call    printf
    pop_caller_regs 


    movq    %rax, %rdi
    call    fclose
    call    printar_quebra_linha


    movq    $60, %rax 
    movq    $0, %rdi
    syscall        
