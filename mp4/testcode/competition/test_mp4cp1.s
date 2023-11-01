auipc.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    addi x1, x0, 2047   #x1 <= 0x7ff
    addi x2, x0, 510    #x2 <= 0x1fe
    add x3, x1, x2      #x3 <= 0x9FD
    or x4, x1, x3       #x4 <= 0xfff
    xor x5, x1, x2      #x5 <= 0x601
    sub x6, x5, x1      #x6 <= 0xfffffe02
    slt x7, x6, x1      #x7 <= 0x1
    sltu x8, x6, x1     #x8 <= 0x0
    sll x9, x6, x7      #x9 <= 0xFFFFFC04
    srl x10, x9, x7     #x10 <= 0x7FFFFE02
    sra x11, x9, x7     #x11 <= 0xFFFFFE02
    and x12, x5, x6     #x12 <= 0x600

    auipc x7, 8   #x7 <= pc + (8<<12) = pc + 32768
    lui x3, 2   #x3 <= 2<<12 = 8192
    lw x4, mem_data     #x4 <= 0x0d00d
    la x1, mem_data
    sw x3, 0(x1)    #M[mem_data] <= 8192
    lw x5, mem_data     #x5 <= 8192

    addi x7, x0, 8   #x7 <= 0 + 8(x0==0) = 8
    xori x1, x7, 7   #x1 <= x7 xor 7 = 8 xor 7 = f
    andi x2, x1, 3   #x2 <= x1 & 3 = f & 3 = 3
    ori x4, x7, 16   #x4 <= x7 | 16 = 8 | 16 = 18
    srli x3, x7, 1   #x3 <= x7 >> 1 = 8 >> 1 = 4 
    slli x8, x3, 3   #x8 <= x3 << 3 = 4 << 3 = 20

    lui x7, 524288   #x7 <= 80000 << 12 = 80 00 00 00
    srai x11, x7, 4  #x11 <= x7 >> 4 = 80000000 >> 4 = f8000000

    slti x9, x7, 1   #x9 <= x7 < 1 = -2,147,483,648 < 1 = 1
    sltiu x10, x7, 1 #x10 <= x7 < 1 = 2,147,483,648 < 1 = 0

halt:                 # Infinite loop to keep the processor
    beq x0, x0, halt  # from trying to execute the data below.
                      # Your own programs should also make use
                      # of an infinite loop at the end.

.section .rodata

mem_data:    .word 0x0000d00d

.section ".tohost"
.globl tohost
tohost: .dword 0
.section ".fromhost"
.globl fromhost
fromhost: .dword 0
