module decode_stage
(
    input logic clk;
    input logic rst;
    input logic reg_load;
    input rv32i_word rd_data;
    
    input rv32i_word instruction;
    input rv32i_reg rs1;
    input rv32i_reg rs2;
    input rv32i_reg rd;
    output rv32i_word rs1_data;
    output rv32i_word rs2_data;
    output 
)



    regfile regfile
    (.clk(clk),.rst(rst), .load(reg_load),
    .in(reg_in),
    .src_a(rs1), .src_b(rs2), .dest(rd),
    .reg_a(rs1_data), .reg_b(rs2_data)
    );


endmodule : decode_stage