/*    alu_out   = 4'b0000
    ,br_en    = 4'b0001
    ,u_imm    = 4'b0010
    ,lw       = 4'b0011
    ,pc_plus4 = 4'b0100
    ,lb        = 4'b0101
    ,lbu       = 4'b0110  // unsigned byte
    ,lh        = 4'b0111
    ,lhu       = 4'b1000  // unsigned halfword*/

module wb_stage
import rv32i_types::*;
(
    input clk, rst, 
    input rv32i_types::regfilemux_sel_t regfilemux_sel; 
    
    input rv32i_word alu_out,
    input logic br_en, 
    input rv32i_word u_imm,  // make sure correct bit width? 
    input rv32i_word mdrreg_out, 
    input rv32i_word pc_x, 

    output rv32i_word regfilemux_out
);

endmodule : wb_stage