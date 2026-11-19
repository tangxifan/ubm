`timescale 1ns/1ps

module counter8_async_resetb_tb;

    reg        clk;
    reg        resetb;
    wire [7:0] result;

    integer errors;
    integer step;
    reg [7:0] expected_val;

    counter8_async_resetb DUT (
        .clk   (clk),
        .resetb(resetb),
        .result(result)
    );

    // 20 ns clock period (10 ns half-period), same as counter8_async_resetb_tb.v
    initial clk = 1'b0;
    always #10 clk = ~clk;

    initial begin
        errors = 0;

        // --- Step 1: Apply Asynchronous Reset (Active-Low) ---
        $display("[%0t] Asserting active-low reset (resetb = 0)...", $time);
        resetb = 1'b0;
        #25;

        // Verify counter is held at 0 during reset
        if (result !== 8'd0) begin
            $display("ERROR: result should be 0 during reset, got %0d", result);
            errors = errors + 1;
        end

        // De-assert reset on the falling edge of the clock
        $display("[%0t] De-asserting reset (resetb = 1) on falling edge...", $time);
        @(negedge clk);
        resetb = 1'b1;

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
        @(posedge clk);
        #5;              // mid-cycle, 5 ns past the rising edge

        resetb = 1'b0;   // assert active-low reset
        #1;              // brief delay for the output to update

        if (result !== 8'd0) begin
            $display("ERROR: result failed to reset asynchronously, got %0d", result);
            errors = errors + 1;
        end

        // Release reset to clean up
        resetb = 1'b1;

        if (errors == 0)
            $display("All tests passed successfully!");
        else
            $display("FAILED with %0d error(s).", errors);

        $finish;
    end

    // Safety timeout
    initial begin
        #5000;
        $display("ERROR: simulation timeout");
        $finish;
    end

endmodule