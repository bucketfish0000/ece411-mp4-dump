module cache_datapath #(
            parameter       s_offset = 5,
            parameter       s_index  = 4,
            parameter       s_tag    = 32 - s_offset - s_index,
            parameter       s_mask   = 2**s_offset,
            parameter       s_line   = 8*s_mask,
            parameter       num_sets = 2**s_index
)(
    input logic clk,
    input logic reset,
    input logic pmem_resp,
    input logic replace,
    input logic search,
    input logic pmem_read,
    input logic pmem_write,
    input logic reset_way,
    input logic mem_read,
    input logic mem_write,
    input logic end_miss_write,
    input logic [31:0] address,
    input logic [31:0] mem_byte_enable256,
    input logic [255:0] mem_wdata256,
    input logic [255:0] pmem_rdata,
    output logic compare,
    output logic searched,
    output logic dirty_data_o,
    output logic valid_data_o,
    output logic [255:0] pmem_wdata,
    output logic [255:0] mem_rdata256,
    output logic [31:0] pmem_address,
    output logic mem_resp
);

    logic   [255:0] data_d      [4];
    logic   [22:0] tag_d        [4];
    logic   [255:0] data_d_o      [4];
    logic   [22:0] tag_d_o        [4];
    logic [1:0] lru_replace, way;
    logic [2:0] lru_data_o, lru_data_i;
    logic lru_w, way_reset_temp, mem_resp_temp, miss_read, d_d_miss, hit_write, hit_read, dirty_d_o_temp, valid_d_o_temp, mid_miss_write;
    logic [3:0] dirty_w4, valid_w4, valid_data4_o, dirty_data4_o,
    data_write_way, tag_write_way;
    logic [255:0] data_4_cache;
    logic [31:0] mask;

    assign way_reset_temp = reset_way | reset;
    assign mem_resp = mem_resp_temp;
    assign dirty_data_o = dirty_d_o_temp;
    assign valid_data_o = valid_d_o_temp;

    lru_array lru_array0(
        .clk0(clk),//in
        .reset(reset),
        .csb0(1'b1),
        .lru_web0(lru_w),
        .lru_addr0(address[8:5]),
        .lru_din0(lru_data_i),
        .lru_dout0(lru_data_o)//out
    );

    //!! PLRU replace way 4 first on cold start? !!

    plru plru0(
        .update(miss_read || hit_read || hit_write || end_miss_write ),//in
        .replace(replace),
        .way(way),
        .LRU_dout(lru_data_o),
        .LRU_replace(lru_replace),//out
        .LRU_data(lru_data_i),
        .LRU_w(lru_w)
    );


    dirty_array dirty0(
        .clk0(clk),//in
        .reset(reset),
        .csb0(1'b1),
        .dirty_web0(dirty_w4[0]),
        .dirty_addr0(address[8:5]),
        .dirty_din0(((hit_write) && (d_d_miss)) || end_miss_write ),
        .dirty_dout0(dirty_data4_o[0])//out
    );

    dirty_array dirty1(
        .clk0(clk),//in
        .reset(reset),
        .csb0(1'b1),
        .dirty_web0(dirty_w4[1]),
        .dirty_addr0(address[8:5]),
        .dirty_din0(((hit_write) && (d_d_miss)) || end_miss_write ),
        .dirty_dout0(dirty_data4_o[1])//out
    );

    dirty_array dirty2(
        .clk0(clk),//in
        .reset(reset),
        .csb0(1'b1),
        .dirty_web0(dirty_w4[2]),
        .dirty_addr0(address[8:5]),
        .dirty_din0(((hit_write) && (d_d_miss)) || end_miss_write ),
        .dirty_dout0(dirty_data4_o[2])//out
    );

    dirty_array dirty3(
        .clk0(clk),//in
        .reset(reset),
        .csb0(1'b1),
        .dirty_web0(dirty_w4[3]),
        .dirty_addr0(address[8:5]),
        .dirty_din0(((hit_write) && (d_d_miss)) || end_miss_write ),
        .dirty_dout0(dirty_data4_o[3])//out
    );

    way_write dirty_w_way(
        .write_en((hit_write || miss_read) || end_miss_write ),//in
        .replace(replace),
        .LRU_replace(lru_replace),
        .way(way),
        .way_w_en(dirty_w4)//out
    );


    valid_array valid0(
        .clk0(clk),//in
        .reset(reset),
        .csb0(1'b1),
        .valid_web0(valid_w4[0]),
        .valid_addr0(address[8:5]),
        .valid_din0(miss_read || end_miss_write ),
        .valid_dout0(valid_data4_o[0])//out
    );

    valid_array valid1(
        .clk0(clk),//in
        .reset(reset),
        .csb0(1'b1),
        .valid_web0(valid_w4[1]),
        .valid_addr0(address[8:5]),
        .valid_din0(miss_read || end_miss_write ),
        .valid_dout0(valid_data4_o[1])//out
    );

    valid_array valid2(
        .clk0(clk),//in
        .reset(reset),
        .csb0(1'b1),
        .valid_web0(valid_w4[2]),
        .valid_addr0(address[8:5]),
        .valid_din0(miss_read || end_miss_write ),
        .valid_dout0(valid_data4_o[2])//out
    );

    valid_array valid3(
        .clk0(clk),//in
        .reset(reset),
        .csb0(1'b1),
        .valid_web0(valid_w4[3]),
        .valid_addr0(address[8:5]),
        .valid_din0(miss_read || end_miss_write ),
        .valid_dout0(valid_data4_o[3])//out
    );

    way_write valid_w_way(
        .write_en(miss_read || end_miss_write ),//in
        .replace(replace),
        .LRU_replace(lru_replace),
        .way(way),
        .way_w_en(valid_w4)//out
    );

    read_write_mask rw_mask(
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mid_miss_write(mid_miss_write),
        .mem_byte_enable256(mem_byte_enable256),
        .mask(mask)
    );

    genvar i;
    generate for (i = 0; i < 4; i++) begin : arrays0
        mp3_data_array data_array (
            .clk0       ((clk)),//in
            .csb0       (1'b0), //active low Xp
            .web0       (data_write_way[i]),//active low Xp
            .wmask0     (mask /*mem_byte_enable256*/),//bus adapter handles this
            .addr0      (address[8:5]),
            .din0       (data_d[i]),
            .dout0      (data_d_o[i])//out
        );
    end endgenerate

    way_write_data_tag data_w_way(
        .write_en((hit_write || miss_read) || end_miss_write || mid_miss_write),//in
        .replace(replace),
        .LRU_replace(lru_replace),
        .way(way),
        .way_w_en(data_write_way)//out
    );

    parallel_data para_data(
        .data_4_cache(data_4_cache),
        .data_4_way0(data_d[0]),
        .data_4_way1(data_d[1]),
        .data_4_way2(data_d[2]),
        .data_4_way3(data_d[3])
    );

    way_cache_read cache_read(
        .mem_resp(mem_resp_temp), //in
        .replace(replace),
        .mem_read(mem_read), 
        .way(way),
        .data0(data_d_o[0]),
        .data1(data_d_o[1]),
        .data2(data_d_o[2]),
        .data3(data_d_o[3]),
        .pmem_rdata(pmem_rdata),
        .mem_rdata_from_cache(mem_rdata256) // out
    );


    genvar j;
    generate for (j = 0; j < 4; j++) begin : arrays1
        mp3_tag_array tag_array (
            .clk0       ((clk)),//in
            .csb0       (1'b0),//active low Xp
            .web0       (tag_write_way[j]),//active low Xp
            .addr0      (address[8:5]),
            .din0       (tag_d[j]),
            .dout0      (tag_d_o[j])//out
        );
    end endgenerate

    way_write_data_tag tag_w_way(
        .write_en(miss_read || end_miss_write ),//in
        .replace(replace),
        .LRU_replace(lru_replace),
        .way(way),
        .way_w_en(tag_write_way)//out
    );

    parallel_tag para_tag(
        .tag_4_cache(address[31:9]),
        .tag_4_way0(tag_d[0]),
        .tag_4_way1(tag_d[1]),
        .tag_4_way2(tag_d[2]),
        .tag_4_way3(tag_d[3])
    );


    way_pmem_w pmem_w_way(
        .LRU_replace(lru_replace),//in
        .data0(data_d_o[0]),
        .data1(data_d_o[1]),
        .data2(data_d_o[2]),
        .data3(data_d_o[3]),
        .pmem_wdata(pmem_wdata)//out
    );

    mux_2_1 mux2_1(
        .data_sel(miss_read || mid_miss_write),//in
        .mem_wdata256(mem_wdata256),
        .pmem_rdata(pmem_rdata),
        .data(data_4_cache)//out
    );

    data_sel_mux data_sel_dirty(
        .replace(replace),//in
        .way(way),
        .LRU_replace(lru_replace),
        .d4_in(dirty_data4_o),
        .d1_out(dirty_d_o_temp)//out
    );

    data_sel_mux data_sel_valid(
        .replace(replace),//in
        .way(way),
        .LRU_replace(lru_replace),
        .d4_in(valid_data4_o),
        .d1_out(valid_d_o_temp)//out
    );

    way_finder way_finder0(//make a sram resp for each case resp_pls is asserted and if it's asserted in write to cache case the 
        .search(search),//in
        .mem_write(mem_write),
        .mem_read(mem_read),
        .pmem_read(pmem_read),
        .pmem_resp(pmem_resp),
        .reset_way(way_reset_temp),
        .wb_en((valid_d_o_temp && dirty_d_o_temp)),
        .replace(replace),
        .end_miss_write(end_miss_write),
        .tag_dout0(tag_d_o[0]),
        .tag_dout1(tag_d_o[1]),
        .tag_dout2(tag_d_o[2]),
        .tag_dout3(tag_d_o[3]),
        .valid_dout0(valid_data4_o[0]),
        .valid_dout1(valid_data4_o[1]),
        .valid_dout2(valid_data4_o[2]),
        .valid_dout3(valid_data4_o[3]),
        .addr(address[31:9]),
        .compare(compare),//out
        .searched(searched),
        .way(way),
        .mem_resp(mem_resp_temp),
        .hit_write(hit_write),
        .hit_read(hit_read),
        .miss_read(miss_read),
        .mid_miss_write(mid_miss_write),
        .dirty_data_miss(d_d_miss)
    );

    pmem_sel pmem_addr_sel(
        .pmem_read(pmem_read),//in
        .pmem_write(pmem_write),
        .LRU_replace(lru_replace),
        .tag0(tag_d_o[0]),
        .tag1(tag_d_o[1]),
        .tag2(tag_d_o[2]),
        .tag3(tag_d_o[3]),
        .address(address),
        .pmem_address(pmem_address)//out
    );

endmodule : cache_datapath
