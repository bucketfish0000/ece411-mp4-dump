module decode_stage
    import rv32i_types::*;
    import cpuIO::*;
    import immediates::*;   
(
    input logic clk,
    input logic rst,
    input logic reg_load,
    input rv32i_word rd_data,
    input rv32i_reg rd_sel,

    input rv32i_word instruction,
    input rv32i_word pc_rdata,
    input rv32i_word pc_wdata,
    input logic [31:0] commit_order,
    input logic prediction,
    output immediates::imm imm_data,

    output logic ready_o,

    output control_read cr
);
    rv32i_reg rd,rs1,rs2;
    logic [31:0] rs1_data, rs2_data;
    rv32i_opcode opcode;
    logic [2:0] func3;
    logic [6:0] func7;
    assign ready_o = 1'b1;

    //decode logic 
    //begin decode_logic
        assign func3 = instruction[14:12];
        assign func7 = instruction[31:25];
        assign opcode = rv32i_opcode'(instruction[6:0]);
        
        assign imm_data.i_imm = {{21{instruction[31]}}, instruction[30:20]};
        assign imm_data.s_imm = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};
        assign imm_data.b_imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        assign imm_data.u_imm = {instruction[31:12], 12'h000};
        assign imm_data.j_imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
    
        assign rs1 = instruction[19:15];
        assign rs2 = instruction[24:20];
        assign rd = instruction[11:7];
    //end decode_logic

    regfile regfile
    (.clk(clk),.rst(rst), .load(reg_load),
    .in(rd_data),
    .src_a(rs1), 
    .src_b(rs2), 
    .dest(rd_sel),
    .reg_a(rs1_data), 
    .reg_b(rs2_data)
    );

    //control read word to send to cpu
    assign cr.order_commit = commit_order;
    assign cr.opcode = opcode;
    assign cr.func3 = func3;
    assign cr.func7 = func7;
    assign cr.instruction = instruction;
    assign cr.pc_rdata = pc_rdata; //TODO ?????
    assign cr.pc_wdata = pc_wdata;
    assign cr.rs1_addr = rs1;
    assign cr.rs2_addr = rs2;
    assign cr.rs1_data = rs1_data;
    assign cr.rs2_data = rs2_data;
    assign cr.rd_addr = rd;
    assign cr.prediction = prediction;
    
endmodule : decode_stage