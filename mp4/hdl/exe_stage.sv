module exe_stage
import rv32i_types::*;
(
    input clk,
    input rst,
    input logic [0:0] ctrl_w_DE?,
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] PC_x,
    input logic [0:0] astrisk_imm?,
    input logic [31:0] mem_fwd_data,
    output logic [31:0] exe_fwd_data
    output logic [0:0] ctrl_w_EX?,
    output logic [31:0] rs2_out,
    output logic [31:0] alu_out
    output logic br_en
);
    logic [0:0] aluop;
    logic [0:0] cmpop;
    logic [0:0] rs1_sel, rs2_sel;
    logic alumux1_sel;
    logic [0:0] alumux2_sel;
    logic [0:0] cmpmux_sel;
    logic [31:0] rs2_o;

    assign aluop = ctrl_w_DE[0:0]; 
    assign cmpop = ctrl_w_DE[0:0]; 
    assign rs1_sel = ctrl_w_DE[0:0]; 
    assign rs2_sel = ctrl_w_DE[0:0]; 
    assign alumux1_sel = ctrl_w_DE[0:0]; 
    assign alumux2_sel = ctrl_w_DE[0:0]; 
    assign cmpmux_sel = ctrl_w_DE[0:0]; 
    assign rs2_out = rs2_o;

    cmp cmp_logic(
        .cmpop(cmpop),
        .comp1(rs1_out),
        .comp2(cmpmux_o),
        .br_en(br_en)
    );

    alu alu_logic(
        .aluop(aluop),
        .a(alumux1_o), 
        .b(alumux2_o),
        .f(alu_out)
    );

    always_comb begin : exe_mux
        unique case (cmpmux_sel)
            cmpmux::rs2_out: cmpmux_o = rs2_o;
            cmpmux::i_imm: cmpmux_o = astrisk_imm;
        endcase

        unique case (alumux1_sel)
            alumux::rs1_out: alumux1_o = rs1_out;
            alumux::pc_out: alumux1_o = PC_x;
        endcase

        unique case (alumux2_sel)
            alumux::i_imm: alumux2_o = astrisk_imm;
            alumux::u_imm: alumux2_o = astrisk_imm;
            alumux::b_imm: alumux2_o = astrisk_imm;
            alumux::s_imm: alumux2_o = astrisk_imm;
            alumux::j_imm: alumux2_o = astrisk_imm;
            alumux::rs2_out: alumux2_o = rs2_o;
        endcase

        unique case (rs1_sel)
            2'b00: rs1_out = rs1_data;
            2'b01: rs1_out = exe_fwd_data;
            2'b10: rs1_out = mem_fwd_data;
            2'b11: ;
        endcase

        unique case (rs2_sel)
            2'b00: rs2_o = rs2_data;
            2'b01: rs2_o = exe_fwd_data;
            2'b10: rs2_o = mem_fwd_data;
            2'b11: ;
        endcase

    end

endmodule : exe_stage