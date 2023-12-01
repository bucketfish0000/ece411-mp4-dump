br.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
    # missing negative edge case success on blt/bge
    #also didn't test for equal to for signed and unsigned bge
_start:

lol:
    addi x1, x0, 7  #x1<= x0 + 7 = 0+7 = 7
    addi x2, x0, 7  #x2<= x0 + 7 = 0+7 = 7
    blt x0, x1, lol #test success

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