module cacheline_adaptor
    import rv32i_types::*;
    import rv32i_cache_types::*; 
    //import cpuIO::*;
(
    input clk,
    input reset_n,

    // Port to LLC (Lowest Level Cache)
    input rv32i_cache_types::rv32i_cacheline line_i,
    output rv32i_cache_types::rv32i_cacheline line_o,
    input rv32i_word address_i,
    input read_i,
    input write_i,
    output logic resp_o,

    // Port to memory
    input logic [63:0] burst_i,
    output logic [63:0] burst_o,
    output rv32i_word address_o,
    output logic read_o,
    output logic write_o,
    input resp_i
);

logic [1:0] fn_state;
logic [2:0] routine_state;

always_ff @(posedge clk) 
begin

    //reset has highest priority
    if (~reset_n) 
    begin
        fn_state <= 2'b00;
        //routine_state <= 3'b000;
    end

    case(fn_state)
        2'b00: //INIT 
        begin
            //keep everything clean
            routine_state <= 3'b000;
            read_o <= 1'b0;
            write_o <= 1'b0;
            resp_o <= 1'b0;

            //funtion switch
            if (read_i == 1'b1)
            begin
                //raise read
                read_o <= 1'b1;
                //save the address, which should not change during read even it input address changes.
                address_o <= address_i;
                //switch to READ
                fn_state <= 2'b01;
            end 
            else if (write_i == 1'b1) 
            begin
                address_o <= address_i;
                //to WRITE
                fn_state <= 2'b10;
            end
        end
        2'b01: //READ
        begin
            //read_o <= 1'b1;
            address_o <= address_o; 

            case(routine_state) //is (routine_state<= 3'b011) valid here????
                3'b000:
                begin
                    read_o <= 1'b1;
                    //simply read from burst_i if memory responds
                    if (resp_i)
                    begin
                        line_o[63:0] <= burst_i;
                        routine_state <= 3'b001;
                    end
                    else routine_state <= routine_state;
                    //else do nothing, remain in READ
                end
                3'b001:
                begin
                    read_o <= 1'b1;
                    //simply read from burst_i if memory responds
                    if (resp_i)
                    begin
                        line_o[127:64] <= burst_i;
                        routine_state <= 3'b010;
                    end
                    else routine_state <= routine_state;
                    //else do nothing, remain in READ
                end
                3'b010:
                begin
                    read_o <= 1'b1;
                    //simply read from burst_i if memory responds
                    if (resp_i)
                    begin
                        line_o[191:128] <= burst_i;
                        routine_state <= 3'b011;
                    end
                    else routine_state <= routine_state;
                    //else do nothing, remain in READ
                end
                3'b011:
                begin
                    read_o <= 1'b1;
                    //simply read from burst_i if memory responds
                    if (resp_i)
                    begin
                        line_o[255:192] <= burst_i;
                        resp_o <= 1'b1; //raise return, which will be done in the next clk cycle
                        routine_state <= 3'b100;
                    end
                    else routine_state <= routine_state;
                    //else do nothing, remain in READ
                end
                3'b100: //read is complete
                begin
                    //return is done
                    resp_o <= 1'b0; //resp_o can only be raised for 1 clk
                    //back to INIT state, clean up everything
                    read_o <= 1'b0;
                   routine_state <= 3'b000;
                   fn_state <= 2'b00;
                end
            endcase
        end
        2'b10: //WRITE
        begin
            address_o <= address_i;
            
            case (routine_state)
            3'b000:
            begin
                burst_o <= line_i[63:0];
                write_o <= 1'b1;
                routine_state <= 3'b001;
            end
            3'b001: 
            begin
                if (resp_i == 1'b1) 
                begin
                    burst_o <= line_i[127:64];
                    write_o <= 1'b1;
                    routine_state <= 3'b010; //wait for memory respond
                end
            end
            3'b010: //127:64 being written
            begin
                if (resp_i == 1'b1)    
                begin
                    burst_o <= line_i[191:128];
                    write_o <= 1'b1;
                    routine_state <= 3'b011; //wait for memory respond
                end
            end
            3'b011:
            begin
                if (resp_i == 1'b1) 
                begin   
                    burst_o <= line_i[255:192];
                    write_o <= 1'b1;
                    routine_state <= 3'b100; //wait for memory respond
                end
            end
            3'b100:
            begin
                if (resp_i == 1'b1)
                begin
                    write_o <= 1'b0;
                    resp_o <= 1'b1; //raise respond
                    routine_state<=3'b101;  
                end      
            end
            3'b101:
            begin
                resp_o <= 1'b0;
                burst_o <= 64'b0; 
                write_o <= 1'b0;
                routine_state <= 3'b000;
                fn_state <= 2'b00;
            end
            endcase
        end
    endcase 
end

endmodule : cacheline_adaptor