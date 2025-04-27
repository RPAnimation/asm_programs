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
userPrompt:     .asciz      "Provide an index of the array to print: "
ttlStr:         .asciz      "Program 3"
badString:      .asciz      "Incorrect input\n"
resString:      .asciz      "Result: %d\n"

                .data
input:          .fill       maxLen, 1, 0
arrayIndex:     .byte       0
array:          .byte       12, 42, 33, 69, 240, 111

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
                mov     $0, %al
                lea     input(%rip), %rdi
                call    atoi
                mov     %al, arrayIndex(%rip)

                # validate input
                cmp     $0, %rax
                jl      badInput
                cmp     $5, %rax
                jg      badInput

                lea     array(%rip), %rdx
                movzx   arrayIndex(%rip), %rcx
                movzx   (%rdx, %rcx), %rsi


                # print array at index
                mov     $0, %al
                lea     resString(%rip), %rdi

                call    printf

                pop     %rbx
                ret
                
badInput:
                mov     $0, %al
                lea     badString(%rip), %rdi
                call    printf
                pop     %rbx
                ret
