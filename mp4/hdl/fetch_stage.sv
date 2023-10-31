module fetch_stage 
    import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    input logic icache_resp,
    input logic load_pc,

    input pcmux::pcmux_sel_t pcmux_sel,
    input rv32i_word exec_fwd_data,
    input rv32i_word instr_in,
    
    output rv32i_word pc_out,
    output rv32i_word instr_out,
    output logic imem_read,
    
    output logic ready,
    output logic valid
);

    rv32i_word pc_in,pc;
    assign pc_out = pc;
    assign instr_out = instr_in;
    assign ready = icache_resp;
    assign valid = icache_resp;
    assign imem_read = 1'b1;

    register #(.width(32), .resetData(32'h40000000)) 
        PC(.clk(clk),.rst(rst),.load(load_pc),.in(pc_in), .out(pc));

    //pcmux
    always_comb begin : pc_mux_logic
        unique case(pcmux_sel)
            pcmux::pc_plus4: pc_in = pc+4;
            pcmux::alu_out: pc_in = exec_fwd_data;
            pcmux::alu_mod2: pc_in = {exec_fwd_data[31:1],1'b0};
        endcase
    end : pc_mux_logic

endmodule : fetch_stage