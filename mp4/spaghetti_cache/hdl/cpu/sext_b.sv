module sext_b
(
    input logic [7:0] in,
    output logic [31:0] out
);

    always_comb begin
        if(in[7] == 1'b1)
            out = {24'b111111111111111111111111, in};
        else
            out = {24'b000000000000000000000000, in};
    end

endmodule