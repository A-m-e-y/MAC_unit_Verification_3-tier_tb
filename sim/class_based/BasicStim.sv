class BasicStim #( 
    // Parameters
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
) extends Transaction;

    // constraint basic_stim_c {
    //     A_sr == 1;
    //     B_sr == 2;
    //     C_sr == 3;
    // }

    task gen_stim (mailbox #(Transaction) mbx, virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if);
        @(posedge mac_if.clk);
        A_i = $shortrealtobits(1.0);
        B_i = $shortrealtobits(2.0);
        C_i = $shortrealtobits(3.0);
        mbx.put(this.copy);
    endtask

endclass
