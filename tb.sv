`timescale 1ns/10ps
module tb;

    localparam CLK_PERIOD = 80; // 12 MHz 
    localparam RESET_ACTIVE = 0;
    localparam RESET_INACTIVE = 1;

    // Testbench Signals
    integer tb_test_num;
    string tb_test_name; 

    // DUT Inputs
    logic tb_clk;
    logic tb_nrst;

    // Expected values for checks

    // Signal Dump
    initial begin
        $dumpfile ("dump.vcd");
        $dumpvars;
    end

    ////////////////////////
    // Testbenching tasks //
    ////////////////////////

    // Quick reset for 2 clock cycles
    task reset_dut;
    begin
        @(negedge tb_clk); // synchronize to negedge edge so there are not hold or setup time violations
        
        // Activate reset
        tb_nrst = RESET_ACTIVE;

        // Wait 2 clock cycles
        @(negedge tb_clk);
        @(negedge tb_clk);

        // Deactivate reset
        tb_nrst = RESET_INACTIVE; 
    end
    endtask

    // Check output values against expected values
    task check_outputs;
        input logic [NUM_BITS-1:0] exp_count; 
        input logic exp_at_max; 
    begin
        @(negedge tb_clk);  // Check away from the clock edge!
        if(exp_count == tb_count)
            $info("Correct tb_count value.");  
        else
            $error("Incorrect tb_count value. Actual: %0d, Expected: %0d.", tb_count, exp_count);
        
        if(exp_at_max == tb_at_max)
            $info("Correct tb_at_max value.");
        else
            $error("Incorrect tb_at_max value. Actual: %0d, Expected: %0d.", tb_at_max, exp_at_max);

    end
    endtask 

    //////////
    // DUT //
    //////////

    // DUT Instance
     DUT (
        .clk(tb_clk),
        .nrst(tb_nrst),
    );

    // Clock generation block
    always begin
        tb_clk = 0; // set clock initially to be 0 so that they are no time violations at the rising edge 
        #(CLK_PERIOD / 2);
        tb_clk = 1;
        #(CLK_PERIOD / 2);
    end

    initial begin

        // Initialize all test inputs

        #(0.5);

        //reset

        $finish;
    end


endmodule