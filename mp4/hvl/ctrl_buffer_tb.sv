// module ctrl_buffer_tb;

//     timeunit 1ps;
//     timeprecision 1ps;

//     int clock_period_ps = getenv("CLOCK_PERIOD_PS").atoi() / 2;

//     bit clk;
//     initial clk = 1'b1;
//     always #(clock_period_ps) clk = ~clk;

//     bit rst;

//     int timeout = 100; // in cycles, change according to your needs
//     logic ctrl_buffer_sel;
//     logic[31:0] pc_exe,pc_temp,pc_rdata;
//     logic[:0] opcode_exec;
//     logic br_en;

//     control_buffer control_buffer
//     (
//         .clk(clk),.rst(rst),
//         .sel(ctrl_buffer_sel), 
//         .pc_exe(pc_exe), 
//         .opcode(opcode_exec), 
//         .branch_taken(br_en), 
//         .pc_target(banch_target_exe),
//         .bimm_exe(bimm_exec),

//         .pc_fetch(pc_rdata),
//         .prediction(branch_prediction), 
//         .target(prediction_target)
//     );

//     initial begin 
//         $fsdbDumpfile("dump.fsdb");
//         $fsdbDumpvars(0, "+all");
//         rst = 1'b1;
//         repeat (2) @(posedge clk);
//         rst <= 1'b0;
//     end



// endmodule