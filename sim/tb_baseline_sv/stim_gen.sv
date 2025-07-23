module stim_gen #(
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
    ) (
    mac32_if mac32_if_inst
    );
            
    bit [31:0] edge_test_patterns[] = {
        32'h00000000, // +0
        32'h80000000, // -0
        32'h007fffff, // Largest subnormal
        32'h00800000, // Smallest normal
        // 32'h7f7fffff, // Max float
        // 32'hff7fffff, // -Max float
        32'h7f800000, // +Inf
        32'hff800000, // -Inf
        32'h7fc00000, // Quiet NaN
        32'h7fa00000, // Signaling NaN
        32'h3f800000, // +1
        32'hbf800000, // -1
        32'h40000000, // +2
        32'hc0000000, // -2
        32'h40490fdb, // +π
        32'hc0490fdb,  // -π
        32'h34000000  // +Epsilon (2^-23)
    };

    task basic_inputs();
        output logic [PARM_XLEN - 1 : 0] A_i; // First operand
        output logic [PARM_XLEN - 1 : 0] B_i; // Second operand
        output logic [PARM_XLEN - 1 : 0] C_i; // Third operand
        begin
            // Test 1: 1.5 + 2.0 * 3.0 = 7.5
            A_i = 32'h3FC00000; // 1.5
            B_i = 32'h40000000; // 2.0
            C_i = 32'h40400000; // 3.0
        end
    endtask

    function logic [31:0] gen_rand_float(real min_val, real max_val);
        shortreal rand_real;
        int unsigned rand_int;

        begin
            rand_int = $urandom(); // 32-bit unsigned random
            rand_real = min_val + (max_val - min_val) * (rand_int / 4294967295.0);
            return $shortrealtobits(rand_real); // IEEE-754 binary representation
        end
    endfunction


    task random_inputs();
        output logic [PARM_XLEN - 1 : 0] A_i; // First operand
        output logic [PARM_XLEN - 1 : 0] B_i; // Second operand
        output logic [PARM_XLEN - 1 : 0] C_i; // Third operand
        begin
            A_i = gen_rand_float(-100.0, 100.0); // Random float between -100.0 and 100.0
            B_i = gen_rand_float(-100.0, 100.0); // Random float between -100.0 and 100.0
            C_i = gen_rand_float(-100.0, 100.0); // Random float between -100.0 and 100.0

        end
    endtask

    task edge_inputs();
        output logic [PARM_XLEN - 1 : 0] A_i; // First operand
        output logic [PARM_XLEN - 1 : 0] B_i; // Second operand
        output logic [PARM_XLEN - 1 : 0] C_i; // Third operand
        begin
        end
    endtask

    initial begin
        @(posedge mac32_if_inst.clk);
        // Generate basic inputs
        basic_inputs(mac32_if_inst.A_i, mac32_if_inst.B_i, mac32_if_inst.C_i);
        @(posedge mac32_if_inst.clk);
        -> mac32_if_inst.result_ready; // Signal that inputs are ready
        
        for (int i = 0; i < 20; i++) begin
            @(posedge mac32_if_inst.clk);
            random_inputs(mac32_if_inst.A_i, mac32_if_inst.B_i, mac32_if_inst.C_i);
            @(posedge mac32_if_inst.clk);
            -> mac32_if_inst.result_ready; // Signal that inputs are ready
        end

        // @(posedge mac32_if_inst.clk);
        // edge_inputs(mac32_if_inst.A_i, mac32_if_inst.B_i, mac32_if_inst.C_i);
        // @(posedge mac32_if_inst.clk);
        // @(posedge mac32_if_inst.clk);
        // @(posedge mac32_if_inst.clk);
        // @(posedge mac32_if_inst.clk);

        foreach (edge_test_patterns[i]) begin
            foreach (edge_test_patterns[j]) begin
                foreach (edge_test_patterns[k]) begin
                    @(posedge mac32_if_inst.clk);
                    mac32_if_inst.A_i = edge_test_patterns[i];
                    mac32_if_inst.B_i = edge_test_patterns[j];
                    mac32_if_inst.C_i = edge_test_patterns[k];
                    @(posedge mac32_if_inst.clk);
                    -> mac32_if_inst.result_ready; // Signal that inputs are ready
                end
            end
        end

        @(posedge mac32_if_inst.clk);
        // Generate basic inputs
        basic_inputs(mac32_if_inst.A_i, mac32_if_inst.B_i, mac32_if_inst.C_i);
        @(posedge mac32_if_inst.clk);

        // #1000;
        -> mac32_if_inst.sim_end; // Signal end of simulation
        // @(posedge mac32_if_inst.clk);
        // $finish;
    end

    // initial $monitor("[stim_gen] Time: %0t, A_i: %h (%f), B_i: %h (%f), C_i: %h (%f)",
    //                 $time, mac32_if_inst.A_i, $bitstoshortreal(mac32_if_inst.A_i), mac32_if_inst.B_i, $bitstoshortreal(mac32_if_inst.B_i), mac32_if_inst.C_i, $bitstoshortreal(mac32_if_inst.C_i));

endmodule