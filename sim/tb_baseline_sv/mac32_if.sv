interface mac32_if #( 
    // Parameters
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
);
    // Outputs
    logic [PARM_XLEN - 1 : 0] A_i; // First operand
    logic [PARM_XLEN - 1 : 0] B_i; // Second operand
    logic [PARM_XLEN - 1 : 0] C_i; // Third operand

    // Inputs
    logic clk; // Clock signal
    logic [PARM_XLEN - 1 : 0] Result_o; // Result of A + (B * C)
    
    event result_ready, sim_end; // Event to signal that the result is ready

endinterface //mac32_if
