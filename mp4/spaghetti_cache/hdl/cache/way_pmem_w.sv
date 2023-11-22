//decides what way to use when writing to pmem
module way_pmem_w(
    input logic [1:0] LRU_replace,
    input logic [255:0] data0,
    input logic [255:0] data1,
    input logic [255:0] data2,
    input logic [255:0] data3,
    output logic [255:0] pmem_wdata
);
    always_comb begin
        case(LRU_replace)
            2'b00:
                pmem_wdata = data0;
            2'b01:
                pmem_wdata = data1;
            2'b10:
                pmem_wdata = data2;
            2'b11:
                pmem_wdata = data3;
        endcase
    end
endmodule : way_pmem_w