module fulladder(input logic in1, in2, cin,
                 output logic sum, cout);
  
  assign sum = in1 ^ in2 ^ cin;  // Sum logic. xor gate with 3 inputs
    assign cout = (in1 & in2) | (cin & (in1 ^ in2)); // Carry-out logic
endmodule

module fulladder_32bit(input logic [31:0] in1, in2,  // 32-bit inputs
                       input logic cin,              // 1-bit carry-in
                       output logic [31:0] sum,      // 32-bit sum result
                       output logic cout);           // 1-bit carry-out

    logic [32:0] carry;  // Carry signals expanded to 33 bits

    // Instantiate first full adder for the least significant bit
    fulladder fa0 (.in1(in1[0]), .in2(in2[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]));

    // Chain the remaining full adders
    genvar i;
    generate
        for (i = 1; i < 32; i++) begin
            fulladder fa (.in1(in1[i]), .in2(in2[i]), .cin(carry[i-1]), .sum(sum[i]), .cout(carry[i]));
        end
    endgenerate

    // binds the carry-out to the output
    assign cout = carry[32];  // Use the 33rd bit for final carry-out
endmodule

module mux2 (
    input logic [31:0] d0, d1,
    input logic s,
    output logic [31:0] y
);
    assign y = s ? d1 : d0;  // 2x1 MUX implementation
endmodule

module mux4 (
    input logic [31:0] d0, d1, d2, d3,
    input logic [1:0] s,
    output logic [31:0] y
);
    assign y = s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0);  // 4x1 MUX implementation
endmodule

module andgate(input logic [31:0] a, b,
               output logic [31:0] y);
    always_comb
        y = a & b;  // AND operation with always statement.
endmodule

module orgate(input logic [31:0] a, b,
               output logic [31:0] y);
    always_comb
        y = a | b;  // OR operation with always statement
endmodule

module ALU(
    input logic [31:0] a, b,
    input logic [2:0] f,
    output logic [31:0] y,
    output logic z
);//my 32-bit ALU implementation is based on CMPE 361 text book page 249
    logic [31:0] adder_sum_result, and_result, or_result, b_inverted, mux2_out;
  
  
  
    logic carry_out, slt_result;

    // Invert input B when F2 is asserted (for subtraction)
    assign b_inverted = f[2] ? ~b : b;

    // 2x1 MUX to detect second input of AND gate,second input of OR gate
    //and second input of 32 bit full adder 
    mux2 mux2_unit (
      .d0(b),                  // first input: b
      .d1(b_inverted),        // second input: inverse of b
      .s(f[0]),               // select signal
      .y(mux2_out)            // output: mux_out
    );

    // 32-bit Full Adder
    fulladder_32bit adder (
        .in1(a), 
        .in2(mux2_out), 
        .cin(f[2]), // F2 serves as carry in for addition/subtraction
        .sum(adder_sum_result), 
        .cout(carry_out)
    );

    // AND Gate
    andgate and_unit (
        .a(a), 
        .b(mux2_out), 
        .y(and_result)
    );

    // OR Gate
    orgate or_unit (
        .a(a), 
        .b(mux2_out), 
        .y(or_result)
    );

    // SLT operation: set if A < B
  assign slt_result = (f[2] ? adder_sum_result[31] : (a < b)); // If subtracting required, check the MSB; otherwise compare A and B directly.

    // 4:1 MUX for operation selection based on F1:0
    mux4 result_mux (
        .d0(and_result),          // AND operation
        .d1(or_result),           // OR operation
        .d2(adder_sum_result),    // ADD or SUB operation
        .d3(slt_result ? 32'b1 : 32'b0), // SLT operation: return 1 or 0
        .s(f[1:0]),               // Select signal (2 bits)
        .y(y)                     // Result
    );

    // Zero flag
    assign z = (y == 32'b0);
endmodule