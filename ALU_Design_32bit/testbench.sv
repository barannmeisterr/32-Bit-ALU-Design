module tbALU;

    // Declares inputs and outputs for ALU
    logic [31:0] a, b;
    logic [2:0] f;
    logic [31:0] y;
    logic z;

    // Instantiates the ALU module
    ALU uut (
        .a(a),
        .b(b),
        .f(f),
        .y(y),
        .z(z)
    );

    // Task to print the output in the desired format like lab2 document //table1 format
    task print_output(input string test_name, input logic [2:0] f, input logic [31:0] a, b, y, input logic z);
        $display("%s | %0d | %h | %h | %h | %b", test_name, f, a, b, y, z);
    endtask

    initial begin
        // Print header
        $display("Test                | F[2:0] |       a       |       b       |       y       | z");
        $display("----------------------------------------------------------------------------------");

        // ADD Operation Tests (f = 3'b010)
        f = 3'b010;
        a = 32'h00000000; b = 32'h00000000; #10;  // ADD 0 + 0
        print_output("ADD 0+0          ", f, a, b, y, z);

        a = 32'h00000001; b = 32'hFFFFFFFF; #10;  // ADD 1 + (-1)
        print_output("ADD 1+(-1)       ", f, a, b, y, z);

        a = 32'h000000FF; b = 32'h00000001; #10;  // ADD 255 + 1
        print_output("ADD FF+1         ", f, a, b, y, z);

        a = 32'hFFFFFFFF; b = 32'h00000001; #10;  // ADD -1 + 1
        print_output("ADD -1+1         ", f, a, b, y, z);

        // SUB Operation Tests (f = 3'b110)
        f = 3'b110;
        a = 32'h00000000; b = 32'h00000000; #10;  // SUB 0 - 0
        print_output("SUB 0-0          ", f, a, b, y, z);

        a = 32'h00000000; b = 32'hFFFFFFFF; #10;  // SUB 0 - (-1)
        print_output("SUB 0-(-1)       ", f, a, b, y, z);

        a = 32'h00000001; b = 32'h00000001; #10;  // SUB 1 - 1
        print_output("SUB 1-1          ", f, a, b, y, z);

        a = 32'h00000100; b = 32'h00000001; #10;  // SUB 256 - 1
        print_output("SUB 100-1        ", f, a, b, y, z);

        // SLT Operation Tests (f = 3'b111)
        f = 3'b111;
        a = 32'h00000000; b = 32'h00000000; #10;  // SLT 0, 0
        print_output("SLT 0,0          ", f, a, b, y, z);

        a = 32'h00000000; b = 32'h00000001; #10;  // SLT 0, 1
        print_output("SLT 0,1          ", f, a, b, y, z);

        a = 32'h00000000; b = 32'hFFFFFFFF; #10;  // SLT 0, -1
        print_output("SLT 0,-1         ", f, a, b, y, z);

        a = 32'hFFFFFFFF; b = 32'h00000000; #10;  // SLT -1, 0
        print_output("SLT -1,0         ", f, a, b, y, z);

        // AND Operation Tests (f = 3'b000)
        f = 3'b000;
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; #10;  // AND FFFFFFFF, FFFFFFFF
        print_output("AND FFFFFFFF,FFFFFFFF", f, a, b, y, z);

        a = 32'hFFFFFFFF; b = 32'h12345678; #10;  // AND FFFFFFFF, 12345678
        print_output("AND FFFFFFFF,12345678", f, a, b, y, z);

        a = 32'h12345678; b = 32'h87654321; #10;  // AND 12345678, 87654321
        print_output("AND 12345678,87654321", f, a, b, y, z);

        a = 32'h00000000; b = 32'hFFFFFFFF; #10;  // AND 00000000, FFFFFFFF
        print_output("AND 00000000,FFFFFFFF", f, a, b, y, z);

        // OR Operation Tests (f = 3'b001)
        f = 3'b001;
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; #10;  // OR FFFFFFFF, FFFFFFFF
        print_output("OR  FFFFFFFF,FFFFFFFF", f, a, b, y, z);

        a = 32'h12345678; b = 32'h87654321; #10;  // OR 12345678, 87654321
        print_output("OR  12345678,87654321", f, a, b, y, z);

        a = 32'h00000000; b = 32'hFFFFFFFF; #10;  // OR 00000000, FFFFFFFF
        print_output("OR  00000000,FFFFFFFF", f, a, b, y, z);

        a = 32'h00000000; b = 32'h00000000; #10;  // OR 00000000, 00000000
        print_output("OR  00000000,00000000", f, a, b, y, z);

        $finish;  // End simulation
    end

endmodule
