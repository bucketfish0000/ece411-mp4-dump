/*ld and READY signals:
    ld(Output): 
        -Always load unless one of the stages in front of you is stalling(valid == 1 and rdy == 0)
    valid(Input):
        -If high then register has been initialized after cold start(or flush)
        -Otherwise value is unitialized
    ready(Input):
        -If high then stage has finished computation
        -If low still computing so don't load the register before stage yet(stalling if valid is high)
*/
module mp4control
import rv32i_types::*;
import cpuIO::*;
(
    input clk,
    input rst,

    /*---if signals---*/
    //none...?
    output logic load_pc,
    output logic  imem_read,
    input logic icache_resp,
    /*---de signals... none?---*/
    input rv32i_opcode opcode,
    input logic[2:0] func3,
    input logic[6:0] func7,
    //...anything else?

    /*---exe signals---*/
    input logic br_en,
    //...anything else?

    /*---mem_stage signals---*/
    input logic mem_read_D,
    input logic mem_write_D,
    //...anything else?

    /*---ready signals---*/
    input logic if_rdy,
    input logic de_rdy,
    input logic exe_rdy,
    input logic mem_rdy,
    input logic wb_rdy,
    input rv32i_reg rd_addr,

    /*---valid signals---*/
    input logic if_valid,
    input logic de_valid,
    input logic exe_valid,
    input logic mem_valid,
    input logic wb_valid,

    /*---continue/load signals---*/
    output logic if_de_ld,
    output logic de_exe_ld,
    output logic exe_mem_ld,
    output logic mem_wb_ld,

    /*---cpu_cw---*/
    //output control_word cw_cpu, 
    output cw_execute cw_exe,
    output cw_mem cw_memory,
    output cw_writeback cw_wb,

    output pcmux::pcmux_sel_t pcmux_sel 
);

logic [4:0] rdy;
logic [4:0] vald;

assign rdy = {if_rdy, de_rdy, exe_rdy, mem_rdy, wb_rdy};
assign vald = {if_valid, de_valid, exe_valid, mem_valid, wb_valid};

