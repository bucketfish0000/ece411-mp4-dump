//output is what ever previous input was, then a posedge output is "current" input aka new previous input
module exe_mem_reg
import rv32i_types::*;
import cpuIO::*;
(
    input clk, //from datapath
    input rst, //from datapath
    input logic br_en_i, //from exe_stage
    input logic exe_go, //from cpu_ctrl
    input logic de_rdy, //from DE_EXE
    input logic [31:0] alu_out, //from exe_stage
    input logic [31:0] exe_pc_x, //from DE_EXE pipeline reg
    input logic [31:0] rs2_out_i, //from exe_stage
    input logic [31:0] u_imm_i, //from DE_EXE pipeline reg
    input rv32i_opcode opcode_i; //from DE_EXE pipeline reg
    input control_word ctrl_w_DE, //from DE_EXE pipeline reg
    output control_word ctrl_w_MEM, //to mem_stage / MEM_WB pipeline reg
    output logic [31:0] exe_fwd_data, //to exe_stage / mem_stage / MEM_WB pipeline reg
    output logic [31:0] mem_pc_x, //to MEM_WB pipeline reg
    output logic [31:0] rs2_out_o, //to mem_stage
    output logic [31:0] u_imm_o, //to MEM_WB pipeline reg
    output rv32i_opcode opcode_o, //to MEM_WB pipeline reg / mem_stage
    output logic br_en_o, //to ctrl??? / MEM_WB pipeline reg
    output logic exe_rdy; //to cpu_ctrl
);
    logic [31:0] fwd_r_EX, pc_x_r, rs2_out_r, u_imm_r;
    control_word ctrl_w_r;
    logic br_en_r;

    //always_comb or always_ff??
    //hold ready high unless exe_go == 1 || de_rdy == 1
    always_ff @ (posedge clk, posedge rst) begin : exe_mem_ctrl
        if(rst)
            exe_rdy <= 1'b0;
        else if((exe_go == 1) || (de_rdy == 1))//KEEP RDY HIGH IN THE CASE THAT exe_go == 0, BUT de_rdy == 1, THIS INDICATES CTRL IS TELLING YOU
                                                //TO KEEP ALL OUTPUTS CONSTANT
            exe_rdy <= 1'b1;
        else
            exe_rdy <= 1'b0;
    end

    //serves as alu_out reg/fwding exe data reg for cp2 onward
    always_ff @ (posedge clk, posedge rst) begin : fwd_EX_reg
        if(rst)begin
            exe_fwd_data <= 32'b0;
            fwd_r_EX <= 32'b0;
        end
        else if(exe_go == 1) begin
            exe_fwd_data <= alu_out;
            fwd_r_EX <= alu_out;
        end
        else begin
            exe_fwd_data <= fwd_r_EX;
        end
    end

    //serves as pc_x reg, mem_pc_x is the output, exe_pc_x is input
    always_ff @ (posedge clk, posedge rst) begin : pc_x_register
        if(rst)begin
            mem_pc_x <= 32'h40000000;
            pc_x_r <= 32'h40000000;
        end
        else if(exe_go == 1) begin
            mem_pc_x <= exe_pc_x;
            pc_x_r <= exe_pc_x;
        end
        else begin
            mem_pc_x <= pc_x_r;
        end
    end

    //rs2_out reg
    always_ff @ (posedge clk, posedge rst) begin : rs2_out_register
        if(rst)begin
            rs2_out_o <= 32'b0;
            rs2_out_r <= 32'b0;
        end
        else if(exe_go == 1) begin
            rs2_out_o <= rs2_out_i;
            rs2_out_r <= rs2_out_i;
        end
        else begin
            rs2_out_o <= rs2_out_r;
        end
    end

    //control word for MEM 
    always_ff @ (posedge clk, posedge rst) begin : ctrl_w_MEM_register
        if(rst)begin
            ctrl_w_MEM.opcode <= rv32i_opcode::op_lui;
            ctrl_w_r.opcode <= rv32i_opcode::op_lui;
            ctrl_w_MEM.funct3 <= 3'b000;
            ctrl_w_r.funct3 <= 3'b000;
            ctrl_w_MEM.funct7 <= 3'b000;
            ctrl_w_r.funct7 <= 3'b000;
        end
        else if(exe_go == 1) begin
            ctrl_w_MEM <= ctrl_w_DE;
            ctrl_w_r <= ctrl_w_DE;
        end
        else begin
            ctrl_w_MEM <= ctrl_w_r;
        end
    end

    //br_en register
    always_ff @ (posedge clk, posedge rst) begin : br_en_register
        if(rst)begin
            br_en_o <= 1'b0;
            br_en_r <= 1'b0;
        end
        else if(exe_go == 1) begin
            br_en_o <= br_en_i;
            br_en_r <= br_en_i;
        end
        else begin
            br_en_o <= br_en_r;
        end
    end

    //u_imm register
    always_ff @ (posedge clk, posedge rst) begin : u_imm_register
        if(rst)begin
            u_imm_o <= 32'b0;
            u_imm_r <= 32'b0;
        end
        else if(exe_go == 1) begin
            u_imm_o <= u_imm_i;
            u_imm_r <= u_imm_i;
        end
        else begin
            u_imm_o <= u_imm_r;
        end
    end

endmodule : exe_mem_reg