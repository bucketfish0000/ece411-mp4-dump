module cache_control (
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
    output logic[1:0] dirty_op, 
    output logic[1:0] valid_op, 
    output logic plru_update,
    output logic[1:0] dataweb_mux,
    output logic tagweb_mux,
    output logic datain_mux,
    output logic dataout_sel_mux,
    output logic dirty_way_mux,
    output logic pmem_address_mux,
    output logic data_wmask_mux,

    //ctrl input
    input logic cache_hit,
    input logic cache_dirty
);

//vars 
logic ex_write;
logic ex_read;

//assignment
assign ex_read = cpu_read&&(~cpu_write);
assign ex_write = cpu_write&&(~cpu_read);

//state machine def
enum logic[1:0] {
    idle = 0,
    hit_look = 1,
    write_back = 2,
    allocate = 3
} state, next_state;

always_ff @(posedge clk) begin
      state <= next_state;
end

//functions
function void set_defaults();
    cache_resp = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    dirty_op = 2'b00;
    valid_op = 2'b00;
    plru_update = '0;
    dataweb_mux = 2'b00;
    tagweb_mux = '0;
    datain_mux = '0;
    dataout_sel_mux = '0;
    dirty_way_mux = '0;
    pmem_address_mux = '0;
    data_wmask_mux = '0;
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
                //if(ex_write) dataweb_mux <= 2'b01;
            end
        end
        write_back:;
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
                if (ex_read) begin
                    dataout_sel_mux = 1'b0;
                end 
                else if (ex_write) begin
                    data_wmask_mux=1'b1;
                    datain_mux = 1'b0;
                    dirty_way_mux = 1'b0; 
                    dirty_op= 2'b01;
                    dataweb_mux=2'b01;
                end
                plru_update = 1'b1;//plru update on hitmap
                cache_resp = 1'b1;//mark cache ready before idle
            end else begin
                dirty_way_mux=1'b1; //check for dirty in plru
                dirty_op=2'b00;
            end
        end
        write_back: begin
            mem_read = 1'b0;
            mem_write = 1'b1;
            pmem_address_mux = 1'b1;//eviction address
            dataout_sel_mux = 1'b1;//readout plru 
            if (!pmem_resp) begin
                //omfg just spin here
            end else begin //writeback complete
                //unmark dirty
                dirty_way_mux = 1'b1;//clear plru way dirty
                dirty_op = 2'b10;
            end
        end
        allocate: begin
            mem_read = 1'b1;
            mem_write = 1'b0;
            data_wmask_mux = 1'b0;
            dataweb_mux=2'b10;
            pmem_address_mux = 1'b0; //cpu specified address
            if (!pmem_resp) begin
            end else begin
                datain_mux = 1'b1;
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
    if(rst || (mem_cancel)) next_state=idle;
    else begin
    case(state)
        idle:begin
            if ((ex_read || ex_write)) next_state = hit_look;
            else next_state = idle;
        end
        hit_look: begin
            if (!cache_hit) begin
                if (cache_dirty) begin
                    next_state = write_back;
                end
                else next_state = allocate;
            end
            else next_state = idle;
        end
        write_back: begin
            if (~pmem_resp) next_state = write_back;
            else next_state = allocate;
        end
        allocate: begin
            if (~pmem_resp) next_state = allocate;
            else next_state = hit_look;
        end
        default:next_state=idle;
    endcase
    end
end:next_state_logic
endmodule : cache_control
