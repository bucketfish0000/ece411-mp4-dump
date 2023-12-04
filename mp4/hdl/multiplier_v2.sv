module multiplier_v2(
    input clk,
    input rst,
    input logic start,
    input logic new_instruction,
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    output logic [31:0] rd_low,
    output logic [31:0] rd_high,
    output logic done
);
logic bum;
assign bum = 1'b1;
logic [15:0] lay_1_nums [3:0][1:0];
logic [7:0] lay_2_nums [3:0][3:0][1:0];
logic [3:0] lay_3_nums [3:0][3:0][3:0][1:0];
logic [1:0] lay_4_nums [3:0][3:0][3:0][3:0][1:0];
logic lay_5_nums [3:0][3:0][3:0][3:0][3:0][1:0];

// logic [63:0] lay_1_result;
// logic [31:0] lay_2_result [3:0];
// logic [15:0] lay_3_result [3:0][3:0];
// logic [7:0] lay_4_result [3:0][3:0][3:0];
// logic [3:0] lay_5_result [3:0][3:0][3:0][3:0];
// logic lay_6_result [3:0][3:0][3:0][3:0][3:0];
typedef logic [3:0][3:0][3:0][3:0][3:0] six_result;
typedef logic [3:0][3:0][3:0][3:0][3:0] five_result;
typedef logic [1:0][3:0][3:0][3:0][7:0] four_result;
typedef logic [3:0][3:0][3:0][15:0] three_result;
typedef logic [7:0][3:0][31:0]  two_result;
typedef logic [15:0][63:0] one_result;
union packed { 
  struct packed {
    one_result lay_1_result;
  } lay_1_struct;
  struct packed {
    two_result lay_2_result;
  } lay_2_struct;
  struct packed {
    three_result lay_3_result;
  } lay_3_struct;
  struct packed {
    four_result lay_4_result;
  } lay_4_struct;
  struct packed {
    five_result lay_5_result;
  } lay_5_struct;
  struct packed {
    six_result lay_6_result;
  } lay_6_struct;
} ult_result;


assign lay_1_nums[0][0] = rs1[15:0];
assign lay_1_nums[0][1] = rs2[15:0];

assign lay_1_nums[1][0] = rs1[15:0];
assign lay_1_nums[1][1] = rs2[31:16];

assign lay_1_nums[2][0] = rs1[31:16];
assign lay_1_nums[2][1] = rs2[15:0];

assign lay_1_nums[3][0] = rs1[31:16];
assign lay_1_nums[3][1] = rs2[31:16];

generate
    genvar i0;
    for(i0 = 0; i0 < 4; i0 = i0 + 1) begin : lay_2 //which z from lay 1
        assign lay_2_nums[i0][0][0] = lay_1_nums[i0][0][7:0];
        assign lay_2_nums[i0][0][1] = lay_1_nums[i0][1][7:0];

        assign lay_2_nums[i0][1][0] = lay_1_nums[i0][0][7:0];
        assign lay_2_nums[i0][1][1] = lay_1_nums[i0][1][15:8];

        assign lay_2_nums[i0][2][0] = lay_1_nums[i0][0][15:8];
        assign lay_2_nums[i0][2][1] = lay_1_nums[i0][1][7:0];

        assign lay_2_nums[i0][3][0] = lay_1_nums[i0][0][15:8];
        assign lay_2_nums[i0][3][1] = lay_1_nums[i0][1][15:8];
    end
endgenerate

