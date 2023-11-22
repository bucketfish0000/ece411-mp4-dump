module datapath
import rv32i_types::*;
(
    input clk,
    input rst,
    input pcmux::pcmux_sel_t pcmux_sel, //added
    input alumux::alumux1_sel_t alumux1_sel, //added
    input alumux::alumux2_sel_t alumux2_sel, //added
    input regfilemux::regfilemux_sel_t regfilemux_sel, //added
    input marmux::marmux_sel_t marmux_sel, //added
    input cmpmux::cmpmux_sel_t cmpmux_sel, //added
    input alu_ops aluop, //added
    input bit [2:0] cmpop, //added
    input logic load_pc, //added
    input logic load_ir, //added
    input logic load_regfile, //added
    input logic load_mar, //added
    input logic load_mdr,
    input logic load_data_out, //added
    input rv32i_word mem_rdata,
    output rv32i_word mem_wdata, // signal used by RVFI Monitor
    output rv32i_opcode opcode, //added
    output logic [2:0] funct3, //added
    output logic [6:0] funct7, //added
    output logic br_en, //added
    output logic [4:0] rs1, //added
    output logic [4:0] rs2, //added
    output logic [31:0] mem_address
    /* You will need to connect more signals to your datapath module*/
);

/******************* Signals Needed for RVFI Monitor *************************/
rv32i_word pcmux_out;
rv32i_word mdrreg_out;
/*****************************************************************************/


/***************************** Registers *************************************/
// Keep Instruction register named `IR` for RVFI Monitor
logic [2:0] funct3_ir_o;
logic [6:0] funct7_ir_o;
rv32i_opcode opcode_ir_o;
rv32i_word marmux_o, cmpmux_o, alumux1_o, alumux2_o, regfilemux_out;
logic [31:0] i_imm_ir_o, s_imm_ir_o, b_imm_ir_o, u_imm_ir_o, j_imm_ir_o,
rs1_out, rs2_out, alu_o, pc_out, mar_o, sext_b_o, sext_h_o, mem_addr_o;
logic [4:0] rs1_ir_o, rs2_ir_o, rd;
logic br_en_o;

assign opcode = opcode_ir_o;
assign funct3 = funct3_ir_o;
assign funct7 = funct7_ir_o;
assign rs1 = rs1_ir_o;
assign rs2 = rs2_ir_o;
assign br_en = br_en_o;
assign mem_address = mem_addr_o;

ir IR(
    .clk(clk), //in
    .rst(rst), //in
    .load(load_ir), //in from control
    .in(mdrreg_out), //in from mdr
    .funct3(funct3_ir_o), //out
    .funct7(funct7_ir_o), //out
    .opcode(opcode_ir_o), //out
    .i_imm(i_imm_ir_o), //out
    .s_imm(s_imm_ir_o), //out
    .b_imm(b_imm_ir_o), //out
    .u_imm(u_imm_ir_o), //out
    .j_imm(j_imm_ir_o), //out
    .rs1(rs1_ir_o), //out to regfile
    .rs2(rs2_ir_o), //out to regfile
    .rd(rd) //out to regfile
);

logic [31:0] mdr;
always_ff @( posedge clk ) begin : mdr_ff
    if (rst) begin
        mdr <= '0;
    end else if (load_mdr) begin
        mdr <= mem_rdata;
    end
end : mdr_ff
assign mdrreg_out = mdr;

regfile REGFILE(
    .clk(clk), //in
    .rst(rst), //in
    .load(load_regfile), //in from control
    .in(regfilemux_out), //in
    .src_a(rs1_ir_o), //in
    .src_b(rs2_ir_o), //in
    .dest(rd), //in
    .reg_a(rs1_out), //out
    .reg_b(rs2_out) //out
);

pc PC(
    .clk(clk), //in
    .reset(rst), //in
    .load_pc(load_pc), //in from control
    .pc_in(pcmux_out), // in from pcmux
    .pc_out(pc_out) //out
);

mar MAR(
    .clk(clk), //in
    .reset(rst), //in
    .load_mar(load_mar), //in from control
    .mar_in(marmux_o), //in from marmux
    .mar_out(mem_addr_o) //out to top level
);

