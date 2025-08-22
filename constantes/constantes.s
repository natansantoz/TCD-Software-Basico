.equ SYS_read,  0
.equ SYS_write, 1
.equ SYS_open,  2
.equ SYS_close, 3
.equ SYS_lseek, 8
.equ SYS_fork,  57
.equ SYS_exit,  60
.equ SYS_creat, 85

.equ STDIN,  0
.equ STDOUT, 1
.equ STDERR, 2

.equ SIZE_BUFFER_CARACTERE, 1

.equ O_CREAT,  64
.equ O_TRUNC,  512
.equ O_APPEND, 1024

.equ O_RDONLY, 0            
.equ O_WRONLY, 1            
.equ O_RDWR,   2              

.equ READ, O_RDONLY               #                                     r
.equ WRITE, 577                   # O_WRONLY  + O_CREAT + O_TRUNC       w
.equ APPEND, 1089                 # O_WRONLY  + O_CREAT + O_APPEND      a
.equ R_READ_AND_WRITE, O_RDWR     #                                     r+ 
.equ W_READ_AND_WRITE, 578        # O_RDWR    + O_CREAT + O_TRUNC       w+ 
.equ A_READ_AND_WRITE, 1090       # O_RDWR    + O_CREAT + O_APPEND      a+ 
