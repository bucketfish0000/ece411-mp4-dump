module mem_stage
import rv32i_types::*;
import cpuIO::*;
(
    input clk,
    input rst, 
    input logic [31:0] alu_out,
    input logic [31:0] rs2_out,
    input cw_mem ctrl_w_EX,
    input logic [31:0] pc_x,
    input logic load_data_out,
    input logic load_mar,
    output logic [31:0] mem_address,
    output logic [31:0] mem_wdata
);
    logic [31:0] marmux_o;
    logic marmux_sel;

    always_comb begin : mem_mux
        unique case (ctrl_w_EX.mar_sel)
            marmux::pc_out: marmux_o = pc_x;
            marmux::alu_out: marmux_o = alu_out;
        endcase
    end

    always_comb begin : mem_ctrl
        
    end

    //we could include these registers in the pipeline 
    //register..., but then this stage is just a mux...
    mem_data_out mdo_reg(
        .clk(clk),
        .reset(rst),
        .load_data_out(load_data_out),
        .mdo_in(rs2_out),
        .mdo_out(mem_wdata)
    );

    mar mar_reg(
        .clk(clk),
        .reset(rst),
        .load_mar(load_mar),
        .mar_in(marmux_o),
        .mar_out(mem_address)
    );

endmodule : mem_stage