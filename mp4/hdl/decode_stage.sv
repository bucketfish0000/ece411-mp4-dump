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
    output rv32i_reg rs1_o,
    output rv32i_reg rs2_o,
    output rv32i_reg rd_o,
    output rv32i_word rs1_data,
    output rv32i_word rs2_data,

    output rv32i_opcode opcode,
    output immediates::imm imm_data,
    output logic[2:0] func3,
    output logic[6:0] func7,

    input logic ready_i,
    input logic valid_i,
    output logic ready_o,
    output logic valid_o,

    output control_read cr
);
/*
        typedef struct {
        logic[6:0] opcode;
        logic [2:0] func3;
        logic [6:0] func7;
        logic [63:0] order_commit;
        logic [31:0] instruction;
        logic [31:0] pc_rdata;
        logic [4:0] rs1_addr;
        logic [4:0] rs2_addr;
        logic [31:0] rs1_data;
        logic [31:0] rs2_data;
        logic [4:0] rd_addr;
    } control_read;
*/
    rv32i_reg rd,rs1,rs2;
    assign rd_o = rd;
    assign rs1_o = rs1;
    assign rs2_o = rs2;
    assign ready_o = 1'b1;
    assign valid_o = ready_i & valid_i;



    //logic [63:0] order_commit;

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

    
    
endmodule : decode_stage