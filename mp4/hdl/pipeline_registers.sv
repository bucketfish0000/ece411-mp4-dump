module fet_dec_reg
    import rv32i_types::*;
    import immediates::*; 
(
    input logic clk,
    input logic rst,
    input logic load,

    input logic ready_i,
    input logic valid_i,
    output logic ready_o,
    output logic valid_o,

    input rv32i_word instr_fetch,
    input rv32i_word pc_fetch,
    input rv32i_word pc_wdata,

    output rv32i_word instr_decode,
    output rv32i_word pc_decode,
    output rv32i_word pc_wdata_decode,

    output logic [63:0] commit_order
);

    logic ready,valid;
    logic[31:0] instr,pc_r, pc_w;
    logic [63:0] order_counter;

    always_ff @(posedge clk)
    begin
        if (rst)
        begin
            ready<='0;
            valid<='0;
            instr<=0;
            pc_r<=0;
            pc_w<=0;
            order_counter <= 64'b0;
        end
        else if (load)
        begin
            ready<=ready_i;
            valid<=valid_i;
            instr<=instr_fetch;
            pc_r<=pc_fetch;
            pc_w<=pc_wdata;
            order_counter <= order_counter + 64'b01;
        end
    end

    always_comb
    begin
        ready_o=ready;
        valid_o=valid;
        instr_decode=instr;
        pc_decode=pc_r;
        pc_wdata_decode=pc_w;
        commit_order = order_counter; 
    end
endmodule : fet_dec_reg

module dec_exe_reg
    import rv32i_types::*;
    import cpuIO::*;
(
    input logic clk,
    input logic rst,
    input logic load,
    input immediates::imm imm_in,

    output immediates::imm imm_out,

    input logic ready_i,
    input logic valid_i,
    output logic ready_o,
    output logic valid_o,

    input control_word cw_in,
    output control_word cw_out
);

    immediates::imm imm_data;
    logic ready,valid;
    control_word cw_data;

    always_ff @(posedge clk)
    begin
        if (rst) begin
            imm_data.i_imm <= 32'b0;
            imm_data.u_imm <= 32'b0;
            imm_data.b_imm <= 32'b0;
            imm_data.s_imm <= 32'b0;
            imm_data.j_imm <= 32'b0;

            ready<= 1'b0;
            valid<= 1'b0;

            cw_data.exe.cmp_sel <= cmpmux::rs2_out;
            cw_data.exe.alumux1_sel <= alumux::rs1_out;
            cw_data.exe.alumux2_sel <= alumux::i_imm;
            cw_data.exe.rs1_sel <= rs1mux::rs1_data;
            cw_data.exe.rs2_sel <= rs2mux::rs2_data;
            cw_data.exe.cmpop <= beq;
            cw_data.exe.aluop <= alu_add;
            cw_data.mem.mem_read_d <= 1'b0;
            cw_data.mem.mem_write_d <= 1'b0;
            cw_data.mem.store_funct3 <= sb;
            cw_data.mem.load_funct3 <= lb;
            cw_data.mem.mar_sel <= marmux::pc_out;
            cw_data.wb.ld_reg <= 1'b0;
            cw_data.wb.regfilemux_sel <= regfilemux::alu_out;
            cw_data.wb.rd_sel <= 5'b00000;
            cw_data.rvfi.valid_commit <= 1'b0;//done
            cw_data.rvfi.order_commit <= 64'b0;//done
            cw_data.rvfi.instruction <= 32'b0;//done
            cw_data.rvfi.rs1_addr <= 5'b0; //done
            cw_data.rvfi.rs2_addr <= 5'b0; //dome
            cw_data.rvfi.rs1_data <= 32'b0; //done
            cw_data.rvfi.rs2_data <= 32'b0; //done
            cw_data.rvfi.rd_wdata <= 32'b0;//done
            cw_data.rvfi.pc_rdata <= 32'h40000000;//done
            cw_data.rvfi.pc_wdata <= 32'b0;//done
            cw_data.rvfi.mem_addr <= 32'b0;//done
            cw_data.rvfi.rmask <= 4'b0;//done
            cw_data.rvfi.wmask <= 4'b0;//done
            cw_data.rvfi.mem_rdata <= 32'b0;//done
            cw_data.rvfi.mem_wdata <= 32'b0;//done
        end
        else if (load) begin
            imm_data<=imm_in;
            ready<=ready_i;
            valid<=valid_i;

            cw_data<=cw_in;
        end
    end 

    always_comb
    begin
        imm_out=imm_data;
        ready_o = ready;
        valid_o = valid;
        cw_out=cw_data;
    end

