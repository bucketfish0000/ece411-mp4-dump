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
    input cpuIO::cw_writeback ctrl_w_WB,
    
    input rv32i_word alu_out,
    input logic br_en, 
    input rv32i_word ir_u_imm,  // make sure correct bit width? 
    input rv32i_word mem_data_out, 
    input rv32i_word pc_wb, 

    output rv32i_word regfilemux_out,
    output logic load_reg,
    output logic rd_sel
);

assign load_reg = ctrl_w_WB.ld_reg;
assign rd_sel =  ctrl_w_WB.rd_sel;
always_comb begin : regfilemux_sel
    unique case (ctrl_w_WB.regfilemux_sel)
        regfilemux::alu_out: regfilemux_out = alu_out;
        regfilemux::br_en:   regfilemux_out = {{31'h0000}, br_en}; 
        regfilemux::u_imm:   regfilemux_out = ir_u_imm;         
        regfilemux::lw:      regfilemux_out = mem_data_out;
        regfilemux::pc_plus4: regfilemux_out = pc_wb + 4; 
        regfilemux::lb: begin 
            
            regfilemux_out = 32'hdeadbeef; //wat is dis?
        end
        regfilemux::lbu: begin 
            
            regfilemux_out = 32'hdeadbeef;  //wat is dis?
        end
        regfilemux::lh: begin 
            
            regfilemux_out = 32'hdeadbeef;  //wat is dis?
        end
        regfilemux::lhu: begin 
            
            regfilemux_out = 32'hdeadbeef;  //wat is dis?
        end
    endcase
end
endmodule : wb_stage