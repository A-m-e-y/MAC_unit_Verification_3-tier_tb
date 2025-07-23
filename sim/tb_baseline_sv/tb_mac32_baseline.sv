`timescale 1ns/1ps

module tb_mac32_baseline;

    mac32_if #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    ) mac32_if_inst();

    MAC32_top #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    ) DUT (
        .A_i(mac32_if_inst.A_i),
        .B_i(mac32_if_inst.B_i),
        .C_i(mac32_if_inst.C_i),
        .Result_o(mac32_if_inst.Result_o)
    );

    stim_gen stim_gen_inst(
        .mac32_if_inst(mac32_if_inst)
    );

    scoreboard scoreboard_inst(
        .mac32_if_inst(mac32_if_inst)
    );

    initial begin
        $dumpfile("results/tb_mac32_baseline.vcd");
        $dumpvars(0);
        // $fsdbDumpfile("results/tb_mac32_baseline.fsdb"); // Specify the FSDB file name
        // $fsdbDumpvars(0);
    end

    initial begin
        mac32_if_inst.clk = 0;
        forever #5 mac32_if_inst.clk = ~mac32_if_inst.clk; // 10 ns clock period
    end

    // initial $monitor("[tb_top] Time: %0t, A_i: %h, B_i: %h, C_i: %h, Result_o: %h",
    //                   $time, mac32_if_inst.A_i, mac32_if_inst.B_i,
    //                   mac32_if_inst.C_i, mac32_if_inst.Result_o);

endmodule