//how know when load pc? Gonna need testing to see for sure
//logic load_pc_next;
// always_comb begin : icache_fetch_interactions
//     if (rst) begin
//         imem_read = 1'b0;
//         load_pc = 1'b0;
//     end
//     else begin
//         imem_read = 1'b1;
//         load_pc = 1'b1;
//     end
// end: icache_fetch_interactions
always_comb begin : ld_ctrl
    if(rst) begin
        if_de_ld = 1'b0;
        imem_read = 1'b0;
        load_pc = 1'b0;
        de_exe_ld = 1'b0;
        exe_mem_ld = 1'b0;
        mem_wb_ld = 1'b0;
    end
    else begin
        /*
            start:
            i1:  addi r1, r0, 17     #r1 = 17 = r0 + 17 = 0 + 17
            i2:  ld r2, val_x        #r2 = 16 = mem[val_x]
                 nop
                 nop
            i3:  add r3, r1, r2      #r3 = 33 = r1 + r2 = 17 + 16
            end
                 nop
                 nop
                 nop
                 nop
                 nop

            val_x: .word 0x0000010 #0x010 = 16 

            ------------------------------------------------------------------------------------
            cyc   |   ld   |   de   |   exe   |   mem   |   wb   ||    rdy    |   valid   |    ld    |    event
             0    |     x    |    x   |    x    |    x    |   x    ||  000000   |   000000  |  100000  |  start
             1    |    i1    |    x   |    x    |    x    |   x    ||  100000   |   100000  |  110000  |  I_read_hit,
             2    |    i2    |   i1   |    x    |    x    |   x    ||  110000   |   110000  |  111000  |  I_read_hit, I_resp
             3    |   nop    |   i2   |   i1    |    x    |   x    ||  111000   |   111000  |  111100  |  I_read_hit, I_resp
             4    |   nop    |  nop   |   i2    |   i1    |   x    ||  111100   |           |  111110  |  I_read_hit, I_resp
             5    |    i3    |  nop   |  nop    |   i2    |  i1    ||  111110   |           |  111111  |  I_read_hit, I_resp
             6    |   end    |  nop   |  nop    |   i2    |  i1    ||  111101   |           |  000010  |  I_read_hit, I_resp, r1 = 17
             7    |   end    |  nop   |  nop    |   i2    |   x    ||  111110   |           |  111111  |  D_resp
             8    |   nop    |   i3   |  nop    |  nop    |  i2    ||  111111   |           |  111111  |  chugga,     r2 = 16
             9    |   nop    |  end   |   i3    |  nop    | nop    ||  111111   |           |  111111  |  chugga     
             10   |   nop    |  nop   |  end    |   i3    | nop    ||  111111   |           |  111111  |  choo  
             11   |   nop    |  nop   |  nop    |  end    |  i3    ||  111111   |           |  111111  |  choo,       r3 = 33       
             12   |   nop    |  nop   |  nop    |  nop    | end    ||  111111   |           |  111111  |  end         
        */

        if_de_ld = 1'b1;
        imem_read = 1'b1;
        load_pc = 1'b1;
        de_exe_ld = 1'b1;
        exe_mem_ld = 1'b1;
        mem_wb_ld = 1'b1;

        //              de                          exe                                         mem                                     wb
        if(((rdy[3] == 0) && (vald[3] == 1)) || ((rdy[2] == 0) && (vald[2] == 1)) || ((rdy[1] == 0) && (vald[1] == 1)) || ((rdy[0] == 0) && (vald[0] == 1))) begin
            if_de_ld = 1'b0;
            imem_read = 1'b0;
            load_pc = 1'b0;
        end

        //           exe                                         mem                                     wb
        if(((rdy[2] == 0) && (vald[2] == 1)) || ((rdy[1] == 0) && (vald[1] == 1)) || ((rdy[0] == 0) && (vald[0] == 1))) begin
            if_de_ld = 1'b0;
            imem_read = 1'b0;
            load_pc = 1'b0;
            de_exe_ld = 1'b0;
        end

        //                 mem                                     wb
        if(((rdy[1] == 0) && (vald[1] == 1)) || ((rdy[0] == 0) && (vald[0] == 1))) begin
            if_de_ld = 1'b0;
            imem_read = 1'b0;
            load_pc = 1'b0;
            de_exe_ld = 1'b0;
            exe_mem_ld = 1'b0;
        end
        
        //                  wb
        if(((rdy[0] == 0) && (vald[0] == 1))) begin
            if_de_ld = 1'b0;
            imem_read = 1'b0;
            load_pc = 1'b0;
            de_exe_ld = 1'b0;
            exe_mem_ld = 1'b0;
            mem_wb_ld = 1'b0;
        end

    end
end

// /***************** USED BY RVFIMON --- ONLY MODIFY WHEN TOLD *****************/
// logic trap;
// logic [3:0] rmask, wmask;
// /*****************************************************************************/

branch_funct3_t branch_funct3;
store_funct3_t store_funct3;
load_funct3_t load_funct3;
arith_funct3_t arith_funct3;

assign arith_funct3 = arith_funct3_t'(func3);
assign branch_funct3 = branch_funct3_t'(func3);
assign load_funct3 = load_funct3_t'(func3);
assign store_funct3 = store_funct3_t'(func3);

function void set_def();
    // cw_cpu.opcode = 7'b0;
    // cw_cpu.funct3 = 3'b0;
    // cw_cpu.funct7 = 7'b0;
    cw_exe.cmp_sel = cmpmux::rs2_out;
    cw_exe.alumux1_sel = alumux::rs1_out;
    cw_exe.alumux2_sel = alumux::i_imm;
    cw_exe.rs1_sel = rs1mux::rs1_data;
    cw_exe.rs2_sel = rs2mux::rs2_data;
    cw_exe.cmpop = beq;
    cw_exe.aluop = alu_add;
    cw_memory.mem_read_d = 1'b0;
    cw_memory.mem_write_d = 1'b0;
    cw_memory.mar_sel = marmux::pc_out;
    cw_wb.ld_reg = 1'b0;
    cw_wb.regfilemux_sel = regfilemux::alu_out;
