//handles interfacing with memory(using cache control signals r/w/resp), d cache input data(addr, wdata, byte_en) handled by exe_mem reg
//they get set at same time as exe_mem reg so that this can immediately begin
module mem_stage
import rv32i_types::*;
// Mux types are in their own packages to prevent identiier collisions
// e.g. pcmux::pc_plus4 and regfilemux::pc_plus4 are seperate identifiers
// for seperate enumerated types, you cannot //import rv32i_mux_types::*;
import pcmux::*;
import marmux::*;
import cmpmux::*;
import alumux::*;
import regfilemux::*;
import rs1mux::*;
import rs2mux::*;
import cpuIO::*;
(
    input clk, //from datapath
    input rst, //from datapath
    input logic exe_mem_valid, //from EXE_MEM pipeline reg
    input cw_mem ctrl_w_MEM,//from EXE_MEM pipeline reg
    input logic mem_resp_d, //from data_cache
    output logic mem_r_d, //to data cache
    output logic mem_w_d, //to data cache
    output logic mem_rdy //to ctrl / MEM_WB reg
);
    logic mem_resp_flag;
    logic mem_ready;

    assign mem_rdy = mem_ready;

    function void do_default();
        mem_r_d = 1'b0;
        mem_w_d = 1'b0;
    endfunction

    //essentialy clocked by dram resp signal
    always_comb begin : rdy_ctrl
        if((((mem_resp_d == 1) && ((ctrl_w_MEM.mem_read_d == 1) || (ctrl_w_MEM.mem_write_d == 1))) 
        || ((ctrl_w_MEM.mem_read_d == 0) && (ctrl_w_MEM.mem_write_d == 0))))
            mem_ready = 1'b1;
        else
            mem_ready = 1'b0;
    end

    always_comb begin : mem_ctrl
        if(rst) begin
            do_default();
        end
        else if(exe_mem_valid && !mem_resp_flag)begin
            do_default();
            mem_r_d = ctrl_w_MEM.mem_read_d;
            mem_w_d = ctrl_w_MEM.mem_write_d;
        end
        else begin
            do_default();
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            mem_resp_flag <= 1'b0;
        end
        else if(mem_ready && ((ctrl_w_MEM.mem_read_d == 1) || (ctrl_w_MEM.mem_write_d == 1))) begin
            mem_resp_flag <= 1'b1;
        end
        else begin
            mem_resp_flag <= 1'b0;
        end
    end

endmodule : mem_stage