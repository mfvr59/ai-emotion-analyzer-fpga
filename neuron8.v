module neuron8 (
    input clk,
    input reset,
    input signed [7:0] x0, x1, x2, x3, x4, x5, x6, x7,
    input signed [7:0] w0, w1, w2, w3, w4, w5, w6, w7,
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
    
    wire signed [15:0] p0_reg, p1_reg, p2_reg, p3_reg;
    wire signed [15:0] p4_reg, p5_reg, p6_reg, p7_reg;
    wire valid_stage1;
    wire signed [7:0] bias_reg;
    wire relu_stage1;
    
    dffre #(.WIDTH(16)) p0_dff (.clk(clk), .r(reset), .en(valid_in), .d(p0), .q(p0_reg));
    dffre #(.WIDTH(16)) p1_dff (.clk(clk), .r(reset), .en(valid_in), .d(p1), .q(p1_reg));
    dffre #(.WIDTH(16)) p2_dff (.clk(clk), .r(reset), .en(valid_in), .d(p2), .q(p2_reg));
    dffre #(.WIDTH(16)) p3_dff (.clk(clk), .r(reset), .en(valid_in), .d(p3), .q(p3_reg));
    dffre #(.WIDTH(16)) p4_dff (.clk(clk), .r(reset), .en(valid_in), .d(p4), .q(p4_reg));
    dffre #(.WIDTH(16)) p5_dff (.clk(clk), .r(reset), .en(valid_in), .d(p5), .q(p5_reg));
    dffre #(.WIDTH(16)) p6_dff (.clk(clk), .r(reset), .en(valid_in), .d(p6), .q(p6_reg));
    dffre #(.WIDTH(16)) p7_dff (.clk(clk), .r(reset), .en(valid_in), .d(p7), .q(p7_reg));
    dffre #(.WIDTH(8))  bias_dff (.clk(clk), .r(reset), .en(valid_in), .d(bias), .q(bias_reg));
    dffre #(.WIDTH(1))  relu_dff (.clk(clk), .r(reset), .en(valid_in), .d(use_relu), .q(relu_stage1));
    dffre #(.WIDTH(1))  valid1_dff (.clk(clk), .r(reset), .en(1'b1), .d(valid_in), .q(valid_stage1));
    
    wire signed [19:0] p0_ext = {{4{p0_reg[15]}}, p0_reg};
    wire signed [19:0] p1_ext = {{4{p1_reg[15]}}, p1_reg};
    wire signed [19:0] p2_ext = {{4{p2_reg[15]}}, p2_reg};
    wire signed [19:0] p3_ext = {{4{p3_reg[15]}}, p3_reg};
    wire signed [19:0] p4_ext = {{4{p4_reg[15]}}, p4_reg};
    wire signed [19:0] p5_ext = {{4{p5_reg[15]}}, p5_reg};
    wire signed [19:0] p6_ext = {{4{p6_reg[15]}}, p6_reg};
    wire signed [19:0] p7_ext = {{4{p7_reg[15]}}, p7_reg};
    wire signed [19:0] bias_ext = {{12{bias_reg[7]}}, bias_reg};
    
    wire signed [19:0] sum = p0_ext + p1_ext + p2_ext + p3_ext + p4_ext + p5_ext + p6_ext + p7_ext + bias_ext;
    wire signed [19:0] relu_applied = (relu_stage1 && sum[19]) ? 20'd0 : sum;
    
    reg signed [15:0] saturated;
    always @(*) begin
        if (relu_applied > 32767)
            saturated = 16'd32767;
        else if (relu_applied < -32768)
            saturated = -16'd32768;
        else
            saturated = relu_applied[15:0];
    end
    
    dffre #(.WIDTH(16)) out_dff (.clk(clk), .r(reset), .en(valid_stage1), .d(saturated), .q(out));
    dffre #(.WIDTH(1)) valid_out_dff (.clk(clk), .r(reset), .en(1'b1), .d(valid_stage1), .q(valid_out));
endmodule
