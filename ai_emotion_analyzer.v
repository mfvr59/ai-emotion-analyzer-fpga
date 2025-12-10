module ai_emotion_analyzer (
    input clk,
    input reset,
    input enable_ai,
    input [5:0] note_played,
    input load_new_note,
    output [1:0] emotion_code,
    output [7:0] emotion_confidence,
    output emotion_ready,
    output buffer_full
);
    wire [5:0] n0, n1, n2, n3, n4, n5, n6, n7;
    wire [5:0] n8, n9, n10, n11, n12, n13, n14, n15;
    wire buf_full;
    wire signed [7:0] f0, f1, f2, f3, f4, f5, f6, f7;
    wire signed [7:0] f8, f9, f10, f11, f12, f13, f14, f15;
    wire signed [7:0] f0_comb, f1_comb, f2_comb, f3_comb, f4_comb, f5_comb, f6_comb, f7_comb;
    wire signed [7:0] f8_comb, f9_comb, f10_comb, f11_comb, f12_comb, f13_comb, f14_comb, f15_comb;
    
    wire feat_valid_raw;
    wire feat_valid_raw2;
    wire feat_valid;
    wire start_mlp_pre;
    wire mlp_valid;
    wire signed [15:0] y0, y1, y2, y3, y4, y5, y6, y7;
    
    phrase_buffer pbuf (.clk(clk), .reset(reset), .note_played(note_played), .load_new_note(load_new_note), .n0(n0), .n1(n1), .n2(n2), .n3(n3), .n4(n4), .n5(n5), .n6(n6), .n7(n7), .n8(n8), .n9(n9), .n10(n10), .n11(n11), .n12(n12), .n13(n13), .n14(n14), .n15(n15), .buffer_full(buf_full));
    assign buffer_full = buf_full;
    feature_extractor feat_ext (.clk(clk), .reset(reset), .n0(n0), .n1(n1), .n2(n2), .n3(n3), .n4(n4), .n5(n5), .n6(n6), .n7(n7), .n8(n8), .n9(n9), .n10(n10), .n11(n11), .n12(n12), .n13(n13), .n14(n14), .n15(n15), .f0(f0_comb), .f1(f1_comb), .f2(f2_comb), .f3(f3_comb), .f4(f4_comb), .f5(f5_comb), .f6(f6_comb), .f7(f7_comb), .f8(f8_comb), .f9(f9_comb), .f10(f10_comb), .f11(f11_comb), .f12(f12_comb), .f13(f13_comb), .f14(f14_comb), .f15(f15_comb));
    
    dffre #(.WIDTH(8)) f0_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f0_comb), .q(f0));
    dffre #(.WIDTH(8)) f1_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f1_comb), .q(f1));
    dffre #(.WIDTH(8)) f2_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f2_comb), .q(f2));
    dffre #(.WIDTH(8)) f3_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f3_comb), .q(f3));
    dffre #(.WIDTH(8)) f4_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f4_comb), .q(f4));
    dffre #(.WIDTH(8)) f5_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f5_comb), .q(f5));
    dffre #(.WIDTH(8)) f6_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f6_comb), .q(f6));
    dffre #(.WIDTH(8)) f7_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f7_comb), .q(f7));
    dffre #(.WIDTH(8)) f8_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f8_comb), .q(f8));
    dffre #(.WIDTH(8)) f9_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f9_comb),  .q(f9));
    dffre #(.WIDTH(8)) f10_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f10_comb), .q(f10));
    dffre #(.WIDTH(8)) f11_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f11_comb), .q(f11));
    dffre #(.WIDTH(8)) f12_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f12_comb), .q(f12));
    dffre #(.WIDTH(8)) f13_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f13_comb), .q(f13));
    dffre #(.WIDTH(8)) f14_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f14_comb), .q(f14));
    dffre #(.WIDTH(8)) f15_dff (.clk(clk), .r(reset), .en(start_mlp_pre), .d(f15_comb), .q(f15));
    
    dffre #(.WIDTH(1)) feat_valid_stage1_dff (.clk(clk), .r(reset), .en(1'b1), .d(start_mlp_pre), .q(feat_valid_raw));
    dffre #(.WIDTH(1)) feat_valid_stage2_dff (.clk(clk), .r(reset), .en(1'b1), .d(feat_valid_raw), .q(feat_valid_raw2));
    dffre #(.WIDTH(1)) feat_valid_stage3_dff (.clk(clk), .r(reset), .en(1'b1), .d(feat_valid_raw2), .q(feat_valid));
    
    inference_fsm inf (.clk(clk), .reset(reset), .buffer_full(buf_full), .enable_cnn(enable_ai), .mlp_valid_out(mlp_valid), .start_mlp(start_mlp_pre), .note_ready(emotion_ready));
    mlp u_mlp (.clk(clk), .reset(reset), .x0(f0), .x1(f1), .x2(f2), .x3(f3), .x4(f4), .x5(f5), .x6(f6), .x7(f7), .x8(f8), .x9(f9), .x10(f10), .x11(f11), .x12(f12), .x13(f13), .x14(f14), .x15(f15), .valid_in(feat_valid), .y0(y0), .y1(y1), .y2(y2), .y3(y3), .y4(y4), .y5(y5), .y6(y6), .y7(y7), .valid_out(mlp_valid));
    emotion_decoder dec (.y0(y0), .y1(y1), .y2(y2), .emotion_code(emotion_code), .emotion_confidence(emotion_confidence));
endmodule
