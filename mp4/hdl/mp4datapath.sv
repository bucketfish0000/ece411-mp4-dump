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
    //output logic imem_read,
    input load_pc,

    input pcmux::pcmux_sel_t pcmux_sel,

    input logic fet_dec_load,
    input logic dec_exe_load,
    input logic exe_mem_load,
    input logic mem_wb_load,

    input control_word cw_dec,

    output control_read cr,

    output rv32i_reg rs1_addr,
    output rv32i_reg rs2_addr,
    output rv32i_word rs1_rdata,
    output rv32i_word rs2_rdata,
    output rv32i_reg rd_addr,
    output rv32i_word rd_wdata,
    output rv32i_word pc_rdata,
    output rv32i_word pc_wdata,

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
    output logic [3:0] rmask, wmask

    // output logic [4:0] rd_addr_sel
);

rv32i_word pc_fetch, pc_decode, pc_exec, pc_mem, pc_wb;
rv32i_word regfilemux_out;
rv32i_reg rd_sel;

// assign rd_addr_sel = rd_sel;

logic  br_en_exe_o, br_en_exe_mem_o, br_en_mem_wb_o;
assign br_en = br_en_exe_o;
logic fetch_ready_i, decode_ready_i,exec_ready_i,mem_ready_i,wb_ready_i;
logic fetch_valid_i, decode_valid_i,exec_valid_i,mem_valid_i,wb_valid_i;
logic fetch_ready_o, decode_ready_o, exec_ready_o, mem_ready_o, wb_ready_o;
logic fetch_valid_o, decode_valid_o, exec_valid_o, mem_valid_o, wb_valid_o;
logic load_reg_wb;

cw_execute cw_exe_from_de_exe;
cw_mem cw_mem_from_de_exe, cw_mem_from_exe_mem;
cw_writeback cw_wb_from_de_exe, cw_wb_from_exe_mem, cw_wb_from_mem_wb;

// logic f_d_ready,d_e_ready,e_m_ready,_m_w_ready;
// logic f_d_valid,d_e_valid,e_m_valid,m_w_valid;

logic [31:0] mem_fwd_data, exe_fwd_data, alu_out_exe, alu_out_mem_wb, rs2_out, rs1_data_decode, rs2_data_decode;

//yes this looks messed up because the naming conventions don't actually work for my(the correct :) ) implementation
//it's on purpose don't touch without asking
assign exe_rdy = exec_ready_o;
assign exe_valid = mem_valid_i;
assign mem_rdy = mem_ready_o;
assign mem_valid = wb_valid_i;

rv32i_opcode opcode_decode;
logic [2:0] func3_decode;
logic [6:0] func7_decode;
assign cr.opcode = opcode_decode;
assign cr.func3 = func3_decode;
assign cr.func7 = func7_decode;

rv32i_word instr_fetch;
//logic load_pc;

assign if_rdy = fetch_ready_o;
assign if_valid = fetch_valid_o;

fetch_stage fetch(
    .clk(clk),
    .rst(rst),
    .icache_resp(icache_resp),
    .load_pc(load_pc), 
    .pcmux_sel(pcmux_sel),
    .exec_fwd_data(exe_fwd_data),                                                                       
    .instr_in(icache_out),
    .pc_out(pc_fetch),
    .pc_next(pc_wdata),
    .instr_out(instr_fetch),
    .ready(fetch_ready_o),
    .valid(fetch_valid_o)
    //.imem_read(imem_read)
    );

rv32i_word instr_decode;
fet_dec_reg fet_dec_reg(
    .clk(clk),.rst(rst),
    .load(fet_dec_load),

    .ready_i(fetch_ready_o),
    .valid_i(fetch_valid_o),
    .ready_o(decode_ready_i),
    .valid_o(decode_valid_i),

    .instr_fetch(instr_fetch),
    .pc_fetch(pc_fetch),
    .instr_decode(instr_decode),
    .pc_decode(pc_decode)
);

imm imm_decode;

decode_stage decode(
    .clk(clk),.rst(rst),
    .reg_load(load_reg_wb),//???
    .rd_data(regfilemux_out),//???
    .rd_sel(rd_sel),//
    .instruction(instr_decode),
    .rs1_o(rs1_addr),
    .rs2_o(rs2_addr),
    .rd_o(rd_addr),
    .rs1_data(rs1_data_decode),
    .rs2_data(rs2_data_decode),
    .opcode(opcode_decode),
    .imm_data(imm_decode),
    .func3(func3_decode),
    .func7(func7_decode),
    .ready_i(decode_ready_i),
    .valid_i(decode_valid_i),
    .ready_o(decode_ready_o),
    .valid_o(decode_valid_o)
);
assign de_rdy = decode_ready_o;
assign de_valid = decode_valid_o;


assign rs1_rdata = rs1_data_decode;
assign rs2_rdata = rs2_data_decode;

assign rd_wdata = regfilemux_out;

