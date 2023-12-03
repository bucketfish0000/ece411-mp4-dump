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

logic k;
assign k = {24'b0, 8'b00100000};

// list of fsm states 
enum int unsigned { 
    icache, dcache, idle
} state, next_states; 

enum logic[1:0] {
    none,iread,dread,dwrite
} current_request, pending_request;

/*
the guideline is that from the arbiter's point of view there can never be more than one pending request: if one of the caches is waiting for pmem it cannot send in another request, and on the other hand if one of the caches is requesting something it cannot be the cache that is being handled.
*/

always_comb begin : request_track_logic
    if (reset) begin
        current_request = none;
        pending_request = none;
    end
    case (state)
        icache: begin
            current_request = iread;//only option
            if (dcache_read) pending_request = dread;
            else if (dcache_write) pending_request = dwrite;
            else pending_request = none;
        end
        dcache: begin
            current_request = (dcache_read) ? dread : dwrite;
            pending_request = (icache_read) ? iread : none;
        end
        default: begin
            current_request = none;
            pending_request = none;
        end
    endcase
end
function void set_defaults(); 
    icache_data = 256'b0; 
    icache_resp = 1'b0; 
    dcache_data_r = 256'b0; 
    dcache_resp = 1'b0; 
    mem_write = 1'b0; 
    mem_read = 1'b0;
    mem_data_w = 256'b0; 
    mem_addr = 32'b0;
    icache_resp = 1'b0;
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
            mem_data_w = 256'b0;
        end
        dcache: begin 
            dcache_resp = mem_resp; 
            dcache_data_r = mem_data_r; 
            mem_addr = dcache_addr; 
            mem_read = dcache_read; 
            mem_write = dcache_write; 
            mem_data_w = dcache_data_w; 
        end
        idle: begin
            mem_addr = pf_pc_addr_i + k;//input from fetch, pc_wdata, plus some offset of how many cachelines ahead we want to fetch
            pf_addr = mem_addr;
            pf_write = 1'b1;
            if(pf_miss) begin
                mem_read = 1'b1;
            end
            else begin

            end
        end
        default: ;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_states; 
end

always_comb begin: next_state_logic
    if(reset) next_states = icache; 
    else begin 
        case(state)
            icache: begin 
                if(mem_resp) begin
                    if(pending_request == dread || pending_request == dwrite) next_states = dcache; 
                    else next_states = idle; 
                end
                else begin
                    next_states = icache;
                end
            end
            dcache: begin 
                if(mem_resp) begin
                    if(pending_request == iread) next_states = icache; 
                    else next_states = idle; 
                end
                else begin
                    next_states = dcache;
                end
            end
            idle: begin
                if(icache_read) next_states = icache; 
                else if(~icache_read && (dcache_read || dcache_write)) next_states = dcache;  
                else next_states = idle;
            end
            default: next_states = idle;
        endcase
    end
end
endmodule