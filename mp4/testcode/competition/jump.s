jump.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    addi x3, x0, 17 #x3 <= 0x11
    jal x1, loop
    ori x2, x3, 32  #x2 <= 0x31
    jal x0, halt

loop:
    andi x4, x3, 33  #x4 <= 0x01
    ret

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
