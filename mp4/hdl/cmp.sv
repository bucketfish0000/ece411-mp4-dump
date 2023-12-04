module cmp
import rv32i_types::*;
(
    input branch_funct3_t cmpop,
    input rv32i_word comp1,
    input rv32i_word comp2,
    output logic br_en
);

always_comb begin
    rv32i_word diff=comp1-comp2;
    unique case(cmpop)
        beq: br_en = (diff==32'b0);
        bne: br_en = (diff!=32'b0);
        blt: br_en = (diff[31]==1'b1);
        bge: br_en = (diff[31]==1'b0);
        bltu: br_en = (comp1 < comp2);
        bgeu: br_en = (comp1 >= comp2);
        default:br_en = 1'b0;
    endcase
end
endmodule : cmp