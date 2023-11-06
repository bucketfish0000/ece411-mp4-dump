/*ld and READY signals:
    ld(Output): 
        -Always load unless one of the stages in front of you is stalling(valid == 1 and rdy == 0)
    valid(Input):
        -If high then register has been initialized after cold start(or flush)
        -Otherwise value is unitialized
    ready(Input):
        -If high then stage has finished computation
        -If low still computing so don't load the register before stage yet(stalling if valid is high)

    ~valid, x -- cold, wait for filling
    valid, ~ready -- pending output, stall
    valid, ready -- output ready, load

    v/r ops: reset--flushes ppr, clears valid/ready; load (only when previous valid&ready) --loads ppr, forces valid to high
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

    /*---exe signals---*/
    input logic br_en,
    //...anything else?

    /*---mem_stage signals---*/
    input logic mem_read_D,
    input logic mem_write_D,
    //...anything else?
    input rv32i_opcode opcode_exec,
    /*---ready signals---*/
    input logic if_rdy,
    input logic de_rdy,
    input logic exe_rdy,
    input logic mem_rdy,
    input logic wb_rdy,

    /*---valid signals---*/
    input logic if_valid,
    input logic de_valid,
    input logic exe_valid,
    input logic mem_valid,
    input logic wb_valid,

    /*---continue/load signals---*/
    output logic if_de_rst,
    output logic de_exe_rst,
    output logic exe_mem_rst,
    output logic mem_wb_rst,
    output logic if_de_ld,
    output logic de_exe_ld,
    output logic exe_mem_ld,
    output logic mem_wb_ld,

    /*---cpu_cw---*/
    input control_read cw_read, 
    output control_word ctrl_word,

    output pcmux::pcmux_sel_t pcmux_sel 
);

logic branch_taken;
assign branch_taken = br_en && (opcode_exec == op_br);

logic [4:0] rdy;
logic [4:0] vald;

assign rdy = {if_rdy, de_rdy, exe_rdy, mem_rdy, wb_rdy};
assign vald = {if_valid, de_valid, exe_valid, mem_valid, wb_valid};

logic stall_if_de, stall_de_exe, stall_exe_mem, stall_mem_wb;
//stall a ppr when any ppr after it is valid but not ready

assign stall_if_de = 
    ((rdy[3] == 0) && (vald[3] == 1)) || 
    ((rdy[2] == 0) && (vald[2] == 1)) || 
    ((rdy[1] == 0) && (vald[1] == 1)) || 
    ((rdy[0] == 0) && (vald[0] == 1));

assign stall_de_exe = 
    ((rdy[2] == 0) && (vald[2] == 1)) || 
    ((rdy[1] == 0) && (vald[1] == 1)) || 
    ((rdy[0] == 0) && (vald[0] == 1));

assign stall_exe_mem = 
    ((rdy[1] == 0) && (vald[1] == 1)) || 
    ((rdy[0] == 0) && (vald[0] == 1));

assign stall_mem_wb = 
    ((rdy[0] == 0) && (vald[0] == 1));


//how know when load pc? Gonna need testing to see for sure

always_comb begin : pipeline_regs_logic
    if(rst) begin
        if_de_ld = 1'b0;
        imem_read = 1'b0;
        load_pc = 1'b0;
        de_exe_ld = 1'b0;
        exe_mem_ld = 1'b0;
        mem_wb_ld = 1'b0;
        
        //flush every ppr on reset
        if_de_rst = 1'b1;
        de_exe_rst = 1'b1;
        exe_mem_rst = 1'b1;
        mem_wb_rst = 1'b1;
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
        //imem and pc interactions
        //only not try to fetch when waiting for resp from icache 
        imem_read = (/*(if_valid & !icache_resp) || */stall_if_de) ? 1'b0 : 1'b1; 
        //update pc when imem has responded (can proc)
        load_pc = (icache_resp || stall_if_de) ? 1'b0 : 1'b1;
        
        //ppr resets
        // if_de_rst = 1'b0;
        // de_exe_rst = 1'b0;
        // exe_mem_rst = 1'b0;
        // mem_wb_rst = 1'b0;

        //ppr loads (stalling control)
        if_de_ld = (stall_if_de || !icache_resp) ? 1'b0 : 1'b1;
        de_exe_ld = (stall_de_exe || vald[4]==0) ? 1'b0: 1'b1;
        exe_mem_ld = (stall_exe_mem || vald[3]==0) ? 1'b0 : 1'b1;
        mem_wb_ld = (stall_mem_wb || vald[2]==0) ? 1'b0 : 1'b1;

        //ppr rst (flushing control)
        //
        if_de_rst = (branch_taken)? 1'b1 : 1'b0;
        de_exe_rst = (branch_taken) ? 1'b1 : 1'b0;
        exe_mem_rst = (mem_rdy && !exe_valid) ? 1'b1 : 1'b0; 
        mem_wb_rst = 1'b0;

    end
