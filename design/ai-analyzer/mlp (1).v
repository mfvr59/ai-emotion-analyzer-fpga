module mlp (
    input clk,
    input reset,
    input signed [7:0] x0,
    input signed [7:0] x1,
    input signed [7:0] x2,
    input signed [7:0] x3,
    input signed [7:0] x4,
    input signed [7:0] x5,
    input signed [7:0] x6,
    input signed [7:0] x7,
    input signed [7:0] x8,
    input signed [7:0] x9,
    input signed [7:0] x10,
    input signed [7:0] x11,
    input signed [7:0] x12,
    input signed [7:0] x13,
    input signed [7:0] x14,
    input signed [7:0] x15,
    output signed [15:0] y0,
    output signed [15:0] y1,
    output signed [15:0] y2,
    output signed [15:0] y3,
    output signed [15:0] y4,
    output signed [15:0] y5,
    output signed [15:0] y6,
    output signed [15:0] y7,
    input  valid_in,
    output valid_out
);
    wire v_l1, v_l2, v_l3;
    dffr valid_ff1 (.clk(clk), .r(reset), .d(valid_in), .q(v_l1));
    dffr valid_ff2 (.clk(clk), .r(reset), .d(v_l1),     .q(v_l2));
    dffr valid_ff3 (.clk(clk), .r(reset), .d(v_l2),     .q(v_l3));
    assign valid_out = v_l3;

    //layer1
    wire signed [15:0] l1_0_raw, l1_1_raw, l1_2_raw, l1_3_raw;
    wire signed [15:0] l1_4_raw, l1_5_raw, l1_6_raw, l1_7_raw;
    wire l1_valid_unused;

    layer1 u_layer1(
        .clk(clk), .reset(reset),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3),
        .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .x8(x8), .x9(x9), .x10(x10), .x11(x11),
        .x12(x12), .x13(x13), .x14(x14), .x15(x15),
        .valid_in(v_l1), 
        .y0(l1_0_raw), .y1(l1_1_raw), .y2(l1_2_raw), .y3(l1_3_raw),
        .y4(l1_4_raw), .y5(l1_5_raw), .y6(l1_6_raw), .y7(l1_7_raw),
        .valid_out(l1_valid_unused) 
    );

    wire signed [15:0] l1_0 = l1_0_raw <<< 2;
    wire signed [15:0] l1_1 = l1_1_raw <<< 2;
    wire signed [15:0] l1_2 = l1_2_raw <<< 2;
    wire signed [15:0] l1_3 = l1_3_raw <<< 2;
    wire signed [15:0] l1_4 = l1_4_raw <<< 2;
    wire signed [15:0] l1_5 = l1_5_raw <<< 2;
    wire signed [15:0] l1_6 = l1_6_raw <<< 2;
    wire signed [15:0] l1_7 = l1_7_raw <<< 2;

    wire signed [7:0] l1_t0 = l1_0 >>> 5;
    wire signed [7:0] l1_t1 = l1_1 >>> 5;
    wire signed [7:0] l1_t2 = l1_2 >>> 5;
    wire signed [7:0] l1_t3 = l1_3 >>> 5;
    wire signed [7:0] l1_t4 = l1_4 >>> 5;
    wire signed [7:0] l1_t5 = l1_5 >>> 5;
    wire signed [7:0] l1_t6 = l1_6 >>> 5;
    wire signed [7:0] l1_t7 = l1_7 >>> 5;

    //layer2
    wire signed [15:0] l2_0_raw, l2_1_raw, l2_2_raw, l2_3_raw;
    wire signed [15:0] l2_4_raw, l2_5_raw, l2_6_raw, l2_7_raw;
    wire l2_valid_unused;

    layer2 u_layer2(
        .clk(clk), .reset(reset),
        .x0(l1_t0), .x1(l1_t1), .x2(l1_t2), .x3(l1_t3),
        .x4(l1_t4), .x5(l1_t5), .x6(l1_t6), .x7(l1_t7),
        .valid_in(v_l2),
        .y0(l2_0_raw), .y1(l2_1_raw), .y2(l2_2_raw), .y3(l2_3_raw),
        .y4(l2_4_raw), .y5(l2_5_raw), .y6(l2_6_raw), .y7(l2_7_raw),
        .valid_out(l2_valid_unused)
    );

    wire signed [15:0] l2_0 = l2_0_raw <<< 2;
    wire signed [15:0] l2_1 = l2_1_raw <<< 2;
    wire signed [15:0] l2_2 = l2_2_raw <<< 2;
    wire signed [15:0] l2_3 = l2_3_raw <<< 2;
    wire signed [15:0] l2_4 = l2_4_raw <<< 2;
    wire signed [15:0] l2_5 = l2_5_raw <<< 2;
    wire signed [15:0] l2_6 = l2_6_raw <<< 2;
    wire signed [15:0] l2_7 = l2_7_raw <<< 2;

    wire signed [7:0] l2_t0 = l2_0 >>> 5;
    wire signed [7:0] l2_t1 = l2_1 >>> 5;
    wire signed [7:0] l2_t2 = l2_2 >>> 5;
    wire signed [7:0] l2_t3 = l2_3 >>> 5;
    wire signed [7:0] l2_t4 = l2_4 >>> 5;
    wire signed [7:0] l2_t5 = l2_5 >>> 5;
    wire signed [7:0] l2_t6 = l2_6 >>> 5;
    wire signed [7:0] l2_t7 = l2_7 >>> 5;

    //layer3
    wire signed [15:0] y0_raw, y1_raw, y2_raw;
    wire l3_valid_unused;

    layer3 u_layer3(
        .clk(clk), .reset(reset),
        .x0(l2_t0), .x1(l2_t1), .x2(l2_t2), .x3(l2_t3),
        .x4(l2_t4), .x5(l2_t5), .x6(l2_t6), .x7(l2_t7),
        .valid_in(v_l3),
        .y0(y0_raw), .y1(y1_raw), .y2(y2_raw),
        .valid_out(l3_valid_unused)
    );

    assign y0 = y0_raw <<< 2;
    assign y1 = y1_raw <<< 2;
    assign y2 = y2_raw <<< 2;
    assign y3 = 16'd0;
    assign y4 = 16'd0;
    assign y5 = 16'd0;
    assign y6 = 16'd0;
    assign y7 = 16'd0;

endmodule
