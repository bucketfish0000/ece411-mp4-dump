module prefetch_buffer(
    input clk,
    input rst,
    input logic [31:0] mem_addr, //mem_addr, either imem_addr or new pf_addr
    input logic imem_writing,
    input logic pf_read, //imem is reading
    input logic pf_write, //want to write something into pf_buf
    input logic pf_ld, //pmem_resp goes high, load cacheline
    input logic [255:0] mem_rdata,
    output logic pf_hit,
    output logic pf_miss,
    output logic pf_mem_resp,
    output logic [255:0] pf_mem_rdata,
);

    assign pf_hit = hit;
    assign pf_miss = miss;

    logic least_recent_used;
    logic used;
    logic [31:0] addrs [1:0];
    logic [255:0] cache_lines [1:0];
    logic hit, miss, pf_miss_resp;

    assign pf_mem_rdata = cache_lines[used];
    
    always_ff @( posedge clk, posedge rst ) begin
        if(rst) begin
            least_recent_used <= 1'b0;
            addrs[1:0] <= 64'b0;
            cache_lines <= 512'b0;
            pf_miss_resp <= 1'b0;//goes high cycle after reading in cacheline from pmem on miss
        end
        else begin
            if(miss&&pf_write) begin
                if(pf_ld) begin
                    addrs[least_recent_used] <= mem_addr;
                    cache_lines[least_recent_used] <= mem_rdata;
                    least_recent_used <= !least_recent_used;
                    pf_miss_resp <= 1'b1;
                end
                else pf_miss <= 1'b0;
            end
            else if(hit&&(pf_write||pf_read)) begin
                least_recent_used <= !used;
                pf_miss_resp <= 1'b0;
            end
            else if(hit&&imem_writing) begin //hit and give imem the cacheline if it needs it, but then remove cacheline, it's dirty now
                least_recent_used <= used;
                pf_miss_resp <= 1'b0;
                addrs[least_recent_used] <= 32'b0;
                cache_lines[least_recent_used] <= 256'b0;
            end
            else begin
                pf_miss_resp == 1'b0;
            end
        end
    end

    always_comb begin
        hit = 1'b0;
        miss = 1'b0;
        used = 1'b0;
        pf_resp = 1'b0;

        if((pf_write || pf_read || )) begin
            if((mem_addr == addrs[0])) begin
                hit = 1'b1;
                pf_resp = 1'b1;
                used = 1'b0;
            end
            else if((mem_addr == addrs[1])) begin
                hit = 1'b1;
                pf_resp = 1'b1;
                used = 1'b1;
            end
            else begin
                miss = 1'b1;
                if(pf_mem_resp) begin
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