mem_data_out MDO(
    .clk(clk), //in
    .reset(rst), //in
    .load_data_out(load_data_out), //in from control
    .mdo_in(rs2_out << ((mem_addr_o % 4)*8)), //in
    .mdo_out(mem_wdata) //out
);

/*****************************************************************************/

/******************************* ALU and CMP *********************************/
alu ALU(
    .aluop(aluop), //in from control
    .a(alumux1_o), //in from alumux1
    .b(alumux2_o), //in from alumux2
    .f(alu_o) //out
);

branch_funct3_t cmpoppy;
always_comb begin
    $cast(cmpoppy, cmpop);
end

cmp CMP(
    .cmpop(cmpoppy), //in from ir funct3
    .a(rs1_out), //in from rs1 regfile
    .b(cmpmux_o), //in from cmpmux
    .br_en(br_en_o) //out
);

/*****************************************************************************/

/***************************** Sign Extenders ********************************/

logic [7:0] sext_b_i;
logic [15:0] sext_h_i;

always_comb begin
    if((mem_addr_o % 4) == 0) begin
        sext_b_i = mdrreg_out[7:0];
        sext_h_i = mdrreg_out[15:0];
    end
    else if((mem_addr_o % 4) == 1) begin
        sext_b_i = mdrreg_out[15:8];
        sext_h_i = mdrreg_out[15:0];
    end
    else if((mem_addr_o % 4) == 2) begin
        sext_b_i = mdrreg_out[23:16];
        sext_h_i = mdrreg_out[31:16];
    end
    else begin
        sext_b_i = mdrreg_out[31:24];
        sext_h_i = mdrreg_out[31:16];
    end
end

sext_b SEXT_B(
    .in(sext_b_i),
    .out(sext_b_o)
);

sext_h SEXT_H(
    .in(sext_h_i),
    .out(sext_h_o)
);

/*****************************************************************************/

/******************************** Muxes **************************************/
always_comb begin : MUXES
    // We provide one (incomplete) example of a mux instantiated using
    // a case statement.  Using enumerated types rather than bit vectors
    // provides compile time type safety.  Defensive programming is extremely
    // useful in SystemVerilog. 
    unique case (pcmux_sel) // correct???
        pcmux::pc_plus4: pcmux_out = pc_out + 4;
        pcmux::alu_out: pcmux_out = alu_o;
        pcmux::alu_mod2: pcmux_out = {alu_o[31:1], 1'b0}; 
    endcase

    unique case (marmux_sel)
        marmux::pc_out: marmux_o = pc_out;
        marmux::alu_out: marmux_o = alu_o;
    endcase

    unique case (cmpmux_sel)
        cmpmux::rs2_out: cmpmux_o = rs2_out;
        cmpmux::i_imm: cmpmux_o = i_imm_ir_o;
    endcase

    unique case (alumux1_sel)
        alumux::rs1_out: alumux1_o = rs1_out;
        alumux::pc_out: alumux1_o = pc_out;
    endcase

    unique case (alumux2_sel)
        alumux::i_imm: alumux2_o = i_imm_ir_o;
        alumux::u_imm: alumux2_o = u_imm_ir_o;
        alumux::b_imm: alumux2_o = b_imm_ir_o;
        alumux::s_imm: alumux2_o = s_imm_ir_o;
        alumux::j_imm: alumux2_o = j_imm_ir_o;
        alumux::rs2_out: alumux2_o = rs2_out;
    endcase

    unique case (regfilemux_sel)//correct???
        regfilemux::alu_out: regfilemux_out = alu_o;
        regfilemux::br_en: regfilemux_out = {31'b0000000000000000000000000000000, br_en_o};
        regfilemux::u_imm: regfilemux_out = u_imm_ir_o;
        regfilemux::lw: regfilemux_out = mdrreg_out;
        regfilemux::pc_plus4: regfilemux_out = pc_out + 4;
        regfilemux::lb: regfilemux_out = sext_b_o;
        regfilemux::lbu: regfilemux_out = {24'b000000000000000000000000, sext_b_i};
        regfilemux::lh: regfilemux_out = sext_h_o;
        regfilemux::lhu: regfilemux_out = {16'b0000000000000000, sext_h_i};
    endcase
end
/*****************************************************************************/

endmodule : datapath
