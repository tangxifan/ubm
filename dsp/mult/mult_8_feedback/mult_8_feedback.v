//-------------------------------------------------------
//  Functionality: An 8-bit multiply whose operand a is
//                 the low byte of its registered product,
//                 shifted right by one bit with sign
//                 extension
//  Author:        Amin Mohaghegh
//-------------------------------------------------------

module mult_8_feedback (
    clk,
    b,
    p
);

    input clk;
    input [7:0] b;
    output [15:0] p;

    reg [15:0] p;
    wire [7:0] a;

    // Feedback: shift the low byte of the product right by one bit and keep its sign bit
    assign a = {p[7], p[7:1]};

    // Register the product
    always @(posedge clk) begin
        p <= a * b;
    end

endmodule
