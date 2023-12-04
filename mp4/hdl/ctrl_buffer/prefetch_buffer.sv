/*
    General Idea:
        If imem is reading and is going to miss, but pf_buff has the cacheline it needs, grab from prefetch and write it into cache

        If imem is reading and going to miss, but pf_buff doesn't have it, imem read from pmem as normal

        If imem is reading and going to hit, ignore pf_buff entirely

        If imem and dmem are not using pmem, then pf_write high and petition pmem IF miss, then when pf_ld(==pmem_resp) update the buffer. However,
        if hit then don't petition pmem and change least_recently_used accordingly

*/

module prefetch_buffer(
    input clk,
    input rst,
    input logic [31:0] mem_addr, //mem_addr, either imem_addr or new pf_addr
    input logic pf_read, //imem is reading, check for data
    input logic pf_write, //want to write something into pf_buf
    input logic pf_ld, //pmem_resp goes high, load cacheline
    input logic [255:0] mem_rdata, //data read from pmem
    output logic pf_resp,
    output logic pf_hit, //pf_hits
    output logic pf_miss, //pf_misses
    output logic [255:0] pf_mem_rdata
);
    logic volatile;
    logic hit_num;
    logic [31:0] addrs [1:0];
    logic [255:0] cache_lines [1:0];
    logic hit, miss;

    assign pf_hit = hit;
    assign pf_miss = miss;
    assign pf_mem_rdata = cache_lines[hit_num];
    
    always_ff @( posedge clk, posedge rst ) begin
        if(rst) begin
            volatile <= 1'b0;
            addrs[0] <= 32'hf;
            addrs[1] <= 32'hf;
            cache_lines[0] <= 256'b0;
            cache_lines[1] <= 256'b0;
        end
        else begin
            if(miss&&pf_write) begin
                if(pf_ld) begin
                    addrs[volatile] <= mem_addr;
                    cache_lines[volatile] <= mem_rdata;
                    volatile <= !volatile;
                end
            end
            else if(hit&&(pf_write||pf_read)) begin
                volatile <= !hit_num;
            end
            else begin
                ;
            end
        end
    end

    // always_comb begin
    //     hit = 1'b0;
    //     miss = 1'b0;
    //     hit_num = 1'b0;
    //     pf_resp = 1'b1;

    //     if((mem_addr == addrs[0])) begin
    //         hit = 1'b1;
    //         hit_num = 1'b0;
    //     end
    //     else if((mem_addr == addrs[1])) begin
    //         hit = 1'b1;
    //         hit_num = 1'b1;
    //         pf_resp = 1'b1;
    //     end
    //     else begin
    //         miss = 1'b1;
    //         pf_resp = pf_ld;
    //     end

    // end

    
    always_comb begin
        hit = 1'b0;
        miss = 1'b0;
        hit_num = 1'b0;
        pf_resp = 1'b0;

        if((pf_write || pf_read)) begin
            if((mem_addr == addrs[0])) begin
                hit = 1'b1;
                pf_resp = 1'b1;
                hit_num = 1'b0;
            end
            else if((mem_addr == addrs[1])) begin
                hit = 1'b1;
                pf_resp = 1'b1;
                hit_num = 1'b1;
            end
            else begin
                miss = 1'b1;
                if(pf_ld) begin
                    pf_resp = 1'b1;
                end
                else begin
                    pf_resp = 1'b0;
                end
            end
        end
        else begin
            //do nothing
        end

    end

endmodule : prefetch_buffer