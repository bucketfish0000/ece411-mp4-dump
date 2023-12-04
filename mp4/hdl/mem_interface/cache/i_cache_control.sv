module i_cache_control (
    input clk,
    input rst,

    //cpu interaction    
    input cpu_read,
    input cpu_write,
    input mem_cancel,
    output logic cache_resp,//!!!

    //mem interaction
    input pmem_resp,
    output logic mem_read,//read from memory
    output logic mem_write,//write to memory

    //dp ctrl output 
    output logic[1:0] valid_op, 
    output logic plru_update,
    output logic[1:0] dataweb_mux,
    output logic tagweb_mux,
    output logic pmem_address_mux,
    output logic data_wmask_mux,

    //ctrl input
    input logic cache_hit,

    output logic hit,
    output logic miss
);

//vars 
logic ex_read;
assign mem_write = 1'b0;

//assignment
assign ex_read = cpu_read&&(~cpu_write);

//state machine def
enum logic[1:0] {
    idle = 0,
    hit_look = 1,
    allocate = 2
} state, next_state;

always_ff @(posedge clk) begin
      state <= next_state;
end

//functions
function void set_defaults();
    cache_resp = 1'b0;
    mem_read = 1'b0;
    valid_op = 2'b00;
    plru_update = '0;
    dataweb_mux = 2'b00;
    tagweb_mux = '0;
endfunction
//state behavior
always_ff@(posedge clk)
begin: state_actions_ff
    case(state)
        idle:begin
            //cache_resp<=1'b0;
            //dataweb_mux <= 2'b00;
        end
        hit_look:begin
            if(cache_hit)begin
                //cache_resp<=1'b1;
            end
        end
        allocate:begin
            //if(!pmem_resp) dataweb_mux <= 2'b10;
        end
    endcase
end:state_actions_ff
always_comb 
begin: state_actions
    set_defaults();
    case(state)
        idle:begin
            if(mem_cancel) begin
                cache_resp = 1'b1;
            end
            else begin
                cache_resp = 1'b0;
            end
        end
        hit_look: begin
            if(mem_cancel) begin
                cache_resp = 1'b1;
            end
            else begin
                cache_resp = 1'b0;
            end

            if (cache_hit) begin
                //hit: perfom w/r
                plru_update = 1'b1;//plru update on hitmap
                cache_resp = 1'b1;//mark cache ready before idle
            end else begin
            end
        end
        allocate: begin
            mem_read = 1'b1;
            dataweb_mux=2'b10;
            if (!pmem_resp) begin
                ;
            end else begin
                dataweb_mux=2'b10;
                //store tag
                tagweb_mux = 1'b1;
                valid_op=2'b01;
            end
        end
    endcase
end

//state transition
always_comb
begin: next_state_logic
    hit = 1'b0;
    miss = 1'b0;
    if(rst || (mem_cancel)) next_state=idle;
    else begin
    case(state)
        idle:begin
            if ((ex_read)) next_state = hit_look;
            else next_state = idle;
        end
        hit_look: begin
            if (!cache_hit) begin
                miss = 1'b1;
                next_state = allocate;
            end
            else begin
                hit = 1'b1;
                next_state = idle;
            end
        end
        allocate: begin
            if (~pmem_resp) next_state = allocate;
            else next_state = hit_look;
        end
        default:next_state=idle;
    endcase
    end
end:next_state_logic
endmodule : i_cache_control
