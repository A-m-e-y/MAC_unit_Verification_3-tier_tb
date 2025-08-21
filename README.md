# MAC_unit_Verification_3-tier_tb
This project aims to build a 3-tier testbench architecture (baseline SV, class-based, UVM) with reusable components, functional/code coverage, and assertion-based verification.

## Running the Testbenches with Makefile

This project includes a `Makefile` to simplify the process of compiling and running the testbenches for the different verification tiers. The Makefile provides targets to run the baseline testbench, the class-based testbench, and any future additions. Below are detailed instructions on how to use the Makefile.

### Available Makefile Targets

#### 1. Running the Baseline Testbench
To run the baseline SystemVerilog testbench, use the following command:
```bash
make baseline
```

#### 2. Running the Class based Testbench
To run the class_based SystemVerilog testbench, use the following command:
```bash
make class_based
```

#### 3. Cleaning the Build
To clean the working directory, use the following command:
```bash
make clean
```
This will delete following files -
```
simv simv* csrc ucli.key results/* verdiLog novas* nWaveLog
```
