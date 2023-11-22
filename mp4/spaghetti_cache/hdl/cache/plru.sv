module plru(
    input logic update,
    input logic replace,
    input logic [1:0] way,
    input logic [2:0] LRU_dout,
    output logic [1:0] LRU_replace,
    output logic [2:0] LRU_data,
    output logic LRU_w
);

    always_comb begin
        case ({update, replace})
            2'b00: begin
                LRU_w = 1'b0;
                LRU_data = 3'b000;
                LRU_replace = 2'b00;
            end

            2'b01: begin
                case (LRU_dout)
                    3'b000, 3'b001: begin
                        LRU_w = 1'b0;
                        LRU_data = 3'b000;
                        LRU_replace = 2'b00;
                    end

                    3'b010, 3'b011: begin
                        LRU_w = 1'b0;
                        LRU_data = 3'b000;
                        LRU_replace = 2'b01;
                    end

                    3'b100, 3'b110: begin
                        LRU_w = 1'b0;
                        LRU_data = 3'b000;
                        LRU_replace = 2'b10;
                    end

                    3'b101, 3'b111: begin
                        LRU_w = 1'b0;
                        LRU_data = 3'b000;
                        LRU_replace = 2'b11;
                    end
                endcase
            end

            2'b10: begin
                case (way)
                    2'b00: begin
                        LRU_w = 1'b1;
                        LRU_data = {2'b11 , LRU_dout[0]};
                        LRU_replace = 2'b00;
                    end

                    2'b01: begin
                        LRU_w = 1'b1;
                        LRU_data = {2'b10 , LRU_dout[0]};
                        LRU_replace = 2'b00;
                    end

                    2'b10: begin
                        LRU_w = 1'b1;
                        LRU_data = {1'b0 , LRU_dout[1], 1'b1};
                        LRU_replace = 2'b00;
                    end

                    2'b11: begin
                        LRU_w = 1'b1;
                        LRU_data = {1'b0 , LRU_dout[1], 1'b0};
                        LRU_replace = 2'b00;
                    end
                endcase
            end

            2'b11: begin
                case (LRU_dout)
                    3'b000, 3'b001: begin
                        LRU_w = 1'b1;
                        LRU_data = {2'b11 , LRU_dout[0]};
                        LRU_replace = 2'b00;
                    end

                    3'b010, 3'b011: begin
                        LRU_w = 1'b1;
                        LRU_data = {2'b10 , LRU_dout[0]};
                        LRU_replace = 2'b01;
                    end

                    3'b100, 3'b110: begin
                        LRU_w = 1'b1;
                        LRU_data = {1'b0 , LRU_dout[1], 1'b1};
                        LRU_replace = 2'b10;
                    end

                    3'b101, 3'b111: begin
                        LRU_w = 1'b1;
                        LRU_data = {1'b0 , LRU_dout[1], 1'b0};
                        LRU_replace = 2'b11;
                    end
                endcase
            end
        endcase
    end

endmodule : plru