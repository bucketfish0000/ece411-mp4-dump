module mp4datapath
    import rv32i_types::*;
    import cpuIO::*;
    import immediates::*;
(
    input logic clk,
    input logic rst,

    input logic icache_resp,
    input logic dcache_resp,
    input rv32i_word icache_out,
    input rv32i_word dcache_out,
    input load_pc,
    //output logic imem_read,

    input pcmux::pcmux_sel_t pcmux_sel,

    input logic fet_dec_rst,
    input logic dec_exe_rst,
    input logic exe_mem_rst,
    input logic mem_wb_rst,

    input logic fet_dec_load,
    input logic dec_exe_load,
    input logic exe_mem_load,
    input logic mem_wb_load,

    input control_word cw_dec,

    output control_read cr,

    output rv32i_opcode opcode_exec,
    output rv32i_word pc_rdata,

    output logic br_en,
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
    output logic [3:0] mem_byte_enable,
    output logic [3:0] wmask,

    output control_word control_rvfi,
    output logic [4:0] rd_addr_o
);

rv32i_word pc_fetch, pc_decode, pc_exec, pc_mem, pc_wb, pc_wdata;
rv32i_word regfilemux_out;
rv32i_reg rd_sel;

assign rd_addr_o = rd_sel;

logic  br_en_exe_o, br_en_exe_mem_o, br_en_mem_wb_o;
assign br_en = br_en_exe_o;
logic decode_ready_i,exec_ready_i,mem_ready_i,wb_ready_i;
logic decode_valid_i,exec_valid_i,mem_valid_i,wb_valid_i;
logic fetch_ready_o, decode_ready_o, exec_ready_o, mem_ready_o, wb_ready_o;
logic fetch_valid_o, decode_valid_o;
logic load_reg_wb;
logic [63:0] commit_order_decode_i;

control_word cw_exec, cw_mem, cw_wb;

// logic f_d_ready,d_e_ready,e_m_ready,_m_w_ready;
// logic f_d_valid,d_e_valid,e_m_valid,m_w_valid;

logic [31:0] mem_fwd_data, exe_fwd_data, wb_fwd_data, alu_out_exe, alu_out_mem_wb, rs1_out, rs2_out, rs1_data_decode, rs2_data_decode, mem_rdata;

//yes this looks messed up because the naming conventions don't actually work for my(the correct :) ) implementation
//it's on purpose don't touch without asking
assign exe_rdy = exec_ready_o;
assign exe_valid = mem_valid_i;
assign mem_rdy = mem_ready_o;
assign mem_valid = wb_valid_i;
assign de_valid = exec_valid_i;
assign if_valid = decode_valid_i;



rv32i_word instr_fetch, pc_prev;
//logic load_pc;

assign if_rdy = fetch_ready_o;

fetch_stage fetch(
    .clk(clk),
    .rst(rst),
    .icache_resp(icache_resp),
    .load_pc(load_pc), 
    .pcmux_sel(pcmux_sel),
    .exec_fwd_data(exe_fwd_data),                                                                       
    .instr_in(icache_out),
    .pc_out(pc_fetch),
    // .pc_prev(pc_prev),
    .pc_next(pc_wdata),
    .instr_out(instr_fetch),
    .ready(fetch_ready_o)
    //.imem_read(imem_read)
    );

assign pc_rdata = pc_fetch;

rv32i_word instr_decode, pc_wdata_decode;
fet_dec_reg fet_dec_reg(
    .clk(clk),.rst(fet_dec_rst),
    .load(fet_dec_load),

    .ready_i(fetch_ready_o),
    .ready_o(decode_ready_i),
    .valid_o(decode_valid_i),

    .instr_fetch(instr_fetch),
    .pc_fetch(pc_fetch),
    .pc_wdata(pc_wdata),
    .instr_decode(instr_decode),
    .pc_decode(pc_decode),
    .pc_wdata_decode(pc_wdata_decode),

    .commit_order(commit_order_decode_i)
);

imm imm_decode;

decode_stage decode(
    .clk(clk),.rst(rst),
    .reg_load(load_reg_wb),
    .rd_data(regfilemux_out),
    .rd_sel(rd_sel),

    .instruction(instr_decode),
    .pc_rdata(pc_decode),
    .pc_wdata(pc_wdata_decode),
    .commit_order(commit_order_decode_i),

    .imm_data(imm_decode),

    .ready_i(decode_ready_i),
    .valid_i(decode_valid_i),
    .ready_o(decode_ready_o),

    .cr(cr)
);
assign de_rdy = decode_ready_o;

rv32i_word rs1_data_exec,rs2_data_exec;
imm imm_exec;
rv32i_word func3_exec, func7_exec;
dec_exe_reg dec_exe_reg(
    .clk(clk),
    .rst(dec_exe_rst),
    .load(dec_exe_load),
    .imm_in(imm_decode),

    .imm_out(imm_exec),

    .valid_i(decode_valid_i),
    .ready_i(decode_ready_o),

    .ready_o(exec_ready_i),
    .valid_o(exec_valid_i),

    .opcode_dec(cr.opcode),
    .opcode_dec_exe(opcode_exec),
    .cw_in(cw_dec),
    .cw_out(cw_exec)
);

