module exe_stage;
import rv32i_types::*;
import rv32i_mux_types::*;
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
    input imm imm_in,
    output logic [31:0] rs2_out,
    output logic [31:0] alu_out,
    output logic br_en,
  
    input logic ready_i,
    input logic valid_i,
    output logic ready_o,
    output logic valid_o
);
    logic [31:0] rs1_o, rs2_o, alumux1_o, alumux2_o, cmpmux_o;
    cmpmux_sel_t cmp_sel;
    alumux1_sel_t alumux1_sel;
    alumux2_sel_t alumux2_sel;
    rs1_sel_t rs1_sel;
    rs2_sel_t rs2_sel;
    rv32i_word i_imm;
    rv32i_word s_imm;
    rv32i_word b_imm;
    rv32i_word u_imm;
    rv32i_word j_imm;

    assign i_imm = imm_in.i_imm;
    assign s_imm = imm_in.s_imm;
    assign b_imm = imm_in.b_imm;
    assign u_imm = imm_in.u_imm;
    assign j_imm = imm_in.j_imm;
    assign rs2_out = rs2_o;

    assign ready_o = 1'b1;
    assign valid_o = ready_i & valid_i;

    //always_ff or always_comb??
    always_ff @(posedge clk, posedge rst) begin : exe_rdy_ctrl
        if(rst)
            exe_rdy <= 1'b0;
        else if((de_exe_valid == 1) && (de_exe_rdy == 1)) //when sees these signals by the time rdy goes high operation will be done(1 cycle)
            exe_rdy <= 1'b1;
        else
            exe_rdy <= 1'b0;
    end

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
            2'b00: rs1_o = rs1_data;
            2'b01: rs1_o = exe_fwd_data;
            2'b10: rs1_o = mem_fwd_data;
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