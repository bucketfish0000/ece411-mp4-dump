//used to select between pmem data and data coming from cpu to write to cahce
module mux_2_1(
    input logic data_sel,
    input logic [255:0] mem_wdata256,
    input logic [255:0] pmem_rdata,
    output logic [255:0] data
);

always_comb begin
    if(data_sel == 1)
        data = pmem_rdata;
    else    
        data = mem_wdata256;
end

endmodule : mux_2_1