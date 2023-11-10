module mp4
import rv32i_types::*;
import rv32i_cache_types::*; 

import cpuIO::*;
(
    input   logic           clk,
    input   logic           rst,

    // Use these for CP1 (magic memory)
    // output  logic   [31:0]  imem_address,
    // output  logic           imem_read,
    // input   logic   [31:0]  imem_rdata,
    // input   logic           imem_resp,
    // output  logic   [31:0]  dmem_address,
    // output  logic           dmem_read,
    // output  logic           dmem_write,
    // output  logic   [3:0]   dmem_wmask,
    // input   logic   [31:0]  dmem_rdata,
    // output  logic   [31:0]  dmem_wdata,
    // input   logic           dmem_resp

    // Use these for CP2+ (with caches and burst memory)
    output  logic   [31:0]  bmem_address,
    output  logic           bmem_read,
    output  logic           bmem_write,
    input   logic   [63:0]  bmem_rdata,
    output  logic   [63:0]  bmem_wdata,
    input   logic           bmem_resp
);
/*                             256bit                        32bit word
          64bit              cacheline        -> icache    -> word adapter -> cpu datapath fetch
    memory <-> cacheline adapter <-> arbiter  
                                             <->  dcache  <-> word adapter <-> cpu datapath memory 
*/


            // imem and dmem signals to cpu datapath 
            logic   [31:0]  imem_address;           //word aligned to cpu 
            logic   [31:0]  cacheline_imem_address; //cacheline aligned to cache
            logic           imem_read;
            logic   [31:0]  imem_rdata;
            rv32i_cache_types::rv32i_cacheline imem_cacheline_rdata;
            logic           imem_resp;
            logic   [31:0]  dmem_address;           //word aligned 
            logic   [31:0]  cacheline_dmem_address; //cacheline aligned 
            logic           dmem_read;
            logic           dmem_write;
            logic   [3:0]   dmem_wmask;
            logic   [31:0]  dmem_rdata;
            rv32i_cache_types::rv32i_cacheline dmem_cacheline_rdata; 
            logic   [31:0]  dmem_wdata;
            rv32i_cache_types::rv32i_cacheline dmem_cacheline_wdata; 
            logic           dmem_resp;

            rv32i_cache_types::rv32i_cacheline cacheline_wdata_mem;
            rv32i_cache_types::rv32i_cacheline cacheline_rdata_mem;
            rv32i_word cacheline_mem_address;
            logic cacheline_resp, cacheline_read, cacheline_write; 

            //imem and dmem signals to arbiter mem 
            rv32i_word arbiter_cacheline_dmem_address;
            rv32i_cache_types::rv32i_cacheline arbiter_dmem_cacheline_rdata; 
            rv32i_cache_types::rv32i_cacheline arbiter_dmem_cacheline_wdata; 
            logic arbiter_dmem_resp, arbiter_cacheline_dmem_write, arbiter_cacheline_dmem_read; 

            rv32i_word arbiter_cacheline_imem_address;
            rv32i_cache_types::rv32i_cacheline arbiter_imem_cacheline_rdata; 
            logic arbiter_imem_resp, arbiter_cacheline_imem_read; 

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
            pcmux::pcmux_sel_t pcmux_sel;
            logic if_rdy, de_rdy, exe_rdy, mem_rdy, wb_rdy;
            logic if_valid, de_valid, exe_valid, mem_valid, wb_valid;
            logic if_de_ld, de_exe_ld, exe_mem_ld, mem_wb_ld;
            logic if_de_rst, de_exe_rst, exe_mem_rst, mem_wb_rst;
            logic mem_r_d, mem_w_d;
            logic br_en;
            logic [3:0] mem_byte_enable; 
            logic [31:0] cacheline_mem_byte_enable;
            control_read ctrl_rd;
            logic load_pc;
            control_word cw_control, ctrl_rvfi;
            rv32i_opcode opcode_exec;
    
    mp4control control(
        .clk(clk),
        .rst(rst),

        /*---if signals---*/
        //none...?
        .load_pc(load_pc),
        .imem_read(imem_read),
        .icache_resp(imem_resp),
        /*---de signals... none?---*/

        /*---exe signals---*/
        .br_en(br_en),
        //...anything else?

        /*---mem_stage signals---*/
        .mem_read_D(mem_r_d),
        .mem_write_D(mem_w_d),
        //...anything else?

        .opcode_exec(opcode_exec),
        .if_de_rst(if_de_rst),
        .de_exe_rst(de_exe_rst),
        .exe_mem_rst(exe_mem_rst),
        .mem_wb_rst(mem_wb_rst),

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
        .mem_wb_ld(mem_wb_ld),

        /*---cpu_cw---*/
        .cw_read(ctrl_rd), 
        .ctrl_word(cw_control),

        .pcmux_sel(pcmux_sel)      
    );

    cache dcache0(
        .clk(clk), .rst(rst),
        .mem_address(dmem_address), //cpu datapath 
        .mem_read(dmem_read), 
        .mem_write(dmem_write), 
        .mem_byte_enable(cacheline_mem_byte_enable),
        .mem_rdata(dmem_cacheline_rdata), 
        .mem_wdata(dmem_cacheline_wdata), 
        .mem_resp(dmem_resp), 

        .pmem_address(arbiter_cacheline_dmem_address), //arbiter
        .pmem_read(arbiter_cacheline_dmem_read), 
        .pmem_write(arbiter_cacheline_dmem_write), 
        .pmem_rdata(arbiter_dmem_cacheline_wdata), 
        .pmem_wdata(arbiter_dmem_cacheline_wdata), 
        .pmem_resp(arbiter_dmem_resp)
    );

    cache icache0(
        .clk(clk), .rst(rst),
        .mem_address(imem_address),  // cpu datapath 
        .mem_read(imem_read), 
        .mem_write(1'b0), 
        .mem_byte_enable(),
        .mem_rdata(imem_cacheline_rdata), 
        .mem_wdata(), 
        .mem_resp(imem_resp), 

        .pmem_address(arbiter_cacheline_imem_address), //arbiter 
        .pmem_read(arbiter_cacheline_imem_read), 
        .pmem_write(), 
        .pmem_rdata(arbiter_imem_cacheline_rdata), 
        .pmem_wdata(), 
        .pmem_resp(arbiter_imem_resp)
    );
    cacheline_adaptor cacheline_adaptor(
        .clk(clk), .reset_n(~rst),
        .line_i(cacheline_wdata_mem),          //cache
        .line_o(cacheline_rdata_mem),
        .address_i(cacheline_mem_address),
        .read_i(cacheline_read),
        .write_i(cacheline_write),
        .resp_o(cacheline_resp),

        .burst_i(bmem_rdata),         //memory
        .burst_o(bmem_wdata), 
        .address_o(bmem_address), 
        .read_o(bmem_read), 
        .write_o(bmem_write),
        .resp_i(bmem_resp)
    );

    cache_arbiter cache_arbiter(
        .clk(clk), .reset(rst),
        .icache_addr(arbiter_cacheline_imem_address),            //interface with icache
        .icache_read(arbiter_cacheline_imem_read),
        .icache_data(arbiter_imem_cacheline_rdata), 
        .icache_resp(arbiter_imem_resp), 

        .dcache_addr(arbiter_cacheline_dmem_address),  //interface with dcache 
        .dcache_read(arbiter_cacheline_dmem_read),
        .dcache_write(arbiter_cacheline_dmem_write),
        .dcache_data_r(arbiter_dmem_cacheline_rdata), 
        .dcache_data_w(arbiter_dmem_cacheline_wdata), 
        .dcache_resp(arbiter_dmem_resp), 
        
        .mem_data_r(cacheline_rdata_mem),               // interface with cacheline adapter 
        .mem_resp(cacheline_resp), 
        .mem_addr(cacheline_mem_address),    
        .mem_data_w(cacheline_wdata_mem), 
        .mem_read(cacheline_read), 
        .mem_write(cacheline_write)
    );

    mem_word_adapter imem_word_adapter(
        .clk(clk), .rst(rst),
        .mem_address(imem_address), 
        .cacheline_mem_address(cacheline_imem_address), 
        .cacheline_rdata(imem_cacheline_rdata), 
        .cacheline_wdata(), 
        .mem_wdata(), 
        .mem_rdata(imem_rdata), 
        .mem_byte_enable(), 
        .cacheline_mem_byte_enable()
    );

    mem_word_adapter dmem_word_adapter(
        .clk(clk), .rst(rst),
        .mem_address(dmem_address), 
        .cacheline_mem_address(cacheline_dmem_address), 
        .cacheline_rdata(dmem_cacheline_rdata), 
        .cacheline_wdata(dmem_cacheline_wdata), 
        .mem_wdata(dmem_wdata), 
        .mem_rdata(dmem_rdata), 
        .mem_byte_enable(mem_byte_enable), 
        .cacheline_mem_byte_enable(cacheline_mem_byte_enable)
    );

    mp4datapath datapath(
        .clk(clk),
        .rst(rst),

        .icache_resp(imem_resp),
        .dcache_resp(dmem_resp),
        .icache_out(imem_rdata),
        .dcache_out(dmem_rdata),
        .load_pc(load_pc),
        //.imem_read(imem_read),
        .pcmux_sel(pcmux_sel),

        .fet_dec_load(if_de_ld),
        .dec_exe_load(de_exe_ld),
        .exe_mem_load(exe_mem_ld),
        .mem_wb_load(mem_wb_ld),

        .fet_dec_rst(if_de_rst),
        .dec_exe_rst(de_exe_rst),
        .exe_mem_rst(exe_mem_rst),
        .mem_wb_rst(mem_wb_rst),

        //to decode
        .cw_dec(cw_control),
        .cr(ctrl_rd),

        .opcode_exec(opcode_exec),
        .pc_rdata(pc_rdata),

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
        .mem_byte_enable(mem_byte_enable),

        .wmask(wmask),

        .control_rvfi(ctrl_rvfi),
        .rd_addr_o(rd_addr)
    );

    assign imem_address = pc_rdata;
    //assign imem_read = imem_read;
    assign dmem_address = mem_addr_d;
    assign dmem_read = mem_r_d;
    assign dmem_write = mem_w_d;
    assign dmem_wmask = wmask;
    assign dmem_wdata = mem_wdata_d;

    // Fill this out
    // Only use hierarchical references here for verification
    // **DO NOT** use hierarchical references in the actual design!
    assign monitor_valid     = ctrl_rvfi.rvfi.valid_commit; //???
    assign monitor_order     = ctrl_rvfi.rvfi.order_commit; //???
    assign monitor_inst      = ctrl_rvfi.rvfi.instruction; //???
    assign monitor_rs1_addr  = ctrl_rvfi.rvfi.rs1_addr;
    assign monitor_rs2_addr  = ctrl_rvfi.rvfi.rs2_addr;
    assign monitor_rs1_rdata = ctrl_rvfi.rvfi.rs1_data;
    assign monitor_rs2_rdata = ctrl_rvfi.rvfi.rs2_data;
    assign monitor_rd_addr   = rd_addr;
    assign monitor_rd_wdata  = ctrl_rvfi.rvfi.rd_wdata;
    assign monitor_pc_rdata  = ctrl_rvfi.rvfi.pc_rdata;
    assign monitor_pc_wdata  = ctrl_rvfi.rvfi.pc_wdata;
    assign monitor_mem_addr  = ctrl_rvfi.rvfi.mem_addr;
    assign monitor_mem_rmask = ctrl_rvfi.rvfi.rmask;
    assign monitor_mem_wmask = ctrl_rvfi.rvfi.wmask;
    assign monitor_mem_rdata = ctrl_rvfi.rvfi.mem_rdata;
    assign monitor_mem_wdata = ctrl_rvfi.rvfi.mem_wdata;

endmodule : mp4
