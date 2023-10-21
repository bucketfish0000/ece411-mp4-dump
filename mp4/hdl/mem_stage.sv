module mem_stage
import rv32i_types::*;
import cpuIO::*;
(
    input clk, //from datapath
    input rst, //from datapath
    input logic [31:0] alu_out,//from EXE_MEM pipeline reg
    input logic [31:0] rs2_out,//from EXE_MEM pipeline reg
    input cw_mem ctrl_w_EX,//from EXE_MEM pipeline reg
    input logic [31:0] pc_x,//from EXE_MEM pipeline reg
    input logic load_data_out, //from ??? would this always be 1?
    input logic load_mar, //from ??? would this always be 1?
    input rv32i_opcode opcode,//from EXE_MEM pipeline reg
    input logic mem_resp_d //from data_cache
    output logic [31:0] mem_address_d, //to data cache
    output logic [31:0] mem_wdata_d, //to data cache
    output logic mem_r_d, //to data cache
    output logic mem_w_d, //to data cache
    output logic mem_r_d_resp, //to MEM_WB pipeline reg
    // output logic mem_stage_rdy //to exe_stage mem stage isn't busy if high, this will be a major bottle neck when low
);
    logic [31:0] marmux_o;
    // logic mem_stage_rdy_temp;

    // assign mem_stage_rdy = mem_stage_rdy_temp;

    always_comb begin : mem_mux
        unique case (ctrl_w_EX.mar_sel)
            marmux::pc_out: marmux_o = pc_x;
            marmux::alu_out: marmux_o = alu_out;
        endcase
    end

    function void do_default();
        mem_r_d_resp <= 1'b0;
        mem_r_d <= 1'b0;
        mem_w_d <= 1'b0;
        // mem_stage_rdy_temp <= 1'b1;
    endfunction

    always_ff @ (posedge clk, posedge rst) begin : mem_ctrl
        if(rst) begin
            do_default();
        end
        else begin
            do_default();
            case(opcode)
                op_store: begin //mem_write to d cache until respond
                    if (mem_resp_d == 1)begin 
                        mem_r_d_resp <= 1'b1;
                    end
                    else begin
                        mem_w_d <= 1'b1;
                        // mem_stage_rdy_temp <= 1'b0;
                    end
                end
                op_load: begin
                    if(mem_resp_d == 1)begin //mem_read to d cache until respond
                        mem_r_d_resp <= 1'b1;
                    end
                    else begin
                        mem_r_d <= 1'b1;
                        // mem_stage_rdy_temp <= 1'b0;
                    end
                end
                default: ;
            endcase
        end
    end

    //we could include these registers in the pipeline 
    //register..., but then this stage is just a mux...
    mem_data_out mdo_reg(
        .clk(clk),
        .reset(rst),
        .load_data_out(load_data_out /*&& mem_stage_rdy_temp*/),//don't load until mem r/w finish
        .mdo_in(rs2_out),
        .mdo_out(mem_wdata_d)
    );

    mar mar_reg(
        .clk(clk),
        .reset(rst),
        .load_mar(load_mar /*&& mem_stage_rdy_temp*/),//don't load until mem r/w finish
        .mar_in(marmux_o),
        .mar_out(mem_address_d)
    );

endmodule : mem_stage