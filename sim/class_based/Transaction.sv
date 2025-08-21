
class Transaction #( 
    // Parameters
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
);

    // Outputs
    bit [PARM_XLEN - 1 : 0] A_i; // First operand
    bit [PARM_XLEN - 1 : 0] B_i; // Second operand
    bit [PARM_XLEN - 1 : 0] C_i; // Third operand

    randc int A_sr; // First operand as int
    randc int B_sr; // Second operand as int
    randc int C_sr; // Third operand as int
    

    // Inputs
    bit clk; // Clock signal
    bit [PARM_XLEN - 1 : 0] Result_o; // Result of A + (B * C)

    function display (string str);
        $display("%s %0t: A_i = %h (%0f), B_i = %h (%0f), C_i = %h (%0f), Result_o = %h (%0f)", 
                 str, $time, A_i, $bitstoshortreal(A_i), B_i, $bitstoshortreal(B_i), C_i, $bitstoshortreal(C_i), Result_o, $bitstoshortreal(Result_o));
    endfunction

    task dump_display (string str);
        integer file_handle = $fopen("./results/class_outputs.txt", "a");
        $fdisplay(file_handle, "%s %0t: A_i = %h (%0f), B_i = %h (%0f), C_i = %h (%0f), Result_o = %h (%0f)", 
                 str, $time, A_i, $bitstoshortreal(A_i), B_i, $bitstoshortreal(B_i), C_i, $bitstoshortreal(C_i), Result_o, $bitstoshortreal(Result_o));
        $fclose(file_handle);
    endtask

    function apply ();
        A_i = $shortrealtobits(A_sr / 0.42949672950);
        B_i = $shortrealtobits(B_sr / 0.42949672950);
        C_i = $shortrealtobits(C_sr / 0.42949672950);
    endfunction

    function Transaction #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) copy ();
        copy = new();
        copy.A_i = this.A_i;
        copy.B_i = this.B_i;
        copy.C_i = this.C_i;
        copy.Result_o = this.Result_o;
        copy.clk = this.clk;
    endfunction

endclass
