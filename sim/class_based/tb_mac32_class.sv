module tb;

    
    mac32_if #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    ) mac_if();

    MAC32_top #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    ) DUT (
        .A_i(mac_if.A_i),
        .B_i(mac_if.B_i),
        .C_i(mac_if.C_i),
        .Result_o(mac_if.Result_o)
    );

    Transaction #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    ) tra = new();

    mailbox #(Transaction #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    )) mbx = new();

    Generator #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    ) gen = new (mac_if, mbx, tra);

    Driver #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    ) drv = new (mac_if, mbx, tra);

    Monitor #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    ) mon = new (mac_if, mbx, tra);

    Scoreboard #(
        .PARM_XLEN(32),
        .PARM_EXP(8),
        .PARM_MANT(23),
        .PARM_BIAS(127)
    ) scb = new (mac_if, mbx, tra);

    initial begin
        $dumpfile("results/tb_mac32_class.vcd");
        $dumpvars(0);
        // $fsdbDumpfile("results/tb_mac32_baseline.fsdb"); // Specify the FSDB file name
        // $fsdbDumpvars(0);
    end

    initial begin
        mac_if.clk = 0;
        forever #5 mac_if.clk = ~mac_if.clk; // 10 ns clock period
    end

    initial begin
        // Start the generator and driver tasks
        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_any
        // Wait for the done event from the generator
        wait(mac_if.sim_end.triggered);
        @(posedge mac_if.clk);
        $display("###### End of Simulation ######");
        $display();
        $display();
        $finish;
    end 

endmodule
