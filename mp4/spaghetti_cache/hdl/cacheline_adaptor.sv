module cacheline_adaptor
(
    input clk,
    input reset_n,

    // Port to LLC (Lowest Level Cache)
    input logic [255:0] line_i,
    output logic [255:0] line_o,
    input logic [31:0] address_i,
    input read_i,
    input write_i,
    output logic resp_o,

    // Port to memory
    input logic [63:0] burst_i,
    output logic [63:0] burst_o,
    output logic [31:0] address_o,
    output logic read_o,
    output logic write_o,
    input resp_i
);

logic [255:0] out_line;
logic [2:0] count_four;
logic resp_o_temp;//using this so that nothing new can be done while resp_o is asserted in the decision circuit below

assign resp_o = resp_o_temp;

always_ff @ (posedge clk, negedge reset_n) begin
    if(~reset_n) begin
        count_four <= 3'b000;
        read_o <= 1'b0;
        write_o <= 1'b0;
        resp_o_temp <= 1'b0;
        //burst_o <= x
        //addr_o <= x
        //line_o <= x
    end
    else begin
        case({(read_i && !resp_o_temp), (write_i && !resp_o_temp)})
            2'b01: begin//write
                read_o <= 1'b0;
                address_o <= address_i;
                //line_o <= x
                case(count_four)
                    3'b000: begin
                        burst_o <= line_i[63:0];
                        resp_o_temp <= 1'b0;
                        write_o <= 1'b1;
                        if(resp_i == 1) begin
                            count_four <= count_four + 3'b001;
                            burst_o <= line_i[127:64];
                        end
                    end
                    3'b001: begin
                        burst_o <= line_i[127:64];
                        resp_o_temp <= 1'b0;
                        write_o <= 1'b1;
                        if(resp_i == 1) begin
                            count_four <= count_four + 3'b001;
                            burst_o <= line_i[191:128];
                        end
                    end
                    3'b010: begin
                        burst_o <= line_i[191:128];
                        resp_o_temp <= 1'b0;
                        write_o <= 1'b1;
                        if(resp_i == 1) begin
                            count_four <= count_four + 3'b001;
                            burst_o <= line_i[255:192];
                        end
                    end
                    3'b011: begin
                        burst_o <= line_i[255:192];
                        if(resp_i == 1) begin
                            resp_o_temp <= 1'b1;
                            write_o <= 1'b0;
                            count_four <= 3'b000;
                        end
                        else begin
                            resp_o_temp <= 1'b0;
                            write_o <= 1'b1;
                        end
                    end
                    default: begin//shouldn't happen
                        read_o <= 1'b0;
                        write_o <= 1'b0;
                        resp_o_temp <= 1'b0;
                        count_four <= 3'b0;//shouldn't be necessary, but just in case
                        //line_o <= x
                        //burst_o <= x
                        //addr_o <= x
                    end
                endcase
            end
            2'b10: begin//read
                write_o <= 1'b0;
                address_o <= address_i;
                //burst_o <= x
                case(count_four)
                    3'b000: begin
                        resp_o_temp <= 1'b0;
                        read_o <= 1'b1;
                        if(resp_i == 1) begin
                            out_line[63:0] <= burst_i;
                            count_four <= count_four + 3'b001;
                        end
                    end
                    3'b001: begin
                        resp_o_temp <= 1'b0;
                        read_o <= 1'b1;
                        if(resp_i == 1) begin
                            out_line[127:64] <= burst_i;
                            count_four <= count_four + 3'b001;
                        end
                    end
                    3'b010: begin
                        resp_o_temp <= 1'b0;
                        read_o <= 1'b1;
                        if(resp_i == 1) begin
                            out_line[191:128] <= burst_i;
                            count_four <= count_four + 3'b001;
                        end
                    end
                    3'b011: begin
                        resp_o_temp <= 1'b0;
                        if(resp_i == 1) begin
                            read_o <= 1'b0;
                            count_four <= 3'b100;
                            out_line[255:192] <= burst_i;
                        end
                        else begin
                            read_o <= 1'b1;
                        end
                    end
                    3'b100: begin
                        resp_o_temp <= 1'b1;
                        count_four <= 3'b0;
                        read_o <= 1'b0;
                        line_o <= out_line;
                    end
                    default: begin//shouldn't happen
                        read_o <= 1'b0;
                        write_o <= 1'b0;
                        resp_o_temp <= 1'b0;
                        count_four <= 3'b0;//shouldn't be necessary, but just in case
                        //line_o <= x
                        //burst_o <= x
                        //addr_o <= x
                    end
                endcase
            end
            default: begin //niether
                read_o <= 1'b0;
                write_o <= 1'b0;
                resp_o_temp <= 1'b0;
                count_four <= 3'b0;//shouldn't be necessary, but just in case
                //line_o <= x
                //burst_o <= x
                //addr_o <= x
            end
        endcase
    end
end

endmodule : cacheline_adaptor
