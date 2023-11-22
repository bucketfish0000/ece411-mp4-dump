module half_adder(
    input logic a,
    input logic b,
    output logic s,
    output logic c
);

always_comb begin : halfy_add
    s = a^b;
    c = a&b;
end

endmodule : half_adder