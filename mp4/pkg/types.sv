package cpuIO;
    import pcmux::*;
    import marmux::*;
    import cmpmux::*;
    import alumux::*;
    import regfilemux::*;
    import rsmux::*;
    typedef struct {

    } cw_output;
    
    typedef struct {
        rsmux::rs1_sel_t rs1_sel;
        rsmux::rs2_sel_t rs2_sel;
        alumux::alumux1_sel_t alumux1_sel;
        alumux::alumux2_sel_t alumux2_sel;
        cmpmux::cmpmux_sel_t cmp_sel;
        rv32i_types::alu_ops aluop;
        rv32i_types::branch_funct3_t cmpop;
    } cw_execute;

    typedef struct {
        logic mem_read_d;
        logic mem_write_d;
        marmux::marmux_sel_t mar_sel;
    } cw_mem;
    typedef struct {

    } cw_writeback;

    typedef struct {

    } cpu_read;



endpackage cpuIO