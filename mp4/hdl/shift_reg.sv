module shift_reg(
    input clk,
    input rst,
    input logic ld,
    input logic ld_parallel,
    input logic ld_parallel_shift,
    input logic bit_in,
    input logic [63:0] z_in,
    output logic [63:0] z_out
);
    always_ff @ (posedge clk, posedge rst) begin
        if(rst) begin
            z_out <= 64'b0;
        end 
        else if(ld) begin
            z_out <= {z_out[62:0], bit_in};
        end
        else if(ld_parallel) begin
            z_out <= z_in;
        end
        else if(ld_parallel_shift) begin
            z_out <= {z_in[62:0], bit_in};
        end
    end

endmodule : shift_reg