rv32i_word rs1_data_exec,rs2_data_exec;
rv32i_opcode opcode_exec;
imm imm_exec;
rv32i_word func3_exec, func7_exec;
control_word cw_exec;
dec_exe_reg dec_exe_reg(
    .clk(clk),
    .rst(rst),
    .load(dec_exe_load),
    .pc_in(pc_decode),
    .imm_in(imm_decode),
    .rs1_data_in(rs1_data_decode),
    .rs2_data_in(rs2_data_decode),

    .ready_i(decode_ready_o),
    .valid_i(decode_valid_o),

    .imm_out(imm_exec),
    .rs1_data_out(rs1_data_exec),
    .rs2_data_out(rs2_data_exec),
    .pc_out(pc_exec),

    .ready_o(exec_ready_i),
    .valid_o(exec_valid_i),

    .cw_in(cw_dec),
    .cw_out(cw_exec)
);

//exexute stage
exe_stage execute(
    .clk(clk), //ins
    .rst(rst),
    .ctrl_w_EXE(cw_exec.exe),
    .rs1_data(rs1_data_exec),
    .rs2_data(rs2_data_exec),
    .pc_x(pc_exec),
    .mem_fwd_data(mem_fwd_data),
    .exe_fwd_data(exe_fwd_data),
    .imm_in(imm_exec),
    .rs2_out(rs2_out), //outs
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
    .rst(rst), //from datapath
    .br_en_i(br_en_exe_o), //from exe_stage
   // .load(),
    .exe_mem_ld(exe_mem_load), //from cpu_ctrl
    .exe_rdy(exec_ready_o),
    .de_exe_valid(exec_valid_i),
    .alu_out_i(alu_out_exe), //from exe_stage
    .exe_pc_x(pc_exec), //from DE_EXE pipeline reg
    .rs2_out_i(rs2_out), //from exe_stage
    .u_imm_i(imm_exec.u_imm), //from DE_EXE pipeline reg
    .ctrl_w_MEM_i(cw_exec.mem), //from DE_EXE pipeline reg
    .ctrl_w_WB_i(cw_exec.wb), //from DE_EXE pipeline reg
    .ctrl_w_MEM_o(cw_mem_from_exe_mem), //to mem_stage / MEM_WB pipeline reg
    .ctrl_w_WB_o(cw_wb_from_exe_mem), //to MEM_WB pipeline reg
    .exe_fwd_data(exe_fwd_data), //to exe_stage / mem_stage / MEM_WB pipeline reg
    .mem_pc_x(pc_exe_mem_reg), //to MEM_WB pipeline reg
    .u_imm_o(u_imm_exec), //to MEM_WB pipeline reg
    .br_en_o(br_en_exe_mem_o), //to ctrl??? / MEM_WB pipeline reg
    .exe_mem_valid(mem_valid_i), //to ctrl / MEM_WB pipeline reg
    .exe_mem_rdy(mem_ready_i), //to MEM_WB pipeline reg

    //include these here bc they need to be loaded at same time as EXE_MEM
    .mem_address_d(mem_address_d), //to data cache
    .mem_wdata_d(mem_wdata_d), //to data cache
    .mem_byte_enable(mem_byte_enable), //to data cache
    .rmask(rmask),
    .wmask(wmask)
);

//memory stage
mem_stage memory(
    .clk(clk), //from datapath
    .rst(rst), //from datapath
    .exe_mem_valid(mem_valid_i), //from EXE_MEM pipeline reg, don't want to accidentally do junk memory operations
    .ctrl_w_MEM(cw_mem_from_exe_mem),//from EXE_MEM pipeline reg
    .mem_resp_d(dcache_resp), //from data_cache
    .mem_r_d(mem_r_d), //to data cache
    .mem_w_d(mem_w_d), //to data cache
    .mem_rdy(mem_ready_o) //to ctrl / MEM_WB reg
);

rv32i_word u_imm_wb;
//mem_wb_reg
mem_wb_reg mem_wb_register(
    .clk(clk),
    .rst(rst),
    .mem_wb_ld(mem_wb_load),
    .mem_rdy(mem_ready_o),
    .alu_out_i(exe_fwd_data), //aka exe_fwd_data
    .br_en_i(br_en_exe_mem_o),
    .mem_pc_x(pc_exe_mem_reg),
    .u_imm_i(u_imm_exec),
    .mem_rdata_D_i(dcache_out),
    .exe_mem_valid(mem_valid_i),
    .ctrl_w_WB_i(cw_wb_from_exe_mem),
    .ctrl_w_WB_o(cw_wb_from_mem_wb),
    .wb_pc_x(pc_wb),
    .u_imm_o(u_imm_wb),
    .mem_rdata_D_o(mem_fwd_data), //aka mem_fwd_data
    .mem_wb_rdy(wb_ready_i),
    .mem_wb_valid(wb_valid_i),
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
    .ir_u_imm(u_imm_wb),
    .mem_data_out(mem_fwd_data),
    .pc_wb(pc_wb),
    .regfilemux_out(regfilemux_out),
    .load_reg(load_reg_wb),
    .rd_sel(rd_sel)
);

assign pc_rdata = pc_wb; 
assign wb_valid = 1'b1;
assign wb_rdy = 1'b1;

endmodule : mp4datapath