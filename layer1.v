module layer1 (
    input clk,
    input reset,
    input signed [7:0] x0, x1, x2, x3, x4, x5, x6, x7,
    input signed [7:0] x8, x9, x10, x11, x12, x13, x14, x15,
    input valid_in,
    output signed [15:0] y0, y1, y2, y3, y4, y5, y6, y7,
    output valid_out
);
    wire signed [7:0] w0_0, w0_1, w0_2, w0_3, w0_4, w0_5, w0_6, w0_7;
    wire signed [7:0] w0_8, w0_9, w0_10, w0_11, w0_12, w0_13, w0_14, w0_15;
    wire signed [7:0] w1_0, w1_1, w1_2, w1_3, w1_4, w1_5, w1_6, w1_7;
    wire signed [7:0] w1_8, w1_9, w1_10, w1_11, w1_12, w1_13, w1_14, w1_15;
    wire signed [7:0] w2_0, w2_1, w2_2, w2_3, w2_4, w2_5, w2_6, w2_7;
    wire signed [7:0] w2_8, w2_9, w2_10, w2_11, w2_12, w2_13, w2_14, w2_15;
    wire signed [7:0] w3_0, w3_1, w3_2, w3_3, w3_4, w3_5, w3_6, w3_7;
    wire signed [7:0] w3_8, w3_9, w3_10, w3_11, w3_12, w3_13, w3_14, w3_15;
    wire signed [7:0] w4_0, w4_1, w4_2, w4_3, w4_4, w4_5, w4_6, w4_7;
    wire signed [7:0] w4_8, w4_9, w4_10, w4_11, w4_12, w4_13, w4_14, w4_15;
    wire signed [7:0] w5_0, w5_1, w5_2, w5_3, w5_4, w5_5, w5_6, w5_7;
    wire signed [7:0] w5_8, w5_9, w5_10, w5_11, w5_12, w5_13, w5_14, w5_15;
    wire signed [7:0] w6_0, w6_1, w6_2, w6_3, w6_4, w6_5, w6_6, w6_7;
    wire signed [7:0] w6_8, w6_9, w6_10, w6_11, w6_12, w6_13, w6_14, w6_15;
    wire signed [7:0] w7_0, w7_1, w7_2, w7_3, w7_4, w7_5, w7_6, w7_7;
    wire signed [7:0] w7_8, w7_9, w7_10, w7_11, w7_12, w7_13, w7_14, w7_15;
    wire signed [7:0] b0, b1, b2, b3, b4, b5, b6, b7;
    
    layer1_rom rom (
        .w0_0(w0_0), .w0_1(w0_1), .w0_2(w0_2), .w0_3(w0_3),
        .w0_4(w0_4), .w0_5(w0_5), .w0_6(w0_6), .w0_7(w0_7),
        .w0_8(w0_8), .w0_9(w0_9), .w0_10(w0_10), .w0_11(w0_11),
        .w0_12(w0_12), .w0_13(w0_13), .w0_14(w0_14), .w0_15(w0_15),
        .w1_0(w1_0), .w1_1(w1_1), .w1_2(w1_2), .w1_3(w1_3),
        .w1_4(w1_4), .w1_5(w1_5), .w1_6(w1_6), .w1_7(w1_7),
        .w1_8(w1_8), .w1_9(w1_9), .w1_10(w1_10), .w1_11(w1_11),
        .w1_12(w1_12), .w1_13(w1_13), .w1_14(w1_14), .w1_15(w1_15),
        .w2_0(w2_0), .w2_1(w2_1), .w2_2(w2_2), .w2_3(w2_3),
        .w2_4(w2_4), .w2_5(w2_5), .w2_6(w2_6), .w2_7(w2_7),
        .w2_8(w2_8), .w2_9(w2_9), .w2_10(w2_10), .w2_11(w2_11),
        .w2_12(w2_12), .w2_13(w2_13), .w2_14(w2_14), .w2_15(w2_15),
        .w3_0(w3_0), .w3_1(w3_1), .w3_2(w3_2), .w3_3(w3_3),
        .w3_4(w3_4), .w3_5(w3_5), .w3_6(w3_6), .w3_7(w3_7),
        .w3_8(w3_8), .w3_9(w3_9), .w3_10(w3_10), .w3_11(w3_11),
        .w3_12(w3_12), .w3_13(w3_13), .w3_14(w3_14), .w3_15(w3_15),
        .w4_0(w4_0), .w4_1(w4_1), .w4_2(w4_2), .w4_3(w4_3),
        .w4_4(w4_4), .w4_5(w4_5), .w4_6(w4_6), .w4_7(w4_7),
        .w4_8(w4_8), .w4_9(w4_9), .w4_10(w4_10), .w4_11(w4_11),
        .w4_12(w4_12), .w4_13(w4_13), .w4_14(w4_14), .w4_15(w4_15),
        .w5_0(w5_0), .w5_1(w5_1), .w5_2(w5_2), .w5_3(w5_3),
        .w5_4(w5_4), .w5_5(w5_5), .w5_6(w5_6), .w5_7(w5_7),
        .w5_8(w5_8), .w5_9(w5_9), .w5_10(w5_10), .w5_11(w5_11),
        .w5_12(w5_12), .w5_13(w5_13), .w5_14(w5_14), .w5_15(w5_15),
        .w6_0(w6_0), .w6_1(w6_1), .w6_2(w6_2), .w6_3(w6_3),
        .w6_4(w6_4), .w6_5(w6_5), .w6_6(w6_6), .w6_7(w6_7),
        .w6_8(w6_8), .w6_9(w6_9), .w6_10(w6_10), .w6_11(w6_11),
        .w6_12(w6_12), .w6_13(w6_13), .w6_14(w6_14), .w6_15(w6_15),
        .w7_0(w7_0), .w7_1(w7_1), .w7_2(w7_2), .w7_3(w7_3),
        .w7_4(w7_4), .w7_5(w7_5), .w7_6(w7_6), .w7_7(w7_7),
        .w7_8(w7_8), .w7_9(w7_9), .w7_10(w7_10), .w7_11(w7_11),
        .w7_12(w7_12), .w7_13(w7_13), .w7_14(w7_14), .w7_15(w7_15),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3),
        .b4(b4), .b5(b5), .b6(b6), .b7(b7)
    );
    
    // Neuron 0
    wire valid_out0;
    neuron16 neuron0 (
        .clk(clk), .reset(reset),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11),
        .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .w0(w0_0), .w1(w0_1), .w2(w0_2), .w3(w0_3),
        .w4(w0_4), .w5(w0_5), .w6(w0_6), .w7(w0_7),
        .w8(w0_8), .w9(w0_9), .w10(w0_10), .w11(w0_11),
        .w12(w0_12), .w13(w0_13), .w14(w0_14), .w15(w0_15),
        .bias(b0),
        .use_relu(1'b1),
        .valid_in(valid_in),
        .out(y0),
        .valid_out(valid_out0)
    );
    
    // Neuron 1
    wire valid_out1;
    neuron16 neuron1 (
        .clk(clk), .reset(reset),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11),
        .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .w0(w1_0), .w1(w1_1), .w2(w1_2), .w3(w1_3),
        .w4(w1_4), .w5(w1_5), .w6(w1_6), .w7(w1_7),
        .w8(w1_8), .w9(w1_9), .w10(w1_10), .w11(w1_11),
        .w12(w1_12), .w13(w1_13), .w14(w1_14), .w15(w1_15),
        .bias(b1),
        .use_relu(1'b1),
        .valid_in(valid_in),
        .out(y1),
        .valid_out(valid_out1)
    );
    
    // Neuron 2
    wire valid_out2;
    neuron16 neuron2 (
        .clk(clk), .reset(reset),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11),
        .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .w0(w2_0), .w1(w2_1), .w2(w2_2), .w3(w2_3),
        .w4(w2_4), .w5(w2_5), .w6(w2_6), .w7(w2_7),
        .w8(w2_8), .w9(w2_9), .w10(w2_10), .w11(w2_11),
        .w12(w2_12), .w13(w2_13), .w14(w2_14), .w15(w2_15),
        .bias(b2),
        .use_relu(1'b1),
        .valid_in(valid_in),
        .out(y2),
        .valid_out(valid_out2)
    );
    
    // Neuron 3
    wire valid_out3;
    neuron16 neuron3 (
        .clk(clk), .reset(reset),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11),
        .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .w0(w3_0), .w1(w3_1), .w2(w3_2), .w3(w3_3),
        .w4(w3_4), .w5(w3_5), .w6(w3_6), .w7(w3_7),
        .w8(w3_8), .w9(w3_9), .w10(w3_10), .w11(w3_11),
        .w12(w3_12), .w13(w3_13), .w14(w3_14), .w15(w3_15),
        .bias(b3),
        .use_relu(1'b1),
        .valid_in(valid_in),
        .out(y3),
        .valid_out(valid_out3)
    );
    
    // Neuron 4
    wire valid_out4;
    neuron16 neuron4 (
        .clk(clk), .reset(reset),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11),
        .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .w0(w4_0), .w1(w4_1), .w2(w4_2), .w3(w4_3),
        .w4(w4_4), .w5(w4_5), .w6(w4_6), .w7(w4_7),
        .w8(w4_8), .w9(w4_9), .w10(w4_10), .w11(w4_11),
        .w12(w4_12), .w13(w4_13), .w14(w4_14), .w15(w4_15),
        .bias(b4),
        .use_relu(1'b1),
        .valid_in(valid_in),
        .out(y4),
        .valid_out(valid_out4)
    );
    
    // Neuron 5
    wire valid_out5;
    neuron16 neuron5 (
        .clk(clk), .reset(reset),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11),
        .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .w0(w5_0), .w1(w5_1), .w2(w5_2), .w3(w5_3),
        .w4(w5_4), .w5(w5_5), .w6(w5_6), .w7(w5_7),
        .w8(w5_8), .w9(w5_9), .w10(w5_10), .w11(w5_11),
        .w12(w5_12), .w13(w5_13), .w14(w5_14), .w15(w5_15),
        .bias(b5),
        .use_relu(1'b1),
        .valid_in(valid_in),
        .out(y5),
        .valid_out(valid_out5)
    );
    
    // Neuron 6
    wire valid_out6;
    neuron16 neuron6 (
        .clk(clk), .reset(reset),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11),
        .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .w0(w6_0), .w1(w6_1), .w2(w6_2), .w3(w6_3),
        .w4(w6_4), .w5(w6_5), .w6(w6_6), .w7(w6_7),
        .w8(w6_8), .w9(w6_9), .w10(w6_10), .w11(w6_11),
        .w12(w6_12), .w13(w6_13), .w14(w6_14), .w15(w6_15),
        .bias(b6),
        .use_relu(1'b1),
        .valid_in(valid_in),
        .out(y6),
        .valid_out(valid_out6)
    );
    
    // Neuron 7
    wire valid_out7;
    neuron16 neuron7 (
        .clk(clk), .reset(reset),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11),
        .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .w0(w7_0), .w1(w7_1), .w2(w7_2), .w3(w7_3),
        .w4(w7_4), .w5(w7_5), .w6(w7_6), .w7(w7_7),
        .w8(w7_8), .w9(w7_9), .w10(w7_10), .w11(w7_11),
        .w12(w7_12), .w13(w7_13), .w14(w7_14), .w15(w7_15),
        .bias(b7),
        .use_relu(1'b1),
        .valid_in(valid_in),
        .out(y7),
        .valid_out(valid_out7)
    );
    
    assign valid_out = valid_out0;
endmodule
