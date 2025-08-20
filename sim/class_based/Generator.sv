class Generator #( 
    // Parameters
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
);

    mailbox #(Transaction) mbx;
    Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra;
    virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if;

    // Constructor
    function new(virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if, 
                 mailbox #(Transaction) mbx, 
                 Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra);
        this.mbx = mbx;
        this.mac_if = mac_if;
        this.tra = tra;
    endfunction

    task run;
        repeat(10) begin
            @(posedge mac_if.clk);
            // Generate random values for A_i, B_i, C_i
            assert (tra.randomize())
            else 
                $fatal("Randomization failed");

            // Send the transaction to the mailbox
            mbx.put(tra.copy);
            // tra.display("[Gen]");
        end
        -> mac_if.gen_done;
    endtask

endclass
