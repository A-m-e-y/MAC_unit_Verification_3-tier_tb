`timescale 1ns/1ps

module tb_mac32_sanity;
    localparam PARM_XLEN     = 32;
    localparam PARM_EXP      = 8;
    localparam PARM_MANT     = 23;
    localparam PARM_BIAS     = 127;

    logic [PARM_XLEN - 1 : 0] A_i;
    logic [PARM_XLEN - 1 : 0] B_i;
    logic [PARM_XLEN - 1 : 0] C_i;
    
    logic [PARM_XLEN - 1 : 0] Result_o; // result_o = A + (B * C)

    MAC32_top #(
        .PARM_XLEN(PARM_XLEN),
        .PARM_EXP(PARM_EXP),
        .PARM_MANT(PARM_MANT),
        .PARM_BIAS(PARM_BIAS)
    ) DUT (
        .A_i(A_i),
        .B_i(B_i),
        .C_i(C_i),
        .Result_o(Result_o)
    );

    initial begin
        $dumpfile("results/tb_mac32_sanity.vcd");
        $dumpvars(0, tb_mac32_sanity);
    end

    initial begin
        // Test 1: 1.5 + 2.0 * 3.0 = 7.5
        A_i = 32'h3FC00000; // 1.5
        B_i = 32'h40000000; // 2.0
        C_i = 32'h40400000; // 3.0

        // Wait for a short time to allow DUT to process
        #1;

        // Check result
        if (Result_o !== 32'h40F00000) begin // Expected: 7.5
            $display();
            $display("Test failed: Expected Result_o = 7.5, got %h", Result_o);
            $display();
        end else begin
            $display();
            $display("Test passed: Result_o = %h", Result_o);
            $display();
        end

        $finish;
    end

endmodule