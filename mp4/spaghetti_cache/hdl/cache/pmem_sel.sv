//select what address to send to pmem and when
module pmem_sel(
    input logic pmem_read,
    input logic pmem_write,
    input logic [1:0] LRU_replace,
    input logic [22:0] tag0,
    input logic [22:0] tag1,
    input logic [22:0] tag2,
    input logic [22:0] tag3,
    input logic [31:0] address,
    output logic [31:0] pmem_address
);

    always_comb begin
        if(pmem_read == 1) begin
            pmem_address = address;
        end
        else if(pmem_write == 1) begin
            case(LRU_replace)
                2'b00: begin
                    pmem_address = {tag0, address[8:0]};
                end
                2'b01: begin
                    pmem_address = {tag1, address[8:0]};
                end
                2'b10: begin
                    pmem_address = {tag2, address[8:0]};
                end
                2'b11: begin
                    pmem_address = {tag3, address[8:0]};
                end
            endcase
        end
        else    
            pmem_address = 32'h00000000;
    end


endmodule : pmem_sel