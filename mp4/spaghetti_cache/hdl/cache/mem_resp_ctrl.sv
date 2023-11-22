module mem_resp_ctrl(
    input logic [1:0] state,
    input logic compare,
    input logic pmem_resp,
    input logic mem_write,
    input logic dirty_d_o,
    input logic valid_d_o,
    output logic mem_resp
);
    logic mem_resp_fake;

    always_comb begin
        if(((state == 2'b01) && (compare == 0) && (mem_write == 1'b1) && ((valid_d_o == 0) || (dirty_d_o == 0)))//write miss, but no wb
            || ((state == 2'b01) && (compare == 1))//hit
            || ((state == 2'b11) && (pmem_resp == 1'b1)))//end of mem_responded
            mem_resp_fake = 1'b1;
        else 
            mem_resp_fake = 1'b0;
    end

endmodule : mem_resp_ctrl