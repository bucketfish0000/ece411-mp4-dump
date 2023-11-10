auipc.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:

    #la x1, mem_data    #                                                    5
    #sw x3, 0(x1)    #M[mem_data] <= 8192                                    6
    #lw x5, mem_data     #x5 <= 8192                                         7/8
    beq x1, x1, target
    addi x6, x0, 42 # should never get here
target:
    addi x6, x0, 69 

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