endmodule : dec_exe_reg

//substantially more complicated than other registers on account of needing to prime mar/mdo/mem_data_out for mem_stage to then be able to 
//start r/w right away
module exe_mem_reg
// Mux types are in their own packages to prevent identiier collisions
// e.g. pcmux::pc_plus4 and regfilemux::pc_plus4 are seperate identifiers
// for seperate enumerated types, you cannot //import rv32i_mux_types::*;
import rv32i_types::*;
import cpuIO::*;
(
    input logic clk, //from datapath
    input logic rst, //from datapath

    input logic br_en_i, 
    input logic exe_mem_ld, 
    input logic exe_rdy,
    input logic de_exe_valid,
    input logic [31:0] alu_out_i, 
    input logic [31:0] rs2_out_i,
    input logic [31:0] u_imm_i, 

    output logic [31:0] exe_fwd_data, 
    output logic [31:0] u_imm_o, 
    output logic br_en_o, 
    output logic exe_mem_valid, 
    output logic exe_mem_rdy, 

    output logic [31:0] mem_address_d, //to data cache
    output logic [31:0] mem_wdata_d, //to data cache
    output logic [3:0] mem_byte_enable, //to data cache

    input control_word cw_in,
    output control_word cw_out,

    output logic [3:0] wmask
);

    logic [31:0] fwd_r_EX, u_imm_r;
    logic [3:0] mem_byte_enable_r;
    control_word cw_data;
    logic br_en_r, valid_r, ready_r;

     logic [31:0] marmux_o, mem_addr;
    logic trap;
    logic [3:0] rmask, wmask_temp;

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

    //control word reg 
     always_ff @ (posedge clk, posedge rst) begin : cw_register
        if(rst)begin
            cw_data.exe.cmp_sel <= cmpmux::rs2_out;
            cw_data.exe.alumux1_sel <= alumux::rs1_out;
            cw_data.exe.alumux2_sel <= alumux::i_imm;
            cw_data.exe.rs1_sel <= rs1mux::rs1_data;
            cw_data.exe.rs2_sel <= rs2mux::rs2_data;
            cw_data.exe.cmpop <= beq;
            cw_data.exe.aluop <= alu_add;
            cw_data.mem.mem_read_d <= 1'b0;
            cw_data.mem.mem_write_d <= 1'b0;
            cw_data.mem.store_funct3 <= sb;
            cw_data.mem.load_funct3 <= lb;
            cw_data.mem.mar_sel <= marmux::pc_out;
            cw_data.wb.ld_reg <= 1'b0;
            cw_data.wb.regfilemux_sel <= regfilemux::alu_out;
            cw_data.wb.rd_sel <= 5'b00000;
            cw_data.rvfi.valid_commit <= 1'b0;//done
            cw_data.rvfi.order_commit <= 64'b0;//done
            cw_data.rvfi.instruction <= 32'b0;//done
            cw_data.rvfi.rs1_addr <= 5'b0; //done
            cw_data.rvfi.rs2_addr <= 5'b0; //dome
            cw_data.rvfi.rs1_data <= 32'b0; //done
            cw_data.rvfi.rs2_data <= 32'b0; //done
            cw_data.rvfi.rd_wdata <= 32'b0;//done
            cw_data.rvfi.pc_rdata <= 32'h40000000;//done
            cw_data.rvfi.pc_wdata <= 32'b0;//done
            cw_data.rvfi.mem_addr <= 32'b0;//done
            cw_data.rvfi.rmask <= 4'b0;//done
            cw_data.rvfi.wmask <= 4'b0;//done
            cw_data.rvfi.mem_rdata <= 32'b0;//done
            cw_data.rvfi.mem_wdata <= 32'b0;//done

            cw_out.exe.cmp_sel <= cmpmux::rs2_out;
            cw_out.exe.alumux1_sel <= alumux::rs1_out;
            cw_out.exe.alumux2_sel <= alumux::i_imm;
            cw_out.exe.rs1_sel <= rs1mux::rs1_data;
            cw_out.exe.rs2_sel <= rs2mux::rs2_data;
            cw_out.exe.cmpop <= beq;
            cw_out.exe.aluop <= alu_add;
            cw_out.mem.mem_read_d <= 1'b0;
            cw_out.mem.mem_write_d <= 1'b0;
            cw_out.mem.store_funct3 <= sb;
            cw_out.mem.load_funct3 <= lb;
            cw_out.mem.mar_sel <= marmux::pc_out;
            cw_out.wb.ld_reg <= 1'b0;
            cw_out.wb.regfilemux_sel <= regfilemux::alu_out;
            cw_out.wb.rd_sel <= 5'b00000;
            cw_out.rvfi.valid_commit <= 1'b0;//done
            cw_out.rvfi.order_commit <= 64'b0;//done
            cw_out.rvfi.instruction <= 32'b0;//done
            cw_out.rvfi.rs1_addr <= 5'b0; //done
            cw_out.rvfi.rs2_addr <= 5'b0; //dome
            cw_out.rvfi.rs1_data <= 32'b0; //done
            cw_out.rvfi.rs2_data <= 32'b0; //done
            cw_out.rvfi.rd_wdata <= 32'b0;//done
            cw_out.rvfi.pc_rdata <= 32'h40000000;//done
            cw_out.rvfi.pc_wdata <= 32'b0;//done
            cw_out.rvfi.mem_addr <= 32'b0;//done
            cw_out.rvfi.rmask <= 4'b0;//done
            cw_out.rvfi.wmask <= 4'b0;//done
            cw_out.rvfi.mem_rdata <= 32'b0;//done
            cw_out.rvfi.mem_wdata <= 32'b0;//done
        end
        else if((exe_mem_ld == 1) && (de_exe_valid == 1)) begin
            cw_data.exe <= cw_in.exe;
            cw_data.mem <= cw_in.mem;
            cw_data.wb <= cw_in.wb;
            cw_data.rvfi.valid_commit <= cw_in.rvfi.valid_commit;//done
            cw_data.rvfi.order_commit <= cw_in.rvfi.order_commit;//done
            cw_data.rvfi.instruction <= cw_in.rvfi.instruction;//done
            cw_data.rvfi.rs1_addr <= cw_in.rvfi.rs1_addr; //done
            cw_data.rvfi.rs2_addr <= cw_in.rvfi.rs2_addr; //dome
            cw_data.rvfi.rs1_data <= cw_in.rvfi.rs1_data; //done
            cw_data.rvfi.rs2_data <= cw_in.rvfi.rs2_data; //done
            cw_data.rvfi.rd_wdata <= cw_in.rvfi.rd_wdata;//done
            cw_data.rvfi.pc_rdata <= cw_in.rvfi.pc_rdata;//done
            cw_data.rvfi.pc_wdata <= cw_in.rvfi.pc_wdata;//done
            cw_data.rvfi.mem_addr <= mem_addr;//done
            cw_data.rvfi.rmask <= rmask;//done
            cw_data.rvfi.wmask <= wmask_temp;//done
            cw_data.rvfi.mem_rdata <= cw_in.rvfi.mem_rdata;//done
            cw_data.rvfi.mem_wdata <= rs2_out_i;//done

            cw_out.exe <= cw_in.exe;
            cw_out.mem <= cw_in.mem;
            cw_out.wb <= cw_in.wb;
            cw_out.rvfi.valid_commit <= cw_in.rvfi.valid_commit;//done
            cw_out.rvfi.order_commit <= cw_in.rvfi.order_commit;//done
            cw_out.rvfi.instruction <= cw_in.rvfi.instruction;//done
            cw_out.rvfi.rs1_addr <= cw_in.rvfi.rs1_addr; //done
            cw_out.rvfi.rs2_addr <= cw_in.rvfi.rs2_addr; //dome
            cw_out.rvfi.rs1_data <= cw_in.rvfi.rs1_data; //done
            cw_out.rvfi.rs2_data <= cw_in.rvfi.rs2_data; //done
            cw_out.rvfi.rd_wdata <= cw_in.rvfi.rd_wdata;//done
            cw_out.rvfi.pc_rdata <= cw_in.rvfi.pc_rdata;//done
            cw_out.rvfi.pc_wdata <= cw_in.rvfi.pc_wdata;//done
            cw_out.rvfi.mem_addr <= mem_addr;//done
            cw_out.rvfi.rmask <= rmask;//done
            cw_out.rvfi.wmask <= wmask_temp;//done
            cw_out.rvfi.mem_rdata <= cw_in.rvfi.mem_rdata;//done
            cw_out.rvfi.mem_wdata <= rs2_out_i;//done
        end
        else begin
            cw_out <= cw_data;
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
    assign wmask = wmask_temp;

    always_comb begin : mem_mux
        unique case (cw_in.mem.mar_sel)
            marmux::pc_out: marmux_o = cw_in.rvfi.pc_rdata;
            marmux::alu_out: marmux_o = alu_out_i;
        endcase
    end

    mem_data_out mdo_reg(
        .clk(clk),
        .reset(rst),
        .load_data_out((exe_mem_ld == 1) && (de_exe_valid == 1) && ((cw_in.mem.mem_read_d) || (cw_in.mem.mem_write_d))),
        .mdo_in(rs2_out_i),
        .mdo_out(mem_wdata_d)
    );

    always_comb begin : calc_addr
        rmask = 4'b0000;
        wmask_temp = 4'b0000;
        mem_addr = marmux_o;
        trap = 1'b0;

        if(cw_in.mem.mem_read_d) begin
            case (cw_in.mem.load_funct3)
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
        else if(cw_in.mem.mem_write_d) begin
            case (cw_in.mem.store_funct3)
                sw: begin
                    wmask_temp = 4'b1111;
                end
                sh: begin
                    wmask_temp = (4'b0011) << (marmux_o%4); /* Modify for MP1 Final */ //correct???
                    mem_addr = marmux_o - (marmux_o%4);
                end
                sb: begin
                    wmask_temp = (4'b0001) << (marmux_o%4); /* Modify for MP1 Final */ //correct???
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
        else if((exe_mem_ld == 1) && (de_exe_valid == 1) && ((cw_in.mem.mem_read_d) || (cw_in.mem.mem_write_d))) begin
            if(cw_in.mem.mem_read_d) begin
                mem_byte_enable <= rmask;
                mem_byte_enable_r <= rmask;
            end
            else if(cw_in.mem.mem_write_d) begin
                mem_byte_enable <= wmask_temp;
                mem_byte_enable_r <= wmask_temp;
            end
        end
        else begin
            mem_byte_enable <= mem_byte_enable_r;
        end
    end

    mar mar_reg(
        .clk(clk),
        .reset(rst),
        .load_mar((exe_mem_ld == 1) && (de_exe_valid == 1) && ((cw_in.mem.mem_read_d) || (cw_in.mem.mem_write_d))),
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
    input logic [31:0] alu_out_i, //aka exe_fwd_data
    input logic br_en_i,
    input logic [31:0] u_imm_i,
    input logic [31:0] mem_rdata_D_i,
    input logic exe_mem_valid,
    output logic [31:0] u_imm_o,
    output logic [31:0] mem_rdata_D_o,
    output logic mem_wb_rdy,
    output logic mem_wb_valid,
    output logic [31:0] alu_out_o, //aka exe_fwd_data
    output logic br_en_o,

    input control_word cw_in,
    output control_word cw_out
);
    logic [31:0] alu_out_r, u_imm_r, mem_rdata_r;
    control_word cw_data;
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


    //control word for WB 
    always_ff @ (posedge clk, posedge rst) begin : cw_register
        if(rst)begin
            cw_data.exe.cmp_sel <= cmpmux::rs2_out;
            cw_data.exe.alumux1_sel <= alumux::rs1_out;
            cw_data.exe.alumux2_sel <= alumux::i_imm;
            cw_data.exe.rs1_sel <= rs1mux::rs1_data;
            cw_data.exe.rs2_sel <= rs2mux::rs2_data;
            cw_data.exe.cmpop <= beq;
            cw_data.exe.aluop <= alu_add;
            cw_data.mem.mem_read_d <= 1'b0;
            cw_data.mem.mem_write_d <= 1'b0;
            cw_data.mem.store_funct3 <= sb;
            cw_data.mem.load_funct3 <= lb;
            cw_data.mem.mar_sel <= marmux::pc_out;
            cw_data.wb.ld_reg <= 1'b0;
            cw_data.wb.regfilemux_sel <= regfilemux::alu_out;
            cw_data.wb.rd_sel <= 5'b00000;
            cw_data.rvfi.valid_commit <= 1'b0;//done
            cw_data.rvfi.order_commit <= 64'b0;//done
            cw_data.rvfi.instruction <= 32'b0;//done
            cw_data.rvfi.rs1_addr <= 5'b0; //done
            cw_data.rvfi.rs2_addr <= 5'b0; //dome
            cw_data.rvfi.rs1_data <= 32'b0; //done
            cw_data.rvfi.rs2_data <= 32'b0; //done
            cw_data.rvfi.rd_wdata <= 32'b0;//done
            cw_data.rvfi.pc_rdata <= 32'h40000000;//done
            cw_data.rvfi.pc_wdata <= 32'b0;//done
            cw_data.rvfi.mem_addr <= 32'b0;//done
            cw_data.rvfi.rmask <= 4'b0;//done
            cw_data.rvfi.wmask <= 4'b0;//done
            cw_data.rvfi.mem_rdata <= 32'b0;//done
            cw_data.rvfi.mem_wdata <= 32'b0;//done

            cw_out.exe.cmp_sel <= cmpmux::rs2_out;
            cw_out.exe.alumux1_sel <= alumux::rs1_out;
            cw_out.exe.alumux2_sel <= alumux::i_imm;
            cw_out.exe.rs1_sel <= rs1mux::rs1_data;
            cw_out.exe.rs2_sel <= rs2mux::rs2_data;
            cw_out.exe.cmpop <= beq;
            cw_out.exe.aluop <= alu_add;
            cw_out.mem.mem_read_d <= 1'b0;
            cw_out.mem.mem_write_d <= 1'b0;
            cw_out.mem.store_funct3 <= sb;
            cw_out.mem.load_funct3 <= lb;
            cw_out.mem.mar_sel <= marmux::pc_out;
            cw_out.wb.ld_reg <= 1'b0;
            cw_out.wb.regfilemux_sel <= regfilemux::alu_out;
            cw_out.wb.rd_sel <= 5'b00000;
            cw_out.rvfi.valid_commit <= 1'b0;//done
            cw_out.rvfi.order_commit <= 64'b0;//done
            cw_out.rvfi.instruction <= 32'b0;//done
            cw_out.rvfi.rs1_addr <= 5'b0; //done
            cw_out.rvfi.rs2_addr <= 5'b0; //dome
            cw_out.rvfi.rs1_data <= 32'b0; //done
            cw_out.rvfi.rs2_data <= 32'b0; //done
            cw_out.rvfi.rd_wdata <= 32'b0;//done
            cw_out.rvfi.pc_rdata <= 32'h40000000;//done
            cw_out.rvfi.pc_wdata <= 32'b0;//done
            cw_out.rvfi.mem_addr <= 32'b0;//done
            cw_out.rvfi.rmask <= 4'b0;//done
            cw_out.rvfi.wmask <= 4'b0;//done
            cw_out.rvfi.mem_rdata <= 32'b0;//done
            cw_out.rvfi.mem_wdata <= 32'b0;//done
        end
        else if((mem_wb_ld == 1) && (exe_mem_valid == 1)) begin
            cw_data.exe <= cw_in.exe;
            cw_data.mem <= cw_in.mem;
            cw_data.wb <= cw_in.wb;
            cw_data.rvfi.valid_commit <= cw_in.rvfi.valid_commit;//done
            cw_data.rvfi.order_commit <= cw_in.rvfi.order_commit;//done
            cw_data.rvfi.instruction <= cw_in.rvfi.instruction;//done
            cw_data.rvfi.rs1_addr <= cw_in.rvfi.rs1_addr; //done
            cw_data.rvfi.rs2_addr <= cw_in.rvfi.rs2_addr; //dome
            cw_data.rvfi.rs1_data <= cw_in.rvfi.rs1_data; //done
            cw_data.rvfi.rs2_data <= cw_in.rvfi.rs2_data; //done
            cw_data.rvfi.rd_wdata <= cw_in.rvfi.rd_wdata;//done
            cw_data.rvfi.pc_rdata <= cw_in.rvfi.pc_rdata;//done
            cw_data.rvfi.pc_wdata <= cw_in.rvfi.pc_wdata;//done
            cw_data.rvfi.mem_addr <= cw_in.rvfi.mem_addr;//done
            cw_data.rvfi.rmask <= cw_in.rvfi.rmask;//done
            cw_data.rvfi.wmask <= cw_in.rvfi.wmask;//done
            cw_data.rvfi.mem_rdata <= mem_rdata_D_i;//done
            cw_data.rvfi.mem_wdata <= cw_in.rvfi.mem_wdata;//done

            cw_out.exe <= cw_in.exe;
            cw_out.mem <= cw_in.mem;
            cw_out.wb <= cw_in.wb;
            cw_out.rvfi.valid_commit <= cw_in.rvfi.valid_commit;//done
            cw_out.rvfi.order_commit <= cw_in.rvfi.order_commit;//done
            cw_out.rvfi.instruction <= cw_in.rvfi.instruction;//done
            cw_out.rvfi.rs1_addr <= cw_in.rvfi.rs1_addr; //done
            cw_out.rvfi.rs2_addr <= cw_in.rvfi.rs2_addr; //dome
            cw_out.rvfi.rs1_data <= cw_in.rvfi.rs1_data; //done
            cw_out.rvfi.rs2_data <= cw_in.rvfi.rs2_data; //done
            cw_out.rvfi.rd_wdata <= cw_in.rvfi.rd_wdata;//done
            cw_out.rvfi.pc_rdata <= cw_in.rvfi.pc_rdata;//done
            cw_out.rvfi.pc_wdata <= cw_in.rvfi.pc_wdata;//done
            cw_out.rvfi.mem_addr <= cw_in.rvfi.mem_addr;//done
            cw_out.rvfi.rmask <= cw_in.rvfi.rmask;//done
            cw_out.rvfi.wmask <= cw_in.rvfi.wmask;//done
            cw_out.rvfi.mem_rdata <= mem_rdata_D_i;//done
            cw_out.rvfi.mem_wdata <= cw_in.rvfi.mem_wdata;//done
        end
        else begin
            cw_out <= cw_data;
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
