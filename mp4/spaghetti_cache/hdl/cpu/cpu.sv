
module cpu
import rv32i_types::*;
(
    input clk,
    input rst,
    input mem_resp,
    input rv32i_word mem_rdata,
    output logic mem_read,
    output logic mem_write,
    output logic [3:0] mem_byte_enable,
    output rv32i_word mem_address,
    output rv32i_word mem_wdata
);

/******************* Signals Needed for RVFI Monitor *************************/
logic load_pc;
logic load_regfile;
/*****************************************************************************/

/**************************** Control Signals ********************************/
pcmux::pcmux_sel_t pcmux_sel;
alumux::alumux1_sel_t alumux1_sel;
alumux::alumux2_sel_t alumux2_sel;
regfilemux::regfilemux_sel_t regfilemux_sel;
marmux::marmux_sel_t marmux_sel;
cmpmux::cmpmux_sel_t cmpmux_sel;
/*****************************************************************************/

//wires baby
alu_ops aluop;
logic ld_ir, ld_mar, ld_mdr, ld_data_out, br_en;
rv32i_opcode opcode;
rv32i_word mem_addr;
logic [2:0] funct3;
bit [2:0] cmpop;
logic [6:0] funct7;
logic [4:0] rs1, rs2;

/* Instantiate MP 1 top level blocks here */

// Keep control named `control` for RVFI Monitor
control control(
    .clk(clk),
    .rst(rst),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .br_en(br_en),
    .rs1(rs1),
    .rs2(rs2),
    .mem_resp(mem_resp),
    .mem_address(mem_addr),
    .pcmux_sel(pcmux_sel),
    .alumux1_sel(alumux1_sel),
    .alumux2_sel(alumux2_sel),
    .regfilemux_sel(regfilemux_sel),
    .marmux_sel(marmux_sel),
    .cmpmux_sel(cmpmux_sel),
    .aluop(aluop),
    .cmpop(cmpop),
    .load_pc(load_pc),
    .load_ir(ld_ir),
    .load_regfile(load_regfile),
    .load_mar(ld_mar),
    .load_mdr(ld_mdr),
    .load_data_out(ld_data_out),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable),
    .mem_addr(mem_address));

// Keep datapath named `datapath` for RVFI Monitor
datapath datapath(
    .clk(clk),
    .rst(rst),
    .pcmux_sel(pcmux_sel),
    .alumux1_sel(alumux1_sel),
    .alumux2_sel(alumux2_sel),
    .regfilemux_sel(regfilemux_sel),
    .marmux_sel(marmux_sel),
    .cmpmux_sel(cmpmux_sel),
    .aluop(aluop),
    .cmpop(cmpop),
    .load_pc(load_pc),
    .load_ir(ld_ir),
    .load_regfile(load_regfile),
    .load_mar(ld_mar),
    .load_mdr(ld_mdr),
    .load_data_out(ld_data_out),
    .mem_rdata(mem_rdata),
    .mem_wdata(mem_wdata),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .br_en(br_en),
    .rs1(rs1),
    .rs2(rs2),
    .mem_address(mem_addr));

endmodule : cpu
