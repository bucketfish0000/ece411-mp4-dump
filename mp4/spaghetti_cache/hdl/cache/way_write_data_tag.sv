//Have a separate way write decided for tag and data bc write en is active low
module way_write_data_tag(
    input logic write_en,
    input logic replace,
    input logic [1:0] LRU_replace,
    input logic [1:0] way,
    output logic [3:0] way_w_en
);

    always_comb begin
        if((write_en == 1) && (replace == 0)) begin
            case(way)
                2'b00: way_w_en = 4'b1110;
                2'b01: way_w_en = 4'b1101;
                2'b10: way_w_en = 4'b1011;
                2'b11: way_w_en = 4'b0111;
            endcase
        end
        else if((write_en == 1) && (replace == 1)) begin
            case(LRU_replace)
                2'b00: way_w_en = 4'b1110;
                2'b01: way_w_en = 4'b1101;
                2'b10: way_w_en = 4'b1011;
                2'b11: way_w_en = 4'b0111;
            endcase
        end
        else
            way_w_en = 4'b1111;
    end

endmodule : way_write_data_tag