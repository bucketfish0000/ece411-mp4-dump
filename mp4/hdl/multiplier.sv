module multiplier(
    input clk, 
    input rst,
    input logic start,
    input logic new_instruction,
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    output logic done,
    output logic [31:0] rd_low,
    output logic [31:0] rd_high
);
    logic [63:0] result;

    function automatic karatsuba_1;
        input logic num1;
        input logic num2;

        begin : multiplication_logic
            karatsuba_1 = num1 & num2;
        end
    endfunction

    function automatic [3:0] karatsuba_2;
        input logic [1:0] num1;
        input logic [1:0] num2;

        logic x_0, x_1, y_0, y_1; 
        logic [2:0] shifty_1, shifty_2;
        logic [3:0] z_0, z_1, z_2;

        begin : kara_2
            x_0 = num1[0];
            x_1 = num1[1];
            y_0 = num2[0];
            y_1 = num2[1];
            shifty_1 = 3'b001;
            shifty_2 = 3'b010;

            z_0 = {3'b000, karatsuba_1(x_0, y_0)};
            z_2 = {3'b000, karatsuba_1(x_1, y_1)};
            z_1 = {3'b000, karatsuba_1(x_1, y_0)} + {3'b000, karatsuba_1(x_0, y_1)};

            karatsuba_2 = ((z_2<<shifty_2) + (z_1<<shifty_1) + z_0);
        end
    endfunction

    function automatic [7:0] karatsuba_4;
        input logic [3:0] num1;
        input logic [3:0] num2;

        logic [1:0] x_0, x_1, y_0, y_1; 
        logic [3:0] shifty_1, shifty_2;
        logic [7:0] z_0, z_1, z_2;

        begin : kara_4
            x_0 = num1[1:0];
            x_1 = num1[3:2];
            y_0 = num2[1:0];
            y_1 = num2[3:2];
            shifty_1 = 4'b0010;
            shifty_2 = 4'b0100;

            z_0 = {4'b0000, karatsuba_2(x_0, y_0)};
            z_2 = {4'b0000, karatsuba_2(x_1, y_1)};
            z_1 = {4'b0000, karatsuba_2(x_1, y_0)} + {4'b000, karatsuba_2(x_0, y_1)};

            karatsuba_4 = ((z_2<<shifty_2) + (z_1<<shifty_1) + z_0);
        end
    endfunction

    function automatic [15:0] karatsuba_8;
        input logic [7:0] num1;
        input logic [7:0] num2;

        logic [3:0] x_0, x_1, y_0, y_1; 
        logic [4:0] shifty_1, shifty_2;
        logic [15:0] z_0, z_1, z_2;

        begin : kara_8
            x_0 = num1[3:0];
            x_1 = num1[7:4];
            y_0 = num2[3:0];
            y_1 = num2[7:4];
            shifty_1 = 5'b00100;
            shifty_2 = 5'b01000;

            z_0 = {8'h00, karatsuba_4(x_0, y_0)};
            z_2 = {8'h00, karatsuba_4(x_1, y_1)};
            z_1 = {8'h00, karatsuba_4(x_1, y_0)} + {8'h00, karatsuba_4(x_0, y_1)};

            karatsuba_8 = ((z_2<<shifty_2) + (z_1<<shifty_1) + z_0);
        end
    endfunction

    function automatic [31:0] karatsuba_16;
        input logic [15:0] num1;
        input logic [15:0] num2;

        logic [7:0] x_0, x_1, y_0, y_1; 
        logic [5:0] shifty_1, shifty_2;
        logic [31:0] z_0, z_1, z_2;

        begin : kara_16
            x_0 = num1[7:0];
            x_1 = num1[15:8];
            y_0 = num2[7:0];
            y_1 = num2[15:8];
            shifty_1 = 6'b001000;
            shifty_2 = 6'b010000;

            z_0 = {16'h0000, karatsuba_8(x_0, y_0)};
            z_2 = {16'h0000, karatsuba_8(x_1, y_1)};
            z_1 = {16'h0000, karatsuba_8(x_1, y_0)} + {16'h0000, karatsuba_8(x_0, y_1)};

            karatsuba_16 = ((z_2<<shifty_2) + (z_1<<shifty_1) + z_0);
        end
    endfunction

    // function automatic [63:0] karatsuba_32;
    //     input logic [31:0] num1;
    //     input logic [31:0] num2;

    //     logic [15:0] x_0, x_1, y_0, y_1; 
    //     logic [6:0] shifty_1, shifty_2;
    //     logic [31:0] z_0, z_1, z_2;

    //     begin : kara_32
    //         x_0 = num1[15:0];
    //         x_1 = num1[31:16];
    //         y_0 = num2[15:0];
    //         y_1 = num2[31:16];
    //         shifty_1 = 7'b0010000;
    //         shifty_2 = 7'b0100000;

    //         z_0 = {32'h0, karatsuba_16(x_0, y_0)};
    //         z_2 = {32'h0, karatsuba_16(x_1, y_1)};
    //         z_1 = {32'h0, karatsuba_16(x_1, y_0)} + {32'h0, karatsuba_16(x_0, y_1)};

    //         karatsuba_32 = ((z_2<<shifty_2) + (z_1<<shifty_1) + z_0);
    //     end
    // endfunction

    logic [31:0] kara_16_0, kara_16_1_0, kara_16_1_1, kara_16_2;
    logic [63:0] kara_32;
    logic [1:0] count;

    always_ff @ (posedge clk, posedge rst) begin
        if(rst) begin
            kara_16_0 <= 32'b0;
            kara_16_1_0 <= 32'b0;
            kara_16_1_1 <= 32'b0;
            kara_16_2 <= 32'b0;
            kara_32 <= 64'b0;
            rd_low <= 32'b0;
            rd_high <= 32'b0;
            done <= 1'b0;
            count <= 2'b0;
        end
        else begin
            if(new_instruction) begin
                kara_16_0 <= 32'b0;
                kara_16_1_0 <= 32'b0;
                kara_16_1_1 <= 32'b0;
                kara_16_2 <= 32'b0;
                kara_32 <= 64'b0;
                rd_low <= 32'b0;
                rd_high <= 32'b0;
                done <= 1'b0;
                count <= 2'b0;
            end
            else if((count == 2'b00) && (start)) begin
                kara_16_0 <= {32'h0, karatsuba_16(rs1[15:0], rs2[15:0])};
                kara_16_2 <= {32'h0, karatsuba_16(rs1[31:16], rs1[31:16])};
                kara_16_1_0 <= {32'h0, karatsuba_16(rs1[31:16], rs2[15:0])};
                kara_16_1_1 <= {32'h0, karatsuba_16(rs1[15:0], rs2[31:16])};
                rd_low <= 32'b0;
                rd_high <= 32'b0;
                done <= 1'b0;
                count <= count + 2'b01;
            end
            else if((count == 2'b01) && (start)) begin
                kara_32 <= ({32'b0, kara_16_2}<<7'b0100000) + (({32'b0, kara_16_1_1}+{32'b0, kara_16_1_0})<<7'b0010000) + {32'b0, kara_16_0};
                rd_low <= 32'b0;
                rd_high <= 32'b0;
                done <= 1'b0;
                count <= count + 2'b01;
            end
            else if((count == 2'b10) && (start)) begin
                rd_low <= kara_32[31:0];
                rd_high <= kara_32[63:32];
                done <= 1'b1;
                if(new_instruction) begin
                    count <= 2'b0;
                end
            end
        end
    end

    // assign result = karatsuba_32(rs1, rs2);
    // assign rd_low = result[31:0];
    // assign rd_high = result[63:32];
endmodule : multiplier