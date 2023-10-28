module mem_stage;
import rv32i_types::*;
import rv32i_mux_types::*;
import cpuIO::*;
(
    input clk, //from datapath
    input rst, //from datapath
    input logic exe_mem_rdy, //from EXE_MEM pipeline reg
    input logic exe_mem_valid, //from EXE_MEM pipeline reg
    input cw_mem ctrl_w_MEM,//from EXE_MEM pipeline reg
    input logic mem_resp_d //from data_cache
    output logic mem_r_d, //to data cache
    output logic mem_w_d, //to data cache
    output logic mem_rdy //to ctrl / MEM_WB reg
);
    function void do_default();
        mem_r_d = 1'b0;
        mem_w_d = 1'b0;
    endfunction

    always_comb begin : rdy_ctrl
        if((mem_resp_d == 1) && ((ctrl_w_MEM.mem_read_d == 1) || (ctrl_w_MEM.mem_write_d == 1)))
            mem_rdy = 1'b1;
        else
            mem_rdy = 1'b0;
    end

    always_comb begin : mem_ctrl
        if(rst) begin
            do_default();
        end
        else begin
            do_default();
            mem_r_d = ctrl_w_MEM.mem_read_d;
            mem_w_d = ctrl_w_MEM.mem_write_d;
        end
    end

endmodule : mem_stage