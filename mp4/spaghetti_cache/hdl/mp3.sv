module mp3
import rv32i_types::*;
(
    input   logic           clk,
    input   logic           rst, //!! ACTIVE LOW??? !! assuming high
    output  logic   [31:0]  bmem_address,
    output  logic           bmem_read,
    output  logic           bmem_write,
    input   logic   [63:0]  bmem_rdata,
    output  logic   [63:0]  bmem_wdata,
    input   logic           bmem_resp
);

    logic mem_resp, mem_read, mem_write, pmem_read, pmem_write, pmem_resp;
    logic [3:0] mem_byte_enable;
    logic [31:0] mem_rdata, mem_wdata, mem_address, pmem_address, 
    mem_byte_enable256;
    logic [255:0] pmem_rdata, pmem_wdata, mem_wdata256, mem_rdata256;

    cpu cpu(
        .clk(clk), //check
        .rst(rst), //check
        .mem_resp(mem_resp), //check
        .mem_rdata(mem_rdata), //check
        .mem_read(mem_read), //check
        .mem_write(mem_write), //check
        .mem_byte_enable(mem_byte_enable), //check
        .mem_address(mem_address), //check
        .mem_wdata(mem_wdata) //check
    );

    bus_adapter bus_adapt(
        .address(mem_address), //check
        .mem_wdata256(mem_wdata256), //check
        .mem_rdata256(mem_rdata256), //check
        .mem_wdata(mem_wdata), //check
        .mem_rdata(mem_rdata), //check
        .mem_byte_enable(mem_byte_enable), //check
        .mem_byte_enable256(mem_byte_enable256) //check
    );

    cache cache(
        .clk(clk), //check
        .rst(rst), //check

        /* CPU side signals */
        .mem_address(mem_address), //check
        .mem_read(mem_read), //check
        .mem_write(mem_write), //check
        .mem_byte_enable(mem_byte_enable256), //check
        .mem_rdata(mem_rdata256), //check
        .mem_wdata(mem_wdata256), //check
        .mem_resp(mem_resp), //check

        /* Memory side signals */
        .pmem_address(pmem_address), //check
        .pmem_read(pmem_read), //check
        .pmem_write(pmem_write), //check
        .pmem_rdata(pmem_rdata), //check
        .pmem_wdata(pmem_wdata), //check
        .pmem_resp(pmem_resp) //check
    );

    cacheline_adaptor cacheline_adapt(
        .clk(clk), //check
        .reset_n(!(rst)), //check

        // Port to LLC (Lowest Level Cache)
        .line_i(pmem_wdata), //check
        .line_o(pmem_rdata), //check
        .address_i(pmem_address), //check
        .read_i(pmem_read), //check
        .write_i(pmem_write), //check
        .resp_o(pmem_resp), //check

        // Port to memory
        .burst_i(bmem_rdata), //check
        .burst_o(bmem_wdata), //check
        .address_o(bmem_address), //check
        .read_o(bmem_read), //check
        .write_o(bmem_write), //check
        .resp_i(bmem_resp) //check
    );

endmodule : mp3
