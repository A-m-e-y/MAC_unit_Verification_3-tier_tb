
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
        $display("%s %0t: A_i = %h, B_i = %h, C_i = %h, Result_o = %h", 
                 str, $time, A_i, B_i, C_i, Result_o);
    endfunction

    function apply ();
        A_i = $shortrealtobits(A_sr / 4294967295.0);
        B_i = $shortrealtobits(B_sr / 4294967295.0);
        C_i = $shortrealtobits(C_sr / 4294967295.0);
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
