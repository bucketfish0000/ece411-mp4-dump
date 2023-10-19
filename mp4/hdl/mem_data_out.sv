module mem_data_out
(
    input clk,
    input reset,
    input logic load_data_out,
    input logic [31:0] mdo_in,
    output logic [31:0] mdo_out
);

always_ff @ (posedge clk or posedge reset)
begin
    if(reset)
        mdo_out <= 32'h00000000;
    else if(load_data_out)
        mdo_out <= mdo_in;
end

endmodule : mem_data_out