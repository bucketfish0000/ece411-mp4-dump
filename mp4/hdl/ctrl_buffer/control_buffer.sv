module control_buffer 
    import rv32i_types::*;
    import rv32i_cache_types::*; 
    import hazards::*;
    import cpuIO::*;
(
    input clk,rst,
    input sel, //chip sel, without which selected the buffer should not update. this should only be high for the 1st cycle of an instr in exe, to deal with stalls and m-extension executions.
    input rv32i_word pc_exe, // pc of the instr in exe
    input rv32i_opcode opcode, //opcode of the instr in exe. an instr can possibly enter the buffer only if it is br/jmp
    input logic branch_taken, //if exe wants to take the branch or not
    input rv32i_word pc_target,
    input rv32i_word bimm_exe,

    input rv32i_word pc_fetch, //pc of instr in fetch
    output logic prediction, //the prediction bit indicating if we think the instr in location of pc_fetch would be an active branch
    //notice branch_prediction will always be 0 for non-br/jmp instrs fetched, since they have no chance to enter the buffer
    output rv32i_word target //the output target addr for br/jmps predicted as active
);

/*
btb:
32*[32b instr-pc][12b bimm[12:1]][10b branch-hist][10b prediction-hist]
guideline:
    1.  the buffer is a queue that keeps track of the 32 most recent br instrs. 
    2.  an instr is added to queue when it is br and is taken. 
    3.  an instr is target of evction when it is the oldest in the queue and something new comes along, i.e. do fifo
    4.  branch hist reg goes from high to low, i.e. bit 7 is the most recent encounter.
        therefore, the more times we see it not being taken, the hist reg number becomes smaller.
        an instr is predicted as the following: 
            if (branch-hist >= 11_1000_0000)
                predict take   
            else if (branch-hist >= 00_0001_0000)
                if (prediction is accurate enough)
                    follow last prediction
                else
                    invert last prediction
            else
                predict not take
        which means the times of activeness has been decent both in amount and in time locality in the branch instr's recent history.
        the actual threshold numbers should be subject of optimization in the future.
*/

/*
apart from the above, a separate buffer is used for jump targets:
16*[32b instr-pc][32b target]
not histories are needed since jumps are unconditional.
*/

logic [7:0] br_exe_hits, br_fetch_hits;
logic [7:0] branch_predictions;
logic [1:0] jp_exe_hits, jp_fetch_hits;

logic [7:0] update_br_pc, update_br_history;
logic [1:0] update_jp_pc, update_jp_history;
rv32i_word [7:0] br_targets;
rv32i_word [1:0] jp_targets;
logic br_exe_hit, br_fetch_hit,jp_exe_hit, jp_fetch_hit;
assign br_exe_hit = |br_exe_hits;
assign br_fetch_hit = |br_fetch_hits;
assign jp_exe_hit = |jp_exe_hits;
assign jp_fetch_hit = |jp_fetch_hits;

logic [2:0] btb_head, btb_exe_hit_index, btb_fetch_hit_index;
logic jtb_head, jtb_fetch_hit_index;

///generate!
genvar i,j;
generate
    for (i = 0; i < 8; i++) 
    begin: btb
        btb_entry bentry (
            .clk(clk),.rst(rst),
            .update_pc(update_br_pc[i]),.update_history(update_br_history[i]),.prediction(prediction),.branch_taken(branch_taken),
            .pc_exe(pc_exe),.pc_fetch(pc_fetch),.target_offset(bimm_exe[12:1]),
            
            .fetch_pc_hit(br_fetch_hits[i]),.exe_pc_hit(br_exe_hits[i]),
            .branch_prediction(branch_predictions[i]),
            .branch_target(br_targets[i])
        );
    end

    for (j = 0; j < 2; j++) 
    begin: jtb
        jtb_entry jentry (
            .clk(clk),.rst(rst),
            .update_pc(update_jp_pc[j]),
            .pc_exe(pc_exe),.pc_fetch(pc_fetch),.target(pc_target),
            
            .fetch_pc_hit(jp_fetch_hits[j]),.exe_pc_hit(jp_exe_hits[j]),
            .branch_target(jp_targets[j])
        );
    end
endgenerate

///end of generate


function void set_defaults();
    update_br_pc = 8'b0;
    update_br_history = 8'b0;
    update_jp_pc = 2'b0;
    update_jp_history = 2'b0;
endfunction

function logic[2:0] clogb2;
   input [8:0] value;
   case(value)
    8'h01:clogb2=3'b000;
    8'h02:clogb2=3'b001;
    8'h04:clogb2=3'b010;
    8'h08:clogb2=3'b011;
    8'h10:clogb2=3'b100;
    8'h20:clogb2=3'b101;
    8'h40:clogb2=3'b110;
    8'h80:clogb2=3'b111;
    default: clogb2=3'b000;
   endcase 
endfunction

