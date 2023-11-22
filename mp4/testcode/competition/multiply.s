multiply.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    
    lw x1, mem_data
    mul x2, x1, x1
    mul x3, x2, x2
    mulh x4, x2, x2
    mulhu x5, x2, x2
    mulhsu x6, x2, x2
                     
halt:                 # Infinite loop to keep the processor
    beq x0, x0, halt  # from trying to execute the data below.
                      # Your own programs should also make use
                      # of an infinite loop at the end.

.section .rodata

mem_data:    .word 0x0000d00d
mem_data0:    .word 0x0000d01d
mem_data1:    .word 0x0000d02d
mem_data2:    .word 0x0000d03d
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