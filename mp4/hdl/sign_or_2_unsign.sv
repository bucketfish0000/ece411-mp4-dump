module sign_or_2_unsign(
    input logic [31:0] rs1_i,
    input logic [31:0] rs2_i,
    input logic [31:0] rd_i,
    output logic [31:0] rs1_o,
    output logic [31:0] rs2_o,
    output logic [31:0] rd_o
);
    always_comb begin
        if(rs1_i[31]) begin
            rs1_o = ~rs1_i - 32'b01;
        end
        else begin
            rs1_o = rs1_i;
        end

        if(rs2_i[31]) begin
            rs2_o = ~rs2_i - 32'b01;
        end
        else begin
            rs2_o = rs2_i;
        end

        if((rs1_i[31] && rs2_i[31]) || (!rs1_i[31] && !rs2_i[31])) begin
            rd_o = rd_i;
        end
        else begin
            rd_o = ~rd_i + 32'b01;
        end
    end


endmodule : sign_or_2_unsign


//logic for exe or alu or ...? Idk where
/*
    sign_or_2_unsign(
        .rs1_i(alumux1_o),
        .rs2_i(alumux2_o),
        .rd_i(multi_o),
        .rs1_o(so2u_rs1_o),
        .rs2_o(so2u_rs2_o),
        .rd_o(so2u_rd_o)
    );

    multiplier multi(
        .rs1(multi_rs1),
        .rs2(multi_rs2),
        .rd_low(multi_low),
        .rd_high(multi_high)
    );

    always_comb begin
        unique case(exe_CW.multihighlowmux_sel)
            multihighlowmux::low: multi_o = multi_low;
            multihighlowmux::high: multi_o = multi_high;
        endcase

        unique case(exe_CW.rs1signunsignmux_sel)
            rs1signunsignmux::sign: multi_rs1 = so2u_rs1_o;
            rs1signunsignmux::unsign: multi_rs1 = alumux1_o;
        endcase

        unique case(exe_CW.rs2signunsignmux_sel)
            rs2signunsignmux::sign: multi_rs2 = so2u_rs2_o;
            rs2signunsignmux::unsign: multi_rs2 = alumux2_o;
        endcase
    end
*/