end

always_comb begin : pc_branch_logics
    pcmux_sel = pcmux::pc_plus4;//default
    if (branch_taken) pcmux_sel = pcmux::alu_out; //branch taken
    else if (opcode_exec == op_jal) pcmux_sel = pcmux::alu_out; //jal
    else if (opcode_exec == op_jalr) pcmux_sel = pcmux::alu_mod2; //jalr
end
// /***************** USED BY RVFIMON --- ONLY MODIFY WHEN TOLD *****************/
// logic trap;
// logic [3:0] rmask, wmask;
// /*****************************************************************************/

branch_funct3_t branch_funct3;
store_funct3_t store_funct3;
load_funct3_t load_funct3;
arith_funct3_t arith_funct3;

assign arith_funct3 = arith_funct3_t'(cw_read.func3);
assign branch_funct3 = branch_funct3_t'(cw_read.func3);
assign load_funct3 = load_funct3_t'(cw_read.func3);
assign store_funct3 = store_funct3_t'(cw_read.func3);

function void set_def();
    ctrl_word.exe.cmp_sel = cmpmux::rs2_out;
    ctrl_word.exe.alumux1_sel = alumux::rs1_out;
    ctrl_word.exe.alumux2_sel = alumux::i_imm;
    ctrl_word.exe.rs1_sel = rs1mux::rs1_data;
    ctrl_word.exe.rs2_sel = rs2mux::rs2_data;
    ctrl_word.exe.cmpop = beq;
    ctrl_word.exe.aluop = alu_add;
    ctrl_word.mem.mem_read_d = 1'b0;
    ctrl_word.mem.mem_write_d = 1'b0;
    ctrl_word.mem.store_funct3 = sb;
    ctrl_word.mem.load_funct3 = lb;
    ctrl_word.mem.mar_sel = marmux::pc_out;
    ctrl_word.wb.ld_reg = 1'b0;
    ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
    ctrl_word.wb.rd_sel = 5'b00000;
    ctrl_word.rvfi.valid_commit = 1'b0;//done
    ctrl_word.rvfi.order_commit = 64'b0;//done
    ctrl_word.rvfi.instruction = 32'b0;//done
    ctrl_word.rvfi.rs1_addr = 5'b0; //done
    ctrl_word.rvfi.rs2_addr = 5'b0; //dome
    ctrl_word.rvfi.rs1_data = 32'b0; //done
    ctrl_word.rvfi.rs2_data = 32'b0; //done
    ctrl_word.rvfi.rd_wdata = 32'b0;//done
    ctrl_word.rvfi.pc_rdata = 32'h40000000;//done
    ctrl_word.rvfi.pc_wdata = 32'b0;//done
    ctrl_word.rvfi.mem_addr = 32'b0;//done
    ctrl_word.rvfi.rmask = 4'b0;//done
    ctrl_word.rvfi.wmask = 4'b0;//done
    ctrl_word.rvfi.mem_rdata = 32'b0;//done
    ctrl_word.rvfi.mem_wdata = 32'b0;//done
endfunction

