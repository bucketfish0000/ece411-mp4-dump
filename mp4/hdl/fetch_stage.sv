module fetch_stage 
    import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    input logic icache_resp,

    input pcmux_sel_t pcmux_sel,
    input rv32i_word exec_fwd_data,
    input rv32i_word instr_in,
    
    output rv32i_word pc_out,
    output rv32i_word instr_out,
    
    output logic ready;
);
    logic load;
    assign load = icache_resp;loadresp;

    rv32i_word pc_in,pc;
    assign pc_out = pc;
    assign instr_out = instr_in;

    register PC(.clk(clk),.rst(rst),.load(icache_resp) .in(pc_in),.out(pc));

    

    //pcmux
    always_comb begin
        unique case(pcmux_sel)
            pcmux_sel_t::pc_plus4: pc_in = pc+4;
            pcmux_sel_t::alu_out: pc_in = exec_fwd_data;
            pcmux_sel_t::alu_mod2: pc_in = {exec_fwd_date[31:1],1'b0};
        endcase
    end : pc_mux_logic
endmodule : fetch_stage