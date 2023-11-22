package rv32i_cache_types;

//typedef rv32i_word [7:0] rv32i_cacheline;
typedef logic [255:0] rv32i_cacheline;

endpackage

package pcmux;
typedef enum bit [1:0] {
    pc_plus4  = 2'b00
    ,alu_out  = 2'b01
    ,alu_mod2 = 2'b10
} pcmux_sel_t;
endpackage

package marmux;
typedef enum bit {
    pc_out = 1'b0
    ,alu_out = 1'b1
} marmux_sel_t;
endpackage

package cmpmux;
typedef enum bit {
    rs2_out = 1'b0
    ,i_imm = 1'b1
} cmpmux_sel_t;
endpackage

package alumux;
typedef enum bit {
    rs1_out = 1'b0
    ,pc_out = 1'b1
} alumux1_sel_t;

typedef enum bit [2:0] {
    i_imm    = 3'b000
    ,u_imm   = 3'b001
    ,b_imm   = 3'b010
    ,s_imm   = 3'b011
    ,j_imm   = 3'b100
    ,rs2_out = 3'b101
} alumux2_sel_t;
endpackage

package regfilemux;
typedef enum bit [3:0] {
    alu_out   = 4'b0000
    ,br_en    = 4'b0001
    ,u_imm    = 4'b0010
    ,lw       = 4'b0011
    ,pc_plus4 = 4'b0100
    ,lb        = 4'b0101
    ,lbu       = 4'b0110  // unsigned byte
    ,lh        = 4'b0111
    ,lhu       = 4'b1000  // unsigned halfword
} regfilemux_sel_t;
endpackage

package rs1mux;
typedef enum bit[1:0] {
    rs1_data = 2'b00
    ,exe_fwd_data = 2'b01
    ,mem_fwd_data = 2'b10
    ,wb_fwd_data = 2'b11
} rs1_sel_t;
endpackage

package rs2mux;
typedef enum bit[1:0] {
    rs2_data = 2'b00
    ,exe_fwd_data = 2'b01
    ,mem_fwd_data = 2'b10
    ,wb_fwd_data = 2'b11
} rs2_sel_t;
endpackage

package exefwdmux;
typedef enum bit [1:0] { 
    alu_out = 2'b00
    ,br_en_zext = 2'b01
    ,u_imm = 2'b10
} exefwdmux_sel_t;
endpackage

package memfwdmux;
typedef enum bit { 
    mem_fwd_data = 1'b0
    ,exe_fwd_data = 1'b1
} memfwdmux_sel_t;
endpackage

package rs1signunsignmux;
typedef enum bit { 
    sign = 1'b0
    ,unsign = 1'b1
} rs1signunsignmux_sel_t;
endpackage

package rs2signunsignmux;
typedef enum bit { 
    sign = 1'b0
    ,unsign = 1'b1
} rs2signunsignmux_sel_t;
endpackage

package multihighlowmux;
typedef enum bit { 
    low = 1'b0
    ,high = 1'b1
} multihighlowmux_sel_t;
endpackage


package rv32i_types;
// Mux types are in their own packages to prevent identiier collisions
// e.g. pcmux::pc_plus4 and regfilemux::pc_plus4 are seperate identifiers
// for seperate enumerated types
import pcmux::*;
import marmux::*;
import cmpmux::*;
import alumux::*;
import regfilemux::*;
import rs1mux::*;
import rs2mux::*;
import memfwdmux::*;
import exefwdmux::*;

typedef logic [31:0] rv32i_word;
typedef logic [4:0] rv32i_reg;
typedef logic [3:0] rv32i_mem_wmask;

typedef enum bit [6:0] {
    op_lui   = 7'b0110111, //load upper immediate (U type)
    op_auipc = 7'b0010111, //add upper immediate PC (U type)
    op_jal   = 7'b1101111, //jump and link (J type)
    op_jalr  = 7'b1100111, //jump and link register (I type)
    op_br    = 7'b1100011, //branch (B type)
    op_load  = 7'b0000011, //load (I type)
    op_store = 7'b0100011, //store (S type)
    op_imm   = 7'b0010011, //arith ops with register/immediate operands (I type)
    op_reg   = 7'b0110011, //arith ops with register operands (R type)
    op_csr   = 7'b1110011  //control and status register (I type)
} rv32i_opcode;

typedef enum bit [2:0] {
    beq  = 3'b000,
    bne  = 3'b001,
    blt  = 3'b100,
    bge  = 3'b101,
    bltu = 3'b110,
    bgeu = 3'b111
} branch_funct3_t;

typedef enum bit [2:0] {
    lb  = 3'b000,
    lh  = 3'b001,
    lw  = 3'b010,
    lbu = 3'b100,
    lhu = 3'b101
} load_funct3_t;

typedef enum bit [2:0] {
    sb = 3'b000,
    sh = 3'b001,
    sw = 3'b010
} store_funct3_t;

typedef enum bit [2:0] {
    add  = 3'b000, //check bit30 for sub if op_reg opcode, check funct7[0] for mul
    sll  = 3'b001, //check funct7[0] for mulh
    slt  = 3'b010,
    sltu = 3'b011,
    axor = 3'b100,//check funct7[0] for mulhu
    sr   = 3'b101, //check bit30 for logical/arithmetic
    aor  = 3'b110,
    aand = 3'b111
} arith_funct3_t;

typedef enum bit [3:0] {
    alu_add = 4'b0000,
    alu_sll = 4'b0001,
    alu_sra = 4'b0010,
    alu_sub = 4'b0011,
    alu_xor = 4'b0100,
    alu_srl = 4'b0101,
    alu_or  = 4'b0110,
    alu_and = 4'b0111,
    alu_mul = 4'b1000
} alu_ops;

endpackage


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
        rs1signunsignmux::rs1signunsignmux_sel_t rs1signunsignmux_sel;
        rs2signunsignmux::rs2signunsignmux_sel_t rs2signunsignmux_sel;
        multihighlowmux::multihighlowmux_sel_t multihighlowmux_sel;
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

package hazards;
    import rv32i_types::*; 
    typedef struct {
        rv32i_opcode opcode;
        logic [4:0] rd_addr;
        logic [4:0] rs1_addr;
        logic [4:0] rs2_addr;
        logic [63:0] commit_order;
    } hzds;
endpackage : hazards

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