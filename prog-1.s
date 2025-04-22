#	al: must be zero
#  rdi: 1st argument
#  rsi: 2nd argument
#  rdx: 3rd argument
#  rcx: 4th argument
#  r8:	5th argument
#  r9:	6th argument

                .equ        NULL, 0
                .equ        maxLen, 30

                .section    const, "a"
userPrompt:     .asciz      "Input a number in range of 1-10: "
ttlStr:         .asciz      "Program 1"
badString:      .asciz      "Incorrect input\n"
loopString:     .asciz      "%d\n"

                .data
number:         .quad       0
input:          .fill       maxLen, 1, 0

                .text
                .extern     printf
                .extern     readLine
                .extern     atoi

                .global	    getTitle
getTitle:
                lea     ttlStr(%rip), %rax
                ret

                .global asmMain
asmMain:
                push    %rbx
                mov     $0, %al
                lea     userPrompt(%rip), %rdi
                call    printf

                mov     $0, %al
                lea     input(%rip), %rdi
                mov     $maxLen, %rsi
                call    readLine

                mov     $0, %al
                lea     input(%rip), %rdi
                call    atoi
                
                cmp     $NULL, %rax
                je      badInput
                cmp     $1, %rax
                jl      badInput
                cmp     $10, %rax
                jg      badInput

                mov     %rax, number(%rip) 

loop:
                mov     $0, %al
                lea     loopString(%rip), %rdi
                mov     number(%rip), %rsi
                call    printf

                mov     number(%rip), %rdi
                sub     $1, %rdi
                mov     %rdi, number(%rip)
                jnz     loop

                pop     %rbx
                ret
                
badInput:
                mov     $0, %al
                lea     badString(%rip), %rdi
                call    printf
                pop     %rbx
                ret
