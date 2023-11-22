module cache #(
            parameter       s_offset = 5,
            parameter       s_index  = 4,
            parameter       s_tag    = 32 - s_offset - s_index,
            parameter       s_mask   = 2**s_offset,
            parameter       s_line   = 8*s_mask,
            parameter       num_sets = 2**s_index
)(
    input                   clk,
    input                   rst,

    /* CPU side signals */
    input   logic   [31:0]  mem_address,
    input   logic           mem_read,
    input   logic           mem_write,
    input   logic   [31:0]  mem_byte_enable,
    output  logic   [255:0] mem_rdata,
    input   logic   [255:0] mem_wdata,
    output  logic           mem_resp,

    /* Memory side signals */
    output  logic   [31:0]  pmem_address,
    output  logic           pmem_read,
    output  logic           pmem_write,
    input   logic   [255:0] pmem_rdata,
    output  logic   [255:0] pmem_wdata,
    input   logic           pmem_resp
);

logic compare, replace, dirty_data_o, valid_data_o, searched, search,
 pmem_read_temp, pmem_write_temp, reset_way, write_end, end_miss_write;//, mem_resp_temp;
 
logic [1:0] state;

// assign mem_resp = mem_resp_temp;
assign pmem_read = pmem_read_temp;
assign pmem_write = pmem_write_temp;

cache_control control
(   .clk(clk),
    .reset(rst),
    .mem_write(mem_write),//in
    .mem_read(mem_read),
    .dirty_data_o(dirty_data_o),
    .valid_data_o(valid_data_o),
    .pmem_resp(pmem_resp),
    .compare(compare), 
    .searched(searched),
    .search(search),//out
    .replace(replace),
    .pmem_read(pmem_read_temp),
    .pmem_write(pmem_write_temp),
    .reset_way(reset_way),
    .end_miss_write(end_miss_write)
);

// mem_resp_ctrl memmy_resp(
//     //.clk(clk),
//     .state(state),//in
//     .compare(compare),
//     .pmem_resp(pmem_resp),
//     .mem_write(mem_write),
//     .dirty_d_o(dirty_data_o),
//     .valid_d_o(valid_data_o),
//     .mem_resp(mem_resp_temp)//out
// );

cache_datapath datapath(
    .clk(clk),//in
    .reset(rst),
    .pmem_resp(pmem_resp),
    .replace(replace),
    .search(search),
    .pmem_read(pmem_read_temp),
    .pmem_write(pmem_write_temp),
    .reset_way(reset_way),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .end_miss_write(end_miss_write),
    .address(mem_address),
    .mem_byte_enable256(mem_byte_enable),
    .mem_wdata256(mem_wdata),
    .pmem_rdata(pmem_rdata),
    .compare(compare),//out
    .searched(searched),
    .dirty_data_o(dirty_data_o),
    .valid_data_o(valid_data_o),
    .pmem_wdata(pmem_wdata),
    .mem_rdata256(mem_rdata),
    .pmem_address(pmem_address),
    .mem_resp(mem_resp)
);

endmodule : cache
