`timescale 1ns/1ps

module counter8_async_reset_tb;

    reg        clk;
    reg        reset;
    wire [7:0] result;

    integer errors;
    integer step;
    reg [7:0] expected_val;

    // DUT (adjust module/port names if yours differ)
    counter8_async_reset dut (
        .clk   (clk),
        .reset (reset),
        .result(result)
    );

    // 10 ns clock, starts high (matches cocotb Clock default)
    initial clk = 1'b1;
    always #5 clk = ~clk;

    initial begin
        errors = 0;
        reset  = 1'b0;

        // --- Step 1: Apply Asynchronous Reset ---
        $display("[%0t] Asserting reset...", $time);
        reset = 1'b1;
        #25;

        // Verify counter is held at 0 during reset
        if (result !== 8'd0) begin
            $display("ERROR: result should be 0 during reset, got %0d", result);
            errors = errors + 1;
        end

        // De-assert reset on the falling edge of the clock
        $display("[%0t] De-asserting reset on falling edge...", $time);
        @(negedge clk);
        reset = 1'b0;

        // --- Step 2: Verify Sequential Increments ---
        expected_val = 8'd0;
        for (step = 1; step <= 10; step = step + 1) begin
            @(posedge clk);
            expected_val = expected_val + 8'd1;  // wraps naturally at 8 bits
            #1;  // let output settle
            if (result !== expected_val) begin
                $display("ERROR: Mismatch at step %0d: expected %0d, got %0d",
                         step, expected_val, result);
                errors = errors + 1;
            end
        end

        // --- Step 3: Mid-Run Asynchronous Reset Test ---
        $display("[%0t] Testing mid-run asynchronous reset...", $time);
        reset = 1'b1;
        #5;

        if (result !== 8'd0) begin
            $display("ERROR: result failed to reset asynchronously, got %0d", result);
            errors = errors + 1;
        end

        reset = 1'b0;

        if (errors == 0)
            $display("All tests passed successfully!");
        else
            $display("FAILED with %0d error(s).", errors);

        $finish;
    end

    // Safety timeout
    initial begin
        #10000;
        $display("ERROR: simulation timeout");
        $finish;
    end

endmodule
