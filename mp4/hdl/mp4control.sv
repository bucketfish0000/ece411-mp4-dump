/*GO and READY signals:
    GO(Output): 
        -If high, you can start/continue to do work then update the pipeline register right after you.
        -If low, hold your output constant, don't load the pipeline register right after you.
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

logic [5:0] rdy;

assign rdy = {if_1_rdy, /*if_2_rdy*/ 1'b0, de_rdy, exe_rdy, mem_rdy, wb_rdy}

//always comb or always ff???
always_comb begin : go_ctrl
    case(rdy)
        6'b000000: begin //start OR waiting on I_cache
            if_1_go = 1'b1;
            // if_2_go = 1'b0;
            de_go = 1'b0;
            exe_go = 1'b0;
            mem_go = 1'b0;
            wb_go = 1'b0;
        end
        6'b100000: begin //if_1 finished
            if_1_go = 1'b1;
            // if_2_go = 1'b1;
            // de_go = 1'b0; !!! cp2 make sure to uncomment
            de_go = 1'b1; // !!! delete in cp2
            exe_go = 1'b0;
            mem_go = 1'b0;
            wb_go = 1'b0;
        end

        /*---cp2 cases---*/
        6'b010000: begin //if_2 finished, but waiting on I_cache

        end
        6'b110000: begin //if_2 finished
            if_1_go = 1'b1;
            if_2_go = 1'b1;
            de_go = 1'b1;
            exe_go = 1'b0;
            mem_go = 1'b0;
            wb_go = 1'b0;
        end
        6'b111000: begin //de finished
            if_1_go = 1'b1;
            if_2_go = 1'b1;
            de_go = 1'b1;
            exe_go = 1'b1; 
            mem_go = 1'b0;
            wb_go = 1'b0;
        end
        6'b111100: begin //exe finished
            if_1_go = 1'b1;
            if_2_go = 1'b1;
            de_go = 1'b1;
            exe_go = 1'b1;
            mem_go = 1'b1;
            wb_go = 1'b0;
        end
        6'b111110: begin //mem finished
            if_1_go = 1'b1;
            if_2_go = 1'b1;
            de_go = 1'b1;
            exe_go = 1'b1;
            mem_go = 1'b1;
            wb_go = 1'b1;
        end
        6'b111111: begin //all finished
            if_1_go = 1'b1;
            if_2_go = 1'b1;
            de_go = 1'b1;
            exe_go = 1'b1;
            mem_go = 1'b1;
            wb_go = 1'b1;
        end
        6'b111101: begin //mem not ready to continue
            if_1_go = 1'b0;
            if_2_go = 1'b0;
            de_go = 1'b0;
            exe_go = 1'b0;
            mem_go = 1'b1;
            wb_go = 1'b0;
        end

        /*---cp1 cases---*/
        // 6'b101000: begin //de finished OR waiting for memory to continue?
        //     if_1_go = 1'b1;
        //     // if_2_go = 1'b1;
        //     de_go = 1'b1;
        //     exe_go = 1'b1;
        //     mem_go = 1'b0;
        //     wb_go = 1'b0;
        // end
        // 6'b101100: begin //exe finished
        //     if_1_go = 1'b1;
        //     // if_2_go = 1'b1;
        //     de_go = 1'b1;
        //     exe_go = 1'b1;
        //     mem_go = 1'b1;
        //     wb_go = 1'b0;
        // end
        // 6'b101110: begin //mem finished
        //     if_1_go = 1'b1;
        //     // if_2_go = 1'b1;
        //     de_go = 1'b1;
        //     exe_go = 1'b1;
        //     mem_go = 1'b1;
        //     wb_go = 1'b1;
        // end
        // 6'b101111: begin //all finished
        //     if_1_go = 1'b1;
        //     // if_2_go = 1'b1;
        //     de_go = 1'b1;
        //     exe_go = 1'b1;
        //     mem_go = 1'b1;
        //     wb_go = 1'b1;
        // end
        // 6'b101101: begin //mem not ready to continue
        //     if_1_go = 1'b1;
        //     // if_2_go = 1'b1;
        //     de_go = 1'b1;
        //     exe_go = 1'b0; //keep exe_mem output constant
        //     mem_go = 1'b1;
        //     wb_go = 1'b0; //data from mem not ready, don't load into regfile
        // end
        // 6'b101010: begin //mem ready to continue again
        //     if_1_go = 1'b1;
        //     // if_2_go = 1'b1;
        //     de_go = 1'b1;
        //     exe_go = 1'b1;
        //     mem_go = 1'b1;
        //     wb_go = 1'b1;
        // end

        default: begin //something has gone terribly wrong
            if_1_go = 1'b0;
            // if_2_go = 1'b0;
            de_go = 1'b0;
            exe_go = 1'b0;
            mem_go = 1'b0;
            wb_go = 1'b0;
        end
    endcase
end


endmodule : mp4control
