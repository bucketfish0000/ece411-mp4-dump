/*Encoding of compare signal:
    compare         meaning
    2'b00           no overflow, not divided by zero, set lsb of z to 0 and no update
    2'b01           no overflow, not divided by zero, set lsb of z to 1 and update z with diff z-d
    2'b10           divide by zero
    2'b11           overflow
*/

module div_compare(
    input logic [32:0] zed_in,
    input logic [32:0] ded_in,
    output logic compare
);

always_comb begin : div_cmp_logic
    if((zed_in >= ded_in)) begin
        compare = 1'b1;
    end
    else begin
        compare = 1'b0;
    end
    // compare = 2'b10;
end

endmodule : div_compare