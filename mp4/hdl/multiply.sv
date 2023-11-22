module multiply(
    input clk,
    input rst,
    input logic start,
    input logic [31:0] rs1_i,
    input logic [31:0] rs2_i,
    input multihighlowmux::multihighlowmux_sel_t multihighlowmux_sel,
    input rs1signunsignmux::rs1signunsignmux_sel_t rs1signunsignmux_sel,
    input rs2signunsignmux::rs2signunsignmux_sel_t rs2signunsignmux_sel,
    output logic [31:0] rd_o,
    output logic done
);
    logic [31:0] rs1_s_us, rs2_s_us, multi_high, multi_low, multi_rs1, multi_rs2, multi_o;

    always_comb begin
        if(rs1_i[31]) begin
            rs1_s_us = ~rs1_i + 32'b01;
        end
        else begin
            rs1_s_us = rs1_i;
        end

        if(rs2_i[31]) begin
            rs2_s_us = ~rs2_i + 32'b01;
        end
        else begin
            rs2_s_us = rs2_i;
        end

        if(((rs1_i[31] && rs2_i[31]) && !(!rs1signunsignmux_sel && rs2signunsignmux_sel)) || (!rs1_i[31] && !rs2_i[31])) begin
            rd_o = multi_o;
        end
        else begin
            rd_o = ~multi_o;
        end
    end

    always_comb begin
        unique case(multihighlowmux_sel)
            multihighlowmux::low: multi_o = multi_low;
            multihighlowmux::high: multi_o = multi_high;
        endcase

        unique case(rs1signunsignmux_sel)
            rs1signunsignmux::sign: multi_rs1 = rs1_s_us;
            rs1signunsignmux::unsign: multi_rs1 = rs1_i;
        endcase

        unique case(rs2signunsignmux_sel)
            rs2signunsignmux::sign: multi_rs2 = rs2_s_us;
            rs2signunsignmux::unsign: multi_rs2 = rs2_i;
        endcase
    end

    multiplier_v2 multi(
        .clk(clk),
        .rst(rst),
        .start(start),
        .rs1(multi_rs1),
        .rs2(multi_rs2),
        .rd_low(multi_low),
        .rd_high(multi_high),
        .done(done)
    );

endmodule : multiply
