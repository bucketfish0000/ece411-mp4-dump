module register #(parameter width = 32, 
                  parameter resetData = 32'h00000000)
(
    input clk,
    input rst,
    input load,
    input [width - 1:0] in,
    //input [4:0] src_a, src_b, dest,
    output logic [width - 1:0] out
);

//logic [31:0] data [32] /* synthesis ramstyle = "logic" */ = '{default:'0};
logic [width - 1:0] data; 

always_ff @(posedge clk)
begin
    if (rst)
    begin
        data <= resetData;
    end
    else if (load)
    begin
        data <= in;
        //data <= 32'h00000000;
    end
end

always_comb
begin
    out <= data; 
end

endmodule : register