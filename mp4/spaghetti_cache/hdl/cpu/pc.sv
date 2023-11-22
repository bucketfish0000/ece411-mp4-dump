module pc
import rv32i_types::*;
(
    input clk,
    input reset,
    input load_pc,
    input [31:0] pc_in,
    output logic [31:0] pc_out
);

always_ff @ (posedge clk or posedge reset)
begin
    if(reset) begin
        pc_out <= 32'h40000000;
    end
    else if(load_pc) begin
        pc_out <= pc_in;
    end
end

endmodule : pc