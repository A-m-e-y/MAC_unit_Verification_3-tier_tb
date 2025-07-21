module Normalizer#(
    parameter PARM_EXP              = 8,  // Width of the exponent
    parameter PARM_MANT             = 23, // Width of the mantissa
    parameter PARM_LEADONE_WIDTH    = 7   // Width of the leading-one detector output
) (
    input [3*PARM_MANT + 4 : 0] Mant_i,          // Input mantissa (extended for normalization)
    input [PARM_EXP + 1 : 0] Exp_i,             // Input exponent (extended for overflow detection)
    input [PARM_LEADONE_WIDTH - 1 : 0] Shift_num_i, // Number of shifts required for normalization
    input Exp_mv_sign_i,                        // Sign of the exponent movement (used for special cases)

    output [3*PARM_MANT + 4 : 0] Mant_norm_o,   // Normalized mantissa output
    output reg [PARM_EXP + 1 : 0] Exp_norm_o,   // Normalized exponent output
    output [PARM_EXP + 1 : 0] Exp_norm_mone_o, // Exponent minus one (used for specific calculations)
    output [PARM_EXP + 1 : 0] Exp_max_rs_o,    // Maximum exponent for right shift
    output [3*PARM_MANT + 6 : 0] Rs_Mant_o     // Mantissa after right shift for denormalized numbers
);

    // Determine the effective shift amount based on the input conditions
    // If the exponent is negative or the mantissa already has a leading one, no shift is needed
    wire [PARM_LEADONE_WIDTH - 1 : 0] Shift_num = 
        (Exp_mv_sign_i | Mant_i[3*PARM_MANT + 4]) ? 0 : Shift_num_i;

    // Calculate the normalization amount based on the exponent and shift number
    reg [PARM_EXP : 0] norm_amt;
    always @(*) begin
        if (Exp_i[PARM_EXP + 1]) 
            norm_amt = 0; // Exponent overflow, no normalization
        else if (Exp_i > Shift_num) 
            norm_amt = Shift_num; // Ensure exponent does not go below zero
        else 
            norm_amt = Exp_i[PARM_EXP : 0] - 1; // Denormalized numbers, exponent becomes zero
    end

    // Perform left shift on the mantissa for normalization
    assign Mant_norm_o = Mant_i << norm_amt;

    // Calculate the normalized exponent
    always @(*) begin
        if (Exp_i[PARM_EXP + 1]) 
            Exp_norm_o = 0; // Exponent overflow, set to zero
        else if (Exp_i > Shift_num) 
            Exp_norm_o = Exp_i - Shift_num; // Subtract shift amount from exponent
        else 
            Exp_norm_o = 1; // Denormalized numbers, exponent becomes zero
    end

    // Calculate the exponent minus one for specific use cases
    assign Exp_norm_mone_o = Exp_i - Shift_num - 1;

    // Calculate the maximum exponent for right shift
    assign Exp_max_rs_o = Exp_i[PARM_EXP : 0] + 74;

    // Calculate the number of right shifts required for denormalized numbers
    wire [PARM_EXP + 1 : 0] Rs_count = (~Exp_i + 1) + 1; // Compute -Exp_i + 1

    // Perform right shift on the mantissa for denormalized numbers
    assign Rs_Mant_o = {Mant_i, 2'd0} >> Rs_count;

endmodule
