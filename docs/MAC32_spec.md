# MAC32_top - Floating Point Multiply-Accumulate Unit

## Purpose
Performs: `Result_o = A_i + (B_i * C_i)`  
All operands are 32-bit IEEE 754 floating point numbers.

## Parameters
- `PARM_XLEN = 32` - Data width (32-bit IEEE 754)
- `PARM_EXP = 8` - Exponent width
- `PARM_MANT = 23` - Mantissa width
- `PARM_BIAS = 127` - Exponent bias
- `PARM_LEADONE_WIDTH = 7` - Leading one detector width
- `PARM_EXP_ONE = 8'h01` - Exponent value for denormalized numbers

## Ports

| Name     | Direction | Width | Description                          |
|----------|-----------|-------|--------------------------------------|
| A_i      | Input     | 32    | Operand A (32-bit IEEE-754 HEX value)|
| B_i      | Input     | 32    | Operand B (32-bit IEEE-754 HEX value)|
| C_i      | Input     | 32    | Operand C (32-bit IEEE-754 HEX value)|
| Result_o | Output    | 32    | MAC result = A_i + (B_i * C_i)       |

## Operation
- **Combinational Logic**: The MAC unit is purely combinational (no clock or reset)
- **Operation**: Computes `Result_o = A_i + (B_i * C_i)` using IEEE 754 floating-point arithmetic
- **Latency**: Combinational - result available in same cycle

## Architecture Overview
The MAC unit consists of several key components:

1. **Special Case Detector**: Detects infinity, zero, NaN, and denormalized numbers
2. **R4 Booth Multiplier**: Performs B_i × C_i multiplication using Radix-4 Booth encoding
3. **Wallace Tree**: Reduces partial products from multiplication
4. **Pre-Normalizer**: Aligns mantissas for addition
5. **Carry Save Adder**: Performs three-operand addition
6. **EAC Adder**: End-around-carry adder for final addition
7. **MSB Incrementer**: Handles carry propagation to high-order bits
8. **Leading One Detector**: Finds position of leading one for normalization
9. **Normalizer**: Normalizes the result mantissa
10. **Rounder**: Handles rounding and special cases

## Special Cases Handled
- **Infinity**: Proper handling of infinite operands
- **Zero**: Detection and handling of zero operands
- **NaN**: Not-a-Number detection and propagation
- **Denormalized Numbers**: Proper handling of subnormal numbers
- **Overflow/Underflow**: Exponent range checking and saturation

## Key Features
- Full IEEE 754 compliance for 32-bit floating-point
- Handles all special cases (±∞, ±0, NaN, denormals)
- Sign handling for all operand combinations
- Proper rounding according to IEEE 754 standards
- Optimized using Wallace tree and Booth encoding for performance

## Implementation Details
- Uses Radix-4 Booth encoding for efficient multiplication
- Wallace tree reduces 13 partial products to 2 terms
- Dual-path architecture for addition (normal and inverted)
- Leading one detection for normalization
- Comprehensive special case handling

## Verification Considerations
- Test all IEEE 754 special values (±0, ±∞, NaN, denormals)
- Verify correct rounding behavior
- Test boundary conditions and edge cases
- Validate against IEEE 754 standard compliance
- Check sign handling for all combinations
- Test overflow and underflow scenarios
- Verify mantissa alignment and normalization
