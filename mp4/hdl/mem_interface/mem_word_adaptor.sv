module mem_word_adapter
    import rv32i_types::*;
    import rv32i_cache_types::*; 
    import cpuIO::*;
(
    input clk, rst,

    input rv32i_word mem_address, // word aligned 
    output rv32i_word cacheline_mem_address, 

    input rv32i_cache_types::rv32i_cacheline cacheline_rdata,  // read from cache
    output rv32i_cache_types::rv32i_cacheline cacheline_wdata, // write to cache
    
    input rv32i_word mem_wdata, 
    output rv32i_word mem_rdata, 

    input logic [3:0] mem_byte_enable, 
    output logic [31:0] cacheline_mem_byte_enable
);

logic [2:0] word_offset;
assign word_offset = mem_address[4:2]; // 0 to 7 index word within cacheline 
assign cacheline_wdata = {8{mem_wdata}}; 
assign mem_rdata = cacheline_rdata[(32*word_offset) +: 32]; 
assign cacheline_mem_byte_enable = {28'h0, mem_byte_enable} << (mem_address[4:2]*4);
assign cacheline_mem_address = {mem_address[31:5],5'b0};
 
endmodule : mem_word_adapter