always_comb begin : hit_idx_convert
    btb_exe_hit_index = 3'b0;
    btb_fetch_hit_index = 3'b0;
    jtb_fetch_hit_index = 2'b0;
    if (br_exe_hit) btb_exe_hit_index = clogb2({br_exe_hits});
    if (br_fetch_hit) btb_fetch_hit_index = clogb2({br_fetch_hits});
    if (jp_fetch_hit) jtb_fetch_hit_index = jp_fetch_hits;
end

always_comb begin : fetch_pc_lookup
    prediction = 1'b0;
    target = 32'hff;//default to invalid
    if (br_fetch_hit) begin
        prediction = branch_predictions[btb_fetch_hit_index];
        if (prediction) target = br_targets[btb_fetch_hit_index];
    end
    else if (jp_fetch_hit) begin
        prediction = 1'b1;
        target = jp_targets[jtb_fetch_hit_index];
    end
end

always_ff @(posedge clk) begin : queue_heads
    if (rst) begin
        btb_head <= 3'b0;
        jtb_head <= 2'b0;
        end 
    else if (sel) begin
        if (opcode == op_br) begin
            if (branch_taken) begin
                btb_head <= (btb_head + 3'b01);
            end
        end
        else if (opcode == op_jal) begin
            if ((!jp_exe_hit) && branch_taken) begin
                jtb_head <= (jtb_head + 2'b01);
            end
        end
    end
end

always_comb begin : buffer_operation
    set_defaults();
    if (rst) begin
        set_defaults();
    end
    else if (sel) begin
        set_defaults();
        if (opcode == op_br) begin
            if (br_exe_hit) begin
                update_br_history[btb_exe_hit_index] = 1'b1;
            end
            else if (branch_taken) begin
                update_br_pc[int'(btb_head)] = 1'b1;
            end
        end
        else if (opcode == op_jal) begin
            if ((!jp_exe_hit) && branch_taken) begin
                update_jp_pc[int'(jtb_head)] = 1'b1;
            end
        end
    end
end
endmodule : control_buffer





module btb_entry
    import rv32i_types::*;
    import rv32i_cache_types::*; 
    import hazards::*;
    import cpuIO::*;
(
    input clk,rst,
    input logic update_pc, update_history, branch_taken, prediction,
    input rv32i_word pc_exe, pc_fetch, 
    input logic [11:0] target_offset,
    
    output logic fetch_pc_hit, exe_pc_hit,
    output logic branch_prediction,
    output rv32i_word branch_target
);

    logic[31:0] instr_pc;
    logic[11:0] offset;
    logic[9:0] branch_hist;
    logic[9:0] prediction_hist;
    logic[18:0] sig_ext_19;
idth (8) does not match selector (value) width (9).[Hierarchy: ':mp4:control_buffer@control_buffer']
[C4]     [CB]       W263                                         Warning         /home/bak7/mp
    always_comb begin : sig_ext_19_logic
        if(offset[11]) sig_ext_19 = 19'b1111111111111111111;
        else sig_ext_19 = 19'b0000000000000000000;
    end
    
    assign fetch_pc_hit = (pc_fetch==instr_pc);
    assign exe_pc_hit = (pc_exe==instr_pc);
    assign branch_target = (instr_pc + {sig_ext_19, offset[11:0], 1'b0}); //sext bimm 

    always_comb begin
        branch_prediction = 1'b0;
        if (branch_hist >= 10'b1110000000) branch_prediction = 1'b1;
        else if (branch_hist < 10'b0000010000) branch_prediction =  1'b0;
        else begin
            if ((branch_hist ^ prediction_hist) >= 10'b1101010000) branch_prediction = ~prediction_hist[9];
            else branch_prediction = prediction_hist[9];
        end
    end

    always_ff @(posedge clk) begin 
        if (rst) begin
            instr_pc <= 32'b0;
            offset <= 12'b0;
            branch_hist <= 10'b0;
            prediction_hist <= 10'b0;
        end
        else begin
            if (update_pc) begin
                instr_pc <= pc_exe;
                offset <= target_offset; //bimm
                branch_hist <= 10'b1000000000;
                prediction_hist <=10'b0;
            end
            else if (update_history) begin
                branch_hist <= {branch_taken,branch_hist[9:1]};
                prediction_hist <= {prediction, prediction_hist[9:1]};
            end
        end
    end
endmodule : btb_entry

module jtb_entry
    import rv32i_types::*;
    import rv32i_cache_types::*; 
    import hazards::*;
    import cpuIO::*;
(
    input clk, rst,
    input logic update_pc,
    input rv32i_word pc_exe,pc_fetch,target,
    
    output logic fetch_pc_hit, exe_pc_hit,
    output rv32i_word branch_target
);
    logic[31:0] instr_pc;
    logic[31:0] target_pc;

    assign fetch_pc_hit = (pc_fetch==instr_pc);
    assign exe_pc_hit = (pc_exe==instr_pc);
    assign branch_target = target_pc; 

    always_ff @(posedge clk) begin 
        if (rst) begin
            instr_pc <= 32'b0;
            target_pc <= 32'b0;
        end
        else if (update_pc) begin
            instr_pc <= pc_exe;
            target_pc<= target;
        end
    end

endmodule : jtb_entry
