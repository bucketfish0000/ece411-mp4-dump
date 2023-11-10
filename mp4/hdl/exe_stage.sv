module exe_stage
import cpuIO::*;
import rv32i_types::*;
// Mux types are in their own packages to prevent identiier collisions
// e.g. pcmux::pc_plus4 and regfilemux::pc_plus4 are seperate identifiers
// for seperate enumerated types, you cannot //import rv32i_mux_types::*;
// import pcmux::*;
// import marmux::*;
// import cmpmux::*;
// import alumux::*;
// import regfilemux::*;
// import rs1mux::*;
// import rs2mux::*;
import immediates::*;
(
    input clk, 
    input logic rst,
    input cw_execute ctrl_w_EXE,
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] pc_x,
    input logic [31:0] mem_fwd_data,
    input logic [31:0] exe_fwd_data,
    input logic [31:0] wb_fwd_data,
    input imm imm_in,
    
    output logic [31:0] rs1_out,
    output logic [31:0] rs2_out,
    output logic [31:0] alu_out,
    output logic br_en,
  
    input logic de_exe_valid,
    input logic de_exe_rdy,
    output logic exe_rdy
);
    logic [31:0] rs1_o, rs2_o, alumux1_o, alumux2_o, cmpmux_o;/*, multi_low, multi_high;*/
    cmpmux::cmpmux_sel_t cmp_sel;
    alumux::alumux1_sel_t alumux1_sel;
    alumux::alumux2_sel_t alumux2_sel;
    rs1mux::rs1_sel_t rs1_sel;
    rs2mux::rs2_sel_t rs2_sel;
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
    assign rs1_out = rs1_o;

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

    /*multiplier mutli(
        .rs1(alumux1_o),
        .rs2(alumux2_o),
        .rd_low(multi_low),
        .rd_high(multi_high)
    );*/

    always_comb begin : exe_mux
        unique case (ctrl_w_EXE.rs1_sel)
            2'b00: rs1_o = rs1_data;
            2'b01: rs1_o = exe_fwd_data;
            2'b10: rs1_o = mem_fwd_data;
            2'b11: rs1_o = wb_fwd_data;
        endcase

        unique case (ctrl_w_EXE.rs2_sel)
            2'b00: rs2_o = rs2_data;
            2'b01: rs2_o = exe_fwd_data;
            2'b10: rs2_o = mem_fwd_data;
            2'b11: rs2_o = wb_fwd_data;
        endcase

        unique case (ctrl_w_EXE.cmp_sel)
            cmpmux::rs2_out: cmpmux_o = rs2_o;
            cmpmux::i_imm: cmpmux_o = i_imm;
        endcase

        unique case (ctrl_w_EXE.alumux1_sel)
            alumux::rs1_out: alumux1_o = rs1_o;
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
    end

endmodule : exe_stage