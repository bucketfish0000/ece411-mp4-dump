module exe_stage
import rv32i_types::*;
import cpuIO::*;
(
    input clk,
    input rst,
    input control_word ctrl_w_EXE,
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] pc_x,
    input logic [31:0] mem_fwd_data,
    input logic [31:0] exe_fwd_data,
    input [31:0] i_imm,
    input [31:0] s_imm,
    input [31:0] b_imm,
    input [31:0] u_imm,
    input [31:0] j_imm,
    output logic [31:0] rs2_out,
    output logic [31:0] alu_out,
    output logic br_en
);
    logic [31:0] rs1_o, rs2_o, alumux1_o, alumux2_o, cmpmux_o;
    cmpmux_sel_t cmp_sel;
    alumux1_sel_t alumux1_sel;
    alumux2_sel_t alumux2_sel;
    rs1_sel_t rs1_sel;
    rs2_sel_t rs2_sel;
    branch_funct3_t cmpop;
    alu_ops aluop;
    
    assign rs2_out = rs2_o;

    function set_default();
        cmp_sel = cmpmux::rs2_out;
        alumux1_sel = alumux::rs1_out;
        alumux2_sel = alumux::i_imm;
        rs1_sel = rsmux::rs1_data;
        rs2_sel = rsmux::rs2_data;
        cmpop = branch_funct3_t::beq;
        aluop = alu_ops::alu_add;
    endfunction

    always_comb begin : exe_ctrl
        set_default();
        unique case(ctrl_w_EXE.opcode)
            op_lui: begin
                ; //exe doesn't do anyting here
            end

            op_auipc: begin
                aluop = alu_ops::alu_add;
                alumux1_sel = alumux::pc_out;
                alumux2_sel = alumux::u_imm;
            end

            op_jal: begin
                aluop = alu_ops::alu_add;
                alumux1_sel = alumux::pc_out;
                alumux2_sel = alumux::j_imm;
            end

            op_jalr: begin
                aluop = alu_ops::alu_add;
                alumux1_sel = alumux::rs1_out;
                alumux2_sel = alumux::i_imm;
            end

            op_br: begin
                cmp_sel = cmpmux::rs2_out;
                unique case(ctrl_w_EXE.funct3)
                    3'b000: cmpop = branch_funct3_t::beq;

                    3'b001: cmpop = branch_funct3_t::bne;

                    3'b100: cmpop = branch_funct3_t::blt;

                    3'b101: cmpop = branch_funct3_t::bge;

                    3'b110: cmpop = branch_funct3_t::bltu;

                    3'b111: cmpop = branch_funct3_t::bgeu;

                    default: ;
                endcase
            end

            op_load: begin
                aluop = alu_ops::add;
                alumux1_sel = alumux::rs1_out;
                alumux2_sel = alumux::i_imm;
            end

            op_store: begin
                aluop = alu_ops::add;
                alumux1_sel = alumux::rs1_out;
                alumux2_sel = alumux::s_imm;
            end

            op_imm: begin
                case(ctrl_w_EXE.funct3):
                    3'b000: begin
                        aluop = alu_ops::alu_add;
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::i_imm;
                    end
                     
                    3'b001: begin
                        aluop = alu_ops::alu_sll;
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::i_imm;
                    end

                    3'b010: begin
                        cmpop = branch_funct3_t::blt;
                        cmp_sel = cmpmux::i_imm;
                    end

                    3'b011: begin
                        cmpop = branch_funct3_t::bltu;
                        cmp_sel = cmpmux::i_imm;
                    end

                    3'b100: begin
                        aluop = alu_ops::alu_xor;
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::i_imm;
                    end

                    3'b101: begin
                        if(ctrl_w_EXE.funct7[5]) begin
                            aluop = alu_ops::alu_sra;
                        end
                        else begin
                            aluop = alu_ops::alu_srl;
                        end
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::i_imm;
                    end

                    3'b110: begin
                        aluop = alu_ops::alu_or;
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::i_imm;
                    end
                    
                    3'b111: begin
                        aluop = alu_ops::alu_and;
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::i_imm;
                    end
                endcase
            end

            op_reg: begin
                case(ctrl_w_EXE.funct3):
                    3'b000: begin
                        if(ctrl_w_EXE.funct7[5]) begin
                            aluop = alu_ops::alu_sub;
                        end
                        else begin
                            aluop = alu_ops::alu_add;
                        end
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::rs2_out;
                    end
                    
                    3'b001 begin
                        aluop = alu_ops::alu_sll;
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::rs2_out;
                    end

                    3'b010: begin
                        cmpop = branch_funct3_t::blt;
                        cmp_sel = cmpmux::rs2_out;
                    end

                    3'b011: begin
                        cmpop = branch_funct3_t::bltu;
                        cmp_sel = cmpmux::rs2_out;
                    end

                    3'b100: begin
                        aluop = alu_ops::alu_xor;
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::rs2_out;
                    end

                    3'b101: begin
                        if(ctrl_w_EXE.funct7[5]) begin
                            aluop = alu_ops::alu_sra;
                        end
                        else begin
                            aluop = alu_ops::alu_srl;
                        end
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::rs2_out;
                    end

                    3'b110: begin
                        aluop = alu_ops::alu_or;
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::rs2_out;
                    end

                    3'b111: begin
                        aluop = alu_ops::alu_and;
                        alumux1_sel = alumux::rs1_out;
                        alumux2_sel = alumux::rs2_out;
                    end
                endcase
            end

            default: ;
        endcase
    end

    cmp cmp_logic(
        .cmpop(cmpop),
        .comp1(rs1_o),
        .comp2(cmpmux_o),
        .br_en(br_en)
    );

    alu alu_logic(
        .aluop(aluop),
        .a(alumux1_o), 
        .b(alumux2_o),
        .f(alu_out)
    );

    always_comb begin : exe_mux
        unique case (cmp_sel)
            cmpmux::rs2_out: cmpmux_o = rs2_o;
            cmpmux::i_imm: cmpmux_o = i_imm;
        endcase

        unique case (alumux1_sel)
            alumux::rs1_out: alumux1_o = rs1_out;
            alumux::pc_out: alumux1_o = pc_x;
        endcase

        unique case (alumux2_sel)
            alumux::i_imm: alumux2_o = i_imm;
            alumux::u_imm: alumux2_o = u_imm;
            alumux::b_imm: alumux2_o = b_imm;
            alumux::s_imm: alumux2_o = s_imm;
            alumux::j_imm: alumux2_o = j_imm;
            alumux::rs2_out: alumux2_o = rs2_o;
        endcase

        unique case (rs1_sel)
            2'b00: rs1_o = rs1_data;
            2'b01: rs1_o = exe_fwd_data;
            2'b10: rs1_o = mem_fwd_data;
            2'b11: ;
        endcase

        unique case (rs2_sel)
            2'b00: rs2_o = rs2_data;
            2'b01: rs2_o = exe_fwd_data;
            2'b10: rs2_o = mem_fwd_data;
            2'b11: ;
        endcase

    end

endmodule : exe_stage