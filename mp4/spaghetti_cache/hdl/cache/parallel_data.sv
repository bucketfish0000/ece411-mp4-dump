//for now this just sets all the input to the same value for the ways of the data store
//in the future can use to support parallel cache writes
module parallel_data(
    input logic [255:0] data_4_cache,
    output logic [255:0] data_4_way0,
    output logic [255:0] data_4_way1,
    output logic [255:0] data_4_way2,
    output logic [255:0] data_4_way3
);

    always_comb begin
        data_4_way0 = data_4_cache;
        data_4_way1 = data_4_cache;
        data_4_way2 = data_4_cache;
        data_4_way3 = data_4_cache;
    end

endmodule : parallel_data