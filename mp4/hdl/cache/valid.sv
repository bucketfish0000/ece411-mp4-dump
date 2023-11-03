module valid#(
    parameter s_index = 4,
    parameter w_index = 2
)(
    input   logic                   clk,
    input   logic                   rst,
    input   logic[1:0]                  operation,//00,11 - idle, 01 - mark, 10 - unmark
    input   logic[s_index-1:0]          set_sel,
    input   logic[w_index-1:0]          way_sel,
    output  logic[2*w_index-1:0]        valid_out
);

localparam num_sets = 2**s_index;
localparam num_ways = 2**w_index;

logic [num_ways-1:0] web;
logic [num_ways-1:0] in;
logic [num_ways-1:0] out;
assign valid_out = out;

genvar i;
generate
    for (i=0;i<num_ways;i++) begin
        ff_array #(.s_index(s_index),.width(1)) 
        valid_arr
            (.clk0(clk),
            .rst0(rst),
            .csb0('0),
            .web0(web[i]),
            .addr0(set_sel),
            .din0(in[i]),
            .dout0(out[i]));
    end
endgenerate

always_comb begin
    case (operation)
    00,11:begin //idle, read out
        web = 4'b1111; //rd
        in = 4'b0000;
    end
    01:begin //mark
        web = web;
        in = in;
        web[way_sel] = 1'b0;
        in[way_sel] = 1'b1;
    end
    10:begin //unmark
        web = web;
        in = in;
        web[way_sel]= 1'b0;
        in[way_sel] = 1'b0;
    end
    default:begin 
        web = 4'b0000; //rd
        in = 4'b0000;
    end
    endcase



end

endmodule : valid