class EdgeStim #( 
    // Parameters
    parameter PARM_XLEN = 32,
    parameter PARM_EXP  = 8,
    parameter PARM_MANT = 23,
    parameter PARM_BIAS = 127
) extends Transaction;

static const bit [31:0] edge_test_patterns[] = '{
      32'h00000000, // +0
      32'h80000000, // -0
      32'h007fffff, // Largest subnormal
      32'h00800000, // Smallest normal
      32'h7f800000, // +Inf
      32'hff800000, // -Inf
      32'h7fc00000, // Quiet NaN
      32'h7fa00000, // Signaling NaN
      32'h3f800000, // +1
      32'hbf800000, // -1
      32'h40000000, // +2
      32'hc0000000, // -2
      32'h40490fdb, // +π
      32'hc0490fdb, // -π
      32'h34000000  // +Epsilon (2^-23)
  };

//   constraint edge_stim_c {
//       // Randomly select one of the edge test patterns
//       A_i inside {edge_test_patterns};
//       B_i inside {edge_test_patterns};
//       C_i inside {edge_test_patterns};
//   }
task gen_stim (mailbox #(Transaction) mbx, virtual mac32_if #(PARM_XLEN, PARM_EXP, PARM_MANT, PARM_BIAS) mac_if);
    foreach (edge_test_patterns[i]) begin
        foreach (edge_test_patterns[j]) begin
            foreach (edge_test_patterns[k]) begin
                @(posedge mac_if.clk);
                A_i = edge_test_patterns[i];
                B_i = edge_test_patterns[j];
                C_i = edge_test_patterns[k];
                mbx.put(this.copy);
            end
        end
    end
endtask

endclass
