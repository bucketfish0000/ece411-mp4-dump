br.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
    # missing negative edge case success on blt/bge
    #also didn't test for equal to for signed and unsigned bge
_start:
    addi x1, x0, 7  #x1<= x0 + 7 = 0+7 = 7
    addi x2, x0, 7  #x2<= x0 + 7 = 0+7 = 7
    blt x0, x1, lol #test success


halt:                 # Infinite loop to keep the processor
    beq x0, x0, halt  # from trying to execute the data below.
                      # Your own programs should also make use
                      # of an infinite loop at the end.

lol:
    addi x3, x1, 7  #x3 <= x1 + 7 = 7+7 = E
    blt x3, x1, lol #test fail
    beq x1, x3, halt #test fail
    bne x1, x1, halt #test fail
    bge x0, x1, halt #test fail
    beq x0, x0, lolly  #test success

lolly:
    ori x4, x3, 1 #x4 <= x3 | 1 = e | 1 = f
    bne x4, x2, lolly_two #test success

lolly_two:
    andi x5, x4, 3  #x5<= x4 & 3 = f & 3 = 3
    bge x4, x3, lolly_three

lolly_three:
    xori x6, x4, 1  #x6<= x4 xor 1 = f xor 1 = e 
    beq x0, x0, lolly_four

lolly_four:
    lui x10, 524288 #x10 <= 80000 << 12 = 80 00 00 00
    blt x1, x10, halt #test fail
    bge x10, x1, halt #test fail
    bltu x10, x1, halt #test fail
    bgeu x1, x10, halt #test fail
    bltu x1, x10, loll #test success

loll:
    bgeu x10, x1, halt #test success
    beq x0, x0, loll




.section ".tohost"
.globl tohost
tohost: .dword 0
.section ".fromhost"
.globl fromhost
fromhost: .dword 0
