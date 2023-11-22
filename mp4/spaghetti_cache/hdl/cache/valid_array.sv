module valid_array(
    input clk0,
    input reset,
    input logic csb0,
    input logic valid_web0,
    input logic [3:0] valid_addr0,
    input logic valid_din0,
    output logic valid_dout0
);

logic [15:0] valid_data;

always_ff @ (posedge clk0)
begin
    if(reset) begin
        valid_data <= 16'h0000;
    end
    else begin
        if(csb0 == 1) begin
            if((valid_web0 == 0))
                valid_dout0 <= valid_data[valid_addr0];
            else begin
                valid_data[valid_addr0] <= valid_din0;
                valid_dout0 <= valid_din0;
            end
        end
    end
end

endmodule : valid_array