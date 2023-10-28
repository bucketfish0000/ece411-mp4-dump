//output is what ever previous input was, then a posedge output is "current" input aka new previous input
module exe_mem_reg;
import rv32i_types::*;
import rv32i_mux_types::*;
import cpuIO::*;
(
    input clk, //from datapath
    input rst, //from datapath
    input logic br_en_i, //from exe_stage
    input logic exe_mem_ld, //from cpu_ctrl
    input logic exe_rdy,
    input logic de_exe_valid,
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
    output logic exe_mem_valid, //to ctrl / MEM_WB pipeline reg
    output logic exe_mem_rdy, //to MEM_WB pipeline reg?

    //include these here bc they need to be loaded at same time as EXE_MEM
    output logic [31:0] mem_address_d, //to data cache
    output logic [31:0] mem_wdata_d //to data cache
);
    logic [31:0] fwd_r_EX, pc_x_r, rs2_out_r, u_imm_r;
    cw_mem ctrl_w_mem_r;
    cw_writeback ctrl_w_wb_r;
    logic br_en_r, valid_r, ready_r;

    //serves as alu_out reg/fwding exe data reg for cp2 onward
    always_ff @ (posedge clk, posedge rst) begin : fwd_EX_reg
        if(rst)begin
            exe_fwd_data <= 32'b0;
            fwd_r_EX <= 32'b0;
        end
        else if((exe_mem_ld == 1) && (de_exe_valid == 1)) begin
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
        else if((exe_mem_ld == 1) && (de_exe_valid == 1)) begin
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
        else if((exe_mem_ld == 1) && (de_exe_valid == 1)) begin
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
        else if(exe_mem_ld == 1) begin
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
        else if((exe_mem_ld == 1) && (de_exe_valid == 1)) begin
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
        else if((exe_mem_ld == 1) && (de_exe_valid == 1)) begin
            br_en_o <= br_en_i;
            br_en_r <= br_en_i;
        end
        else begin
            br_en_o <= br_en_r;
        end
    end

    //valid register
    always_ff @(posedge clk, posedge rst) begin : valid_reg
        if(rst) begin
            valid_r <= 1'b0;
            exe_mem_valid <= 1'b0;
        end
        else if((exe_mem_ld == 1) && (de_exe_valid == 1)) begin
            valid_r <= 1'b1;
            exe_mem_valid <= 1'b1;
        end
        else begin
            exe_mem_valid <= valid_r;
        end
    end

    //ready register
    always_ff @(posedge clk, posedge rst) begin : ready_reg
        if(rst) begin
            ready_r <= 1'b0;
            exe_mem_rdy <= 1'b0;
        end
        else if((exe_mem_ld == 1) && (de_exe_valid == 1)) begin
            ready_r <= exe_rdy;
            exe_mem_rdy <= exe_rdy;
        end
        else begin
            exe_mem_rdy <= ready_r;
        end
    end

    //u_imm register
    always_ff @ (posedge clk, posedge rst) begin : u_imm_register
        if(rst)begin
            u_imm_o <= 32'b0;
            u_imm_r <= 32'b0;
        end
        else if((exe_mem_ld == 1) && (de_exe_valid == 1)) begin
            u_imm_o <= u_imm_i;
            u_imm_r <= u_imm_i;
        end
        else begin
            u_imm_o <= u_imm_r;
        end
    end

    //include these here bc they need to be loaded at same time as EXE_MEM

    logic [31:0] marmux_o;

    always_comb begin : mem_mux
        unique case (ctrl_w_MEM.mar_sel)
            marmux::pc_out: marmux_o = exe_pc_x;
            marmux::alu_out: marmux_o = alu_out;
        endcase
    end

    mem_data_out mdo_reg(
        .clk(clk),
        .reset(rst),
        .load_data_out((exe_mem_ld == 1) && (de_exe_valid == 1)),//don't load until mem r/w finish
        .mdo_in(rs2_out_i),
        .mdo_out(mem_wdata_d)
    );

    mar mar_reg(
        .clk(clk),
        .reset(rst),
        .load_mar((exe_mem_ld == 1) && (de_exe_valid == 1)),//don't load until mem r/w finish
        .mar_in(marmux_o),
        .mar_out(mem_address_d)
    );

endmodule : exe_mem_reg
