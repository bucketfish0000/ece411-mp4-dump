module dirty_array(
    input clk0,
    input reset,
    input logic csb0,
    input logic dirty_web0,
    input logic [3:0] dirty_addr0,
    input logic dirty_din0,
    output logic dirty_dout0
);

logic [15:0] dirty_data;

always_ff @ (posedge clk0)
begin
    if(reset) begin
        dirty_data <= 16'h0000;
    end
    else begin
        if(csb0 == 1) begin
            if((dirty_web0 == 0))
                dirty_dout0 <= dirty_data[dirty_addr0];
            else begin
                dirty_data[dirty_addr0] <= dirty_din0;
                dirty_dout0 <= dirty_din0;
            end
        end
    end
end

endmodule : dirty_array