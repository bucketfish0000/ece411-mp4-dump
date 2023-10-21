//output is what ever previous input was, then a posedge output is "current" input aka new previous input
module exe_mem_reg
import rv32i_types::*;
import cpuIO::*;
(
    input clk, //from datapath
    input rst, //from datapath
    input logic br_en_i //from exe_stage
    input logic [31:0] alu_out //from exe_stage
    input logic [31:0] exe_pc_x, //from DE_EXE pipeline reg
    input logic [31:0] rs2_out_i, //from exe_stage
    input logic [31:0] u_imm_i, //from DE_EXE pipeline reg
    input rv32i_opcode opcode_i; //from DE_EXE pipeline reg
    input cw_mem ctrl_w_MEM_i, //from DE_EXE pipeline reg
    input cw_writeback ctrl_w_WB_i, //from DE_EXE pipeline reg
    output cw_mem ctrl_w_MEM_o, //to mem_stage
    output cw_writeback ctrl_w_WB_o, //to MEM_WB pipeline reg
    output logic [31:0] exe_fwd_data, //to exe_stage / mem_stage / MEM_WB pipeline reg
    output logic [31:0] mem_pc_x, //to MEM_WB pipeline reg
    output logic [31:0] rs2_out_o, //to mem_stage
    output logic [31:0] u_imm_o, //to MEM_WB pipeline reg
    output rv32i_opcode opcode_o, //to MEM_WB pipeline reg
    output logic br_en_o //to ctrl??? / MEM_WB pipeline reg
);
    //serves as alu_out reg/fwding exe data reg for cp2 onward
    always_ff @ (posedge clk, posedge rst) begin : fwd_EX_reg
        if(rst)begin
            exe_fwd_data <= 32'b0;
        end
        else begin
            exe_fwd_data <= alu_out;
        end
    end

    //serves as pc_x reg, mem_pc_x is the output, exe_pc_x is input
    always_ff @ (posedge clk, posedge rst) begin : pc_x_register
        if(rst)begin
            mem_pc_x <= 32'h40000000;
        end
        else begin
            mem_pc_x <= exe_pc_x;
        end
    end

    //rs2_out reg
    always_ff @ (posedge clk, posedge rst) begin : rs2_out_register
        if(rst)begin
            rs2_out_o <= 32'b0;
        end
        else begin
            rs2_out_o <= rs2_out_i;
        end
    end

    //control word for MEM register
    always_ff @ (posedge clk, posedge rst) begin : ctrl_w_MEM_register
        if(rst)begin
            ctrl_w_MEM_o <= 32'b0;
        end
        else begin
            ctrl_w_MEM_o <= ctrl_w_MEM_i;
        end
    end

    //control word for WB register
    always_ff @ (posedge clk, posedge rst) begin : ctrl_w_WB_register
        if(rst)begin
            ctrl_w_WB_o <= 32'b0;
        end
        else begin
            ctrl_w_WB_o <= ctrl_w_WB_i;
        end
    end

    //br_en register
    always_ff @ (posedge clk, posedge rst) begin : br_en_register
        if(rst)begin
            br_en_o <= 32'b0;
        end
        else begin
            br_en_o <= br_en_i;
        end
    end

    //opcode register
    always_ff @ (posedge clk, posedge rst) begin : opcode_register
        if(rst)begin
            opcode_o <= 32'b0;
        end
        else begin
            opcode_o <= opcode_i;
        end
    end

    //u_imm register
    always_ff @ (posedge clk, posedge rst) begin : u_imm_register
        if(rst)begin
            u_imm_o <= 32'b0;
        end
        else begin
            u_imm_o <= u_imm_i;
        end
    end

endmodule : exe_mem_reg