module alu
import rv32i_types::*;
import cpuIO::*;
(
    input clk,
    input rst,
    input cw_execute ctrl_w,
    input logic new_instruction,
    input [31:0] a, b,
    output logic [31:0] f,
    output logic done
);
    logic [31:0] multi_div_o;
    logic start_div, start_multi, multi_div_done;

multiply_and_divide multi_div(
    .clk(clk),
    .rst(rst),
    .start_multi(start_multi),
    .start_div(start_div),
    .new_instruction(new_instruction),
    .rs1_i(a),
    .rs2_i(b),
    .multihighlowmux_sel(ctrl_w.multihighlowmux_sel),
    .divremquotmux_sel(ctrl_w.divremquotmux_sel),
    .rs1signunsignmux_sel(ctrl_w.rs1signunsignmux_sel),
    .rs2signunsignmux_sel(ctrl_w.rs2signunsignmux_sel),
    .rd_o(multi_div_o),
    .done(multi_div_done)
);

always_comb
begin
     start_div = 1'b0;
     start_multi = 1'b0;
     unique case (ctrl_w.aluop)
          alu_add: begin
               f = a + b;
               done = 1'b1;
          end
          alu_sll: begin
               f = a << b[4:0];
               done = 1'b1;
          end
          alu_sra: begin
               f = $signed(a) >>> b[4:0];
               done = 1'b1;
          end
          alu_sub: begin
               f = a - b;
               done = 1'b1;
          end
          alu_xor: begin
               f = a ^ b;
               done = 1'b1;
          end
          alu_srl: begin
               f = a >> b[4:0];
               done = 1'b1;
          end
          alu_or:  begin
               f = a | b;
               done = 1'b1;
          end
          alu_and: begin
               f = a & b;
               done = 1'b1;
          end
          alu_mul: begin
               f = multi_div_o;
               start_multi = 1'b1;
               done = multi_div_done;
          end
          alu_div: begin
               f = multi_div_o;
               start_div = 1'b1;
               done = multi_div_done;
          end
     endcase
end

endmodule : alu
