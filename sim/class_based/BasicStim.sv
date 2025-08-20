class BasicStim extends Transaction;

    constraint basic_stim_c {
        A_sr == 1;
        B_sr == 2;
        C_sr == 3;
    }
endclass
