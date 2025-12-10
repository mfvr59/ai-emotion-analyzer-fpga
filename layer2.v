module layer2 (
    input clk,
    input reset,
    input signed [7:0] x0, x1, x2, x3, x4, x5, x6, x7,
    output signed [15:0] y0, y1, y2, y3, y4, y5, y6, y7,
    input valid_in,
    output valid_out
);
    wire signed [7:0] w0_0, w0_1, w0_2, w0_3, w0_4, w0_5, w0_6, w0_7;
    wire signed [7:0] w1_0, w1_1, w1_2, w1_3, w1_4, w1_5, w1_6, w1_7;
    wire signed [7:0] w2_0, w2_1, w2_2, w2_3, w2_4, w2_5, w2_6, w2_7;
    wire signed [7:0] w3_0, w3_1, w3_2, w3_3, w3_4, w3_5, w3_6, w3_7;
    wire signed [7:0] w4_0, w4_1, w4_2, w4_3, w4_4, w4_5, w4_6, w4_7;
    wire signed [7:0] w5_0, w5_1, w5_2, w5_3, w5_4, w5_5, w5_6, w5_7;
    wire signed [7:0] w6_0, w6_1, w6_2, w6_3, w6_4, w6_5, w6_6, w6_7;
    wire signed [7:0] w7_0, w7_1, w7_2, w7_3, w7_4, w7_5, w7_6, w7_7;
    wire signed [7:0] b0, b1, b2, b3, b4, b5, b6, b7;

    layer2_rom rom(
        .w0_0(w0_0), .w0_1(w0_1), .w0_2(w0_2), .w0_3(w0_3), .w0_4(w0_4), .w0_5(w0_5), .w0_6(w0_6), .w0_7(w0_7),
        .w1_0(w1_0), .w1_1(w1_1), .w1_2(w1_2), .w1_3(w1_3), .w1_4(w1_4), .w1_5(w1_5), .w1_6(w1_6), .w1_7(w1_7),
        .w2_0(w2_0), .w2_1(w2_1), .w2_2(w2_2), .w2_3(w2_3), .w2_4(w2_4), .w2_5(w2_5), .w2_6(w2_6), .w2_7(w2_7),
        .w3_0(w3_0), .w3_1(w3_1), .w3_2(w3_2), .w3_3(w3_3), .w3_4(w3_4), .w3_5(w3_5), .w3_6(w3_6), .w3_7(w3_7),
        .w4_0(w4_0), .w4_1(w4_1), .w4_2(w4_2), .w4_3(w4_3), .w4_4(w4_4), .w4_5(w4_5), .w4_6(w4_6), .w4_7(w4_7),
        .w5_0(w5_0), .w5_1(w5_1), .w5_2(w5_2), .w5_3(w5_3), .w5_4(w5_4), .w5_5(w5_5), .w5_6(w5_6), .w5_7(w5_7),
        .w6_0(w6_0), .w6_1(w6_1), .w6_2(w6_2), .w6_3(w6_3), .w6_4(w6_4), .w6_5(w6_5), .w6_6(w6_6), .w6_7(w6_7),
        .w7_0(w7_0), .w7_1(w7_1), .w7_2(w7_2), .w7_3(w7_3), .w7_4(w7_4), .w7_5(w7_5), .w7_6(w7_6), .w7_7(w7_7),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3), .b4(b4), .b5(b5), .b6(b6), .b7(b7)
    );
    
    // Valid outputs from each neuron
    wire v0, v1, v2, v3, v4, v5, v6, v7;
    
    // Pipelined neurons
    neuron8 neuron0(
        .clk(clk), .reset(reset), .valid_in(valid_in), .valid_out(v0),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .w0(w0_0), .w1(w0_1), .w2(w0_2), .w3(w0_3), .w4(w0_4), .w5(w0_5), .w6(w0_6), .w7(w0_7),
        .bias(b0), .use_relu(1'b1), .out(y0)
    );
    
    neuron8 neuron1(
        .clk(clk), .reset(reset), .valid_in(valid_in), .valid_out(v1),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .w0(w1_0), .w1(w1_1), .w2(w1_2), .w3(w1_3), .w4(w1_4), .w5(w1_5), .w6(w1_6), .w7(w1_7),
        .bias(b1), .use_relu(1'b1), .out(y1)
    );
    
    neuron8 neuron2(
        .clk(clk), .reset(reset), .valid_in(valid_in), .valid_out(v2),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .w0(w2_0), .w1(w2_1), .w2(w2_2), .w3(w2_3), .w4(w2_4), .w5(w2_5), .w6(w2_6), .w7(w2_7),
        .bias(b2), .use_relu(1'b1), .out(y2)
    );
    
    neuron8 neuron3(
        .clk(clk), .reset(reset), .valid_in(valid_in), .valid_out(v3),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .w0(w3_0), .w1(w3_1), .w2(w3_2), .w3(w3_3), .w4(w3_4), .w5(w3_5), .w6(w3_6), .w7(w3_7),
        .bias(b3), .use_relu(1'b1), .out(y3)
    );
    
    neuron8 neuron4(
        .clk(clk), .reset(reset), .valid_in(valid_in), .valid_out(v4),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .w0(w4_0), .w1(w4_1), .w2(w4_2), .w3(w4_3), .w4(w4_4), .w5(w4_5), .w6(w4_6), .w7(w4_7),
        .bias(b4), .use_relu(1'b1), .out(y4)
    );
    
    neuron8 neuron5(
        .clk(clk), .reset(reset), .valid_in(valid_in), .valid_out(v5),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .w0(w5_0), .w1(w5_1), .w2(w5_2), .w3(w5_3), .w4(w5_4), .w5(w5_5), .w6(w5_6), .w7(w5_7),
        .bias(b5), .use_relu(1'b1), .out(y5)
    );
    
    neuron8 neuron6(
        .clk(clk), .reset(reset), .valid_in(valid_in), .valid_out(v6),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .w0(w6_0), .w1(w6_1), .w2(w6_2), .w3(w6_3), .w4(w6_4), .w5(w6_5), .w6(w6_6), .w7(w6_7),
        .bias(b6), .use_relu(1'b1), .out(y6)
    );
    
    neuron8 neuron7(
        .clk(clk), .reset(reset), .valid_in(valid_in), .valid_out(v7),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .w0(w7_0), .w1(w7_1), .w2(w7_2), .w3(w7_3), .w4(w7_4), .w5(w7_5), .w6(w7_6), .w7(w7_7),
        .bias(b7), .use_relu(1'b1), .out(y7)
    );
    
    assign valid_out = v7;
    
endmodule
