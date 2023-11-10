module cache_arbiter
    import rv32i_types::*;
    import rv32i_cache_types::*; 
    import cpuIO::*;
(
    input clk, reset,

    input rv32i_word icache_addr, // cannot write to icache
    input logic icache_read, 
    output rv32i_cache_types::rv32i_cacheline icache_data, 
    output logic icache_resp, 

    input rv32i_word dcache_addr,
    input rv32i_cache_types::rv32i_cacheline dcache_data_w,
    input logic dcache_read, dcache_write,  
    output rv32i_cache_types::rv32i_cacheline dcache_data_r, 
    output logic dcache_resp, 

    input rv32i_cache_types::rv32i_cacheline mem_data_r, 
    input logic mem_resp,
    output rv32i_word mem_addr, 
    output rv32i_cache_types::rv32i_cacheline mem_data_w, 
    output logic mem_read, mem_write
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
        icache: begin 
            icache_resp = mem_resp; 
            icache_data = mem_data_r;
            mem_addr = icache_addr; 
            mem_read = icache_read; 
            //mem_read = 1'b1; 
            mem_write = 1'b0; 
            mem_data_w = 0; 
        end
        dcache: begin 
            dcache_resp = mem_resp; 
            dcache_data_r = mem_data_r; 
            mem_addr = dcache_addr; 
            mem_read = dcache_read; 
            mem_write = dcache_write; 
            mem_data_w = dcache_data_w; 
        end
        idle: ;
        default: ;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_states; 
end

always_ff @(posedge clk) begin : next_state_logic
    if(reset) next_states = icache; 
    else begin 
        case(state)
            icache: begin 
                if(icache_resp) begin
                    if(dcache_read || dcache_write) next_states = dcache; 
                    else next_states = idle; 
                end
            end
            dcache: begin 
                if(dcache_resp) begin
                    if(icache_read) next_states = icache; 
                    else next_states = idle; 
                end
            end
            idle: begin
                if(icache_read) next_states = icache; 
                if(~icache_read && (dcache_read || dcache_write)) next_states = dcache;  
            end
        endcase
    end
end
endmodule