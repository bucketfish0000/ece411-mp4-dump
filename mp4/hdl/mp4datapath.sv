module mp4datapath
    import rv32i_type::*;
    import cpuIO::*;
    import immediates::*;
(
    input logic clk,
    input logic rst,

    input logic icache_resp,
    input logic dcache_resp,
    input rv32i_word icache_out,
    input rv32i_word dcache_out,

    input pcmux_sel_t pcmux_sel,

    input logic fet_dec_load,
    input logic dec_exe_load,
    input logic exe_mem_load,
    input logic mem_wb_load,
);

rv32i_word pc_fetch, pc_decode, pc_exec, pc_mem, pc_wb;
logic fetch_ready,decode_ready, exec_ready, mem_ready, wb_ready;

rv32i_word instr_fetch;

fetch_stage fetch(
    .clk(clk),.rst(rst),
    .icache_resp(icache_resp),
    .pcmux_sel(pcmux_sel),
    .exec_fwd_data(/*???*/),
    .instr_in(icache_out),
    .pc_out(pc_fetch),
    .instr_out(instr_fetch),
    .ready(fetch_ready)
    );

rv32i_word instr_decode;

fet_dec_reg fet_dec_reg(
    .clk(clk),.rst(rst),
    .load(fet_dec_load),
    .instr_fetch(instr_fetch),
    .pc_fetch(pc_fetch),
    .instr_decode(instr_decode),
    .pc_decode(pc_decode)
);

decode_stage decode(
    .clk(clk),.rst(rst),
    .reg_load(),//???
    .rd_data(),//???
    .rd_sel(),//
    .instruction(instr_decode),
    .rs1_data(),
    .rs2_data(),
    .opcode(),
    .imm(),
    .func3(),
    .func7(),
    .ready(decode_ready)
);

endmodule : mp4datapath

