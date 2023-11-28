/*  input and output format: 
        {rd_addr, rs1_addr, rs2_addr, opcode, commit_order}

    Store four instructions in front of current enqueuing instuction in the pipeline
*/
module hazard_queue(
    input clk,
    input rst,
    input logic flush_hzd_q,
    input logic load_hzd_q,
    input logic [85:0] enqueue,
    output logic [85:0] entry0,
    output logic [85:0] entry1,
    output logic [85:0] entry2,
    output logic [85:0] entry3
);
    always_ff @ (posedge clk, posedge rst, posedge flush_hzd_q) begin
        if(rst) begin
            entry0 <= 86'h0;
            entry1 <= 86'h0;
            entry2 <= 86'h0;
            entry3 <= 86'h0;
        end
        else if (flush_hzd_q) begin //don't want to flush pre miss predict br_en instructions(mem/wb)
            entry0 <= 86'h0;
            entry1 <= 86'h0;
        end
        else if (load_hzd_q) begin
            entry0 <= enqueue;
            entry1 <= entry0;
            entry2 <= entry1;
            entry3 <= entry2;
        end
    end

endmodule : hazard_queue