module alu
import rv32i_types::*;
import cpuIO::*;
(
    input clk,
    input rst,
    input cw_execute ctrl_w,
    input [31:0] a, b,
    output logic [31:0] f,
    output logic done
);
    logic [31:0] multi_o;
    logic start, multi_done;

multiply multi(
    .clk(clk),
    .rst(rst),
    .start(start),
    .rs1_i(a),
    .rs2_i(b),
    .multihighlowmux_sel(ctrl_w.multihighlowmux_sel),
    .rs1signunsignmux_sel(ctrl_w.rs1signunsignmux_sel),
    .rs2signunsignmux_sel(ctrl_w.rs2signunsignmux_sel),
    .rd_o(multi_o),
    .done(multi_done)
);

always_comb
begin
    unique case (ctrl_w.aluop)
        alu_add: begin
             f = a + b;
             start = 1'b0;
             done = 1'b1;
        end
        alu_sll: begin
             f = a << b[4:0];
             start = 1'b0;
             done = 1'b1;
        end
        alu_sra: begin
             f = $signed(a) >>> b[4:0];
             start = 1'b0;
             done = 1'b1;
        end
        alu_sub: begin
             f = a - b;
             start = 1'b0;
             done = 1'b1;
        end
        alu_xor: begin
             f = a ^ b;
             start = 1'b0;
             done = 1'b1;
        end
        alu_srl: begin
             f = a >> b[4:0];
             start = 1'b0;
             done = 1'b1;
        end
        alu_or:  begin
             f = a | b;
             start = 1'b0;
             done = 1'b1;
        end
        alu_and: begin
             f = a & b;
             start = 1'b0;
             done = 1'b1;
        end
        alu_mul: begin
             f = multi_o;
             start = 1'b1;
             done = multi_done;
        end
    endcase
end

endmodule : alu
