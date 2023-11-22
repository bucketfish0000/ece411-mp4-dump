module read_write_mask(
    input logic mem_read,
    input logic mem_write,
    input logic mid_miss_write,
    input logic [31:0] mem_byte_enable256,
    output logic [31:0] mask
);
    always_comb begin
        if((mem_read == 1) || (mid_miss_write == 1))
            mask = 32'hffffffff;
        else if(mem_write == 1)
            mask = mem_byte_enable256;
        else
            mask = 32'hx;
    end

endmodule : read_write_mask