endfunction

always_comb begin : cpu_cw
    if(rst) begin
        set_def();
    end
    else if(rdy[4]) begin
        // cw_cpu.opcode = opcode;
        // cw_cpu.funct3 = func3;
        // cw_cpu.funct7 = func7;

        unique case(opcode)
            op_lui: begin
                //exe doesn't do anyting here

                //mem doesn't do anything here

                //writeback
                cw_wb.ld_reg = 1'b1;
                cw_wb.regfilemux_sel = regfilemux::u_imm;

                //fetch
                pcmux_sel = pcmux::pc_plus4;
                
            end

            op_auipc: begin
                //exe
                cw_exe.aluop = alu_add;
                cw_exe.alumux1_sel = alumux::pc_out;
                cw_exe.alumux2_sel = alumux::u_imm;

                //mem doesn't do anything here

                //writeback
                cw_wb.ld_reg = 1'b1;
                cw_wb.rd_sel = rd_addr;
                cw_wb.regfilemux_sel = regfilemux::alu_out;

                //fetch
                pcmux_sel = pcmux::pc_plus4;
            end

            op_jal: begin
                //exe
                cw_exe.aluop = alu_add;
                cw_exe.alumux1_sel = alumux::pc_out;
                cw_exe.alumux2_sel = alumux::j_imm;

                //mem doesn't do anything here

                //writeback
                cw_wb.ld_reg = 1'b1;
                cw_wb.regfilemux_sel = regfilemux::pc_plus4;

                //fetch
                pcmux_sel = pcmux::alu_out;
            end

            op_jalr: begin
                //exe
                cw_exe.aluop =  alu_add;
                cw_exe.alumux1_sel = alumux::rs1_out;
                cw_exe.alumux2_sel = alumux::i_imm;

                //mem doesn't do anything here

                //writeback
                cw_wb.ld_reg = 1'b1;
                cw_wb.regfilemux_sel = regfilemux::pc_plus4;

                //fetch
                pcmux_sel = pcmux::alu_mod2;
            end

            op_br: begin
                //exe
                cw_exe.cmp_sel = cmpmux::rs2_out;
                unique case(func3)
                    3'b000: cw_exe.cmpop = beq;
                    3'b001: cw_exe.cmpop = bne;
                    3'b100: cw_exe.cmpop = blt;
                    3'b101: cw_exe.cmpop = bge;
                    3'b110: cw_exe.cmpop = bltu;
                    3'b111: cw_exe.cmpop = bgeu;

                    default: ;
                endcase

                if(br_en) begin
                    cw_exe.aluop =  alu_add;
                    cw_exe.alumux1_sel = alumux::pc_out;
                    cw_exe.alumux2_sel = alumux::b_imm;

                    //mem doesn't do anything here

                    //writeback doesn't do anything here

                    //fetch
                    pcmux_sel = pcmux::alu_out;
                end
                else begin
                    pcmux_sel = pcmux::pc_plus4;
                end
            end

            op_load: begin
                //exe
                cw_exe.aluop = alu_add;
                cw_exe.alumux1_sel = alumux::rs1_out;
                cw_exe.alumux2_sel = alumux::i_imm;

                //mem
                cw_memory.mem_read_d = 1'b1;

                //writeback
                cw_wb.ld_reg = 1'b1;    
                case (func3)
                    3'b000: begin   //lb
                        cw_wb.regfilemux_sel = regfilemux::lb; //lb 
                    end
                    3'b001: begin   //lh
                        cw_wb.regfilemux_sel = regfilemux::lh; //lh
                    end
                    3'b010: begin   //lw
                        cw_wb.regfilemux_sel = regfilemux::lw; //lw
                    end
                    3'b100: begin   //lbu
                        cw_wb.regfilemux_sel = regfilemux::lbu; //lbu
                    end
                    3'b101: begin   //lhu
                        cw_wb.regfilemux_sel = regfilemux::lhu; //lhu
                    end
                    default: ;
                endcase

                //fetch
                pcmux_sel = pcmux::pc_plus4;
            end

            op_store: begin
                //exe
                cw_exe.aluop =  alu_add;
                cw_exe.alumux1_sel = alumux::rs1_out;
                cw_exe.alumux2_sel = alumux::s_imm;

                //mem
                cw_memory.mem_write_d = 1'b1;

                //writeback doesn't do anything here

                //fetch
                pcmux_sel = pcmux::pc_plus4;
            end

            op_imm: begin
                cw_wb.ld_reg = 1'b1;
                case(func3)
                    3'b000: begin
                        //exe
                        cw_exe.aluop =  alu_add;
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::i_imm;
                   
                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end
                     
                    3'b001: begin
                        //exe
                        cw_exe.aluop =  alu_sll;
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end

                    3'b010: begin
                        //exe
                        cw_exe.cmpop = blt;
                        cw_exe.cmp_sel = cmpmux::i_imm;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::br_en;
                    end

                    3'b011: begin
                        //exe
                        cw_exe.cmpop = bltu;
                        cw_exe.cmp_sel = cmpmux::i_imm;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::br_en;
                    end

                    3'b100: begin
                        //exe
                        cw_exe.aluop =  alu_xor;
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end

                    3'b101: begin
                        //exe
                        if(func7[5]) begin
                            cw_exe.aluop =  alu_sra;
                        end
                        else begin
                            cw_exe.aluop =  alu_srl;
                        end
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end

                    3'b110: begin
                        //exe
                        cw_exe.aluop =  alu_or;
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end
                    
                    3'b111: begin
                        //exe
                        cw_exe.aluop =  alu_and;
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end
                endcase

                //mem doesn't do anything here

                //fetch
                pcmux_sel = pcmux::pc_plus4;
            end

            op_reg: begin
                cw_wb.ld_reg = 1'b1;
                case(func3)
                    3'b000: begin
                        //exe
                        if(func7[5]) begin
                            cw_exe.aluop =  alu_sub;
                        end
                        else begin
                            cw_exe.aluop =  alu_add;
                        end
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end
                    
                    3'b001: begin
                        //exe
                        cw_exe.aluop =  alu_sll;
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end

                    3'b010: begin
                        //exe
                        cw_exe.cmpop = blt;
                        cw_exe.cmp_sel = cmpmux::rs2_out;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::br_en;
                    end

                    3'b011: begin
                        //exe
                        cw_exe.cmpop = bltu;
                        cw_exe.cmp_sel = cmpmux::rs2_out;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::br_en;
                    end

                    3'b100: begin
                        //exe
                        cw_exe.aluop =  alu_xor;
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end

                    3'b101: begin
                        //exe
                        if(func7[5]) begin
                            cw_exe.aluop =  alu_sra;
                        end
                        else begin
                            cw_exe.aluop =  alu_srl;
                        end
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end

                    3'b110: begin
                        //exe
                        cw_exe.aluop =  alu_or;
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end

                    3'b111: begin
                        //exe
                        cw_exe.aluop =  alu_and;
                        cw_exe.alumux1_sel = alumux::rs1_out;
                        cw_exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        cw_wb.regfilemux_sel = regfilemux::alu_out;
                    end
                endcase

                //mem doesn't do anything here

                //fetch
                pcmux_sel = pcmux::pc_plus4;
            end

            default: ;
        endcase
    end
    else begin
        set_def();
    end
end

endmodule : mp4control
