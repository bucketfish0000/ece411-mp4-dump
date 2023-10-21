module exe_stage
import rv32i_types::*;
import cpuIO::*;
(
    input clk,
    input rst,
    input cw_execute ctrl_w_EXE,
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] pc_x,
    input logic [31:0] mem_fwd_data,
    input logic [31:0] exe_fwd_data,
    input [31:0] i_imm,
    input [31:0] s_imm,
    input [31:0] b_imm,
    input [31:0] u_imm,
    input [31:0] j_imm,
    output logic [31:0] rs2_out,
    output logic [31:0] alu_out,
    output logic br_en
);
    logic [31:0] rs1_o, rs2_o, alumux1_o, alumux2_o, cmpmux_o;

    assign rs2_out = rs2_o;

    cmp cmp_logic(
        .cmpop(ctrl_w_EXE.cmpop),
        .comp1(rs1_o),
        .comp2(cmpmux_o),
        .br_en(br_en)
    );

    alu alu_logic(
        .aluop(ctrl_w_EXE.aluop),
        .a(alumux1_o), 
        .b(alumux2_o),
        .f(alu_out)
    );

    always_comb begin : exe_mux
        unique case (ctrl_w_EXE.cmp_sel)
            cmpmux::rs2_out: cmpmux_o = rs2_o;
            cmpmux::i_imm: cmpmux_o = i_imm;
        endcase

        unique case (ctrl_w_EXE.alumux1_sel)
            alumux::rs1_out: alumux1_o = rs1_out;
            alumux::pc_out: alumux1_o = pc_x;
        endcase

        unique case (ctrl_w_EXE.alumux2_sel)
            alumux::i_imm: alumux2_o = i_imm;
            alumux::u_imm: alumux2_o = u_imm;
            alumux::b_imm: alumux2_o = b_imm;
            alumux::s_imm: alumux2_o = s_imm;
            alumux::j_imm: alumux2_o = j_imm;
            alumux::rs2_out: alumux2_o = rs2_o;
        endcase

        unique case (ctrl_w_EXE.rs1_sel)
            2'b00: rs1_out = rs1_data;
            2'b01: rs1_out = exe_fwd_data;
            2'b10: rs1_out = mem_fwd_data;
            2'b11: ;
        endcase

        unique case (ctrl_w_EXE.rs2_sel)
            2'b00: rs2_o = rs2_data;
            2'b01: rs2_o = exe_fwd_data;
            2'b10: rs2_o = mem_fwd_data;
            2'b11: ;
        endcase

    end

endmodule : exe_stage