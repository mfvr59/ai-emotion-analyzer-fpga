module harmonics(
    input clk,
    input reset,
    input play_enable,
    input generate_next_sample,
    input [19:0] step_size,
    input [1:0] instrument,
    input note_done,
    output signed [15:0] sample_out,
    output sample_ready
);
    wire [19:0] step1 = step_size;
    wire [19:0] step2 = step_size << 1;
    wire [19:0] step3 = step_size + (step_size << 1);
    wire [19:0] step4 = step_size << 2;
    wire gen = generate_next_sample & play_enable;
    wire signed [15:0] s1_raw, s2_raw, s3_raw, s4_raw;
    wire sr1_raw, sr2_raw, sr3_raw, sr4_raw;
    wire signed [15:0] s1, s2, s3, s4;
    wire sr1, sr2, sr3, sr4;
    
    sine_reader sr_fund(.clk(clk), .reset(reset), .step_size(step1), .generate_next(gen), .sample_ready(sr1_raw), .sample(s1_raw));
    sine_reader sr_h2  (.clk(clk), .reset(reset), .step_size(step2), .generate_next(gen), .sample_ready(sr2_raw), .sample(s2_raw));
    sine_reader sr_h3  (.clk(clk), .reset(reset), .step_size(step3), .generate_next(gen), .sample_ready(sr3_raw), .sample(s3_raw));
    sine_reader sr_h4  (.clk(clk), .reset(reset), .step_size(step4), .generate_next(gen), .sample_ready(sr4_raw), .sample(s4_raw));
    
    dffr #(.WIDTH(16)) s1_pipe (.clk(clk), .r(reset), .d(s1_raw), .q(s1));
    dffr #(.WIDTH(16)) s2_pipe (.clk(clk), .r(reset), .d(s2_raw), .q(s2));
    dffr #(.WIDTH(16)) s3_pipe (.clk(clk), .r(reset), .d(s3_raw), .q(s3));
    dffr #(.WIDTH(16)) s4_pipe (.clk(clk), .r(reset), .d(s4_raw), .q(s4));
    
    dffr sr1_pipe (.clk(clk), .r(reset), .d(sr1_raw), .q(sr1));
    dffr sr2_pipe (.clk(clk), .r(reset), .d(sr2_raw), .q(sr2));
    dffr sr3_pipe (.clk(clk), .r(reset), .d(sr3_raw), .q(sr3));
    dffr sr4_pipe (.clk(clk), .r(reset), .d(sr4_raw), .q(sr4));
    
    assign sample_ready = sr1 & sr2 & sr3 & sr4;
    
    wire signed [21:0] s1e = {{6{s1[15]}}, s1};
    wire signed [21:0] s2e = {{6{s2[15]}}, s2};
    wire signed [21:0] s3e = {{6{s3[15]}}, s3};
    wire signed [21:0] s4e = {{6{s4[15]}}, s4};

    reg signed [21:0] mix_sum;
    always @(*) begin
        case(instrument)
            2'd0: mix_sum = s1e;
            2'd1: mix_sum = s1e + (s2e >>> 1);
            2'd2: mix_sum = s1e + (s2e >>> 1) + (s3e >>> 2);
            2'd3: mix_sum = (s1e >>> 1) + (s2e >>> 1) + (s3e >>> 2) + (s4e >>> 2);
            default: mix_sum = s1e;
        endcase
    end
    
    wire signed [21:0] mix_sum_piped;
    dffr #(.WIDTH(22)) mix_pipe (.clk(clk), .r(reset), .d(mix_sum), .q(mix_sum_piped));
    wire signed [21:0] scaled_22 = mix_sum_piped >>> 2;
    wire signed [15:0] mixed = scaled_22[15:0];
    
    wire signed [15:0] mixed_piped;
    wire play_enable_piped;
    wire note_done_piped;
    
    dffr #(.WIDTH(16)) output_pipe (.clk(clk), .r(reset), .d(mixed), .q(mixed_piped));
    dffr play_en_pipe (.clk(clk), .r(reset), .d(play_enable), .q(play_enable_piped));
    dffr note_done_pipe (.clk(clk), .r(reset), .d(note_done), .q(note_done_piped));
    
    assign sample_out = (play_enable_piped && !note_done_piped) ? mixed_piped : 16'd0;
endmodule
