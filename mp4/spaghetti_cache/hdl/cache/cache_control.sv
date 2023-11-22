module cache_control (
    input logic clk,
    input logic reset,
    input logic mem_write,
    input logic mem_read,
    input logic dirty_data_o,
    input logic valid_data_o,
    input logic pmem_resp,
    input logic compare, //asserted iff a match exists(hit) AND that match is valid
    input logic searched,
    output logic search,
    output logic replace,
    output logic pmem_read,
    output logic pmem_write,
    output logic reset_way,
    output logic end_miss_write
);

logic in_search, in_hit_miss, in_miss_write, in_mem_responded, in_miss, in_hit; //for
logic end_write_miss;

assign end_miss_write = end_write_miss;

enum int unsigned { /* List of states */
    search_s = 0,
    hit_miss = 1,
    miss_write = 2,
    memory_responded = 3
} state, nextstate;

function void set_defaults();
    search <=1'b0;
    // replace <=1'b0;
    pmem_read <=1'b0;
    pmem_write <=1'b0;
    reset_way <=1'b0;
endfunction

always_ff @ (posedge clk) begin
    /* Default output assignments */
    set_defaults();
    case (state)
        search_s: begin 
            end_write_miss <= 1'b0;
            if((searched == 0) && ((mem_read == 1) || (mem_write == 1))) begin
                search <= 1'b1;
            end
            else//default wait for one of the above cases
                    ;
        end

        hit_miss: begin
            end_write_miss <= 1'b0;
            //read/write hit
            if((searched == 1) && (compare == 1) && ((mem_read == 1) || (mem_write ==1))) begin
                reset_way <= 1'b1;
            end
            //read/write miss
            else if((searched == 1) && (compare == 0) && ((mem_read == 1) || (mem_write ==1))) begin
                // replace <= 1'b1;
                if((valid_data_o == 1) && (dirty_data_o == 1) && (pmem_resp == 0)) begin
                    search <= 1'b1;
                    pmem_write <= 1'b1;
                end
                else begin
                    search <= 1'b1;
                    pmem_read <= 1'b1;
                end
            end
        end
            
        miss_write: begin 
            end_write_miss <= 1'b0;
            if((valid_data_o == 1) && (dirty_data_o == 1) && (pmem_resp == 0)) begin
                pmem_write <= 1'b1;
                search <= 1'b1;
            end
            else begin
                pmem_read <= 1'b1;
                search <= 1'b1;
            end
        end
        //done writing to memory, now read in data
        memory_responded: begin
            // if((pmem_resp == 0)) begin//wait on read data from pmem
            //     // replace <= 1'b1;
            //     search <= 1'b1;
            //     pmem_read <= 1'b1;
            // end
            // else if((pmem_resp == 1)) begin//wait till write to cache complete
            //     //off loaded to way_finder
            //     // replace <= 1'b1;
            //     // pmem_read <= 1'b1;
            //     reset_way <= 1'b1;
            // end

            if(pmem_resp == 1) begin
                if(mem_read == 1) begin
                    reset_way <= 1'b1;
                    end_write_miss <= 1'b0;
                end
                else begin
                    search <= 1'b1;
                    end_write_miss <= 1'b1;
                end
            end
            else begin
                if((mem_read == 1) || (end_write_miss == 1'b0)) begin
                    search <= 1'b1;
                    pmem_read <= 1'b1;
                    end_write_miss <= 1'b0;
                end
                else begin 
                    reset_way <= 1'b1;
                    end_write_miss <= 1'b0;                 
                end
            end
        end
        //should never happen, but just in case go to intial state
        default: ;
    endcase
end

always_comb begin //nextstate decide
    in_search = 1'b0;
    in_hit_miss = 1'b0;
    in_miss_write = 1'b0;
    in_mem_responded = 1'b0;
    in_hit = 1'b0;
    in_miss = 1'b0;
    replace = 1'b0;
    

    unique case(state)
        search_s: begin
            in_search = 1'b1;
            if((searched == 0) && ((mem_read == 1) || (mem_write == 1))) begin
                nextstate = hit_miss;
            end
            else
                nextstate = search_s;

        end

        hit_miss: begin
            in_hit_miss = 1'b1;
            if((searched == 1) && (compare == 1) && ((mem_read == 1) || (mem_write ==1))) begin
                in_hit = 1'b1;
                nextstate = search_s;
            end
            else if((searched == 1) && (compare == 0) && ((mem_read == 1) || (mem_write ==1))) begin
                in_miss = 1'b1;
                replace = 1'b1;
                if((valid_data_o == 1) && (dirty_data_o == 1) && (pmem_resp == 0)) begin
                    nextstate = miss_write;
                end
                else begin
                    nextstate = memory_responded;
                end
            end
            else //should never happen
                nextstate = search_s;
        end

        miss_write: begin
            in_miss_write = 1'b1;
            replace = 1'b1;
            if((valid_data_o == 1) && (dirty_data_o == 1) && (pmem_resp == 0)) begin
                nextstate = miss_write;
            end
            else begin
                nextstate = memory_responded;
            end
        end

        memory_responded: begin
            in_mem_responded = 1'b1;
            replace = 1'b1;
            if(pmem_resp == 1) begin
                if(mem_read == 1) begin
                    nextstate = search_s;
                end
                else begin
                    nextstate = memory_responded;
                end
            end
            else begin
                if((mem_read == 1) || (end_write_miss == 1'b0)) begin
                    nextstate = memory_responded;
                end
                else begin                  
                    nextstate = search_s;
                end
            end
        end
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    if(reset || ((mem_read == 0) && (mem_write == 0))) begin
        state <= search_s;
    end
    else begin
        state <= nextstate;
    end
end

endmodule : cache_control
