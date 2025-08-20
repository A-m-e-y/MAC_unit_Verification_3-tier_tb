class Driver #( 
    // Parameters
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
);

    mailbox #(Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS)) mbx;
    Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra;
    virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if;

    // Constructor
    function new(virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if,
                 mailbox #(Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS)) mbx,
                 Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) tra);
        this.mbx = mbx;
        this.mac_if = mac_if;
        this.tra = tra;
    endfunction

    task run;
        forever begin
            @(posedge mac_if.clk);
            mbx.get(tra);
            mac_if.A_i <= tra.A_i;
            mac_if.B_i <= tra.B_i;
            mac_if.C_i <= tra.C_i;

            // tra.display("[Drv]");
        end
    endtask

endclass
