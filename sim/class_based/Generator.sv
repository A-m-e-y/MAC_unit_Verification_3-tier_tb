class Generator #( 
    // Parameters
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
);

    mailbox #(Transaction) mbx;
    Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra;
    BasicStim #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) basic_stim;
    RandomStim #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) random_stim;
    EdgeStim #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) edge_stim;
    virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if;

    // Constructor
    function new(virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if, 
                 mailbox #(Transaction) mbx, 
                 Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra);
        this.mbx = mbx;
        this.mac_if = mac_if;
        this.tra = tra;
    endfunction

    task gen_vals(Transaction in_tra);
        @(posedge mac_if.clk);
        // Generate random values for A_i, B_i, C_i
        tra = in_tra;
        assert (tra.randomize())
        else 
            $fatal("Randomization failed");
        // Apply the random values to the transaction
        tra.apply();
        // Send the transaction to the mailbox
        mbx.put(tra.copy);
        // tra.display("[Gen]");
    endtask

    task run;
        random_stim = new();
        basic_stim = new();
        edge_stim = new();

        // Generate basic stimulus
        basic_stim.gen_stim(mbx, mac_if);

        // Generate random stimulus
        repeat(200) begin
            gen_vals(random_stim);
        end
        // Generate edge cases
        edge_stim.gen_stim(mbx, mac_if);

        // Signal the end of generation
        -> mac_if.gen_done;
    endtask

endclass
