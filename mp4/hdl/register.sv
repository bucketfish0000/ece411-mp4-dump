module register
(
    input clk,
    input rst,
    input load,
    input [31:0] in,
    output logic [31:0] out
);

logic [31:0] data = '0;

always_ff @(posedge clk)
begin
    if (rst) data <= '0;
    else if (load) data <= in;
    else data <= data;
end

always_comb
begin
    out = data;
end

endmodule : register