//exexute stage
exe_stage execute(
    .clk(clk), //ins
    .rst(rst),
    .ctrl_w_EXE(cw_exec.exe),
    .rs1_data(cw_exec.rvfi.rs1_data),
    .rs2_data(cw_exec.rvfi.rs2_data),
    .pc_x(cw_exec.rvfi.pc_rdata),
    .mem_fwd_data(mem_fwd_data),
    .exe_fwd_data(exe_fwd_data),
    .wb_fwd_data(wb_fwd_data),
    .imm_in(imm_exec),
    .rs1_out(rs1_out), //outs
    .rs2_out(rs2_out),
    .alu_out(alu_out_exe),
    .br_en(br_en_exe_o),


    .de_exe_valid(exec_valid_i),
    .de_exe_rdy(exec_ready_i),
    .exe_rdy(exec_ready_o)
);

rv32i_word u_imm_exec;
rv32i_word pc_exe_mem_reg;
//exe_mem_reg
exe_mem_reg exe_mem_register(
    .clk(clk), //from datapath
    .rst(exe_mem_rst), //from datapath

    .br_en_i(br_en_exe_o), //from exe_stage
    .exe_mem_ld(exe_mem_load), //from cpu_ctrl
    .exe_rdy(exec_ready_o),
    .de_exe_valid(exec_valid_i),
    .alu_out_i(alu_out_exe), //from exe_stage
    .rs1_out_i(rs1_out), //from exe_stage
    .rs2_out_i(rs2_out), //from exe_stage
    .u_imm_i(imm_exec.u_imm), //from DE_EXE pipeline reg

    .exe_fwd_data(exe_fwd_data), //to exe_stage / mem_stage / MEM_WB pipeline reg
    .u_imm_o(u_imm_exec), //to MEM_WB pipeline reg
    .br_en_o(br_en_exe_mem_o), //to ctrl??? / MEM_WB pipeline reg
    .exe_mem_valid(mem_valid_i), //to ctrl / MEM_WB pipeline reg
    .exe_mem_rdy(mem_ready_i), //to MEM_WB pipeline reg

    //include these here bc they need to be loaded at same time as EXE_MEM
    .mem_address_d(mem_address_d), //to data cache
    .mem_wdata_d(mem_wdata_d), //to data cache
    .mem_byte_enable(mem_byte_enable), //to data cache

    .cw_in(cw_exec),
    .cw_out(cw_mem),

    .wmask(wmask)
);

//memory stage
mem_stage memory(
    .clk(clk), //from datapath
    .rst(rst), //from datapath
    .exe_mem_valid(mem_valid_i), //from EXE_MEM pipeline reg, don't want to accidentally do junk memory operations
    .ctrl_w_MEM(cw_mem.mem),//from EXE_MEM pipeline reg
    .mem_resp_d(dcache_resp), //from data_cache
    .mem_r_d(mem_r_d), //to data cache
    .mem_w_d(mem_w_d), //to data cache
    .mem_rdy(mem_ready_o) //to ctrl / MEM_WB reg
);

rv32i_word u_imm_wb;
//mem_wb_reg
mem_wb_reg mem_wb_register(
    .clk(clk),
    .rst(mem_wb_rst),
    .mem_wb_ld(mem_wb_load),
    .mem_rdy(mem_ready_o),
    .alu_out_i(exe_fwd_data), //aka exe_fwd_data
    .br_en_i(br_en_exe_mem_o),
    .u_imm_i(u_imm_exec),
    .mem_rdata_D_i(dcache_out),
    .exe_mem_valid(mem_valid_i),
    .u_imm_o(u_imm_wb),
    .mem_rdata_D_o(mem_rdata),
    .mem_fwd_data(mem_fwd_data),
    .mem_wb_rdy(wb_ready_i),
    .mem_wb_valid(wb_valid_i),
    .alu_out_o(alu_out_mem_wb),
    .br_en_o(br_en_mem_wb_o),

    .cw_in(cw_mem),
    .cw_out(cw_wb)
);

//writeback stage, what is going on in here???
wb_stage writeback(
    .clk(clk),
    .rst(rst),
    .alu_out(alu_out_mem_wb),
    .br_en(br_en_mem_wb_o), 
    .ir_u_imm(u_imm_wb),
    .mem_data_out(mem_rdata),
    .mem_wb_rdy(wb_ready_i),
    .mem_wb_valid(wb_valid_i),

    .regfilemux_out(regfilemux_out),
    .load_reg(load_reg_wb),
    .rd_sel(rd_sel),

    .cw_in(cw_wb),
    .cw_out_rvfi(control_rvfi)
);

assign wb_valid = wb_valid_i;
assign wb_rdy = 1'b1;

wb_fwd_reg wb_fwding_reg(
    .clk(clk),
    .rst(rst),
    .load_wb_fwd_reg(mem_wb_load),
    .wb_fwd_data_i(regfilemux_out),

    .wb_fwd_data_o(wb_fwd_data)
);

endmodule : mp4datapath