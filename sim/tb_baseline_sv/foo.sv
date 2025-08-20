interface my_if;
  logic [7:0] val;
  logic flag;
  event evt;
endinterface

module top;
  my_if intf();

  int trigger_count = 0;

  // Task that performs an action on values and triggers the event externally
  task automatic do_action_1(
    inout logic [7:0] val,
    output logic flag,
    event trigger_evt
  );
    val++;
    flag = (val % 2 == 0);
  endtask

task automatic do_action_2(
    inout logic [7:0] val,
    output logic flag,
    event trigger_evt
  );
  repeat (10) begin
    val++;
    flag = (val % 2 == 0);
    -> trigger_evt; // Trigger the event passed
    #5;
  end
  endtask


  // STYLE 1: Call task repeatedly from initial
  initial begin
    repeat (10) begin
      do_action_1(intf.val, intf.flag, intf.evt);
    -> intf.evt; // Trigger the event passed
      #5;
    end
    do_action_2(intf.val, intf.flag, intf.evt);
    #5;
  end

  // Track how many times event was triggered
  initial begin
    forever begin
      wait(intf.evt.triggered);
      trigger_count++;
      $display("[Time: %0t] Event triggered! Count = %0d, val = %0d, flag = %0b",
                $time, trigger_count, intf.val, intf.flag);
    end
    #5;
  end

  // End sim
  initial begin
    #110;
    $display("Total times event was triggered = %0d", trigger_count);
    $finish;
  end

endmodule