generate
    genvar i1,j1;
    for(i1 = 0; i1 < 4; i1 = i1 + 1) begin : lay_3_0 //which lay 2
        for(j1 = 0; j1 < 4; j1 = j1 + 1) begin : lay_3_1//which z from lay 1
            assign lay_3_nums[i1][j1][0][0] = lay_2_nums[i1][j1][0][3:0];
            assign lay_3_nums[i1][j1][0][1] = lay_2_nums[i1][j1][1][3:0];

            assign lay_3_nums[i1][j1][1][0] = lay_2_nums[i1][j1][0][3:0];
            assign lay_3_nums[i1][j1][1][1] = lay_2_nums[i1][j1][1][7:4];

            assign lay_3_nums[i1][j1][2][0] = lay_2_nums[i1][j1][0][7:4];
            assign lay_3_nums[i1][j1][2][1] = lay_2_nums[i1][j1][1][3:0];

            assign lay_3_nums[i1][j1][3][0] = lay_2_nums[i1][j1][0][7:4];
            assign lay_3_nums[i1][j1][3][1] = lay_2_nums[i1][j1][1][7:4];
        end
    end
endgenerate

generate
    genvar i2, j2, k2;
    for(i2 = 0; i2 < 4; i2 = i2 + 1) begin //which lay 2
        for(j2 = 0; j2 < 4; j2 = j2 + 1) begin //which lay 3
            for(k2 = 0; k2 < 4; k2 = k2 + 1) begin //which z from lay 2
                assign lay_4_nums[i2][j2][k2][0][0] = lay_3_nums[i2][j2][k2][0][1:0];
                assign lay_4_nums[i2][j2][k2][0][1] = lay_3_nums[i2][j2][k2][1][1:0];

                assign lay_4_nums[i2][j2][k2][1][0] = lay_3_nums[i2][j2][k2][0][1:0];
                assign lay_4_nums[i2][j2][k2][1][1] = lay_3_nums[i2][j2][k2][1][3:2];

                assign lay_4_nums[i2][j2][k2][2][0] = lay_3_nums[i2][j2][k2][0][3:2];
                assign lay_4_nums[i2][j2][k2][2][1] = lay_3_nums[i2][j2][k2][1][1:0];

                assign lay_4_nums[i2][j2][k2][3][0] = lay_3_nums[i2][j2][k2][0][3:2];
                assign lay_4_nums[i2][j2][k2][3][1] = lay_3_nums[i2][j2][k2][1][3:2];
            end
        end
    end
endgenerate

generate
    genvar i3, j3, k3, l3;
    for(i3 = 0; i3 < 4; i3 = i3 + 1) begin //which lay 2
        for(j3 = 0; j3 < 4; j3 = j3 + 1) begin //which lay 3
            for(k3 = 0; k3 < 4; k3 = k3 + 1) begin //which lay 4
                for(l3 = 0; l3 < 4; l3 = l3 + 1) begin //which z fro lay 3
                    assign lay_5_nums[i3][j3][k3][l3][0][0] = lay_4_nums[i3][j3][k3][l3][0][0];
                    assign lay_5_nums[i3][j3][k3][l3][0][1] = lay_4_nums[i3][j3][k3][l3][1][0];

                    assign lay_5_nums[i3][j3][k3][l3][1][0] = lay_4_nums[i3][j3][k3][l3][0][0];
                    assign lay_5_nums[i3][j3][k3][l3][1][1] = lay_4_nums[i3][j3][k3][l3][1][1];

                    assign lay_5_nums[i3][j3][k3][l3][2][0] = lay_4_nums[i3][j3][k3][l3][0][1];
                    assign lay_5_nums[i3][j3][k3][l3][2][1] = lay_4_nums[i3][j3][k3][l3][1][0];

                    assign lay_5_nums[i3][j3][k3][l3][3][0] = lay_4_nums[i3][j3][k3][l3][0][1];
                    assign lay_5_nums[i3][j3][k3][l3][3][1] = lay_4_nums[i3][j3][k3][l3][1][1];
                end
            end
        end
    end
endgenerate 

logic [2:0] count;

