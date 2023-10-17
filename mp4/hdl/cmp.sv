import rv32i_types::*;

module cmp(
    input branch_funct3_t cmpop,
    input rv32i_word comp1,
    input rv32i_word comp2,
    output logic br_en
);

always_comb begin
    unique case(cmpop)
        beq: br_en = (comp1==comp2);
        bne: br_en = (comp1!=comp2);
        blt: br_en = ($signed(comp1) < $signed(comp2));
        bge: br_en = ($signed(comp1) >= $signed(comp2));
        bltu: br_en = (comp1 < comp2);
        bgeu: br_en = (comp1 >= comp2);
        default:br_en = 1'b0;
    endcase
end
endmodule : cmp