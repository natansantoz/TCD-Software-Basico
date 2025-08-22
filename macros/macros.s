.macro push_caller_regs
    pushq %rax 
    pushq %rdi 
    pushq %rsi 
    pushq %rdx 
    pushq %rcx 
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
.endm

.macro pop_caller_regs
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rcx 
    popq %rdx 
    popq %rsi 
    popq %rdi 
    popq %rax 
.endm

.macro push_regs_ponto_flutuante
    subq $128, %rsp       
    movsd %xmm0, 0(%rsp)
    movsd %xmm1, 16(%rsp)
    movsd %xmm2, 32(%rsp)
    movsd %xmm3, 48(%rsp)
    movsd %xmm4, 64(%rsp)
    movsd %xmm5, 80(%rsp)
    movsd %xmm6, 96(%rsp)
    movsd %xmm7, 112(%rsp)
.endm

.macro pop_regs_ponto_flutuante
    movsd 0(%rsp), %xmm0
    movsd 16(%rsp), %xmm1
    movsd 32(%rsp), %xmm2
    movsd 48(%rsp), %xmm3
    movsd 64(%rsp), %xmm4
    movsd 80(%rsp), %xmm5
    movsd 96(%rsp), %xmm6
    movsd 112(%rsp), %xmm7
    addq $128, %rsp       
.endm