always_ff @( posedge clk) begin
    if(rst) begin
        count <= 3'b0;
        ult_result.lay_1_struct.lay_1_result <= 1024'b0;
    end
    else if(start) begin
        case(count)
            // 4'b0000: begin//lay6
            //     count <= count + 4'b01;
            //     for(logic [2:0] i5 = 3'b0; i5 < 3'b100; i5 = i5 + 3'b001) begin //which lay 2
            //         for(logic [2:0] j5 = 3'b0; j5 < 3'b100; j5 = j5 + 3'b001) begin //which lay 3
            //             for(logic [2:0] k5 = 3'b0; k5 < 3'b100; k5 = k5 + 3'b001) begin //which lay 4
            //                 for(logic [2:0] l5 = 3'b0; l5 < 3'b100; l5 = l5 + 3'b001) begin //which z fro lay 3
            //                     ult_result.lay_6_struct.lay_6_result[i5][j5][k5][l5][0] <= lay_5_nums[i5][j5][k5][l5][0][0] & lay_5_nums[i5][j5][k5][l5][0][1];

            //                     ult_result.lay_6_struct.lay_6_result[i5][j5][k5][l5][1] <= lay_5_nums[i5][j5][k5][l5][1][0] & lay_5_nums[i5][j5][k5][l5][1][1];

            //                     ult_result.lay_6_struct.lay_6_result[i5][j5][k5][l5][2] <= lay_5_nums[i5][j5][k5][l5][2][0] & lay_5_nums[i5][j5][k5][l5][2][1];

            //                     ult_result.lay_6_struct.lay_6_result[i5][j5][k5][l5][3] <= lay_5_nums[i5][j5][k5][l5][3][0] & lay_5_nums[i5][j5][k5][l5][3][1];
            //                 end
            //             end
            //         end
            //     end
            // end

            3'b000: begin //lay5
                count <= count + 3'b01;
                for(logic [2:0] i7 = 3'b0; i7 < 3'b100; i7 = i7 + 3'b001) begin //which lay 2
                    for(logic [2:0] j7 = 3'b0; j7 < 3'b100; j7 = j7 + 3'b001) begin //which lay 3
                        for(logic [2:0] k7 = 3'b0; k7 < 3'b100; k7 = k7 + 3'b001) begin //which lay 4
                            ult_result.lay_5_struct.lay_5_result[i7][j7][k7][0] <= {3'b0, (lay_5_nums[i7][j7][k7][0][0][0] & lay_5_nums[i7][j7][k7][0][0][1])} + 
                                    {({2'b0, (lay_5_nums[i7][j7][k7][0][1][0] & lay_5_nums[i7][j7][k7][0][1][1])} + 
                                        {2'b0, (lay_5_nums[i7][j7][k7][0][2][0] & lay_5_nums[i7][j7][k7][0][2][1])}), 1'b0} + 
                                            {1'b0, (lay_5_nums[i7][j7][k7][0][3][0] & lay_5_nums[i7][j7][k7][0][3][1]), 2'b0};

                            ult_result.lay_5_struct.lay_5_result[i7][j7][k7][1] <= {3'b0, (lay_5_nums[i7][j7][k7][1][0][0] & lay_5_nums[i7][j7][k7][1][0][1])} + 
                                    {({2'b0, (lay_5_nums[i7][j7][k7][1][1][0] & lay_5_nums[i7][j7][k7][1][1][1])} + 
                                        {2'b0, (lay_5_nums[i7][j7][k7][1][2][0] & lay_5_nums[i7][j7][k7][1][2][1])}), 1'b0} + 
                                            {1'b0, (lay_5_nums[i7][j7][k7][1][3][0] & lay_5_nums[i7][j7][k7][1][3][1]), 2'b0};

                            ult_result.lay_5_struct.lay_5_result[i7][j7][k7][2] <= {3'b0, (lay_5_nums[i7][j7][k7][2][0][0] & lay_5_nums[i7][j7][k7][2][0][1])} + 
                                    {({2'b0, (lay_5_nums[i7][j7][k7][2][1][0] & lay_5_nums[i7][j7][k7][2][1][1])} + 
                                        {2'b0, (lay_5_nums[i7][j7][k7][2][2][0] & lay_5_nums[i7][j7][k7][2][2][1])}), 1'b0} + 
                                            {1'b0, (lay_5_nums[i7][j7][k7][2][3][0] & lay_5_nums[i7][j7][k7][2][3][1]), 2'b0};

                            ult_result.lay_5_struct.lay_5_result[i7][j7][k7][3] <= {3'b0, (lay_5_nums[i7][j7][k7][3][0][0] & lay_5_nums[i7][j7][k7][3][0][1])} + 
                                    {({2'b0, (lay_5_nums[i7][j7][k7][3][1][0] & lay_5_nums[i7][j7][k7][3][1][1])} + 
                                        {2'b0, (lay_5_nums[i7][j7][k7][3][2][0] & lay_5_nums[i7][j7][k7][3][2][1])}), 1'b0} + 
                                            {1'b0, (lay_5_nums[i7][j7][k7][3][3][0] & lay_5_nums[i7][j7][k7][3][3][1]), 2'b0};
                        end
                    end
                end
            end

            3'b001: begin //lay4
                count <= count + 3'b01;
                for(logic [2:0] i9 = 3'b0; i9 < 3'b100; i9 = i9 + 3'b001) begin //which lay 2
                    for(logic [2:0] j9 = 3'b0; j9 < 3'b100; j9 = j9 + 3'b001) begin //which lay 3
                        ult_result.lay_4_struct.lay_4_result[0][i9][j9][0] <= {4'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][0][0]} + 
                                {({2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][0][1]} + {2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][0][2]}), 2'b0} + 
                                    {ult_result.lay_5_struct.lay_5_result[i9][j9][0][3], 4'b0};

                        ult_result.lay_4_struct.lay_4_result[0][i9][j9][1] <= {4'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][1][0]} + 
                                {({2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][1][1]} + {2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][1][2]}), 2'b0} + 
                                    {ult_result.lay_5_struct.lay_5_result[i9][j9][1][3], 4'b0};

                        ult_result.lay_4_struct.lay_4_result[0][i9][j9][2] <= {4'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][2][0]} + 
                                {({2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][2][1]} + {2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][2][2]}), 2'b0} + 
                                    {ult_result.lay_5_struct.lay_5_result[i9][j9][2][3], 4'b0};

                        ult_result.lay_4_struct.lay_4_result[0][i9][j9][3] <= {4'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][3][0]} + 
                                {({2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][3][1]} + {2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][3][2]}), 2'b0} + 
                                    {ult_result.lay_5_struct.lay_5_result[i9][j9][3][3], 4'b0};
                    end
                end
            end
            
            3'b010: begin //lay3
                count <= count + 3'b01;
                for(logic [2:0] i11 = 3'b0; i11 < 3'b100; i11 = i11 + 3'b001) begin //which lay 2
                    ult_result.lay_3_struct.lay_3_result[0][i11][0] <= {8'b0, ult_result.lay_4_struct.lay_4_result[0][i11][0][0]} + 
                            {({4'b0, ult_result.lay_4_struct.lay_4_result[0][i11][0][1]} + {4'b0, ult_result.lay_4_struct.lay_4_result[0][i11][0][2]}), 4'b0} + 
                                {ult_result.lay_4_struct.lay_4_result[0][i11][0][3], 8'b0};

                    ult_result.lay_3_struct.lay_3_result[0][i11][1] <= {8'b0, ult_result.lay_4_struct.lay_4_result[0][i11][1][0]} + 
                            {({4'b0, ult_result.lay_4_struct.lay_4_result[0][i11][1][1]} + {4'b0, ult_result.lay_4_struct.lay_4_result[0][i11][1][2]}), 4'b0} + 
                                {ult_result.lay_4_struct.lay_4_result[0][i11][1][3], 8'b0};

                    ult_result.lay_3_struct.lay_3_result[0][i11][2] <= {8'b0, ult_result.lay_4_struct.lay_4_result[0][i11][2][0]} + 
                            {({4'b0, ult_result.lay_4_struct.lay_4_result[0][i11][2][1]} + {4'b0, ult_result.lay_4_struct.lay_4_result[0][i11][2][2]}), 4'b0} + 
                                {ult_result.lay_4_struct.lay_4_result[0][i11][2][3], 8'b0};

                    ult_result.lay_3_struct.lay_3_result[0][i11][3] <= {8'b0, ult_result.lay_4_struct.lay_4_result[0][i11][3][0]} + 
                            {({4'b0, ult_result.lay_4_struct.lay_4_result[0][i11][3][1]} + {4'b0, ult_result.lay_4_struct.lay_4_result[0][i11][3][2]}), 4'b0} + 
                                {ult_result.lay_4_struct.lay_4_result[0][i11][3][3], 8'b0};
                end
            end
             
            3'b011: begin //lay2
                count <= count + 3'b01;
                ult_result.lay_2_struct.lay_2_result[0][0] <= {16'b0, ult_result.lay_3_struct.lay_3_result[0][0][0]} + 
                        {({8'b0, ult_result.lay_3_struct.lay_3_result[0][0][1]} + {8'b0, ult_result.lay_3_struct.lay_3_result[0][0][2]}), 8'b0} + 
                            {ult_result.lay_3_struct.lay_3_result[0][0][3], 16'b0};

                ult_result.lay_2_struct.lay_2_result[0][1] <= {16'b0, ult_result.lay_3_struct.lay_3_result[0][1][0]} + 
                        {({8'b0, ult_result.lay_3_struct.lay_3_result[0][1][1]} + {8'b0, ult_result.lay_3_struct.lay_3_result[0][1][2]}), 8'b0} + 
                            {ult_result.lay_3_struct.lay_3_result[0][1][3], 16'b0};

                ult_result.lay_2_struct.lay_2_result[0][2] <= {16'b0, ult_result.lay_3_struct.lay_3_result[0][2][0]} + 
                        {({8'b0, ult_result.lay_3_struct.lay_3_result[0][2][1]} + {8'b0, ult_result.lay_3_struct.lay_3_result[0][2][2]}), 8'b0} + 
                            {ult_result.lay_3_struct.lay_3_result[0][2][3], 16'b0};

                ult_result.lay_2_struct.lay_2_result[0][3] <= {16'b0, ult_result.lay_3_struct.lay_3_result[0][3][0]} + 
                        {({8'b0, ult_result.lay_3_struct.lay_3_result[0][3][1]} + {8'b0, ult_result.lay_3_struct.lay_3_result[0][3][2]}), 8'b0} + 
                            {ult_result.lay_3_struct.lay_3_result[0][3][3], 16'b0};
            end

            3'b100: begin //lay1
                count <= count + 3'b01;
                ult_result.lay_1_struct.lay_1_result[0] <= {32'b0, ult_result.lay_2_struct.lay_2_result[0][0]} + 
                    {({16'b0, ult_result.lay_2_struct.lay_2_result[0][1]} + {16'b0, ult_result.lay_2_struct.lay_2_result[0][2]}), 16'b0} + 
                        {ult_result.lay_2_struct.lay_2_result[0][3], 32'b0};
            end

            3'b101: begin
                if(new_instruction) begin
                    count <= 3'b0;
                    ult_result.lay_1_struct.lay_1_result <= 1024'b0;
                end
            end
            default: ;
        endcase
    end
end

always_comb begin : done_logic
    if(count == 3'b0101 && !new_instruction) begin
        done = 1'b1;
    end
    else begin
        done = 1'b0;
    end
end

assign rd_low = ult_result.lay_1_struct.lay_1_result[0][31:0];
assign rd_high = ult_result.lay_1_struct.lay_1_result[0][63:32];

// always_ff @( posedge clk) begin : layer_6
//     if(bum) begin
//         for(logic [2:0] i5 = 3'b0; i5 < 3'b100; i5 = i5 + 3'b001) begin //which lay 2
//             for(logic [2:0] j5 = 3'b0; j5 < 3'b100; j5 = j5 + 3'b001) begin //which lay 3
//                 for(logic [2:0] k5 = 3'b0; k5 < 3'b100; k5 = k5 + 3'b001) begin //which lay 4
//                     for(logic [2:0] l5 = 3'b0; l5 < 3'b100; l5 = l5 + 3'b001) begin //which z fro lay 3
//                         ult_result.lay_6_struct.lay_6_result[i5][j5][k5][l5][0] <= lay_5_nums[i5][j5][k5][l5][0][0] & lay_5_nums[i5][j5][k5][l5][0][1];

//                         ult_result.lay_6_struct.lay_6_result[i5][j5][k5][l5][1] <= lay_5_nums[i5][j5][k5][l5][1][0] & lay_5_nums[i5][j5][k5][l5][1][1];

//                         ult_result.lay_6_struct.lay_6_result[i5][j5][k5][l5][2] <= lay_5_nums[i5][j5][k5][l5][2][0] & lay_5_nums[i5][j5][k5][l5][2][1];

//                         ult_result.lay_6_struct.lay_6_result[i5][j5][k5][l5][3] <= lay_5_nums[i5][j5][k5][l5][3][0] & lay_5_nums[i5][j5][k5][l5][3][1];
//                     end
//                 end
//             end
//         end
//     end
// end

// always_ff @( posedge clk) begin : layer_5
//     if(bum) begin
//         for(logic [2:0] i7 = 3'b0; i7 < 3'b100; i7 = i7 + 3'b001) begin //which lay 2
//             for(logic [2:0] j7 = 3'b0; j7 < 3'b100; j7 = j7 + 3'b001) begin //which lay 3
//                 for(logic [2:0] k7 = 3'b0; k7 < 3'b100; k7 = k7 + 3'b001) begin //which lay 4
//                     ult_result.lay_5_struct.lay_5_result[i7][j7][k7][0] <= {3'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][0][0]} + 
//                             {({2'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][0][1]} + {2'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][0][2]}), 1'b0} + 
//                                 {1'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][0][3], 2'b0};

//                     ult_result.lay_5_struct.lay_5_result[i7][j7][k7][1] <= {3'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][1][0]} + 
//                             {({2'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][1][1]} + {2'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][1][2]}), 1'b0} + 
//                                 {1'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][1][3], 2'b0};

//                     ult_result.lay_5_struct.lay_5_result[i7][j7][k7][2] <= {3'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][2][0]} + 
//                             {({2'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][2][1]} + {2'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][2][2]}), 1'b0} + 
//                                 {1'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][2][3], 2'b0};

//                     ult_result.lay_5_struct.lay_5_result[i7][j7][k7][3] <= {3'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][3][0]} + 
//                             {({2'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][3][1]} + {2'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][3][2]}), 1'b0} + 
//                                 {1'b0, ult_result.lay_6_struct.lay_6_result[i7][j7][k7][3][3], 2'b0};
//                 end
//             end
//         end
//     end
// end

// always_ff @( posedge clk) begin : layer_4
//     if(bum) begin
//         for(logic [2:0] i9 = 3'b0; i9 < 3'b100; i9 = i9 + 3'b001) begin //which lay 2
//             for(logic [2:0] j9 = 3'b0; j9 < 3'b100; j9 = j9 + 3'b001) begin //which lay 3
//                 lay_4_result[i9][j9][0] <= {4'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][0][0]} + 
//                         {({2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][0][1]} + {2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][0][2]}), 2'b0} + 
//                             {ult_result.lay_5_struct.lay_5_result[i9][j9][0][3], 4'b0};

//                 lay_4_result[i9][j9][1] <= {4'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][1][0]} + 
//                         {({2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][1][1]} + {2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][1][2]}), 2'b0} + 
//                             {ult_result.lay_5_struct.lay_5_result[i9][j9][1][3], 4'b0};

//                 lay_4_result[i9][j9][2] <= {4'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][2][0]} + 
//                         {({2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][2][1]} + {2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][2][2]}), 2'b0} + 
//                             {ult_result.lay_5_struct.lay_5_result[i9][j9][2][3], 4'b0};

//                 lay_4_result[i9][j9][3] <= {4'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][3][0]} + 
//                         {({2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][3][1]} + {2'b0, ult_result.lay_5_struct.lay_5_result[i9][j9][3][2]}), 2'b0} + 
//                             {ult_result.lay_5_struct.lay_5_result[i9][j9][3][3], 4'b0};
//             end
//         end
//     end
// end

// always_ff @( posedge clk) begin : layer_3
//     if(bum) begin
//         for(logic [2:0] i11 = 3'b0; i11 < 3'b100; i11 = i11 + 3'b001) begin //which lay 2
//             lay_3_result[i11][0] <= {8'b0, lay_4_result[i11][0][0]} + 
//                     {({4'b0, lay_4_result[i11][0][1]} + {4'b0, lay_4_result[i11][0][2]}), 4'b0} + {lay_4_result[i11][0][3], 8'b0};

//             lay_3_result[i11][1] <= {8'b0, lay_4_result[i11][1][0]} + 
//                     {({4'b0, lay_4_result[i11][1][1]} + {4'b0, lay_4_result[i11][1][2]}), 4'b0} + {lay_4_result[i11][1][3], 8'b0};

//             lay_3_result[i11][2] <= {8'b0, lay_4_result[i11][2][0]} + 
//                     {({4'b0, lay_4_result[i11][2][1]} + {4'b0, lay_4_result[i11][2][2]}), 4'b0} + {lay_4_result[i11][2][3], 8'b0};

//             lay_3_result[i11][3] <= {8'b0, lay_4_result[i11][3][0]} + 
//                     {({4'b0, lay_4_result[i11][3][1]} + {4'b0, lay_4_result[i11][3][2]}), 4'b0} + {lay_4_result[i11][3][3], 8'b0};
//         end
//     end
// end

// always_ff @( posedge clk) begin : layer_2
//     if(bum) begin
//         lay_2_result[0] <= {16'b0, lay_3_result[0][0]} + 
//                 {({8'b0, lay_3_result[0][1]} + {8'b0, lay_3_result[0][2]}), 8'b0} + {lay_3_result[0][3], 16'b0};

//         lay_2_result[1] <= {16'b0, lay_3_result[1][0]} + 
//                 {({8'b0, lay_3_result[1][1]} + {8'b0, lay_3_result[1][2]}), 8'b0} + {lay_3_result[1][3], 16'b0};

//         lay_2_result[2] <= {16'b0, lay_3_result[2][0]} + 
//                 {({8'b0, lay_3_result[2][1]} + {8'b0, lay_3_result[2][2]}), 8'b0} + {lay_3_result[2][3], 16'b0};

//         lay_2_result[3] <= {16'b0, lay_3_result[3][0]} + 
//                 {({8'b0, lay_3_result[3][1]} + {8'b0, lay_3_result[3][2]}), 8'b0} + {lay_3_result[3][3], 16'b0};
//     end
// end

// always_ff @( posedge clk) begin : layer_1
//     if(bum) begin
//         lay_1_result <= {32'b0, lay_2_result[0]} + 
//             {({16'b0, lay_2_result[1]} + {16'b0, lay_2_result[2]}), 16'b0} + {lay_2_result[3], 32'b0};
//     end
// end

// assign rd_low = lay_1_result[31:0];
// assign rd_high = lay_1_result[63:32];
    
endmodule : multiplier_v2
