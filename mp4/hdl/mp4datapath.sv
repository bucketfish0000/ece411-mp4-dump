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

    //to decode
    input control_word cw_cpu, //kinda not using this 
    input cw_execute cw_exe,
    input cw_mem cw_memory,
    input cw_writeback cw_wb,

    output logic if_rdy,
    output logic de_rdy,
    output logic exe_rdy,
    output logic mem_rdy,
    output logic wb_rdy,

    /*---valid signals---*/
    output logic if_valid,
    output logic de_valid,
    output logic exe_valid,
    output logic mem_valid,
    output logic wb_valid,

    output logic mem_r_d,
    output logic mem_w_d,
    output rv32i_word mem_wdata_d,
    output rv32i_word mem_address_d,
    output logic [3:0] mem_byte_enable
);

rv32i_word pc_fetch, pc_decode, pc_exec, pc_mem, pc_wb;
logic fetch_ready,decode_ready, exec_ready, mem_ready, wb_ready, exe_mem_rdy, exe_mem_valid, mem_wb_rdy, mem_wb_valid, br_en_exe_o,
br_en_exe_mem_o, br_en_mem_wb_o;
logic [31:0] mem_fwd_data, exe_fwd_data, alu_out_exe, alu_out_mem_wb, rs2_out, rs1_data, rs2_data, mem_address_d, mem_wdata_d;
logic [3:0] mem_byte_enable
cw_execute cw_exe_from_de_exe;
cw_mem cw_mem_from_de_exe, cw_mem_from_exe_mem;
cw_writeback cw_wb_from_de_exe, cw_wb_from_exe_mem, cw_wb_from_mem_wb;

assign exe_rdy = exec_ready;
assign exe_valid = exe_mem_valid;
assign mem_rdy = mem_ready;
assign mem_valid = mem_wb_valid;

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
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .opcode(),
    .imm(),
    .func3(),
    .func7(),
    .ready(decode_ready)
);

//de_exe_reg

//exexute stage
exe_stage execute(
    .clk(clk), //ins
    .rst(rst),
    .ctrl_w_EXE(cw_exe_from_de_exe),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .pc_x(),
    .mem_fwd_data(mem_fwd_data),
    .exe_fwd_data(exe_fwd_data),
    .i_imm(),
    .s_imm(),
    .b_imm(),
    .u_imm(),
    .j_imm(),
    .rs2_out(rs2_out), //outs
    .alu_out(alu_out_exe),
    .br_en(br_en_exe_o),
    .exe_rdy(exec_ready) //to ctrl / EXE_MEM reg
);

//exe_mem_reg
exe_mem_reg exe_mem_register(
    .clk(clk), //from datapath
    .rst(rst), //from datapath
    .br_en_i(br_en_exe_o), //from exe_stage
    .exe_mem_ld(exe_mem_load), //from cpu_ctrl
    .exe_rdy(exec_ready),
    .de_exe_valid(),
    .alu_out_i(alu_out_exe), //from exe_stage
    .exe_pc_x(), //from DE_EXE pipeline reg
    .rs2_out_i(rs2_out), //from exe_stage
    .u_imm_i(), //from DE_EXE pipeline reg
    .ctrl_w_MEM_i(cw_mem_from_de_exe), //from DE_EXE pipeline reg
    .ctrl_w_WB_i(cw_wb_from_de_exe), //from DE_EXE pipeline reg
    .ctrl_w_MEM_o(cw_mem_from_exe_mem), //to mem_stage / MEM_WB pipeline reg
    .ctrl_w_WB_o(cw_wb_from_exe_mem), //to MEM_WB pipeline reg
    .exe_fwd_data(exe_fwd_data), //to exe_stage / mem_stage / MEM_WB pipeline reg
    .mem_pc_x(), //to MEM_WB pipeline reg
    .u_imm_o(), //to MEM_WB pipeline reg
    .br_en_o(br_en_exe_mem_o), //to ctrl??? / MEM_WB pipeline reg
    .exe_mem_valid(exe_mem_valid), //to ctrl / MEM_WB pipeline reg
    .exe_mem_rdy(exe_mem_rdy), //to MEM_WB pipeline reg

    //include these here bc they need to be loaded at same time as EXE_MEM
    .mem_address_d(mem_address_d), //to data cache
    .mem_wdata_d(mem_wdata_d), //to data cache
    .mem_byte_enable(mem_byte_enable) //to data cache
);

//memory stage
mem_stage memory(
    .clk(clk), //from datapath
    .rst(rst), //from datapath
    .exe_mem_valid(exe_mem_valid), //from EXE_MEM pipeline reg, don't want to accidentally do junk memory operations
    .ctrl_w_MEM(cw_mem_from_exe_mem),//from EXE_MEM pipeline reg
    .mem_resp_d(mem_rsp_d), //from data_cache
    .mem_r_d(mem_r_d), //to data cache
    .mem_w_d(mem_w_d), //to data cache
    .mem_rdy(mem_ready) //to ctrl / MEM_WB reg
);

//mem_wb_reg
mem_wb_reg mem_wb_register(
    .clk(clk),
    .rst(rst),
    .mem_wb_ld(mem_wb_load),
    .mem_rdy(mem_ready),
    .alu_out_i(exe_fwd_data), //aka exe_fwd_data
    .br_en_i(br_en_exe_mem_o),
    .mem_pc_x(),
    .u_imm_i(),
    .mem_rdata_D_i(),
    .exe_mem_valid(exe_mem_valid),
    .ctrl_w_WB_i(cw_wb_from_exe_mem),
    .ctrl_w_WB_o(cw_wb_from_mem_wb),
    .wb_pc_x(),
    .u_imm_o(),
    .mem_rdata_D_o(mem_fwd_data), //aka mem_fwd_data
    .mem_wb_rdy(mem_wb_rdy),
    .mem_wb_valid(mem_wb_valid),
    .alu_out_o(alu_out_mem_wb),
    .br_en_o(br_en_mem_wb_o)
);

//writeback stage, what is going on in here???
wb_stage writeback(
    .clk(clk),
    .rst(rst),
    .ctrl_w_WB(cw_wb_from_mem_wb),
    .alu_out(alu_out_mem_wb),
    .br_en(br_en_mem_wb_o), 
);

endmodule : mp4datapath

