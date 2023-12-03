module exe_stage
import cpuIO::*;
import rv32i_types::*;
// Mux types are in their own packages to prevent identiier collisions
// e.g. pcmux::pc_plus4 and regfilemux::pc_plus4 are seperate identifiers
// for seperate enumerated types, you cannot //import rv32i_mux_types::*;
// import pcmux::*;
// import marmux::*;
// import cmpmux::*;
// import alumux::*;
// import regfilemux::*;
// import rs1mux::*;
// import rs2mux::*;
import immediates::*;
(
    input clk, 
    input logic rst,
    input control_word_de_exe ctrl_w,
    input rv32i_opcode opcode_exe,
    input logic [31:0] mem_fwd_data,
    input logic [31:0] exe_fwd_data,
    input logic [31:0] wb_fwd_data,
    input imm imm_in,
    input logic exe_fwd_pc_sel,
    
    
    output logic [31:0] rs1_out,
    output logic [31:0] rs2_out,
    output logic [31:0] alu_out,
    output logic br_en,
    output logic [31:0] bimm_out,
    output logic prediction_exe,
    output logic false_prediction,
    input logic de_exe_valid,
    input logic de_exe_rdy,
    output logic exe_rdy,

    output control_word_exe_mem rvfi_exe

);
    logic [31:0] rs1_o, rs2_o, alumux1_o, alumux2_o, cmpmux_o,pc_wdata;/* multi_low, multi_high, multi_r2, multi_r1, alu_fake;*/
    logic [63:0] prev_order;
    logic br_en_temp, exe_rdy_multi;
    assign false_prediction = (ctrl_w.rvfi.prediction != (br_en_temp)) && (opcode_exe==op_br||opcode_exe==op_jal) || (opcode_exe==op_jalr);
    cmpmux::cmpmux_sel_t cmp_sel;
    alumux::alumux1_sel_t alumux1_sel;
    alumux::alumux2_sel_t alumux2_sel;
    rs1mux::rs1_sel_t rs1_sel;
    rs2mux::rs2_sel_t rs2_sel;
    rv32i_word i_imm;
    rv32i_word s_imm;
    rv32i_word b_imm;
    rv32i_word u_imm;
    rv32i_word j_imm;

    assign br_en = br_en_temp;
    assign i_imm = imm_in.i_imm;
    assign s_imm = imm_in.s_imm;
    assign b_imm = imm_in.b_imm;
    assign u_imm = imm_in.u_imm;
    assign j_imm = imm_in.j_imm;
    assign rs2_out = rs2_o;
    assign rs1_out = rs1_o;
    assign bimm_out = b_imm;
    assign prediction_exe = ctrl_w.rvfi.prediction;

    always_comb begin: exe_fwd_pc_mux
    case(exe_fwd_pc_sel)
        1'b0: pc_wdata = alu_out;
        1'b1: pc_wdata = ctrl_w.rvfi.pc_rdata+4;
    endcase
    end

    always_ff @(posedge clk) begin : prev_order_tracker
    if(rst)
        prev_order <= 64'hffffffffffffffff;
    else
        prev_order <= ctrl_w.rvfi.order_commit;
    end

    cmp cmp_logic(
        .cmpop(ctrl_w.exe.cmpop),
        .comp1(rs1_o),
        .comp2(cmpmux_o),
        .br_en(br_en_temp)
    );

    alu alu_logic(
        .clk(clk),
        .rst(rst),
        .ctrl_w(ctrl_w.exe),
        .new_instruction((prev_order != ctrl_w.rvfi.order_commit)),
        .a(alumux1_o), 
        .b(alumux2_o),
        .f(alu_out),
        .done(exe_rdy) 
    );

    always_comb begin : exe_mux
        unique case (ctrl_w.exe.rs1_sel)
            2'b00: rs1_o = ctrl_w.rvfi.rs1_data;
            2'b01: rs1_o = exe_fwd_data;
            2'b10: rs1_o = mem_fwd_data;
            2'b11: rs1_o = wb_fwd_data;
        endcase

        unique case (ctrl_w.exe.rs2_sel)
            2'b00: rs2_o = ctrl_w.rvfi.rs2_data;
            2'b01: rs2_o = exe_fwd_data;
            2'b10: rs2_o = mem_fwd_data;
            2'b11: rs2_o = wb_fwd_data;
        endcase

        unique case (ctrl_w.exe.cmp_sel)
            cmpmux::rs2_out: cmpmux_o = rs2_o;
            cmpmux::i_imm: cmpmux_o = i_imm;
        endcase

        unique case (ctrl_w.exe.alumux1_sel)
            alumux::rs1_out: alumux1_o = rs1_o;
            alumux::pc_out: alumux1_o = ctrl_w.rvfi.pc_rdata;
        endcase

        unique case (ctrl_w.exe.alumux2_sel)
            alumux::i_imm: alumux2_o = i_imm;
            alumux::u_imm: alumux2_o = u_imm;
            alumux::b_imm: alumux2_o = b_imm;
            alumux::s_imm: alumux2_o = s_imm;
            alumux::j_imm: alumux2_o = j_imm;
            alumux::rs2_out: alumux2_o = rs2_o;
        endcase
    end

logic [31:0] pc_temp;

