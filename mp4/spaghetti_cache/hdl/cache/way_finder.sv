module way_finder(
    input logic search,
    input logic mem_write,
    input logic mem_read,
    input logic pmem_read,
    input logic pmem_resp,
    input logic reset_way,
    input logic wb_en,
    input logic replace,
    input logic end_miss_write,
    input logic [22:0] tag_dout0,
    input logic [22:0] tag_dout1,
    input logic [22:0] tag_dout2,
    input logic [22:0] tag_dout3,
    input logic valid_dout0,
    input logic valid_dout1,
    input logic valid_dout2,
    input logic valid_dout3,
    input logic [31:9] addr,
    output logic compare,
    output logic searched,
    output logic [1:0] way,
    output logic mem_resp,
    output logic hit_write,
    output logic hit_read,
    output logic miss_read,
    output logic mid_miss_write,
    output logic dirty_data_miss
);
    logic [1:0] way_temp;
    logic searched_temp, compare_temp, pmem_high_flag;

    assign compare = compare_temp;
    assign searched = searched_temp;

    always_comb begin
        if((reset_way == 1))  begin

            way = 2'b00;
            compare_temp = 1'b0;
            searched_temp = 1'b0;
        end
        else if((tag_dout0 == addr) && (valid_dout0 == 1) && (search == 1)) begin
            way = 2'b00;
            compare_temp = 1'b1;
            searched_temp = 1'b1;

        end
        else if((tag_dout1 == addr) && (valid_dout1 == 1) && (search == 1)) begin
            way = 2'b01;
            compare_temp = 1'b1;
            searched_temp = 1'b1;
 
        end
        else if((tag_dout2 == addr) && (valid_dout2 == 1) && (search == 1)) begin
            way = 2'b10;
            compare_temp = 1'b1;
            searched_temp = 1'b1;
 
        end
        else if((tag_dout3 == addr) && (valid_dout3 == 1) && (search == 1)) begin
            way = 2'b11;
            compare_temp = 1'b1;
            searched_temp = 1'b1;

        end
        else if((search == 1)) begin
            way = 2'b00;
            compare_temp = 1'b0;
            searched_temp = 1'b1;

        end
        else begin
            way = 2'b00;
            compare_temp = 1'b0;
            searched_temp = 1'b0;

        end
    end

    always_comb begin // when raise mem_resp
        if(((pmem_read == 1) && (pmem_resp == 1) && (mem_read == 1)) || ((compare_temp == 1) && (searched_temp == 1)) ||
            (end_miss_write == 1))
            // || ((wb_en == 1) && (pmem_resp == 1) && (mem_write == 1) && (pmem_read == 1)))
            mem_resp = 1'b1;
        else
            mem_resp = 1'b0;
    end

    always_comb begin
        if((compare_temp == 1) && (searched_temp == 1) && (mem_read == 1))
            hit_read = 1'b1;
        else
            hit_read = 1'b0;
    end

    always_comb begin //update data, which will be over written after reading in data from pmem
        if((pmem_read == 1) && (pmem_resp == 1) && (mem_write == 1)) begin
            mid_miss_write = 1'b1;
        end
        else begin
            mid_miss_write = 1'b0;
        end
    end

    always_comb begin
        if((mem_write == 1) && (compare_temp == 1) && (searched_temp == 1) && (search == 1) && (replace == 0))
            hit_write = 1'b1;
        else
            hit_write = 1'b0;
    end

    always_comb begin //read we pull memory from dram to replace ... is dirty getting set back to zero on miss reads? make sure!!!
        if((pmem_read == 1) && (pmem_resp == 1) && (mem_read == 1)) begin
            miss_read = 1'b1;
            dirty_data_miss = 1'b0;
        end
        else begin
            miss_read = 1'b0;
            dirty_data_miss = 1'b1;
        end
    end
endmodule : way_finder