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
userPrompt:     .asciz      "Input a number in binary: "
ttlStr:         .asciz      "Program 2"
badString:      .asciz      "Incorrect input\n"
lenString:      .asciz      "Strlen: %d\n"
resString:      .asciz      "Result: %d (0x%04x)\n"

                .data
input:          .fill       maxLen, 1, 0
numberLen:      .quad       0

                .text
                .extern     printf
                .extern     readLine
                .extern     atoi

                .global	    getTitle
getTitle:
                lea     ttlStr(%rip), %rax
                ret

strLen:
                mov     $-1, %rax
strLoop:
                add     $1, %rax
                mov     (%rax, %rdi), %rbx
                cmp     $0, %rbx
                jne     strLoop

                ret

                .global asmMain
asmMain:
                # prompt
                push    %rbx
                mov     $0, %al
                lea     userPrompt(%rip), %rdi
                call    printf

                # read
                mov     $0, %al
                lea     input(%rip), %rdi
                mov     $maxLen, %rsi
                call    readLine

                # count string len
                lea     input(%rip), %rdi
                call    strLen
                mov     %rax, numberLen(%rip)

                # print string len
                mov     $0, %al
                lea     lenString(%rip), %rdi
                mov     numberLen(%rip), %rsi
                call    printf

                mov     numberLen(%rip), %rax # loop down counter
                mov     $0, %rcx # loop up counter
                mov     $0, %rdx # result
mainLoop:
                # step
                sub     $1, %rax

                lea     input(%rip), %rbx
                mov     (%rbx, %rax), %rdi
                and     $0x0F, %rdi # strip HO nibble -> convert to bin

                # validate binary
                cmp     $0, %rdi
                jl      badInput
                cmp     $1, %rdi
                jg      badInput

                # calc result
                shl     %cl, %rdi
                or      %rdi, %rdx

                # loop cond
                add     $1, %rcx
                cmp     $0, %rax
                jne     mainLoop

                # print result
                mov     $0, %al
                lea     resString(%rip), %rdi
                mov     %rdx, %rsi
                mov     %rdx, %rdx
                call    printf

                pop     %rbx
                ret
                
badInput:
                mov     $0, %al
                lea     badString(%rip), %rdi
                call    printf
                pop     %rbx
                ret
