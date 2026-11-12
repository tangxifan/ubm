module counter_up_down_preload_compare #(
    parameter WIDTH = 8
) (
    input  wire             clk,
    input  wire             rst_n,       // Active-low asynchronous reset
    input  wire             en,          // Count enable
    input  wire             up_down,     // 1 = count up, 0 = count down
    input  wire             load,        // Synchronous parallel load (priority over en)
    input  wire [WIDTH-1:0] load_val,    // Value to preload
    input  wire [WIDTH-1:0] compare_val, // Target value for comparison
    output reg  [WIDTH-1:0] count,       // Current counter value
    output wire             match        // High when count == compare_val
);

    localparam [WIDTH-1:0] ONE = {{(WIDTH-1){1'b0}}, 1'b1};

    // Sequential Logic: Up/Down Counter with Preload
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= {WIDTH{1'b0}};
        end else if (load) begin
            count <= load_val;
        end else if (en) begin
            if (up_down) begin
                count <= count + ONE;
            end else begin
                count <= count - ONE;
            end
        end
    end

    // Combinational Logic: Compare
    assign match = (count == compare_val);

endmodule

