//when we want to know when one clk cycle has occured
//assert resp_pls, then after one cycle sram_resp asserts
//one_cycle = 1, if one_cycle == 0 then one cycle has not past
//or we don't want to know if a cycle has past

module sram_resp(
    input logic clk,
    input logic resp_pls,
    output logic one_cycle
);
    reg temp_wait;

    always_ff @ (posedge clk) begin
        if((resp_pls == 1)) begin
            one_cycle <= 1'b1;
        end
        // else if((temp_wait == 1)) begin
        //     temp_wait <= 1'b0;
        //     one_cycle <= 1'b1;
        // end
        else begin
            temp_wait <= 1'b0;
            one_cycle <= 1'b0;
        end
    end

endmodule :  sram_resp