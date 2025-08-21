class RandomStim #( 
    // Parameters
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
) extends Transaction;

    // Random constraints for A_i, B_i, C_i
    constraint random_stim_c {
        A_sr >= -1000;
        B_sr >= -1000;
        C_sr >= -1000;
        A_sr <= 1000;
        B_sr <= 1000;
        C_sr <= 1000;
    }

endclass
