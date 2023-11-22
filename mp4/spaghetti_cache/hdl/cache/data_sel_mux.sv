//For deciding what valid/dirty data(one of the 4 ways) should be used by control
module data_sel_mux(
    input logic replace,
    input logic [1:0] way,
    input logic [1:0] LRU_replace,
    input logic [3:0] d4_in,
    output logic d1_out
);

    always_comb begin
        if(replace == 0) begin
            case(way)
                2'b00: d1_out = d4_in[0];
                2'b01: d1_out = d4_in[1];
                2'b10: d1_out = d4_in[2];
                2'b11: d1_out = d4_in[3];
            endcase
        end
        else if(replace == 1) begin
            case(LRU_replace)
                2'b00: d1_out = d4_in[0];
                2'b01: d1_out = d4_in[1];
                2'b10: d1_out = d4_in[2];
                2'b11: d1_out = d4_in[3];
            endcase
        end
    end

endmodule : data_sel_mux