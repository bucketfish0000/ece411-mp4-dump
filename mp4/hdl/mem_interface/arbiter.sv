module cache_arbiter
    import rv32i_types::*;
    import cpuIO::*;
(
    input clk, rst,

    input rv32i_word icache_addr,
    input logic icache_read, 
    output rv32i_cacheline icache_data, 
    output logic icache_resp, 

    input rv32i_word dcache_addr,
    input rv32i_cacheline dcache_data_w,
    input logic dcache_read, dcache_write,  
    output rv32i_cacheline icache_data_r, 
    output logic dcache_resp, 

    input logic mem_resp
    input rv32i_word mem_data, 
    output rv32i_word arbiter_mem_out, 
);

endmodule