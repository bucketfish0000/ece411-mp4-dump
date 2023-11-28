module mar
(
    input clk,
    input reset,
    input logic load_mar,
    input logic [31:0] mar_in,
    output logic [31:0] mar_out
);

always_ff @ (posedge clk or posedge reset)
begin
    if(reset)
        mar_out <= 32'h00000000;
    else if(load_mar)
        mar_out <= mar_in;
end

endmodule : mar