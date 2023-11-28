module sext_half(
    input logic [15:0] half_in,
    output logic [31:0] whole_half_out
);
    always_comb begin : sexty_half
        if(half_in[15]) begin
            whole_half_out = {16'hffff, half_in};
        end
        else begin
            whole_half_out = {16'h0, half_in};
        end
    end

endmodule : sext_half