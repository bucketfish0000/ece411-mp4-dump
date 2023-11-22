module full_adder(
    input logic a,
    input logic b,
    input logic cin,
    output logic s,
    output logic cout
);

always_comb begin : full_add
    s = (a^b)^cin;
    cout = (a&b)+(cin&(a^b));
end

endmodule : full_adder