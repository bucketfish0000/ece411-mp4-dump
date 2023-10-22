/*GO and READY signals:
    GO(Output): 
        -If high, the data you need is ready, do work then update the pipeline register right after you.
        -If low, the data you need isn't ready, hold your output constant, don't load the pipeline register right after you.
    READY(Input):
        -If you give me high that means that you've updated your pipeline register and are ready for more work.
        -If you give me low that means your pipeline register hasn't been updated AND/OR you are still work on something.
*/
module mp4control
import rv32i_types::*;
import cpuIO::*;
(
    input clk,
    input rst,

    /*---if signals---*/
    input logic mem_read_I,
    input logic mem_write_I,
    input rv32i_opcode opcode,
    input rv32i_word pc,
    input rv32i_reg rd, //what dis do?
    output logic[2:0] func3,
    output logic[6:0] func7,
    //...anything else?

    /*---de signals... none?---*/

    /*---exe signals---*/
    input logic br_en,
    //...anything else?

    /*---mem_stage signals---*/
    input logic mem_read_D,
    input logic mem_write_D,
    //...anything else?

    /*---ready signals---*/
    input logic if_1_rdy,
    // input logic if_2_rdy, //for cp2
    input logic de_rdy,
    input logic exe_rdy,
    input logic mem_rdy,
    input logic wb_rdy,

    /*---continue/load signals---*/
    output logic if_1_go,
    // output logic if_2_go, //for cp2
    output logic de_go,
    output logic exe_go,
    output logic mem_go,
    output logic wb_go,

    /*---cpu_cw---*/
    output cw_output cw_cpu //is cw_output for this???
);

// logic [5:0] rdy;
logic [4:0] rdy;

assign rdy = {if_1_rdy, /*if_2_rdy,*/ de_rdy, exe_rdy, mem_rdy, wb_rdy}

//always comb or always ff???
always_comb begin : go_ctrl
    if(rst) begin
        if_1_go = 1'b0;
        // if_2_go = 1'b0;
        de_go = 1'b0;
        exe_go = 1'b0;
        mem_go = 1'b0;
        wb_go = 1'b0;
    end
    else begin
            // 0  miss I => rdy = 000000 -> go = 100000             x
            //    5 cycle penalty                                   x
            // 5  i_resp => rdy = 100000 -> go = 110000             x
            // 6  miss I => rdy = 010000 -> go = 101000             x
            // 7  wait on I => rdy = 001000 -> go = 100100          x
            // 8  wait I / miss D => rdy = 000100 -> go = 100010    x
            // 9  wait I/D => rdy = 000100 -> go = 100010           x
            // 10 wait I/D => rdy = 000100 -> go = 100010           x
            // 11 resp I / wait D => rdy = 100100 -> go = 110010    x
            // 12 hit I / wait D => rdy = 110100 -> go = 111010     x
            // 13 resp I/D => rdy = 111110 -> go = 111111           x
            // 14 hit I / miss D => rdy = 111101 -> go = 111110     !!! need to makes sure this would work from here
            // 15 wait D => rdy = 111100 -> go = 000010
            // 16 wait D => rdy = 111100 -> go = 000010
            // 17 wait D => rdy = 111100 -> go = 000010
            // 18 wait D => rdy = 111100 -> go = 000010
            // 19 resp D => rdy = 111110 -> go = 111111
            // 20 hit I / hit D => rdy = 111101 -> go = 000010
            // 21 resp I/D => rdy = 111110 -> go = 011111
            // 22 hit D => rdy = 011101 -> go = 000010
            // 23 resp D => rdy = 011110 -> go = 001111
            // 24 hit D => rdy = 001101 -> go = 000010
            // 25 resp D => rdy = 001110 -> go = 000111
            // 26 hit D => rdy = 000101 -> go = 000010
            // 27 resp D => rdy = 000110 -> go = 000011
            // 28 hit D => rdy = 000001 -> go = 000010
            // 29 resp D => rdy = 000010 -> go = 000001
            // 30 END => rdy = 000001 -> go = 000000


        if_1_go = 1'b1;

        /*---cp2---*/
        if(rdy[5]) begin
            if_2_go = 1'b1;
        end
        else begin
            if_2_go = 1'b0;
        end

        if(rdy[4]) begin //cp1: if_1 ready --- cp2: if_2 ready
            de_go = 1'b1;
        end
        else begin
            de_go = 1'b0;
        end

        if(rdy[3]) begin //de ready
            exe_go = 1'b1;
        end
        else begin
            exe_go = 1'b0;
        end

        if((rdy[2]) || (mem_read_D || mem_write_D)) begin //exe ready
            mem_go = 1'b1;
        end
        else begin
            mem_go = 1'b0;
        end

        if(rdy[1]) begin //mem ready
            wb_go = 1'b1;
        end
        else begin
            wb_go = 1'b0;
        end

        // if(rdy[0]) begin //wb ready
        //     //...nobody cares about you
        // end
        // else begin
        //     //...and they never will
        // end
    end

    /*
        Hypothetical
        
        start:
            0  miss I => rdy = 000000 -> go = 100000
               5 cycle penalty
            5  i_resp => rdy = 100000 -> go = 110000
            6  miss I => rdy = 010000 -> go = 101000
            7  wait on I => rdy = 001000 -> go = 100100
            8  wait I / miss D => rdy = 000100 -> go = 100010
            9  wait I/D => rdy = 000100 -> go = 100010
            10 wait I/D => rdy = 000100 -> go = 100010
            11 resp I / wait D => rdy = 100100 -> go = 110010
            12 hit I / wait D => rdy = 110100 -> go = 111010
            13 resp I/D => rdy = 111110 -> go = 111101
            14 resp I / miss D => rdy = 111101 -> go = 111110
            15 wait D => rdy = 111100 -> go = 000010
            16 wait D => rdy = 111100 -> go = 000010
            17 wait D => rdy = 111100 -> go = 000010
            18 wait D => rdy = 111100 -> go = 000010
            19 resp D => rdy = 111110 -> go = 111111
            20 hit I / hit D => rdy = 111101 -> go = 000010
            21 resp I/D => rdy = 111110 -> go = 011111
            22 hit D => rdy = 011101 -> go = 000010
            23 resp D => rdy = 011110 -> go = 001111
            24 hit D => rdy = 001101 -> go = 000010
            25 resp D => rdy = 001110 -> go = 000111
            26 hit D => rdy = 000101 -> go = 000010
            27 resp D => rdy = 000110 -> go = 000011
            28 hit D => rdy = 000001 -> go = 000010
            29 resp D => rdy = 000010 -> go = 000001
            30 END => rdy = 000001 -> go = 000000
        end
    */
end


endmodule : mp4control
