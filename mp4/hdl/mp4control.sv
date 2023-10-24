/*GO and READY signals:
    GO(Output): 
        -If high, the data you need is ready, do work then update the pipeline register associated w/ stage.
        -If low, the data you need isn't ready, hold your output constant*(including rdy signal), don't load the pipeline register associated
         w/ stage.
    READY(Input):
        -If you give me high that means that you've updated your pipeline register and are ready for more work.
        -If you give me low that means your pipeline register hasn't been updated AND/OR you are still work on something.

    *NOTE: Each pipeline register/stage using the go signals should also account for the previous stage/pipeline register's ready signal
           If the previous stage has the data ready, but the cpu is not telling you to proceed then this indicates you need to keep all 
           outputs constant. This will usually only be the case when MEM stage is holding up pipeline, and requires constant input signals
           to interface with D cache properly.

    **NOTE: Use internal logic from the associated stage, previous stages ready signal, and cpu go signal to decide when to signal you are 
            ready/when to update the pipeline register.
*/
module mp4control
import rv32i_types::*;
import cpuIO::*;
(
    input clk,
    input rst,

    /*---if signals---*/
    input rv32i_opcode opcode,
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
    output control_word cw_cpu 
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
        /*
            start:
            i1:  addi r1, r0, 17     #r1 = 17 = r0 + 17 = 0 + 17
            i2:  ld r2, val_x        #r2 = 16 = mem[val_x]
                 nop
                 nop
            i3:  add r3, r1, r2      #r3 = 33 = r1 + r2 = 17 + 16
            end
                 nop
                 nop
                 nop
                 nop
                 nop

            val_x: .word 0x0000010 #0x010 = 16 

            ------------------------------------------------------------------------------------
            cyc   |   ld_1   |   ld_2   |   de   |   exe   |   mem   |   wb   ||    rdy    |    go    |    event
             0    |     x    |     x    |    x   |    x    |    x    |   x    ||  000000   |  100000  |  start
             1    |    i1    |     x    |    x   |    x    |    x    |   x    ||  100000   |  110000  |  I_read_hit,
             2    |    i2    |    i1    |    x   |    x    |    x    |   x    ||  110000   |  111000  |  I_read_hit, I_resp
             3    |   nop    |    i2    |   i1   |    x    |    x    |   x    ||  111000   |  111100  |  I_read_hit, I_resp
             4    |   nop    |   nop    |   i2   |   i1    |    x    |   x    ||  111100   |  111110  |  I_read_hit, I_resp
             5    |    i3    |   nop    |  nop   |   i2    |   i1    |   x    ||  111110   |  111111  |  I_read_hit, I_resp
             6    |   end    |    i3    |  nop   |  nop    |   i2    |  i1    ||  111101   |  000010  |  I_read_hit, I_resp, r1 = 17
             7    |   end    |    i3    |  nop   |  nop    |   i2    |   x    ||  111110   |  111111  |  D_resp
             8    |   nop    |   end    |   i3   |  nop    |  nop    |  i2    ||  111111   |  111111  |  chugga,     r2 = 16
             9    |   nop    |   nop    |  end   |   i3    |  nop    | nop    ||  111111   |  111111  |  chugga     
             10   |   nop    |   nop    |  nop   |  end    |   i3    | nop    ||  111111   |  111111  |  choo  
             11   |   nop    |   nop    |  nop   |  nop    |  end    |  i3    ||  111111   |  111111  |  choo,       r3 = 33       
             12   |   nop    |   nop    |  nop   |  nop    |  nop    | end    ||  111111   |  111111  |  end         
        */

        //don't continue if_1 if rest of the pipeline needs to hold data constant until mem finishes, don't really care about status of rdy[0]
        //if r/w D => continue only if if_2/de can continue
        if((mem_read_D || mem_write_D) && /*(rdy[5:1] == 5'b11110)*/ (rdy[4:1] == 4'b1110)) 
            if_1_go = 1'b0;
        else
            if_1_go = 1'b1;

        /*---cp2---*/
        // if((rdy[5]) && !((mem_read_D || mem_write_D) && (rdy[4:1] == 4'b1110))) begin
        //     if_2_go = 1'b1;
        // end
        // else begin
        //     if_2_go = 1'b0;
        // end

        // start if cp1: if_1 ready --- cp2: if_2 ready
        // if r/w D => continue only if exe can continue
        if((rdy[4]) && !((mem_read_D || mem_write_D) && (rdy[3:1] == 3'b110))) begin
            de_go = 1'b1;
        end
        else begin
            de_go = 1'b0;
        end

        //start if de ready, if r/w D => continue only if mem ready continue
        if((rdy[3]) && !((mem_read_D || mem_write_D) && (rdy[2:1] == 2'b10))) begin
            exe_go = 1'b1;
        end
        else begin
            exe_go = 1'b0;
        end

        //start if exe ready, if r/w D => continue writing
        if((rdy[2]) || (mem_read_D || mem_write_D)) begin
            mem_go = 1'b1;
        end
        else begin
            mem_go = 1'b0;
        end

        //start if mem ready
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
end

function void set_def();
    cw_cpu.opcode = 7'b0;
    cw_cpu.funct3 = 3'b0;
    cw_cpu.funct7 = 7'b0;
endfunction

always_comb begin : cpu_cw
    if(rst) begin
        set_def();
    end
    else if(rdy[4]/*rdy[5]*/) begin
        cw_cpu.opcode = opcode;
        cw_cpu.funct3 = func3;
        cw_cpu.funct7 = func7;
    end
    else begin
        set_def();
    end
end



endmodule : mp4control
