//what/when do we send data to cpu(bus adapter)
module way_cache_read(
    input logic mem_resp,
    input logic replace,
    input logic mem_read,
    input logic [1:0] way,
    input logic [255:0] data0,
    input logic [255:0] data1,
    input logic [255:0] data2,
    input logic [255:0] data3,
    input logic [255:0] pmem_rdata,
    output logic [255:0] mem_rdata_from_cache
);

    always_comb begin
        if((mem_resp == 1) && (replace == 0) && (mem_read == 1)) begin
            case(way)
                2'b00: mem_rdata_from_cache = data0;
                2'b01: mem_rdata_from_cache = data1;
                2'b10: mem_rdata_from_cache = data2;
                2'b11: mem_rdata_from_cache = data3;
            endcase
        end
        else if((mem_resp== 1) && (replace == 1) && (mem_read == 1)) begin
            mem_rdata_from_cache = pmem_rdata;
        end
        else
            mem_rdata_from_cache = 256'hx;
    end

endmodule : way_cache_read