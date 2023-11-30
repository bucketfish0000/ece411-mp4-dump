module divider_slow(
    input clk,
    input rst,
    input logic start,
    input logic new_instruction,
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] q,
    output logic [31:0] r,
    output logic done
);
    logic [63:0] z_in, z_out;
    logic [32:0] d;
    assign d = {1'b0, b};
    logic ld_shift, ld_parallel, ld_parallel_shift, bit_in, start_step, done_temp;
    logic [5:0] div_counter;
    logic divy_cmp;

    assign done = done_temp;

    enum logic [1:0] { 
        idle_start = 2'b00,
        dividing = 2'b01,
        finished = 2'b10
    } state, next_state;

    shift_reg shifty_2_duh_left(
        .clk(clk),
        .rst(rst),
        .ld(ld_shift),
        .ld_parallel(ld_parallel),
        .ld_parallel_shift(ld_parallel_shift),
        .bit_in(bit_in),
        .z_in(z_in),
        .z_out(z_out)
    );

    function void do_def();
        ld_shift = 1'b0;
        ld_parallel = 1'b0;
        ld_parallel_shift = 1'b0;
        done_temp = 1'b0;
        start_step = 1'b0;
        z_in = 64'b0;
        bit_in = 1'b0;
        q = 32'b0;
        r = 32'b0;
    endfunction : do_def

    always_comb begin : div_ctrl_signals
        do_def();
        case(state)
            idle_start: begin
                z_in = {32'b0, a};
                start_step = 1'b1;
                if(start) begin
                    ld_parallel = 1'b1;
                end
                else begin
                    ld_parallel = 1'b0;
                end
            end
            dividing: begin
                if(divy_cmp == 1'b1) begin
                    bit_in = 1'b1;
                    ld_parallel_shift = 1'b1;
                    z_in = {(z_out[63:31] - d), z_out[30:0]};
                end
                else if(div_counter != 6'b100001) begin
                    bit_in = 1'b0;
                    z_in = z_out;
                    ld_shift = 1'b1;
                end
            end
            finished: begin
                z_in = z_out;
                q = z_in[31:0];
                r = z_in[63:32];
                done_temp = 1'b1;
            end
            default: ;
        endcase
    end

    div_compare div_cpm(
        .zed_in(z_out[63:31]),
        .ded_in(d),
        .compare(divy_cmp)
    );

    always_comb begin : div_nxt_state_logic
        case(state)
            idle_start: begin
                if(start && !done) begin
                    next_state = dividing;
                end
                else begin
                    next_state = idle_start;
                end
            end
            dividing: begin
                if(div_counter == 6'b100000) begin
                    next_state = finished;
                end
                else begin
                    next_state = dividing;
                end
            end
            finished: begin
                if(new_instruction && done_temp) begin
                    next_state = idle_start;
                end 
                else begin
                    next_state = finished;
                end
            end
            default: next_state = idle_start;
        endcase
    end

    always_ff @ (posedge clk, posedge rst) begin
        if(rst) begin
            state <= idle_start;
            div_counter <= 6'b0;
        end
        else begin
            state <= next_state;
            if(new_instruction && done_temp)
                div_counter <= 6'b0;
            else if(start)
                div_counter <= div_counter + 6'b01;
        end
    end

endmodule : divider_slow