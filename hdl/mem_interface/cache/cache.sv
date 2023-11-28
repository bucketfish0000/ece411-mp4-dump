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

    //control inputs
    logic[1:0] dirty_op;
    logic[1:0] valid_op; 
    logic plru_update;
    logic[1:0] dataweb_mux;
    logic tagweb_mux;
    logic datain_mux;
    logic dataout_sel_mux;
    logic dirty_way_mux;
    logic cache_hit;
    logic cache_dirty;
    logic pmem_address_mux;
    logic data_wmask_mux;
    //assign plru_rf= plru_update;
cache_control control
(   .clk(clk),.rst(rst), 
    .cpu_read(mem_read),.cpu_write(mem_write),
    .cache_resp(mem_resp),
    .pmem_resp(pmem_resp),
    .mem_read(pmem_read),
    .mem_write(pmem_write),
    .dirty_op(dirty_op), 
    .valid_op(valid_op), 
    .plru_update(plru_update),
    .dataweb_mux(dataweb_mux),
    .tagweb_mux(tagweb_mux),
    .datain_mux(datain_mux),
    .dataout_sel_mux(dataout_sel_mux),
    .dirty_way_mux(dirty_way_mux),
    .data_wmask_mux(data_wmask_mux),
    .pmem_address_mux(pmem_address_mux),
    .cache_hit(cache_hit),
    .cache_dirty(cache_dirty)
);

cache_datapath datapath
(
    .clk(clk), .rst(rst),
    .address(mem_address), .wmask(mem_byte_enable),
    
    .cpu_data_write(mem_wdata),
    .cpu_data_read(mem_rdata),
    .mem_data_read(pmem_rdata),
    .mem_data_write(pmem_wdata),
    .pmem_address(pmem_address),

    .dirty_op(dirty_op), 
    .valid_op(valid_op), 
    .plru_update(plru_update),

    .dataweb_mux(dataweb_mux),
    .tagweb_mux(tagweb_mux),
    .datain_mux(datain_mux),
    .dataout_sel_mux(dataout_sel_mux),
    .dirty_way_mux(dirty_way_mux),
    .pmem_address_mux(pmem_address_mux),
    .data_wmask_mux(data_wmask_mux),

    .cache_hit(cache_hit),
    .cache_dirty(cache_dirty)
);

endmodule : cache
