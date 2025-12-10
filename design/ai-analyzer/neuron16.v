module neuron16 (
    input clk,
    input reset,
    input signed [7:0] x0, x1, x2, x3, x4, x5, x6, x7,
    input signed [7:0] x8, x9, x10, x11, x12, x13, x14, x15,
    input signed [7:0] w0, w1, w2, w3, w4, w5, w6, w7,
    input signed [7:0] w8, w9, w10, w11, w12, w13, w14, w15,
    input signed [7:0] bias,
    input use_relu,
    input valid_in,
    output signed [15:0] out,
    output valid_out
);
    wire signed [15:0] p0 = x0 * w0;
    wire signed [15:0] p1 = x1 * w1;
    wire signed [15:0] p2 = x2 * w2;
    wire signed [15:0] p3 = x3 * w3;
    wire signed [15:0] p4 = x4 * w4;
    wire signed [15:0] p5 = x5 * w5;
    wire signed [15:0] p6 = x6 * w6;
    wire signed [15:0] p7 = x7 * w7;
    wire signed [15:0] p8 = x8 * w8;
    wire signed [15:0] p9 = x9 * w9;
    wire signed [15:0] p10 = x10 * w10;
    wire signed [15:0] p11 = x11 * w11;
    wire signed [15:0] p12 = x12 * w12;
    wire signed [15:0] p13 = x13 * w13;
    wire signed [15:0] p14 = x14 * w14;
    wire signed [15:0] p15 = x15 * w15;
    wire signed [15:0] p0_r, p1_r, p2_r, p3_r, p4_r, p5_r, p6_r, p7_r;
    wire signed [15:0] p8_r, p9_r, p10_r, p11_r, p12_r, p13_r, p14_r, p15_r;
    wire valid_stage1;
    wire valid_stage2;
    wire signed [7:0] bias_r;
    wire use_relu_r;
    
    dffre #(.WIDTH(16)) p0_dff (.clk(clk), .r(reset), .en(valid_in), .d(p0), .q(p0_r));
    dffre #(.WIDTH(16)) p1_dff (.clk(clk), .r(reset), .en(valid_in), .d(p1), .q(p1_r));
    dffre #(.WIDTH(16)) p2_dff (.clk(clk), .r(reset), .en(valid_in), .d(p2), .q(p2_r));
    dffre #(.WIDTH(16)) p3_dff (.clk(clk), .r(reset), .en(valid_in), .d(p3), .q(p3_r));
    dffre #(.WIDTH(16)) p4_dff (.clk(clk), .r(reset), .en(valid_in), .d(p4), .q(p4_r));
    dffre #(.WIDTH(16)) p5_dff (.clk(clk), .r(reset), .en(valid_in), .d(p5), .q(p5_r));
    dffre #(.WIDTH(16)) p6_dff (.clk(clk), .r(reset), .en(valid_in), .d(p6), .q(p6_r));
    dffre #(.WIDTH(16)) p7_dff (.clk(clk), .r(reset), .en(valid_in), .d(p7), .q(p7_r));
    dffre #(.WIDTH(16)) p8_dff (.clk(clk), .r(reset), .en(valid_in), .d(p8), .q(p8_r));
    dffre #(.WIDTH(16)) p9_dff (.clk(clk), .r(reset), .en(valid_in), .d(p9), .q(p9_r));
    dffre #(.WIDTH(16)) p10_dff (.clk(clk), .r(reset), .en(valid_in), .d(p10), .q(p10_r));
    dffre #(.WIDTH(16)) p11_dff (.clk(clk), .r(reset), .en(valid_in), .d(p11), .q(p11_r));
    dffre #(.WIDTH(16)) p12_dff (.clk(clk), .r(reset), .en(valid_in), .d(p12), .q(p12_r));
    dffre #(.WIDTH(16)) p13_dff (.clk(clk), .r(reset), .en(valid_in), .d(p13), .q(p13_r));
    dffre #(.WIDTH(16)) p14_dff (.clk(clk), .r(reset), .en(valid_in), .d(p14), .q(p14_r));
    dffre #(.WIDTH(16)) p15_dff (.clk(clk), .r(reset), .en(valid_in), .d(p15), .q(p15_r));
    
    // Valid signal for stage 1
    dffre #(.WIDTH(1)) valid1_dff (.clk(clk), .r(reset), .en(1'b1), .d(valid_in), .q(valid_stage1));
    
    wire signed [16:0] sum0 = p0_r + p1_r;
    wire signed [16:0] sum1 = p2_r + p3_r;
    wire signed [16:0] sum2 = p4_r + p5_r;
    wire signed [16:0] sum3 = p6_r + p7_r;
    wire signed [16:0] sum4 = p8_r + p9_r;
    wire signed [16:0] sum5 = p10_r + p11_r;
    wire signed [16:0] sum6 = p12_r + p13_r;
    wire signed [16:0] sum7 = p14_r + p15_r;
    wire signed [16:0] sum0_r, sum1_r, sum2_r, sum3_r;
    wire signed [16:0] sum4_r, sum5_r, sum6_r, sum7_r;
    
    dffre #(.WIDTH(17)) sum0_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(sum0), .q(sum0_r));
    dffre #(.WIDTH(17)) sum1_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(sum1), .q(sum1_r));
    dffre #(.WIDTH(17)) sum2_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(sum2), .q(sum2_r));
    dffre #(.WIDTH(17)) sum3_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(sum3), .q(sum3_r));
    dffre #(.WIDTH(17)) sum4_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(sum4), .q(sum4_r));
    dffre #(.WIDTH(17)) sum5_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(sum5), .q(sum5_r));
    dffre #(.WIDTH(17)) sum6_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(sum6), .q(sum6_r));
    dffre #(.WIDTH(17)) sum7_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(sum7), .q(sum7_r));
    
    dffre #(.WIDTH(8)) bias_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(bias), .q(bias_r));
    dffre #(.WIDTH(1)) relu_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(use_relu), .q(use_relu_r));
    dffre #(.WIDTH(1)) valid2_dff (.clk(clk), .r(reset), .en(1'b1), .d(valid_stage1), .q(valid_stage2));
    
    wire signed [19:0] total_sum = sum0_r + sum1_r + sum2_r + sum3_r + sum4_r + sum5_r + sum6_r + sum7_r + {{12{bias_r[7]}}, bias_r}; 
    wire signed [15:0] saturated = (total_sum[19:15] == 5'b00000 || total_sum[19:15] == 5'b11111) ? total_sum[15:0] : {total_sum[19], {15{~total_sum[19]}}};
    wire signed [15:0] relu_out = (use_relu_r && saturated[15]) ? 16'd0 : saturated;
    
    dffre #(.WIDTH(16)) out_dff (.clk(clk), .r(reset), .en(valid_stage2), .d(relu_out), .q(out));
    dffre #(.WIDTH(1)) valid_out_dff (.clk(clk), .r(reset), .en(1'b1), .d(valid_stage2), .q(valid_out));
    
endmodule
