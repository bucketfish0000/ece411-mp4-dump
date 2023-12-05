import "DPI-C" function string getenv(input string env_name);

module top_tb;

    timeunit 1ps;
    timeprecision 1ps;

    int clock_period_ps = getenv("CLOCK_PERIOD_PS").atoi() / 2;

    bit clk;
    initial clk = 1'b1;
    always #(clock_period_ps) clk = ~clk;

    bit rst;

    int timeout = 1000000; // in cycles, change according to your needs

    // CP1
    // mem_itf magic_itf_i(.*);
    // mem_itf magic_itf_d(.*);
    // magic_dual_port magic_dual_port(.itf_i(magic_itf_i), .itf_d(magic_itf_d));

    // CP2
    bmem_itf bmem_itf(.*);
    burst_memory burst_memory(.itf(bmem_itf));

    mon_itf mon_itf(.*);    
    monitor monitor(.itf(mon_itf));

    logic i_miss, i_hit, d_hit, d_miss, mispredict, stall_all, stall_fe, stall_de_exe_mem_wb, stall_exe_mem_wb, stall_mem_wb, pf_used;
    logic [31:0] i_miss_count, i_hit_count, d_hit_count, d_miss_count, mispredict_count, stall_all_count, pf_used_count,
     stall_fe_count, stall_de_exe_mem_wb_count, stall_exe_mem_wb_count, stall_mem_wb_count;

    logic buff_flag;
     logic [511:0] buffy;

    mp4 dut(
        .clk          (clk),
        .rst          (rst),

        // Use these for CP1
        // .imem_address  (magic_itf_i.addr),
        // .imem_read     (magic_itf_i.read),
        // .imem_rdata    (magic_itf_i.rdata),
        // .imem_resp     (magic_itf_i.resp),
        // .dmem_address  (magic_itf_d.addr),
        // .dmem_read     (magic_itf_d.read),
        // .dmem_write    (magic_itf_d.write),
        // .dmem_wmask    (magic_itf_d.wmask),
        // .dmem_rdata    (magic_itf_d.rdata),
        // .dmem_wdata    (magic_itf_d.wdata),
        // .dmem_resp     (magic_itf_d.resp)

        // Use these for CP2+
        .bmem_address (bmem_itf.addr),
        .bmem_read    (bmem_itf.read),
        .bmem_write   (bmem_itf.write),
        .bmem_rdata   (bmem_itf.rdata),
        .bmem_wdata   (bmem_itf.wdata),
        .bmem_resp    (bmem_itf.resp),

        .mispredict(mispredict),
        .i_hit(i_hit),
        .i_miss(i_miss),
        .d_hit(d_hit),
        .d_miss(d_miss), 
        .stall_if_de(stall_fe),
        .stall_all(stall_all),
        .stall_de_exe_mem_wb(stall_de_exe_mem_wb),
        .stall_exe_mem_wb(stall_exe_mem_wb),
        .stall_mem_wb(stall_mem_wb),
        .pf_used(pf_used)
    );
    //  ipc without btb or pre-fetch: .323673
    //  with btb and without pre-fetch: .358626, with prefetch . 0.359140


    //NOTE: number of mispredicts is half of this count since if_de_rst goes high for two cycles
    /*  with btb and without prefetch is x1_7106 mispredicts/flush
        without btb or prefetch x2_49f4*/
    always_ff @( posedge clk , posedge rst ) begin : mispredict_counter
        if(rst) begin
            mispredict_count <= 32'h0;
        end
        else if(mispredict) begin
            mispredict_count <= mispredict_count + 32'b01;
        end
    end

    //without prefetch or btb:  e_b391
    //with btb and without prefetch: c_bef0
    always_ff @( posedge clk, posedge rst ) begin : i_hit_counter
        if(rst) begin
            i_hit_count <= 32'h0;
        end
        else if(i_hit) begin
            i_hit_count <= i_hit_count + 32'b01;
        end
    end

    //without prefetch or btb:  4c1
    //with btb and without prefetch: 4c2
    always_ff @( posedge clk, posedge rst ) begin : i_miss_counter
        if(rst) begin
            i_miss_count <= 32'h0;
        end
        else if(i_miss) begin
            i_miss_count <= i_miss_count + 32'b01;
        end
    end

    //without prefetch or btb:  1_20d0
    //with btb and without prefetch: 1_20d0
    always_ff @( posedge clk, posedge rst ) begin : d_hit_counter
        if(rst) begin
            d_hit_count <= 32'h0;
        end
        else if(d_hit) begin
            d_hit_count <= d_hit_count + 32'b01;
        end
    end

    //without prefetch or btb:  87
    //with btb and without prefetch: 87
    always_ff @( posedge clk, posedge rst ) begin : d_miss_counter
        if(rst) begin
            d_miss_count <= 32'h0;
        end
        else if(d_miss) begin
            d_miss_count <= d_miss_count + 32'b01;
        end
    end

    //without prefetch or btb:  1_e01f
    //with btb and without prefetch: 1_db25
    always_ff @( posedge clk, posedge rst ) begin : stall_fe_counter
        if(rst) begin
            stall_fe_count <= 32'h0;
        end
        else if(stall_fe) begin
            stall_fe_count <= stall_fe_count + 32'b01;
        end
    end

    //without prefetch or btb:  1_292e
    //with btb and without prefetch: 1_292e
    always_ff @( posedge clk, posedge rst ) begin : stall_all_counter
        if(rst) begin
            stall_all_count <= 32'h0;
        end
        else if(stall_all) begin
            stall_all_count <= stall_all_count + 32'b01;
        end
    end

    //without prefetch or btb:  1
    //with btb and without prefetch: 1
    always_ff @( posedge clk, posedge rst ) begin : stall_de_exe_mem_wb_counter
        if(rst) begin
            stall_de_exe_mem_wb_count <= 32'h0;
        end
        else if(stall_de_exe_mem_wb) begin
            stall_de_exe_mem_wb_count <= stall_de_exe_mem_wb_count + 32'b01;
        end
    end

    //without prefetch or btb:  1
    //with btb and without prefetch: 1
    always_ff @( posedge clk, posedge rst ) begin : stall_exe_mem_wb_counter
        if(rst) begin
            stall_exe_mem_wb_count <= 32'h0;
        end
        else if(stall_exe_mem_wb) begin
            stall_exe_mem_wb_count <= stall_exe_mem_wb_count + 32'b01;
        end
    end

    //without prefetch or btb:  1d_e6a1
    //with btb and without prefetch: 1b_5b24
    always_ff @( posedge clk, posedge rst ) begin : stall_mem_wb_counter
        if(rst) begin
            stall_mem_wb_count <= 32'h0;
        end
        else if(stall_mem_wb) begin
            stall_mem_wb_count <= stall_mem_wb_count + 32'b01;
        end
    end

    //without prefetch or btb:  1d_e6a1
    //with btb and without prefetch: 42b
    always_ff @( posedge clk, posedge rst ) begin : pf_used_counter
        if(rst) begin
            pf_used_count <= 32'h0;
        end
        else if(pf_used) begin
            pf_used_count <= pf_used_count + 32'b01;
        end
    end

    always_comb begin
        mon_itf.valid     = dut.monitor_valid;
        mon_itf.order     = dut.monitor_order;
        mon_itf.inst      = dut.monitor_inst;
        mon_itf.rs1_addr  = dut.monitor_rs1_addr;
        mon_itf.rs2_addr  = dut.monitor_rs2_addr;
        mon_itf.rs1_rdata = dut.monitor_rs1_rdata;
        mon_itf.rs2_rdata = dut.monitor_rs2_rdata;
        mon_itf.rd_addr   = dut.monitor_rd_addr;
        mon_itf.rd_wdata  = dut.monitor_rd_wdata;
        mon_itf.pc_rdata  = dut.monitor_pc_rdata;
        mon_itf.pc_wdata  = dut.monitor_pc_wdata;
        mon_itf.mem_addr  = dut.monitor_mem_addr;
        mon_itf.mem_rmask = dut.monitor_mem_rmask;
        mon_itf.mem_wmask = dut.monitor_mem_wmask;
        mon_itf.mem_rdata = dut.monitor_mem_rdata;
        mon_itf.mem_wdata = dut.monitor_mem_wdata;
    end

    initial begin
        $fsdbDumpfile("dump.fsdb");
        $fsdbDumpvars(0, "+all");
        rst = 1'b1;
        repeat (2) @(posedge clk);
        rst <= 1'b0;
    end

    always @(posedge clk) begin
        if (mon_itf.halt) begin
            $finish;
        end
        if (timeout == 0) begin
            $error("TB Error: Timed out");
            $finish;
        end
        if (mon_itf.error != 0) begin
            repeat (5) @(posedge clk);
            $finish;
        end
        // Comment this for CP2+
        // if (magic_itf_i.error != 0 || magic_itf_d.error != 0) begin
        //     repeat (5) @(posedge clk);
        //     $finish;
        // end
        // Uncomment this for CP2+
        if (bmem_itf.error != 0) begin
            repeat (5) @(posedge clk);
            $finish;
        end
        timeout <= timeout - 1;
    end

endmodule
