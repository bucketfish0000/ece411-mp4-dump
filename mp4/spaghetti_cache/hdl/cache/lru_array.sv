module lru_array(
    input clk0,
    input reset,
    input logic csb0,
    input logic lru_web0,
    input logic [3:0] lru_addr0,
    input logic [2:0] lru_din0,
    output logic [2:0] lru_dout0
);

logic [15:0][2:0] lru_data;

always_ff @ (posedge clk0)
begin
    if(reset) begin
        lru_data <= 48'h000000000000;
    end
    else begin
        if(csb0 == 1) begin
            if((lru_web0 == 0))
                lru_dout0 <= lru_data[lru_addr0];
            else begin
                lru_data[lru_addr0] <= lru_din0;
                lru_dout0 <= lru_din0;
            end
        end
    end
end

endmodule : lru_array