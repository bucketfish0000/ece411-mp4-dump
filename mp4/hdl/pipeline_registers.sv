module fet_dec_reg
    import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    input logic load,

    input rv32i_word instr_fetch,
    input rv32i_word pc_fetch,

    output rv32i_word instr_decode,
    output rv32i_word pc_decode
);

    register instr_fet_dec(.*,.in(instr_fetch),.out(instr_decode));
    register pc_fet_dec(.*,in(pc_fetch),.out(pc_decode));

endmodule : fet_dec_reg

module dec_exe_reg
    import rv32i_types::*;
    import cpuIO::*;
(
    input logic clk,
    input logic rst,
    input logic load,

    input rv32i_opcode opcode_in,
    input imm imm_in,
    input logic [2:0] func3_in,
    input logic [6:0] func7_in,
    
    output rv32i_opcode opcode_out,
    output imm imm_out,
    output logic [2:0] func3_out,
    output logic [6:0] func7_out,

    input control_word cw_in,
    output control_word cw_out
);

    rv32i_opcode opcode_data;
    imm imm_data;
    logic [2:0] func3_data;
    logic [6:0] func7_data;
    control_word cw_data;

    always_ff (@posedge clk)
    begin
        if (rst) begin
            opcode_data<=7'b0000000;
            imm_data<=0;
            func3_data<=0;
            func7_data<=0;
            cw_data<=0;
        end
        else if (load) begin
            opcode_data<=opcode_in;
            imm_data<=imm_in;
            func3_data<=func3_in;
            func7_data<=func7_in;
            cw_data<=cw_in;
        end
        else begin
            opcode_data<=opcode_data;
            imm_data<=imm_data;
            func3_data<=func3_data;
            func7_data<=func7_data;
            cw_data<=cw_data;
        end
    end 

    always_comb (@posedge clk)
    begin
        opcode_out=opcode_data;
        imm_out=imm_data;
        func3_out=func3_data;
        func7_out=func7_data;
        cw_out=cw_data;
    end

endmodule : dec_exe_reg

//output is what ever previous input was, then a posedge output is "current" input aka new previous input
module exe_mem_reg;
import rv32i_types::*;
import rv32i_mux_types::*;
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
    input cw_mem ctrl_w_MEM_i, //from DE_EXE pipeline reg
    input cw_writeback ctrl_w_WB_i, //from DE_EXE pipeline reg
    output cw_mem ctrl_w_MEM_o, //to mem_stage / MEM_WB pipeline reg
    output cw_writeback ctrl_w_WB_o, //to MEM_WB pipeline reg
    output logic [31:0] exe_fwd_data, //to exe_stage / mem_stage / MEM_WB pipeline reg
    output logic [31:0] mem_pc_x, //to MEM_WB pipeline reg
    output logic [31:0] rs2_out_o, //to mem_stage
    output logic [31:0] u_imm_o, //to MEM_WB pipeline reg
    output logic br_en_o, //to ctrl??? / MEM_WB pipeline reg
    output logic exe_rdy; //to cpu_ctrl
);
    logic [31:0] fwd_r_EX, pc_x_r, rs2_out_r, u_imm_r;
    cw_mem ctrl_w_mem_r;
    cw_writeback ctrl_w_wb_r;
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
            ctrl_w_mem_r.mem_read_d <= 1'b0;
            ctrl_w_mem_r.mem_write_d <= 1'b1;
            ctrl_w_mem_r.mem_byte_enable <= 4'b000;
            ctrl_w_mem_r.mar_sel <= marmux::pc_out;

            ctrl_w_MEM_o.mem_read_d <= 1'b0;
            ctrl_w_MEM_o.mem_write_d <= 1'b1;
            ctrl_w_MEM_o.mem_byte_enable <= 4'b000;
            ctrl_w_MEM_o.mar_sel <= marmux::pc_out;
        end
        else if(exe_go == 1) begin
            ctrl_w_mem_r.mem_read_d <= ctrl_w_MEM_i.mem_read_d;
            ctrl_w_mem_r.mem_write_d <= ctrl_w_MEM_i.mem_write_d;
            ctrl_w_mem_r.mem_byte_enable <= ctrl_w_MEM_i.mem_byte_enable;
            ctrl_w_mem_r.mar_sel <= ctrl_w_MEM_i.mar_sel;
            
            ctrl_w_MEM_o.mem_read_d <= ctrl_w_MEM_i.mem_read_d;
            ctrl_w_MEM_o.mem_write_d <= ctrl_w_MEM_i.mem_write_d;
            ctrl_w_MEM_o.mem_byte_enable <= ctrl_w_MEM_i.mem_byte_enable;
            ctrl_w_MEM_o.mar_sel <= ctrl_w_MEM_i.mar_sel;
        end
        else begin
            ctrl_w_MEM_o.mem_read_d <= ctrl_w_mem_r.mem_read_d;
            ctrl_w_MEM_o.mem_write_d <= ctrl_w_mem_r.mem_write_d;
            ctrl_w_MEM_o.mem_byte_enable <= ctrl_w_mem_r.mem_byte_enable;
            ctrl_w_MEM_o.mar_sel <= ctrl_w_mem_r.mar_sel;
        end
    end

    //control word for WB 
    always_ff @ (posedge clk, posedge rst) begin : ctrl_w_MEM_register
        if(rst)begin
            ctrl_w_wb_r.regfilemux_sel <= regfilemux::alu_out;
            ctrl_w_WB_o.regfilemux_sel <= regfilemux::alu_out;
        end
        else if(exe_go == 1) begin
            ctrl_w_wb_r.regfilemux_sel <= ctrl_w_WB_i.regfilemux_sel;
            ctrl_w_WB_o.regfilemux_sel <= ctrl_w_WB_i.regfilemux_sel;
        end
        else begin
            ctrl_w_WB_o.regfilemux_sel <= ctrl_w_wb_r.regfilemux_sel;
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

module mem_wb_reg
    import rv32i_types::*;
    import cpuIO::*;
(
    input clk,
    input rst,
    input cw_writeback ctrl_w_WB_i
    output 
);



endmodule : mem_wb_reg
