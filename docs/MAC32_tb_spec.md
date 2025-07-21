# MAC32 Verification Specification

## Project Overview
**Project Title:** Design and Verification of a 32-bit Precision Floating Point MAC Unit using SystemVerilog

**Design Under Test (DUT):** `MAC32_top.v`

**Operation:**
Performs the operation `result = a + (b * c)`, where `a`, `b`, and `c` are IEEE-754 compliant 32-bit floating point inputs.

**Goal:**
Develop 3 levels of testbenches (baseline SV, class-based, and UVM), including coverage metrics and reusable components. The project serves as a learning experience for SystemVerilog and verification methodologies.

---

## DUT Interface Specification

| Signal Name | Direction | Width | Description                            |
|-------------|-----------|--------|----------------------------------------|
| a           | Input     | 32     | Operand A (IEEE 754 float)             |
| b           | Input     | 32     | Operand B (IEEE 754 float)             |
| c           | Input     | 32     | Operand C (IEEE 754 float)             |
| result      | Output    | 32     | Computed Result = a + (b * c)          |

**Note:** DUT is a purely combinational module (no clock involved).

---

## Milestone 1: RTL Freeze + Sanity Check

### Description:
Initial RTL check and functional sanity using hardcoded inputs.

### Test Vector:

| a (dec) | b (dec) | c (dec) | Expected Result (dec) | Expected Hex |
|---------|---------|---------|------------------------|---------------|
| 1.5     | 2.0     | 3.0     | 7.5                    | 0x40F00000    |

### Combinational Behavior:
- Upon any change in `a`, `b`, or `c`, compute `result = a + b * c`
- `result` should be valid in the same simulation delta cycle

---

## Milestone 2: Baseline SV Testbench (Modular, No OOP)

### Goals:
- Develop a structured SV testbench using:
  - `interface` for port abstraction
  - Procedural `stim_gen` module with both random and edge-case inputs
  - A scoreboard that compares DUT output with expected computed value
  - Functional coverage using `covergroups`

### Key Features:
- **Random Stimulus Generator:** Uses `std::randomize()` with constraints
- **Edge Cases:**
  - Zero input
  - Max float / Min float
  - Negative operands
  - NaN, ±Inf, denormals (optional)
- **Scoreboard:**
  - Uses `$bitstoreal` and `$realtobits` for expected result calculation
  - Compares DUT output and reports match/mismatch
- **Coverage:**
  - Coverpoints on `a`, `b`, and `c`
  - Optional cross-coverage between operands

### Functional Coverage Plan:
```systemverilog
covergroup mac_inputs;
  coverpoint a;
  coverpoint b;
  coverpoint c;
  ab_cross: cross a, b;
endgroup
```

### Simulation Artifacts:
- Waveform (`.vcd`) for inspection
- Log with PASS/FAIL for each test
- Coverage reports (code + functional if supported)

---

## Milestone 3 and 4 (Planned)

- **Milestone 3:** Class-based testbench with modular reusable classes (transaction, driver, monitor, scoreboard)
- **Milestone 4:** UVM-based TB with complete UVM components and sequence library

(Spec updates for these will be appended after completion of Milestone 2.)

---

## Appendix: Float Hex Table (Sample)

| Decimal Value | IEEE-754 Hex  |
|---------------|----------------|
| 0.0           | 0x00000000     |
| 1.0           | 0x3F800000     |
| 2.0           | 0x40000000     |
| 3.0           | 0x40400000     |
| 1.5           | 0x3FC00000     |
| 7.5           | 0x40F00000     |
| -1.5          | 0xBFC00000     |
| Max Float     | 0x7F7FFFFF     |
| Min Float     | 0xFF7FFFFF     |
| NaN           | 0x7FC00000     |

---

## Author:
Amey Kulkarni  
Date: 07/21/2025

---
