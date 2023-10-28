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
.
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

    always_comb
    begin
        opcode_out=opcode_data;
        imm_out=imm_data;
        func3_out=func3_data;
        func7_out=func7_data;
        cw_out=cw_data;
    end

endmodule : dec_exe_reg

//substantially more complicated than other registers on account of needing to prime mar/mdo/mem_data_out for mem_stage to then be able to 
//start r/w right away
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
    input logic [31:0] alu_out_i, //from exe_stage
    input logic [31:0] exe_pc_x, //from DE_EXE pipeline reg
    input logic [31:0] rs2_out_i, //from exe_stage
    input logic [31:0] u_imm_i, //from DE_EXE pipeline reg
    input cw_mem ctrl_w_MEM_i, //from DE_EXE pipeline reg
    input cw_writeback ctrl_w_WB_i, //from DE_EXE pipeline reg
    output cw_mem ctrl_w_MEM_o, //to mem_stage / MEM_WB pipeline reg
    output cw_writeback ctrl_w_WB_o, //to MEM_WB pipeline reg
    output logic [31:0] exe_fwd_data, //to exe_stage / mem_stage / MEM_WB pipeline reg
    output logic [31:0] mem_pc_x, //to MEM_WB pipeline reg
    output logic [31:0] u_imm_o, //to MEM_WB pipeline reg
    output logic br_en_o, //to ctrl??? / MEM_WB pipeline reg
    output logic exe_mem_valid, //to ctrl / MEM_WB pipeline reg
    output logic exe_mem_rdy, //to MEM_WB pipeline reg

    //include these here bc they need to be loaded at same time as EXE_MEM
    output logic [31:0] mem_address_d, //to data cache
    output logic [31:0] mem_wdata_d, //to data cache
    output logic [3:0] mem_byte_enable //to data cache
);
    logic [31:0] fwd_r_EX, pc_x_r, u_imm_r;
    logic [3:0] mem_byte_enable_r
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
            exe_fwd_data <= alu_out_i;
            fwd_r_EX <= alu_out_i;
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

    //control word for MEM 
    always_ff @ (posedge clk, posedge rst) begin : ctrl_w_MEM_register
        if(rst)begin
            ctrl_w_mem_r.mem_read_d <= 1'b0;
            ctrl_w_mem_r.mem_write_d <= 1'b0;
            ctrl_w_mem_r.load_funct3 <= load_funct3_t::lw;
            ctrl_w_mem_r.store_funct3 <= store_funct3_t::sw;
            ctrl_w_mem_r.mar_sel <= marmux::pc_out;

            ctrl_w_MEM_o.mem_read_d <= 1'b0;
            ctrl_w_MEM_o.mem_write_d <= 1'b0;
            ctrl_w_MEM_o.load_funct3 <= load_funct3_t::lw;
            ctrl_w_MEM_o.store_funct3 <= store_funct3_t::sw;
            ctrl_w_MEM_o.mar_sel <= marmux::pc_out;
        end
        else if(exe_mem_ld == 1) begin
            ctrl_w_mem_r.mem_read_d <= ctrl_w_MEM_i.mem_read_d;
            ctrl_w_mem_r.mem_write_d <= ctrl_w_MEM_i.mem_write_d;
            ctrl_w_mem_r.load_funct3 <= ctrl_w_MEM_i.load_funct3;
            ctrl_w_mem_r.store_funct3 <= ctrl_w_MEM_i.store_funct3;
            ctrl_w_mem_r.mar_sel <= ctrl_w_MEM_i.mar_sel;
            
            ctrl_w_MEM_o.mem_read_d <= ctrl_w_MEM_i.mem_read_d;
            ctrl_w_MEM_o.mem_write_d <= ctrl_w_MEM_i.mem_write_d;
            ctrl_w_MEM_o.load_funct3 <= ctrl_w_MEM_i.load_funct3;
            ctrl_w_MEM_o.store_funct3 <= ctrl_w_MEM_i.store_funct3;
            ctrl_w_MEM_o.mar_sel <= ctrl_w_MEM_i.mar_sel;
        end
        else begin
            ctrl_w_MEM_o.mem_read_d <= ctrl_w_mem_r.mem_read_d;
            ctrl_w_MEM_o.mem_write_d <= ctrl_w_mem_r.mem_write_d;
            ctrl_w_MEM_o.load_funct3 <= ctrl_w_mem_r.load_funct3;
            ctrl_w_MEM_o.store_funct3 <= ctrl_w_mem_r.store_funct3;
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
    //also have rvfi signals here, mem_byte_enable is only able to be calculated once
    //we have address(which is only available after exe computes it)
    logic [31:0] marmux_o, mem_addr;
    logic trap;
    logic [3:0] rmask, wmask; 

    always_comb begin : mem_mux
        unique case (ctrl_w_MEM_i.mar_sel)
            marmux::pc_out: marmux_o = exe_pc_x;
            marmux::alu_out: marmux_o = alu_out;
        endcase
    end

    mem_data_out mdo_reg(
        .clk(clk),
        .reset(rst),
        .load_data_out((exe_mem_ld == 1) && (de_exe_valid == 1) && ((ctrl_w_MEM_i.mem_read_d) || (ctrl_w_MEM_i.mem_write_d))),
        .mdo_in(rs2_out_i),
        .mdo_out(mem_wdata_d)
    );

    always_comb begin : calc_addr
        rmask = 4'b0000;
        wmask = 4'b0000;
        mem_addr = marmux_o;
        trap = 1'b0;

        if(ctrl_w_MEM_i.mem_read_d) begin
            case (ctrl_w_MEM_i.load_funct3)
                lw: begin
                    rmask = 4'b1111;
                end
                lh, lhu: begin
                    rmask = (4'b0011) << (marmux_o%4); /* Modify for MP1 Final */ //correct???
                    mem_addr = marmux_o - (marmux_o%4);
                end
                lb, lbu: begin
                    rmask = (4'b0001) << (marmux_o%4); /* Modify for MP1 Final */ //correct???
                    mem_addr = marmux_o - (marmux_o%4);
                end
                default: trap = '1;
            endcase
        end
        else if(ctrl_w_MEM_i.mem_write_d) begin
            case (ctrl_w_MEM_i.store_funct3)
                sw: begin
                    wmask = 4'b1111;
                end
                sh: begin
                    wmask = (4'b0011) << (marmux_o%4); /* Modify for MP1 Final */ //correct???
                    mem_addr = marmux_o - (marmux_o%4);
                end
                sb: begin
                    wmask = (4'b0001) << (marmux_o%4); /* Modify for MP1 Final */ //correct???
                    mem_addr = marmux_o - (marmux_o%4);
                end
                default: trap = '1;
            endcase
        end
        else begin
            //if not ld or st, don't really care what outputs are so just leave as default
        end
    end

    //mem_byte_enable register
    always_ff @ (posedge clk, posedge rst) begin : mem_byte_enable_register
        if(rst)begin
            mem_byte_enable <= 4'b0000;
            mem_byte_enable_r <= 4'b0000;
        end
        else if((exe_mem_ld == 1) && (de_exe_valid == 1) && ((ctrl_w_MEM_i.mem_read_d) || (ctrl_w_MEM_i.mem_write_d))) begin
            if(ctrl_w_MEM_i.mem_read_d) begin
                mem_byte_enable <= rmask;
                mem_byte_enable_r <= rmask;
            end
            else if(ctrl_w_MEM_i.mem_write_d) begin
                mem_byte_enable <= wmask;
                mem_byte_enable_r <= wmask;
            end
        end
        else begin
            mem_byte_enable <= mem_byte_enable_r;
        end
    end

    mar mar_reg(
        .clk(clk),
        .reset(rst),
        .load_mar((exe_mem_ld == 1) && (de_exe_valid == 1) && ((ctrl_w_MEM_i.mem_read_d) || (ctrl_w_MEM_i.mem_write_d))),
        .mar_in(mem_addr),
        .mar_out(mem_address_d)
    );

endmodule : exe_mem_reg


module mem_wb_reg
    import rv32i_types::*;
    import cpuIO::*;
(
    input clk,
    input rst,
    input logic mem_wb_ld,
    input logic mem_rdy,
    input logic alu_out_i, //aka exe_fwd_data
    input logic br_en_i,
    input logic [31:0] mem_pc_x,
    input logic [31:0] u_imm_i,
    input logic [31:0] mem_rdata_D_i,
    input logic exe_mem_valid,
    input cw_writeback ctrl_w_WB_i,
    output cw_writeback ctrl_w_WB_o,
    output logic [31:0] wb_pc_x,
    output logic [31:0] u_imm_o,
    output logic [31:0] mem_rdata_D_o,
    output logic mem_wb_rdy,
    output logic mem_wb_valid,
    output logic alu_out_o, //aka exe_fwd_data
    output logic br_en_o
);
    logic [31:0] alu_out_r, pc_x_r, u_imm_r, mem_rdata_r;
    cw_writeback ctrl_w_wb_r;
    logic br_en_r, valid_r, ready_r;

    //mem_rdata reg
    always_ff @ (posedge clk, posedge rst) begin : mem_rdata_reg
        if(rst)begin
            mem_rdata_D_o <= 32'b0;
            mem_rdata_r <= 32'b0;
        end
        else if((mem_wb_ld == 1) && (exe_mem_valid == 1)) begin
            mem_rdata_D_o <= mem_rdata_D_i;
            mem_rdata_r <= mem_rdata_D_i;
        end
        else begin
            mem_rdata_D_o <= mem_rdata_r;
        end
    end

    //serves as alu_out reg/fwding exe data reg for cp2 onward
    always_ff @ (posedge clk, posedge rst) begin : alu_out_reg
        if(rst)begin
            alu_out_o <= 32'b0;
            alu_out_r <= 32'b0;
        end
        else if((mem_wb_ld == 1) && (exe_mem_valid == 1)) begin
            alu_out_o <= alu_out_i;
            alu_out_r <= alu_out_i;
        end
        else begin
            alu_out_o <= alu_out_r;
        end
    end

    //serves as pc_x reg
    always_ff @ (posedge clk, posedge rst) begin : pc_x_register
        if(rst)begin
            wb_pc_x <= 32'h40000000;
            pc_x_r <= 32'h40000000;
        end
        else if((mem_wb_ld == 1) && (exe_mem_valid == 1)) begin
            wb_pc_x <= mem_pc_x;
            pc_x_r <= mem_pc_x;
        end
        else begin
            wb_pc_x <= pc_x_r;
        end
    end

    //control word for WB 
    always_ff @ (posedge clk, posedge rst) begin : ctrl_w_wb_register
        if(rst)begin
            ctrl_w_wb_r.regfilemux_sel <= regfilemux::alu_out;
            ctrl_w_WB_o.regfilemux_sel <= regfilemux::alu_out;
        end
        else if((mem_wb_ld == 1) && (exe_mem_valid == 1)) begin
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
        else if((mem_wb_ld == 1) && (exe_mem_valid == 1)) begin
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
            mem_wb_valid <= 1'b0;
        end
        else if((mem_wb_ld == 1) && (exe_mem_valid == 1)) begin
            valid_r <= 1'b1;
            mem_wb_valid <= 1'b1;
        end
        else begin
            mem_wb_valid <= valid_r;
        end
    end

    //ready register
    always_ff @(posedge clk, posedge rst) begin : ready_reg
        if(rst) begin
            ready_r <= 1'b0;
            mem_wb_rdy <= 1'b0;
        end
        else if((mem_wb_ld == 1) && (exe_mem_valid == 1)) begin
            ready_r <= mem_rdy;
            mem_wb_rdy <= mem_rdy;
        end
        else begin
            mem_wb_rdy <= ready_r;
        end
    end

    //u_imm register
    always_ff @ (posedge clk, posedge rst) begin : u_imm_register
        if(rst)begin
            u_imm_o <= 32'b0;
            u_imm_r <= 32'b0;
        end
        else if((mem_wb_ld == 1) && (exe_mem_valid == 1)) begin
            u_imm_o <= u_imm_i;
            u_imm_r <= u_imm_i;
        end
        else begin
            u_imm_o <= u_imm_r;
        end
    end



endmodule : mem_wb_reg
