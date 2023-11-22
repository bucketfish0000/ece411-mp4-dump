module cmp
import rv32i_types::*;
(
    input branch_funct3_t cmpop,
    input [31:0] a,b,
    output logic br_en
);

int a_signed, b_signed;

assign a_signed = a;
assign b_signed = b;

always_comb
begin
    case(cmpop)
        3'b000: begin //beq
            if(a == b)
                br_en = 1'b1;
            else
                br_en = 1'b0;
        end
        3'b001: begin //bne
            if(a != b)
                br_en = 1'b1;
            else
                br_en = 1'b0;
        end
        3'b100: begin //blt
            if(a_signed < b_signed)
                br_en = 1'b1;
            else
                br_en = 1'b0;
        end
        3'b101: begin //bge
            if(a_signed >= b_signed)
                br_en = 1'b1;
            else
                br_en = 1'b0;
        end
        3'b110: begin //bltu
            if(a < b)
                br_en = 1'b1;
            else
                br_en = 1'b0;
        end
        3'b111: begin //bgeu
            if(a >= b)
                br_en = 1'b1;
            else
                br_en = 1'b0;
        end
        default:
            br_en = 1'b0;

    endcase
end

endmodule : cmp