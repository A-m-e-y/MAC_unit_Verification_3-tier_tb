module stim_gen #(
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
    ) (
    mac32_if mac32_if_inst
    );
    
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

    task random_inputs();
        output logic [PARM_XLEN - 1 : 0] A_i; // First operand
        output logic [PARM_XLEN - 1 : 0] B_i; // Second operand
        output logic [PARM_XLEN - 1 : 0] C_i; // Third operand
        begin
            shortreal A, B, C;
            // Generate random inputs for A, B, C
            A = $urandom_range(0.0001, 99.9999); // Random value for A
            B = $urandom_range(0.0001, 99.9999); // Random value for B
            C = $urandom_range(0.0001, 99.9999); // Random value for C

            // Convert to 32-bit floating-point representation
            A_i = $shortrealtobits(A);
            B_i = $shortrealtobits(B);
            C_i = $shortrealtobits(C);
        end
    endtask

    initial begin
        @(posedge mac32_if_inst.clk);
        // Generate basic inputs
        basic_inputs(mac32_if_inst.A_i, mac32_if_inst.B_i, mac32_if_inst.C_i);
        @(posedge mac32_if_inst.clk);
        -> mac32_if_inst.result_ready; // Signal that inputs are ready
        
        for (int i = 0; i < 10; i++) begin
            @(posedge mac32_if_inst.clk);
            random_inputs(mac32_if_inst.A_i, mac32_if_inst.B_i, mac32_if_inst.C_i);
            @(posedge mac32_if_inst.clk);
            -> mac32_if_inst.result_ready; // Signal that inputs are ready
        end
        // @(posedge mac32_if_inst.clk);
        // random_inputs(mac32_if_inst.A_i, mac32_if_inst.B_i, mac32_if_inst.C_i);
        // @(posedge mac32_if_inst.clk);
        // -> mac32_if_inst.result_ready; // Signal that inputs are ready

        // @(posedge mac32_if_inst.clk);
        // random_inputs(mac32_if_inst.A_i, mac32_if_inst.B_i, mac32_if_inst.C_i);
        // @(posedge mac32_if_inst.clk);
        // -> mac32_if_inst.result_ready; // Signal that inputs are ready
        
        // @(posedge mac32_if_inst.clk);
        // random_inputs(mac32_if_inst.A_i, mac32_if_inst.B_i, mac32_if_inst.C_i);
        // @(posedge mac32_if_inst.clk);
        // -> mac32_if_inst.result_ready; // Signal that inputs are ready

        // $display("[stim_gen] Time: %0t, A_i: %h, B_i: %h, C_i: %h, Result_o: %h",
        //               $time, mac32_if_inst.A_i, mac32_if_inst.B_i,
        //               mac32_if_inst.C_i, mac32_if_inst.Result_o);
        #1000;
        -> mac32_if_inst.sim_end; // Signal end of simulation
        $finish; // End simulation
    end

endmodule