module fetch_stage 
    import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    input logic load,

    input pcmux_sel_t pcmux_sel,
    input rv32i_word exec_fwd_data,
    input rv32i_word instr_in,
    
    output rv32i_word pc,
    
    output rv32i_opcode opcode
    output rv32i_reg rd,
    output rv32i_word i_imm,
    output rv32i_word u_imm,
    output rv32i_word b_imm,
    output rv32i_word s_imm,
    output rv32i_word j_imm
    output rv32i_reg rs1,
    output rv32i_reg rs2,
    output logic[2:0] func3,
    output logic[6:0] func7,
);
    rv32i_word pc_in,pc;
    
    register PC(.*, .in(pc_in),.out(pc));

    //register IR(.*,.in(instr_in),.out(instr_out));

    ir IR(
        .clk(clk),
        .rst(rst),
        .load(load),
        .in(instr_in),
        .funct3(func3),
        .funct7(func7),
        .opcode(opcode),
        .i_imm(i_imm),
        .s_imm(s_imm),
        .b_imm(b_imm),
        .u_imm(u_imm),
        .j_imm(j_imm),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );  

    always_comb begin
        unique case(pcmux_sel)
            pcmux_sel_t::pc_plus4: pc_in = pc+4;
            pcmux_sel_t::alu_out: pc_in = exec_fwd_data;
            pcmux_sel_t::alu_mod2: pc_in = {exec_fwd_date[31:1],1'b0};
        endcase
    end : pc_mux_logic
endmodule : fetch_stage