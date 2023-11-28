i_alu_and_cmp.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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

loop:
    addi x1, x1, -1024
    blt x1, x0, halt
    beq x0, x0, loop

halt:                 # Infinite loop to keep the processor
    beq x0, x0, halt  # from trying to execute the data below.
                      # Your own programs should also make use
                      # of an infinite loop at the end.

.section ".tohost"
.globl tohost
tohost: .dword 0
.section ".fromhost"
.globl fromhost
fromhost: .dword 0
