//for now this just sets all the input to the same value for the ways of the tag store
//in the future can use to support parallel cache writes
module parallel_tag(
    input logic [22:0] tag_4_cache,
    output logic [22:0] tag_4_way0,
    output logic [22:0] tag_4_way1,
    output logic [22:0] tag_4_way2,
    output logic [22:0] tag_4_way3
);

    always_comb begin
        tag_4_way0 = tag_4_cache;
        tag_4_way1 = tag_4_cache;
        tag_4_way2 = tag_4_cache;
        tag_4_way3 = tag_4_cache;
    end

endmodule : parallel_tag