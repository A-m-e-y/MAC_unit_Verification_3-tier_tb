module scoreboard #(
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
    ) (
    mac32_if mac32_if_inst
    ); 
    
    logic [PARM_XLEN - 1 : 0] expected_result;

    // Task to generate the expected result
    task get_expected_result(
        input logic [PARM_XLEN - 1 : 0] A_i,
        input logic [PARM_XLEN - 1 : 0] B_i,
        input logic [PARM_XLEN - 1 : 0] C_i, 
        output logic [PARM_XLEN - 1 : 0] expected_result
        );
    begin    
        shortreal A, B, C;
        shortreal result;

        A = $bitstoshortreal(mac32_if_inst.A_i);
        B = $bitstoshortreal(mac32_if_inst.B_i);
        C = $bitstoshortreal(mac32_if_inst.C_i);

        result = A + (B * C);
        expected_result = $shortrealtobits(result);
    end
    endtask

    // Task to check the result against the expected value
    task check_result (
        input logic [PARM_XLEN - 1 : 0] A_i,
        input logic [PARM_XLEN - 1 : 0] B_i,
        input logic [PARM_XLEN - 1 : 0] C_i,
        input logic [PARM_XLEN - 1 : 0] Result_o
        );
        logic [PARM_XLEN - 1 : 0] expected_result;
        begin
            get_expected_result(A_i, B_i, C_i, expected_result);
            if (Result_o !== expected_result) begin
                $display("Scoreboard: Test failed! Expected %h, got %h", expected_result, Result_o);
            end else begin
                $display("Scoreboard: Test passed! Result = %h", Result_o);
            end
        end
    endtask

    always @(posedge mac32_if_inst.clk) begin
        wait(mac32_if_inst.result_ready.triggered);
        $display("[scoreboard] Time: %0t, A_i: %h, B_i: %h, C_i: %h, Result_o: %h",
                      $time, mac32_if_inst.A_i, mac32_if_inst.B_i,
                      mac32_if_inst.C_i, mac32_if_inst.Result_o);

        check_result(mac32_if_inst.A_i, 
                     mac32_if_inst.B_i, 
                     mac32_if_inst.C_i, 
                     mac32_if_inst.Result_o);
    end
endmodule
