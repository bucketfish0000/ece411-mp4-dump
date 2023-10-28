module mp4
import rv32i_types::*;
(
    input   logic           clk,
    input   logic           rst,

    // Use these for CP1 (magic memory)
    output  logic   [31:0]  imem_address,
    output  logic           imem_read,
    input   logic   [31:0]  imem_rdata,
    input   logic           imem_resp,
    output  logic   [31:0]  dmem_address,
    output  logic           dmem_read,
    output  logic           dmem_write,
    output  logic   [3:0]   dmem_wmask,
    input   logic   [31:0]  dmem_rdata,
    output  logic   [31:0]  dmem_wdata,
    input   logic           dmem_resp

    // Use these for CP2+ (with caches and burst memory)
    // output  logic   [31:0]  bmem_address,
    // output  logic           bmem_read,
    // output  logic           bmem_write,
    // input   logic   [63:0]  bmem_rdata,
    // output  logic   [63:0]  bmem_wdata,
    // input   logic           bmem_resp
);

            logic           monitor_valid;
            logic   [63:0]  monitor_order;
            logic   [31:0]  monitor_inst;
            logic   [4:0]   monitor_rs1_addr, rs1_address;
            logic   [4:0]   monitor_rs2_addr, rs2_address;
            logic   [31:0]  monitor_rs1_rdata, rs1_rdata;
            logic   [31:0]  monitor_rs2_rdata, rs2_rdata;
            logic   [4:0]   monitor_rd_addr, rd_addr;
            logic   [31:0]  monitor_rd_wdata, rd_wdata;
            logic   [31:0]  monitor_pc_rdata, pc_rdata;
            logic   [31:0]  monitor_pc_wdata, pc_wdata;
            logic   [31:0]  monitor_mem_addr, mem_addr_d;
            logic   [3:0]   monitor_mem_rmask, rmask;
            logic   [3:0]   monitor_mem_wmask, wmask;
            logic   [31:0]  monitor_mem_rdata, mem_rdata_d;
            logic   [31:0]  monitor_mem_wdata, mem_wdata_d;
            pcmux_sel_t pcmux_sel;
            logic if_rdy, de_rdy, exe_rdy, mem_rdy, wb_rdy;
            logic if_valid, de_valid, exe_valid, mem_valid, wb_valid;
            logic if_de_ld, de_exe_ld, exe_mem_ld, mem_wb_ld;
            logic mem_r_d, mem_w_d;
            cw_cpu cpu_ctrl_word;
            cw_execute exe_ctrl_word;
            cw_mem mem_ctrl_word;
            cw_writeback wb_ctrl_word;
            rv32i_opcode opcode;
            logic[2:0] func3;
            logic[6:0] func7;
            logic br_en;


    mp4control control(
        .clk(clk),
        .rst(rst),

        /*---if signals---*/
        //...none?

        /*---de signals---*/
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        //anything else...?

        /*---exe signals---*/
        .br_en(br_en),
        //...anything else?

        /*---mem_stage signals---*/
        .mem_read_D(mem_r_d),
        .mem_write_D(mem_w_d),
        //...anything else?

        /*---ready signals---*/
        .if_rdy(if_rdy),
        .de_rdy(de_rdy),
        .exe_rdy(exe_rdy),
        .mem_rdy(mem_rdy),
        .wb_rdy(wb_rdy),

        /*---valid signals---*/
        .if_valid(if_valid),
        .de_valid(de_valid),
        .exe_valid(exe_valid),
        .mem_valid(mem_valid),
        .wb_valid(wb_valid),

        /*---continue/load signals---*/
        .if_de_ld(if_de_ld),
        .de_exe_ld(de_exe_ld),
        .exe_mem_ld(exe_mem_ld),
        .mem_wb_ld(mem_wb_ld)

        /*---cpu_cw---*/
        .cw_cpu(cpu_ctrl_word), 
        .cw_exe(exe_ctrl_word),
        .cw_memory(mem_ctrl_word),
        .cw_wb(wb_ctrl_word).

        .pcmux_sel(pcmux_sel)
    );

    mp4datapath datapath(
        .clk(clk),
        .rst(rst),

        .icache_resp(imem_resp),
        .dcache_resp(dmem_resp),
        .icache_out(imem_rdata),
        .dcache_out(dmem_rdata),

        .pcmux_sel(pcmux_sel),

        .fet_dec_load(if_de_ld),
        .dec_exe_load(de_exe_ld),
        .exe_mem_load(exe_mem_ld),
        .mem_wb_load(mem_wb_ld),

        //to decode
        .cw_cpu(cpu_ctrl_word), //kinda not using this 
        .cw_exe(exe_ctrl_word),
        .cw_memory(mem_ctrl_word),
        .cw_wb(wb_ctrl_word),

        .opcode(opcode),
        .func3(func3),
        .func7(func7),

        .rs1_addr(rs1_address),
        .rs2_addr(rs2_address),
        .rs1_rdata(rs1_rdata),
        .rs2_rdata(rs2_rdata),
        .rd_addr(rd_addr),
        .rd_wdata(rd_wdata),
        .pc_rdata(pc_rdata),
        .pc_wdata(pc_wdata),

        .br_en(br_en),

        .if_rdy(if_rdy),
        .de_rdy(de_rdy),
        .exe_rdy(exe_rdy),
        .mem_rdy(mem_rdy),
        .wb_rdy(wb_rdy),

        /*---valid signals---*/
        .if_valid(if_valid),
        .de_valid(de_valid),
        .exe_valid(exe_valid),
        .mem_valid(mem_valid),
        .wb_valid(wb_valid),

        .mem_r_d(mem_r_d),
        .mem_w_d(mem_w_d),
        .mem_wdata_d(mem_wdata_d),
        .mem_address_d(mem_addr_d),
        .mem_byte_enable(),

        .rmask(rmask),
        .wmask(wmask)
    );

    
    assign imem_address = ;
    assign imem_read = ;
    assign dmem_address = mem_addr_d;
    assign dmem_read = mem_r_d;
    assign dmem_write = mem_w_d;
    assign dmem_wmask = wmask;
    assign dmem_wdata = mem_wdata_d;

    // Fill this out
    // Only use hierarchical references here for verification
    // **DO NOT** use hierarchical references in the actual design!
    assign monitor_valid     = ; //???
    assign monitor_order     = ; //???
    assign monitor_inst      = imem_rdata; //???
    assign monitor_rs1_addr  = rs1_address;
    assign monitor_rs2_addr  = rs2_address;
    assign monitor_rs1_rdata = rs1_rdata;
    assign monitor_rs2_rdata = rs2_rdata;
    assign monitor_rd_addr   = rd_addr;
    assign monitor_rd_wdata  = rd_wdata;
    assign monitor_pc_rdata  = pc_rdata;
    assign monitor_pc_wdata  = pc_wdata;
    assign monitor_mem_addr  = mem_addr_d;
    assign monitor_mem_rmask = rmask;
    assign monitor_mem_wmask = wmask;
    assign monitor_mem_rdata = dmem_rdata;
    assign monitor_mem_wdata = mem_wdata_d;

endmodule : mp4
