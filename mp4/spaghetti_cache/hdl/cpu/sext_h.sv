module sext_h
(
    input logic [15:0] in,
    output logic [31:0] out
);

    always_comb begin
        if(in[15] == 1'b1)
            out = {16'b1111111111111111, in};
        else
            out = {16'b0000000000000000, in};
    end

endmodule