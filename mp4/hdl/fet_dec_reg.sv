module fet_dec_reg
    import rv32i_types::*;
(
    input logic clk,
    input logic rst,
    input logic load,

    input rv32i_word instr_fetch,
    input rv32i_word pc_fetch,

    output rv32i_word instr_decode,
    output rv32i_word pc_decode
)

    register instr_fet_dec(.*,.in(instr_fetch),.out(instr_decode));
    register pc_fet_dec(.*,in(pc_fetch),.out(pc_decode));

endmodule: fet_dec_reg