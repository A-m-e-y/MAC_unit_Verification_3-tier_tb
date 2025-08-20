class RandomStim extends Transaction;

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
