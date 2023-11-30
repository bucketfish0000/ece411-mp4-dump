module sext_byte(
    input logic [7:0] byte_in,
    output logic [31:0] whole_byte_out
);
    always_comb begin : sexty_byte
        if(byte_in[7]) begin
            whole_byte_out = {24'hffffff, byte_in};
        end
        else begin
            whole_byte_out = {24'h000000, byte_in};
        end
    end

endmodule : sext_byte