always_comb begin : regfile_ctrl_signals

    if(rst || !((de_exe_rdy == 1) && (de_exe_valid == 1))) begin
        rvfi_exe.mem.mem_read_d = 1'b0;
        rvfi_exe.mem.mem_write_d = 1'b0;
        rvfi_exe.mem.store_funct3 = sb;
        rvfi_exe.mem.load_funct3 = lb;
        rvfi_exe.mem.mar_sel = marmux::pc_out;
        rvfi_exe.mem.memfwdmux_sel = memfwdmux::mem_fwd_data;
        rvfi_exe.wb.ld_reg = 1'b0;
        rvfi_exe.wb.regfilemux_sel = regfilemux::alu_out;
        rvfi_exe.wb.rd_sel = 5'b00000;
        rvfi_exe.rvfi.valid_commit = 1'b0;//done
        rvfi_exe.rvfi.order_commit = 64'b0;//done
        rvfi_exe.rvfi.instruction = 32'b0;//done
        rvfi_exe.rvfi.rs1_addr = 5'b0; //done
        rvfi_exe.rvfi.rs2_addr = 5'b0; //dome
        rvfi_exe.rvfi.rs1_data = 32'b0; //done
        rvfi_exe.rvfi.rs2_data = 32'b0; //done
        rvfi_exe.rvfi.rd_wdata = 32'b0;//done
        rvfi_exe.rvfi.pc_rdata = 32'h40000000;//done
        rvfi_exe.rvfi.pc_wdata = 32'b0;//done
        rvfi_exe.rvfi.mem_addr = 32'b0;//done
        rvfi_exe.rvfi.rmask = 4'b0;//done
        rvfi_exe.rvfi.wmask = 4'b0;//done
        rvfi_exe.rvfi.mem_rdata = 32'b0;//done
        rvfi_exe.rvfi.mem_wdata = 32'b0;//done
        rvfi_exe.rvfi.prediction = 1'b0;
    end
    else begin
        if (((opcode_exe == op_br) || (opcode_exe == op_jal))&&false_prediction) begin
            rvfi_exe.rvfi.valid_commit = ctrl_w.rvfi.valid_commit;//done
            rvfi_exe.mem = ctrl_w.mem;
            rvfi_exe.wb = ctrl_w.wb;
            rvfi_exe.rvfi.order_commit = ctrl_w.rvfi.order_commit;//done
            rvfi_exe.rvfi.instruction = ctrl_w.rvfi.instruction;//done
            rvfi_exe.rvfi.rs1_addr = ctrl_w.rvfi.rs1_addr; //done
            rvfi_exe.rvfi.rs2_addr = ctrl_w.rvfi.rs2_addr; //dome
            rvfi_exe.rvfi.rs1_data = rs1_o; //done
            rvfi_exe.rvfi.rs2_data = rs2_o; //done
            rvfi_exe.rvfi.rd_wdata = 32'b0;//done
            rvfi_exe.rvfi.pc_rdata = ctrl_w.rvfi.pc_rdata;//done
            rvfi_exe.rvfi.pc_wdata = pc_wdata;//done
            rvfi_exe.rvfi.mem_addr = ctrl_w.rvfi.mem_addr;//done
            rvfi_exe.rvfi.rmask = ctrl_w.rvfi.rmask;//done
            rvfi_exe.rvfi.wmask = ctrl_w.rvfi.wmask;//done
            rvfi_exe.rvfi.mem_rdata = ctrl_w.rvfi.mem_rdata;//done
            rvfi_exe.rvfi.mem_wdata = ctrl_w.rvfi.mem_wdata;//done
            rvfi_exe.rvfi.prediction = ctrl_w.rvfi.prediction;
        end
        else if((opcode_exe == op_jalr)) begin
            rvfi_exe.rvfi.valid_commit = ctrl_w.rvfi.valid_commit;//done
            rvfi_exe.mem = ctrl_w.mem;
            rvfi_exe.wb = ctrl_w.wb;
            rvfi_exe.rvfi.order_commit = ctrl_w.rvfi.order_commit;//done
            rvfi_exe.rvfi.instruction = ctrl_w.rvfi.instruction;//done
            rvfi_exe.rvfi.rs1_addr = ctrl_w.rvfi.rs1_addr; //done
            rvfi_exe.rvfi.rs2_addr = ctrl_w.rvfi.rs2_addr; //dome
            rvfi_exe.rvfi.rs1_data = rs1_o; //done
            rvfi_exe.rvfi.rs2_data = rs2_o; //done
            rvfi_exe.rvfi.rd_wdata = 32'b0;//done
            rvfi_exe.rvfi.pc_rdata = ctrl_w.rvfi.pc_rdata;//done
            rvfi_exe.rvfi.pc_wdata = {pc_wdata[31:1], 1'b0};//done
            rvfi_exe.rvfi.mem_addr = ctrl_w.rvfi.mem_addr;//done
            rvfi_exe.rvfi.rmask = ctrl_w.rvfi.rmask;//done
            rvfi_exe.rvfi.wmask = ctrl_w.rvfi.wmask;//done
            rvfi_exe.rvfi.mem_rdata = ctrl_w.rvfi.mem_rdata;//done
            rvfi_exe.rvfi.mem_wdata = ctrl_w.rvfi.mem_wdata;//done
            rvfi_exe.rvfi.prediction = ctrl_w.rvfi.prediction;
        end
        else begin
            rvfi_exe.mem = ctrl_w.mem;
            rvfi_exe.wb = ctrl_w.wb;
            rvfi_exe.rvfi = ctrl_w.rvfi;
        end
    end
end
endmodule : exe_stage
