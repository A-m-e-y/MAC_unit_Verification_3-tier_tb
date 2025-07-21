module PreNormalizer #(
    parameter PARM_EXP  = 8,  // Width of the exponent
    parameter PARM_MANT = 23, // Width of the mantissa
    parameter PARM_BIAS = 127 // Bias for the exponent in IEEE-754 format
) (
    input A_sign_i,                          // Sign bit of operand A
    input B_sign_i,                          // Sign bit of operand B
    input C_sign_i,                          // Sign bit of operand C
    input Sub_Sign_i,                        // Sign of the subtraction result
    input [PARM_EXP - 1 : 0] A_Exp_i,        // Exponent of operand A
    input [PARM_EXP - 1 : 0] B_Exp_i,        // Exponent of operand B
    input [PARM_EXP - 1 : 0] C_Exp_i,        // Exponent of operand C
    input [PARM_MANT : 0] A_Mant_i,          // Mantissa of operand A
    input Sign_flip_i,                       // Indicates if the sign should be flipped
    input Mv_halt_i,                         // Indicates if movement (shifting) should halt
    input [PARM_EXP + 1 : 0] Exp_mv_i,       // Exponent movement value
    input Exp_mv_sign_i,                     // Sign of the exponent movement

    output Sign_aligned_o,                   // Aligned sign output
    output [PARM_EXP + 1: 0] Exp_aligned_o,  // Aligned exponent output
    output reg [74 : 0] A_Mant_aligned_o,    // Aligned mantissa output
    output reg Mant_sticky_sht_out_o         // Sticky bit output for shifted mantissa
);

    // Align the mantissa of operand A based on the exponent movement
    wire [73 : 0] A_Mant_aligned;
    wire [PARM_MANT : 0] Drop_bits; // Bits dropped during the shift
    assign {A_Mant_aligned, Drop_bits} = {A_Mant_i, 74'd0} >> (Mv_halt_i ? 0 : Exp_mv_i);

    // Determine the aligned sign based on the exponent movement sign
    assign Sign_aligned_o = (Exp_mv_sign_i) ? A_sign_i : B_sign_i ^ C_sign_i;

    // Calculate the aligned exponent
    // If the exponent movement is positive, use A's exponent
    // Otherwise, calculate based on B and C's exponents and the point distance
    assign Exp_aligned_o = (Exp_mv_sign_i) ? A_Exp_i : (B_Exp_i + C_Exp_i - PARM_BIAS + 27);

    // Output logic for the aligned mantissa
    always @(*) begin
        if (Exp_mv_sign_i) begin
            // If exponent movement is positive, shift A's mantissa left by 50 bits
            A_Mant_aligned_o = (A_Mant_i << 50);
        end else if (~Mv_halt_i) begin
            // If movement is not halted, align the mantissa with sign extension
            A_Mant_aligned_o = {Sub_Sign_i, {74{Sub_Sign_i}} ^ A_Mant_aligned};
        end else begin
            // If movement is halted, set the aligned mantissa to zero
            A_Mant_aligned_o = 0;
        end
    end

    // Calculate the 2's complement of the mantissa and dropped bits
    wire [PARM_MANT : 0] A_Mant_2compelemnt = (~A_Mant_i) + 1;
    wire [PARM_MANT : 0] Drop_bits_2complement = (~Drop_bits) + 1;

    // Output logic for the sticky bit
    always @(*) begin
        if (Sub_Sign_i & (~Sign_flip_i)) begin
            // If subtraction sign is active and no sign flip, use 2's complement
            Mant_sticky_sht_out_o = (Mv_halt_i) ? (|A_Mant_2compelemnt) : (|Drop_bits_2complement);
        end else begin
            // Otherwise, use the original mantissa and dropped bits
            Mant_sticky_sht_out_o = (Mv_halt_i) ? (|A_Mant_i) : (|Drop_bits);
        end
    end

endmodule
