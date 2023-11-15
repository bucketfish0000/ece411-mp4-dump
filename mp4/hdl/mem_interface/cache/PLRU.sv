module PLRU_4_way#(
    parameter  s_index = 4
) (
    input logic clk,
    input logic rst,
    input logic update,
    input logic[3:0] hit_map, //1-hot
    input logic[s_index-1:0] set_sel,
    output logic[1:0] plru_number,
    output logic[3:0] plru_map
);

    localparam num_sets = 2**s_index;
    logic [num_sets-1:0]update_arr;
    //logic [2:0] plru_arr[num_sets];
    logic [1:0] plru_index_arr[num_sets];
    logic [1:0] plru_num_out;
    logic [3:0] plru_map_out;
    logic [2:0] hit_index;
    assign plru_map =  plru_map_out;
    assign plru_number = plru_num_out;

    genvar i;
    generate
        for (i=0; i<num_sets; i++) begin : make_compile_happy_2
            PLRU_4_way_unit plru_unit(
                .clk(clk),
                .rst(rst),
                .update(update_arr[i]),
                .hit_index(hit_index[1:0]),
                .plru_index(plru_index_arr[i]));
        end
    endgenerate

    always_comb begin
        //mask everything with valid 
        //in mapping
        unique case(hit_map)
            4'b0001: hit_index = 3'b000;
            4'b0010: hit_index = 3'b001;
            4'b0100: hit_index = 3'b010;
            4'b1000: hit_index = 3'b011;
            default: hit_index = 3'b100; //hit_map is not one-hot, meaning no hit and no updates should happen 
        endcase
        //spec output
        update_arr = (16'h0001 << (set_sel)) & ((~hit_index[2]&update)<<(set_sel)); //make sure if hit_index falls into 1xx nothing should update
        //out mapping
        plru_num_out = plru_index_arr[set_sel];
        plru_map_out = 4'b0001 << plru_index_arr[set_sel]; 
        //mask everything with valid 
    end

endmodule: PLRU_4_way

module PLRU_4_way_unit #(
)(
    input logic clk,
    input logic rst,
    input logic update,
    input logic [1:0] hit_index,
    output logic [1:0] plru_index
);

    logic [2:0] bits;

    always_ff @(posedge clk) begin
        if (rst) begin
            bits <= 3'b000;
        end //?

        if (update) begin
            //update: taking hit # as input, convert to bits to invert
            //policy -- we store LRU ptr bits, meaning invert on update
            /* 
                       L0
                   0/     \1
                  L1       L2
                0/  \1  0/  \1
               00   01  10  11
        MRU   x00  x10 0x1  1x1
        PLRU  x11  x01 1x0  0x0
        rtn#  x1    x1  x0  x0   
            */
            bits[2] <= !hit_index[1];
            bits[~hit_index[1]] <= !hit_index[0]; 
        end
        else bits <= bits;
    end

    //bit readout conversion

    always_comb begin
        plru_index[1] = bits[2];
        plru_index[0] = bits[~bits[2]];
    end

endmodule: PLRU_4_way_unit
