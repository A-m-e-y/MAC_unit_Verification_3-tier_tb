class Scoreboard  #( 
    // Parameters
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
);

    // Inputs
    mailbox #(Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS)) mbx;
    Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra;
    virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if;

    // Counters
    int pass_cnt, fail_cnt, total_cnt;
    shortreal tolerance = 0.001; // Tolerance for floating-point comparison

    // Constructor
    function new(virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if,
                 mailbox #(Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS)) mbx,
                 Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra);
        this.mbx = mbx;
        this.mac_if = mac_if;
        this.tra = tra;
    endfunction

    // Task to generate the expected result
    function shortreal get_expected_result(Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra);
    begin    
        shortreal A, B, C;
        shortreal result;

        A = $bitstoshortreal(tra.A_i);
        B = $bitstoshortreal(tra.B_i);
        C = $bitstoshortreal(tra.C_i);

        result = A + (B * C);
        return result;
    end
    endfunction

    // Task to check the result against the expected value
    task check_result (Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra);
        shortreal expected_result, dut_result;
        begin
            dut_result = $bitstoshortreal(tra.Result_o);
            expected_result = get_expected_result(tra);
            total_cnt++;
            if ($abs(dut_result - expected_result) >= tolerance) begin
                fail_cnt++;
                $display("Scoreboard: Test failed! Expected %h (%f), got %h (%h)", $shortrealtobits(expected_result), expected_result, tra.Result_o, $bitstoshortreal(tra.Result_o));
                $display("[Debug Details - time: %0t] A_i: %h (%f), B_i: %h (%f), C_i: %h (%f)", $time, tra.A_i, $bitstoshortreal(tra.A_i), tra.B_i, $bitstoshortreal(tra.B_i), tra.C_i, $bitstoshortreal(tra.C_i));
                $display("[Debug Details] A_i + B_i * C_i = %h (%f)", $shortrealtobits(expected_result), expected_result);
            end else begin
                pass_cnt++;
                // $display("Scoreboard: Test passed! Result = %h (%f)", Result_o, $bitstoshortreal(Result_o));
            end
        end
    endtask


    task run;
        forever begin
            @(posedge mac_if.clk);
            mbx.get(tra);
            tra.display("[Scb]");
            check_result(tra);
            if (mac_if.gen_done.triggered) begin
                $display();
                $display();
                $display("###### Simulation Summary ######");
                $display();
                $display("[time: %0t] Scoreboard Summary: Total tests = %0d, Passed = %0d, Failed = %0d",
                $stime, total_cnt, pass_cnt, fail_cnt);
                $display();
                -> mac_if.sim_end;
            end
        end
    endtask

endclass
