module event_counter 
(
    input clk,rst,

    //input: event signals
    input logic icache_read, icache_hit, icache_resp;
    input logic dcache_read, dcache_write, dcache_hit, dcache_resp;

    input logic stall_if_de, stall_de_exe, stall_exe_mem;
    input logic fetch_invalid,decode_invalid,exe_invalid;
    input logic branch_taken, branch_prediction;

    //output: countings
    output unsigned int icache_misses, dcache_misses, branch_misses,
    output unsigned int icache_miss_wastes, dcache_miss_wastes, branch_miss_wasts, stalling_wastes, pipeline_flush_wastes
);

//todo: i/d cache miss, br/jmp prediction miss (times and cycles), stalling, pipeline flush overhead

    enum int unsigned {
        idle,pending,miss
    } icache_state,icache_next,dcache_state,dcache_next;
    
    int icache_state_counter, dcache_state_counter;
    always_comb begin
        if (rst) begin
            icache_next = idle;
            icache_state_counter = 0;
            dcahce_next = idle;
            dcache_state_counter = 0;
        end
        case (icache_state) 
            idle: begin
                icache_next = idle;
                icache_state_counter = 0;
                if (icache_read) icache_next = pending;
            end
            pending: begin
                icache_state_counter+=1;
                icache_next = pending;
                if (icache_hit) icache_next = idle;
                else if (icache_state_counter >=3) icache_next = miss;
            end
            miss: begin
                icache_state_counter =0;
                if (icache_hit) icache_next = idle;
            end
            default: begin
                icache_next = idle;
                icache_state_counter = 0;
            end
        endcase
            case (dcache_next) 
            idle: begin
                dcache_next = idle;
                dcache_state_counter = 0;
                if (dcache_read || dcache_write) dcache_next = pending;
            end
            pending: begin
                dcache_state_counter+=1;
                dcache_next = pending;
                if (dcache_hit) dcache_next = idle;
                else if (dcache_state_counter >=3) dcache_next = miss;
            end
            miss: begin
                idache_state_counter =0;
                if (dcache_hit) dcache_next = idle;
            end
            default: begin
                dcache_next = idle;
                dcache_state_counter = 0;
            end
        endcase
    end
    always_ff @(posedge clk) begin
        icache_state <= icache_next;
        dcache_state <= dcache_next;
    end

    always_comb 
    begin
        if (rst) begin
            icache_misses = 0;
            dcache_misses = 0;
            icache_miss_wastes = 0;
            dcache_miss_wastes = 0;

            branch_misses = 0;
            //branch_miss_wastes = 0;

            stalling_wastes = 0;
            pipeline_flush_wastes = 0;
        end
        
        if (icache_state == pending && icache_next == miss) icache_misses +=1;
        if (icache_state == miss) icache_miss_wastes +=1;
        if (dcache_state == pending && dcache_next == miss) dcache_misses +=1;
        if (dcache_state == miss) dcache_miss_wastes +=1;

        if (stall_if_de||stall_de_exe||stall_exe_mem) stalling_wastes+=1;
        
        //flush waste should be counted in empty stage*cycles
        if (fetch_invalid) pipeline_flush_wastes +=1;
        if (decode_invalid) pipeline_flush_wastes +=1;
        if (exe_invalid) pipeline_flush_wastes +=1;
        
        //TODO
        if (branch_predict != branch_taken) branch_misses +=1;
        //cycle wasted in missing a branch is counted by flush waste count 

        
    end


endmodule