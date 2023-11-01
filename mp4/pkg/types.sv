package cpuIO;
    import rv32i_types::*; 
    // import pcmux::*;
    // import marmux::*;
    // import cmpmux::*;
    // import alumux::*;
    // import regfilemux::*;
    // import rsmux::*;
  
    typedef struct {
        rs1mux::rs1_sel_t rs1_sel;
        rs2mux::rs2_sel_t rs2_sel;
        alumux::alumux1_sel_t alumux1_sel;
        alumux::alumux2_sel_t alumux2_sel;
        cmpmux::cmpmux_sel_t cmp_sel;
        rv32i_types::alu_ops aluop;
        rv32i_types::branch_funct3_t cmpop;
    } cw_execute;

    typedef struct {
        logic mem_read_d;
        logic mem_write_d;
        store_funct3_t store_funct3;
        load_funct3_t load_funct3;
        marmux::marmux_sel_t mar_sel;
    } cw_mem;

    typedef struct {
        logic ld_reg;
        regfilemux::regfilemux_sel_t regfilemux_sel;
        logic [4:0] rd_sel;
    } cw_writeback;


    typedef struct {
        logic[6:0] opcode;
        logic [2:0] func3;
        logic [6:0] func7;
    } control_read;
    
    typedef struct {
        cw_execute exe;
        cw_mem mem;
        cw_writeback wb;
    } control_word;
endpackage : cpuIO

package immediates;
import rv32i_types::*; 
typedef struct {
    rv32i_word i_imm;
    rv32i_word u_imm;
    rv32i_word b_imm;
    rv32i_word s_imm;
    rv32i_word j_imm;
} imm;
endpackage : immediates