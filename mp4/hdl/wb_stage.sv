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
import cpuIO::*;
(
    input clk, rst, 
    
    input rv32i_word alu_out,
    input logic br_en, 
    input rv32i_word ir_u_imm,  // make sure correct bit width? 
    input rv32i_word mem_data_out,
    input logic mem_wb_valid, 

    output rv32i_word regfilemux_out,
    output logic load_reg,

    input control_word_mem_wb cw_in,
    output rvfi_sigs cw_out_rvfi,
    output logic [4:0] rd_sel
);

logic [31:0] regfile_data;
logic [31:0] prev_order, prev_order_commited;
assign regfilemux_out = regfile_data;

//this keeps track of the previous order so we don't output valid signal more than one cycle for any
//instruction
always_ff @(posedge clk) begin : prev_order_tracker
    if(!mem_wb_valid)
        prev_order <= 32'hffffffff;
    else if(cw_in.rvfi.pc_wdata != 32'b0)
        prev_order <= prev_order_commited;
end

always_comb begin : regfile_ctrl_signals

    if(rst || !((mem_wb_valid == 1))) begin
        load_reg = 1'b0;
        rd_sel = 5'b00000;

        cw_out_rvfi.valid_commit = 1'b0;//done
        cw_out_rvfi.order_commit = 32'b0;//done
        prev_order_commited = 32'b0;
        cw_out_rvfi.instruction = 32'b0;//done
        cw_out_rvfi.rs1_addr = 5'b0; //done
        cw_out_rvfi.rs2_addr = 5'b0; //dome
        cw_out_rvfi.rs1_data = 32'b0; //done
        cw_out_rvfi.rs2_data = 32'b0; //done
        cw_out_rvfi.rd_wdata = 32'b0;//done
        cw_out_rvfi.pc_rdata = 32'h40000000;//done
        cw_out_rvfi.pc_wdata = 32'b0;//done
        cw_out_rvfi.mem_addr = 32'b0;//done
        cw_out_rvfi.rmask = 4'b0;//done
        cw_out_rvfi.wmask = 4'b0;//done
        cw_out_rvfi.mem_rdata = 32'b0;//done
        cw_out_rvfi.mem_wdata = 32'b0;//done
    end
    else begin
        load_reg = cw_in.wb.ld_reg;
        rd_sel = cw_in.wb.rd_sel;

        if(cw_in.rvfi.order_commit != prev_order)
            cw_out_rvfi.valid_commit = cw_in.rvfi.valid_commit;//done
        else
            cw_out_rvfi.valid_commit = 1'b0;

        cw_out_rvfi.order_commit = cw_in.rvfi.order_commit;//done
        prev_order_commited = cw_in.rvfi.order_commit;
        cw_out_rvfi.instruction = cw_in.rvfi.instruction;//done
        cw_out_rvfi.rs1_addr = cw_in.rvfi.rs1_addr; //done
        cw_out_rvfi.rs2_addr = cw_in.rvfi.rs2_addr; //dome
        cw_out_rvfi.rs1_data = cw_in.rvfi.rs1_data; //done
        cw_out_rvfi.rs2_data = cw_in.rvfi.rs2_data; //done
        cw_out_rvfi.rd_wdata = regfile_data;//done
        cw_out_rvfi.pc_rdata = cw_in.rvfi.pc_rdata;//done
        cw_out_rvfi.pc_wdata = cw_in.rvfi.pc_wdata;//done
        cw_out_rvfi.mem_addr = cw_in.rvfi.mem_addr;//done
        cw_out_rvfi.rmask = cw_in.rvfi.rmask;//done
        cw_out_rvfi.wmask = cw_in.rvfi.wmask;//done
        cw_out_rvfi.mem_rdata = cw_in.rvfi.mem_rdata;//done
        cw_out_rvfi.mem_wdata = cw_in.rvfi.mem_wdata;//done
    end
end

always_comb begin : regfilemux_sel
    unique case (cw_in.wb.regfilemux_sel)
        regfilemux::alu_out: regfile_data = alu_out;
        regfilemux::br_en:   regfile_data = {{31'h0000}, br_en}; 
        regfilemux::u_imm:   regfile_data = ir_u_imm;         
        regfilemux::lw:      regfile_data = mem_data_out;
        regfilemux::pc_plus4: regfile_data = cw_in.rvfi.pc_rdata + 4; 
        //mem_data_out set in mem_wb reg
        regfilemux::lb: begin 
            
            regfile_data = mem_data_out;
        end
        regfilemux::lbu: begin 
            
            regfile_data = mem_data_out;
        end
        regfilemux::lh: begin 
            
            regfile_data = mem_data_out;
        end
        regfilemux::lhu: begin 
            
            regfile_data = mem_data_out;
        end
        default: regfile_data = 32'b0;
    endcase

    if(cw_in.mem_write_d) begin
        regfile_data = 32'b0;
    end
    else begin
        //do nothing
    end
end
endmodule : wb_stage