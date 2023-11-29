divide.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    
    lw x1, mem_data #d00d
    mul x2, x1, x1 #a915_20a9
    div x3, x2, x1 #ffff_950d
    div x3, x1, x2 #0
    divu x3, x2, x2 #1
    rem x3, x2, x1 #ffff_ff00
    remu x3, x2, x1 #0
    rem x3, x1, x2 #d00d

    lw x4, mem_data1 #8000_0000
    lw x5, mem_data2 #ffff_ffff
    div x6, x4, x5 #8000_0000
    rem x6, x4, x5 #0
    divu x6, x5, x4 #1
    remu x6, x5, x4 #7fff_ffff

    div x7, x4, x0 #ffff_ffff
    rem x7, x4, x0 #8000_0000
    divu x7, x4, x0 #ffff_ffff
    remu x7, x4, x0 #8000_0000

    #0000_001|0_0001|_0000_1||_0001_0|0011_0011
                     
halt:                 # Infinite loop to keep the processor
    beq x0, x0, halt  # from trying to execute the data below.
                      # Your own programs should also make use
                      # of an infinite loop at the end.

.section .rodata

mem_data:    .word 0x0000d00d
mem_data0:    .word 0x0000d01d
mem_data1:    .word 0x80000000
mem_data2:    .word 0xffffffff
mem_data3:    .word 0x0000d04d
mem_data4:    .word 0x0000d05d
mem_data5:    .word 0x0000d06d
mem_data6:    .word 0x0000d07d
mem_data7:    .word 0x0000d08d

.section ".tohost"
.globl tohost
tohost: .dword 0
.section ".fromhost"
.globl fromhost
fromhost: .dword 0