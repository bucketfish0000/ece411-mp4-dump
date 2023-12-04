module multiply_and_divide(
    input clk,
    input rst,
    input logic start_multi,
    input logic start_div,
    input logic new_instruction,
    input logic [31:0] rs1_i,
    input logic [31:0] rs2_i,
    input multihighlowmux::multihighlowmux_sel_t multihighlowmux_sel,
    input divremquotmux::divremquotmux_sel_t divremquotmux_sel,
    input rs1signunsignmux::rs1signunsignmux_sel_t rs1signunsignmux_sel,
    input rs2signunsignmux::rs2signunsignmux_sel_t rs2signunsignmux_sel,
    output logic [31:0] rd_o,
    output logic done
);
    logic [31:0] rs1_s_us, rs2_s_us, true_rs1, true_rs2, multi_high, multi_low, div_r, div_q, multi_o, div_o, true_o;
    logic done_multi, done_div, overflow, div_zero, div_error;

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

        if(start_multi) begin
            if(((rs1_i[31] && rs2_i[31]) && !(!rs1signunsignmux_sel && rs2signunsignmux_sel)) || (!rs1_i[31] && !rs2_i[31]) 
                    || (rs1signunsignmux_sel && rs2signunsignmux_sel)) begin
                rd_o = true_o;
            end
            else if(multihighlowmux_sel && (multi_low != 32'hffffffff)) begin//if add 1 to bottom then it doesn't overflow to multi_top unless all f
                rd_o = ~true_o;
            end
            else begin
                rd_o = ~true_o+1;
            end
        end
        else begin
            if(((rs1_i[31] && rs2_i[31]) && !(rs1signunsignmux_sel)) || (!rs1_i[31] && !rs2_i[31]) || ((rs1signunsignmux_sel)) || 
                (divremquotmux_sel && !rs1_i[31]) || (div_error)) begin
                rd_o = true_o;
            end
            else begin
                rd_o = ~true_o+1;
            end
        end
    end

    always_comb begin
        unique case(multihighlowmux_sel)
            multihighlowmux::low: multi_o = multi_low;
            multihighlowmux::high: multi_o = multi_high;
        endcase

        unique case(divremquotmux_sel)
            divremquotmux::quotient: div_o = div_q;
            divremquotmux::remainder: div_o = div_r;
        endcase

        unique case(rs1signunsignmux_sel)
            rs1signunsignmux::sign: true_rs1 = rs1_s_us;
            rs1signunsignmux::unsign: true_rs1 = rs1_i;
        endcase

        unique case(rs2signunsignmux_sel)
            rs2signunsignmux::sign: true_rs2 = rs2_s_us;
            rs2signunsignmux::unsign: true_rs2 = rs2_i;
        endcase
    end

    multiplier_v2 multi(
        .clk(clk),
        .rst(rst),
        .start(start_multi),
        .new_instruction(new_instruction),
        .rs1(true_rs1),
        .rs2(true_rs2),
        .rd_low(multi_low),
        .rd_high(multi_high),
        .done(done_multi)
    );

    divider_slow div_slow(
        .clk(clk),
        .rst(rst || div_error),
        .start(start_div),
        .new_instruction(new_instruction),
        .a(true_rs1),
        .b(true_rs2),
        .q(div_q),
        .r(div_r),
        .done(done_div)
    );

    assign div_error = (div_zero || overflow);
    assign div_zero = (start_div && rs2_i == 0);
    assign overflow = ((start_div) && ((rs1_i == 32'h80000000) && (rs2_i == 32'hffffffff) && (rs1signunsignmux_sel == rs1signunsignmux::sign)));

    always_comb begin
        if(start_multi && done_multi) begin
            true_o = multi_o;
            done = 1'b1;
        end
        else if(start_div && (done_div || div_error)) begin
            done = 1'b1;
            if(!overflow && !div_zero) begin
                true_o = div_o;
            end
            else begin
                if(!divremquotmux_sel && div_zero) true_o = 32'hffffffff;
                else if((divremquotmux_sel && div_zero) || (!divremquotmux_sel && !rs1signunsignmux_sel && overflow)) true_o = true_rs1;
                else true_o = 32'b0;
            end
        end
        else begin
            done = 1'b0;
            true_o = 32'h0b00b1e5;
        end
    end

endmodule : multiply_and_divide
