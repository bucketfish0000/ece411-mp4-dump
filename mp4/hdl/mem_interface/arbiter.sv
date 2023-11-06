module cache_arbiter
    import rv32i_types::*;
    import cpuIO::*;
(
    input clk, rst,

    input rv32i_word icache_addr, // cannot write to icache
    input logic icache_read, 
    output rv32i_cacheline icache_data, 
    output logic icache_resp, 

    input rv32i_word dcache_addr,
    input rv32i_cacheline dcache_data_w,
    input logic dcache_read, dcache_write,  
    output rv32i_cacheline dcache_data_r, 
    output logic dcache_resp, 


    input rv32i_cacheline mem_data_r, 
    input logic mem_resp,
    output rv32i_word mem_addr, 
    output rv32i_cacheline mem_data_w, 
    output logic mem_read, mem_write, 
);

// list of fsm states 
enum int unsigned { 
    icache, dcache, idle
} state, next_states; 
 
function void set_defaults(); 
    icache_data = 0; 
    icache_resp = 1'b0; 
    dcache_data_r = 0; 
    dcache_resp = 1'b0; 
endfunction

always_comb begin : state_actions
    set_defaults(); 
    case(state)
        icache: begin end
        dcache: begin end
        idle: begin end
    endcase
end

always_ff @(posedge clk) begin : next_state_logic
    if(rst) state <= icache; 
    else begin 
        case(state)
            icache: begin end
            dcache: begin end
            idle: begin end
        endcase
end
endmodule