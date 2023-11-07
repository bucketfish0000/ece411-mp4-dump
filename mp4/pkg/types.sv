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
        exefwdmux::exefwdmux_sel_t exefwdmux_sel;
    } cw_execute;

    typedef struct {
        logic mem_read_d;
        logic mem_write_d;
        store_funct3_t store_funct3;
        load_funct3_t load_funct3;
        marmux::marmux_sel_t mar_sel;
        memfwdmux::memfwdmux_sel_t memfwdmux_sel;
    } cw_mem;

    typedef struct {
        logic ld_reg;
        regfilemux::regfilemux_sel_t regfilemux_sel;
        logic [4:0] rd_sel; //rvfi needs this, but we'll leave it here
    } cw_writeback;

    typedef struct {
        logic valid_commit; //set in ctrl
        logic [63:0] order_commit; //set in ctrl(from fe_de)
        logic [31:0] instruction; //set in ctrl(from fe_de?)
        logic [4:0] rs1_addr;  //set in ctrl(from decode)
        logic [4:0] rs2_addr;  //set in ctrl(from decode)
        logic [31:0] rs1_data;  //set in ctrl(from decode)
        logic [31:0] rs2_data;  //set in ctrl(from decode)
        // logic [4:0] rd_addr;  this in cw_wb
        logic [31:0] rd_wdata; //set in wb
        logic [31:0] pc_rdata; //set in ctrl(from decode)
        logic [31:0] pc_wdata; //set in ctrl(from decode), overwritten in br?
        logic [31:0] mem_addr; //set in exe_mem(mar)
        logic [3:0] rmask; //set in exe_mem
        logic [3:0] wmask; //set in exe_mem
        logic [31:0] mem_rdata; //set in mem_wb(from mem)
        logic [31:0] mem_wdata; //set in exe_mem(mdo)
    } rvfi_sigs;

    typedef struct {
        rv32i_opcode opcode;
        logic [2:0] func3;
        logic [6:0] func7;
        logic [63:0] order_commit;
        logic [31:0] instruction;
        logic [31:0] pc_rdata;
        logic [31:0] pc_wdata;
        logic [4:0] rs1_addr;
        logic [4:0] rs2_addr;
        logic [31:0] rs1_data;
        logic [31:0] rs2_data;
        logic [4:0] rd_addr;
    } control_read;
    
    typedef struct {
        cw_execute exe;
        cw_mem mem;
        cw_writeback wb;
        rvfi_sigs rvfi;
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