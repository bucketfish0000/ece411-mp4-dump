test_mp4cp1V2.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    
    addi x1, x0, 2047   #x1 <= 0x7ff                                        1
    addi x2, x0, 510    #x2 <= 0x1fe                                        2
    add x3, x1, x2      #x3 <= 0x9FD exe_fwd_02(rs2) + mem_fwd_01(rs1)      3
    or x4, x1, x3       #x4 <= 0xfff                                        4
    xor x5, x1, x2      #x5 <= 0x601                                        5
    and x6, x4, x5
bug:                    #comment out jump and bug, same error with halt. When jump to self on new cache line... bad
    jal x0, bug
                     
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