store.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:


    beq x1, x1, target
    lw x5, mem_data  # should never get here
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