always_comb begin : cpu_cw
    if(rst) begin
        set_def();
    end
    else if(rdy[4]) begin
        ctrl_word.rvfi.valid_commit = 1'b1;
        ctrl_word.rvfi.order_commit = cw_read.order_commit;
        ctrl_word.rvfi.instruction = cw_read.instruction;
        ctrl_word.rvfi.pc_rdata = cw_read.pc_rdata;
        ctrl_word.rvfi.pc_wdata = cw_read.pc_wdata;

        unique case(cw_read.opcode)
            op_lui: begin
                //exe doesn't do anyting here

                //mem doesn't do anything here

                //writeback
                ctrl_word.wb.ld_reg = 1'b1;
                ctrl_word.wb.regfilemux_sel = regfilemux::u_imm;
                ctrl_word.wb.rd_sel = cw_read.rd_addr;

                //fetch
               
                
                //decode nothing here
                
            end

            op_auipc: begin
                //exe
                ctrl_word.exe.aluop = alu_add;
                ctrl_word.exe.alumux1_sel = alumux::pc_out;
                ctrl_word.exe.alumux2_sel = alumux::u_imm;

                //mem doesn't do anything here

                //writeback
                ctrl_word.wb.ld_reg = 1'b1;
                ctrl_word.wb.rd_sel = cw_read.rd_addr;
                ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;

                //fetch
               

                //decode nothing        
            end

            op_jal: begin
                //exe
                ctrl_word.exe.aluop = alu_add;
                ctrl_word.exe.alumux1_sel = alumux::pc_out;
                ctrl_word.exe.alumux2_sel = alumux::j_imm;

                //mem doesn't do anything here

                //writeback
                ctrl_word.wb.ld_reg = 1'b1;
                ctrl_word.wb.regfilemux_sel = regfilemux::pc_plus4;
                ctrl_word.wb.rd_sel = cw_read.rd_addr;

                //fetch
               
            
                //decode nothing
            end

            op_jalr: begin
                //exe
                ctrl_word.exe.aluop =  alu_add;
                ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                ctrl_word.exe.alumux2_sel = alumux::i_imm;

                //mem doesn't do anything here

                //writeback
                ctrl_word.wb.ld_reg = 1'b1;
                ctrl_word.wb.regfilemux_sel = regfilemux::pc_plus4;
                ctrl_word.wb.rd_sel = cw_read.rd_addr;

                //fetch
            
                //decode
                ctrl_word.rvfi.rs1_addr = cw_read.rs1_addr;
                ctrl_word.rvfi.rs1_data = cw_read.rs1_data;
            end

            op_br: begin
                //exe
                ctrl_word.exe.cmp_sel = cmpmux::rs2_out;
                unique case(cw_read.func3)
                    3'b000: ctrl_word.exe.cmpop = beq;
                    3'b001: ctrl_word.exe.cmpop = bne;
                    3'b100: ctrl_word.exe.cmpop = blt;
                    3'b101: ctrl_word.exe.cmpop = bge;
                    3'b110: ctrl_word.exe.cmpop = bltu;
                    3'b111: ctrl_word.exe.cmpop = bgeu;

                    default: ;
                endcase


                    ctrl_word.exe.aluop =  alu_add;
                    ctrl_word.exe.alumux1_sel = alumux::pc_out;
                    ctrl_word.exe.alumux2_sel = alumux::b_imm;

                   

                //decode
                ctrl_word.rvfi.rs1_addr = cw_read.rs1_addr;
                ctrl_word.rvfi.rs2_addr = cw_read.rs2_addr;
                ctrl_word.rvfi.rs1_data = cw_read.rs1_data;
                ctrl_word.rvfi.rs2_data = cw_read.rs2_data;
            end

            op_load: begin
                //exe
                ctrl_word.exe.aluop = alu_add;
                ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                ctrl_word.exe.alumux2_sel = alumux::i_imm;

                //mem
                ctrl_word.mem.mem_read_d = 1'b1;
                ctrl_word.mem.mar_sel = marmux::alu_out;
                ctrl_word.mem.load_funct3 = load_funct3;

                //writeback/more mem
                ctrl_word.wb.ld_reg = 1'b1;
                ctrl_word.wb.rd_sel = cw_read.rd_addr;    
                case (cw_read.func3)
                    3'b000: begin   //lb
                        ctrl_word.wb.regfilemux_sel = regfilemux::lb; //lb 
                    end
                    3'b001: begin   //lh
                        ctrl_word.wb.regfilemux_sel = regfilemux::lh; //lh
                    end
                    3'b010: begin   //lw
                        ctrl_word.wb.regfilemux_sel = regfilemux::lw; //lw
                    end
                    3'b100: begin   //lbu
                        ctrl_word.wb.regfilemux_sel = regfilemux::lbu; //lbu
                    end
                    3'b101: begin   //lhu
                        ctrl_word.wb.regfilemux_sel = regfilemux::lhu; //lhu
                    end
                    default: ;
                endcase

                //fetch
               
            
                //decode
                ctrl_word.rvfi.rs1_addr = cw_read.rs1_addr;
                ctrl_word.rvfi.rs1_data = cw_read.rs1_data;
            end

            op_store: begin
                //exe
                ctrl_word.exe.aluop =  alu_add;
                ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                ctrl_word.exe.alumux2_sel = alumux::s_imm;

                //mem
                ctrl_word.mem.mem_write_d = 1'b1;
                ctrl_word.mem.mar_sel = marmux::alu_out;
                ctrl_word.mem.store_funct3 = store_funct3;

                //writeback doesn't do anything here

                //fetch
               
            
                //decode
                ctrl_word.rvfi.rs1_addr = cw_read.rs1_addr;
                ctrl_word.rvfi.rs2_addr = cw_read.rs2_addr;
                ctrl_word.rvfi.rs1_data = cw_read.rs1_data;
                ctrl_word.rvfi.rs2_data = cw_read.rs2_data;
            end

            op_imm: begin
                ctrl_word.wb.ld_reg = 1'b1;
                case(cw_read.func3)
                    3'b000: begin
                        //exe
                        ctrl_word.exe.aluop =  alu_add;
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::i_imm;
                   
                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end
                     
                    3'b001: begin
                        //exe
                        ctrl_word.exe.aluop =  alu_sll;
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b010: begin
                        //exe
                        ctrl_word.exe.cmpop = blt;
                        ctrl_word.exe.cmp_sel = cmpmux::i_imm;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::br_en;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b011: begin
                        //exe
                        ctrl_word.exe.cmpop = bltu;
                        ctrl_word.exe.cmp_sel = cmpmux::i_imm;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::br_en;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b100: begin
                        //exe
                        ctrl_word.exe.aluop =  alu_xor;
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b101: begin
                        //exe
                        if(cw_read.func7[5]) begin
                            ctrl_word.exe.aluop =  alu_sra;
                        end
                        else begin
                            ctrl_word.exe.aluop =  alu_srl;
                        end
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b110: begin
                        //exe
                        ctrl_word.exe.aluop =  alu_or;
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end
                    
                    3'b111: begin
                        //exe
                        ctrl_word.exe.aluop =  alu_and;
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::i_imm;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end
                endcase

                //mem doesn't do anything here

                //fetch
               
            
                //decode
                ctrl_word.rvfi.rs1_addr = cw_read.rs1_addr;
                ctrl_word.rvfi.rs1_data = cw_read.rs1_data;
            end

            op_reg: begin
                ctrl_word.wb.ld_reg = 1'b1;
                case(cw_read.func3)
                    3'b000: begin
                        //exe
                        if(cw_read.func7[5]) begin
                            ctrl_word.exe.aluop =  alu_sub;
                        end
                        else begin
                            ctrl_word.exe.aluop =  alu_add;
                        end
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end
                    
                    3'b001: begin
                        //exe
                        ctrl_word.exe.aluop =  alu_sll;
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b010: begin
                        //exe
                        ctrl_word.exe.cmpop = blt;
                        ctrl_word.exe.cmp_sel = cmpmux::rs2_out;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::br_en;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b011: begin
                        //exe
                        ctrl_word.exe.cmpop = bltu;
                        ctrl_word.exe.cmp_sel = cmpmux::rs2_out;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::br_en;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b100: begin
                        //exe
                        ctrl_word.exe.aluop =  alu_xor;
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b101: begin
                        //exe
                        if(cw_read.func7[5]) begin
                            ctrl_word.exe.aluop =  alu_sra;
                        end
                        else begin
                            ctrl_word.exe.aluop =  alu_srl;
                        end
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b110: begin
                        //exe
                        ctrl_word.exe.aluop =  alu_or;
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end

                    3'b111: begin
                        //exe
                        ctrl_word.exe.aluop =  alu_and;
                        ctrl_word.exe.alumux1_sel = alumux::rs1_out;
                        ctrl_word.exe.alumux2_sel = alumux::rs2_out;

                        //writeback
                        ctrl_word.wb.regfilemux_sel = regfilemux::alu_out;
                        ctrl_word.wb.rd_sel = cw_read.rd_addr;
                        ctrl_word.wb.ld_reg = 1'b1;
                    end
                endcase

                //mem doesn't do anything here

                //fetch
               
            
                //decode
                ctrl_word.rvfi.rs1_addr = cw_read.rs1_addr;
                ctrl_word.rvfi.rs2_addr = cw_read.rs2_addr;
                ctrl_word.rvfi.rs1_data = cw_read.rs1_data;
                ctrl_word.rvfi.rs2_data = cw_read.rs2_data;
            end

            default: ;
        endcase
    end
    else begin
        set_def();
    end
end

endmodule : mp4control
