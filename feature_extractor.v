module feature_extractor (
    input clk,
    input reset,
    input signed [5:0] n0, n1, n2, n3, n4, n5, n6, n7,
    input signed [5:0] n8, n9, n10, n11, n12, n13, n14, n15,
    output signed [7:0] f0, f1, f2, f3, f4, f5, f6, f7,
    output signed [7:0] f8, f9, f10, f11, f12, f13, f14, f15
);
    wire signed [7:0] interval0 = n1 - n0;
    wire signed [7:0] interval1 = n2 - n1;
    wire signed [7:0] interval2 = n3 - n2;
    wire signed [7:0] interval3 = n4 - n3;
    wire signed [7:0] interval4 = n5 - n4;
    wire signed [7:0] interval5 = n6 - n5;
    wire signed [7:0] interval6 = n7 - n6;
    wire signed [7:0] interval7 = n8 - n7;
    wire signed [7:0] interval8 = n9 - n8;
    wire signed [7:0] interval9 = n10 - n9;
    wire signed [7:0] interval10 = n11 - n10;
    wire signed [7:0] interval11 = n12 - n11;
    wire signed [7:0] interval12 = n13 - n12;
    wire signed [7:0] interval13 = n14 - n13;
    wire signed [7:0] interval14 = n15 - n14;
    wire signed [7:0] int0_r, int1_r, int2_r, int3_r, int4_r;
    wire signed [7:0] int5_r, int6_r, int7_r, int8_r, int9_r;
    wire signed [7:0] int10_r, int11_r, int12_r, int13_r, int14_r;
    
    dffr #(.WIDTH(8)) int0_ff (.clk(clk), .r(reset), .d(interval0), .q(int0_r));
    dffr #(.WIDTH(8)) int1_ff (.clk(clk), .r(reset), .d(interval1), .q(int1_r));
    dffr #(.WIDTH(8)) int2_ff (.clk(clk), .r(reset), .d(interval2), .q(int2_r));
    dffr #(.WIDTH(8)) int3_ff (.clk(clk), .r(reset), .d(interval3), .q(int3_r));
    dffr #(.WIDTH(8)) int4_ff (.clk(clk), .r(reset), .d(interval4), .q(int4_r));
    dffr #(.WIDTH(8)) int5_ff (.clk(clk), .r(reset), .d(interval5), .q(int5_r));
    dffr #(.WIDTH(8)) int6_ff (.clk(clk), .r(reset), .d(interval6), .q(int6_r));
    dffr #(.WIDTH(8)) int7_ff (.clk(clk), .r(reset), .d(interval7), .q(int7_r));
    dffr #(.WIDTH(8)) int8_ff (.clk(clk), .r(reset), .d(interval8), .q(int8_r));
    dffr #(.WIDTH(8)) int9_ff (.clk(clk), .r(reset), .d(interval9), .q(int9_r));
    dffr #(.WIDTH(8)) int10_ff (.clk(clk), .r(reset), .d(interval10), .q(int10_r));
    dffr #(.WIDTH(8)) int11_ff (.clk(clk), .r(reset), .d(interval11), .q(int11_r));
    dffr #(.WIDTH(8)) int12_ff (.clk(clk), .r(reset), .d(interval12), .q(int12_r));
    dffr #(.WIDTH(8)) int13_ff (.clk(clk), .r(reset), .d(interval13), .q(int13_r));
    dffr #(.WIDTH(8)) int14_ff (.clk(clk), .r(reset), .d(interval14), .q(int14_r));

    wire signed [11:0] sum_intervals = int0_r + int1_r + int2_r + int3_r + int4_r + int5_r + int6_r + int7_r + int8_r + int9_r + int10_r + int11_r + int12_r + int13_r + int14_r;
    wire signed [7:0] avg_slope = sum_intervals >>> 4;
    
    assign f0 = int0_r;
    assign f1 = int1_r;
    assign f2 = int2_r;
    assign f3 = int3_r;
    assign f4 = int4_r;
    assign f5 = int5_r;
    assign f6 = int6_r;
    assign f7 = int7_r;
    assign f8 = int8_r;
    assign f9 = int9_r;
    assign f10 = int10_r;
    assign f11 = int11_r;
    assign f12 = int12_r;
    assign f13 = int13_r;
    assign f14 = int14_r;
    assign f15 = avg_slope;
endmodule
