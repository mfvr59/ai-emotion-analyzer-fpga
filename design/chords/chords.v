module chords(
    input clk,
    input reset,
    input play_enable,         
    input [5:0] note_to_load,  
    input [5:0] duration,      
    input load_new_note,       
    input beat,                
    input generate_next_sample, 
    output note_done,
    output signed [15:0] final_sample,       
    output sample_ready          
);
    wire [5:0] count1;
    wire [5:0] count2;
    wire [5:0] count3;
    wire [5:0] next_count1;
    wire [5:0] next_count2;
    wire [5:0] next_count3;
    wire note_done1;
    wire note_done2;
    wire note_done3;
    wire load_note1;
    wire load_note2;
    wire load_note3;
    
    assign note_done1 = (count1 == 6'd0);
    assign note_done2 = (count2 == 6'd0);
    assign note_done3 = (count3 == 6'd0);
    assign load_note1 = load_new_note && (note_to_load != 6'd0) &&  note_done1;
    assign load_note2 = load_new_note && (note_to_load != 6'd0) && !note_done1 &&  note_done2;
    assign load_note3 = load_new_note && (note_to_load != 6'd0) && !note_done1 && !note_done2 && note_done3;
    
    dffre #(.WIDTH(6)) duration_counter1 (.clk(clk), .r(reset), .en((beat || load_note1) && play_enable), .d(next_count1), .q(count1));
    dffre #(.WIDTH(6)) duration_counter2 (.clk(clk), .r(reset), .en((beat || load_note2) && play_enable), .d(next_count2), .q(count2));
    dffre #(.WIDTH(6)) duration_counter3 (.clk(clk), .r(reset), .en((beat || load_note3) && play_enable), .d(next_count3), .q(count3));
    
    assign next_count1 = load_note1 ? duration : (count1 == 6'd0) ? 6'd0 : (count1 - 6'd1);
    assign next_count2 = load_note2 ? duration : (count2 == 6'd0) ? 6'd0 : (count2 - 6'd1);
    assign next_count3 = load_note3 ? duration : (count3 == 6'd0) ? 6'd0 : (count3 - 6'd1);
    
    // Raw outputs from note_players
    wire signed [15:0] note_sample1_raw;
    wire signed [15:0] note_sample2_raw;
    wire signed [15:0] note_sample3_raw;
    wire sample_ready1_raw;
    wire sample_ready2_raw;
    wire sample_ready3_raw;
    wire np1_done;
    wire np2_done;
    wire np3_done;
    
    note_player np1(.clk(clk), .reset(reset), .play_enable(play_enable && !note_done1), .note_to_load(note_to_load), .duration_to_load(duration), .load_new_note(load_note1), .done_with_note(np1_done), .beat(beat), .generate_next_sample(generate_next_sample), .sample_out(note_sample1_raw), .new_sample_ready(sample_ready1_raw));
    note_player np2(.clk(clk), .reset(reset), .play_enable(play_enable && !note_done2), .note_to_load(note_to_load), .duration_to_load(duration), .load_new_note(load_note2), .done_with_note(np2_done), .beat(beat), .generate_next_sample(generate_next_sample), .sample_out(note_sample2_raw), .new_sample_ready(sample_ready2_raw));
    note_player np3(.clk(clk), .reset(reset), .play_enable(play_enable && !note_done3), .note_to_load(note_to_load), .duration_to_load(duration), .load_new_note(load_note3), .done_with_note(np3_done), .beat(beat), .generate_next_sample(generate_next_sample), .sample_out(note_sample3_raw), .new_sample_ready(sample_ready3_raw));
    
    wire signed [15:0] note_sample1;
    wire signed [15:0] note_sample2;
    wire signed [15:0] note_sample3;
    wire sample_ready1;
    wire sample_ready2;
    wire sample_ready3;
    
    dffr #(.WIDTH(16)) ns1_pipe (.clk(clk), .r(reset), .d(note_sample1_raw), .q(note_sample1));
    dffr #(.WIDTH(16)) ns2_pipe (.clk(clk), .r(reset), .d(note_sample2_raw), .q(note_sample2));
    dffr #(.WIDTH(16)) ns3_pipe (.clk(clk), .r(reset), .d(note_sample3_raw), .q(note_sample3));
    
    dffr sr1_pipe (.clk(clk), .r(reset), .d(sample_ready1_raw), .q(sample_ready1));
    dffr sr2_pipe (.clk(clk), .r(reset), .d(sample_ready2_raw), .q(sample_ready2));
    dffr sr3_pipe (.clk(clk), .r(reset), .d(sample_ready3_raw), .q(sample_ready3));
    
    wire note_done1_piped;
    wire note_done2_piped;
    wire note_done3_piped;
    
    dffr nd1_pipe (.clk(clk), .r(reset), .d(note_done1), .q(note_done1_piped));
    dffr nd2_pipe (.clk(clk), .r(reset), .d(note_done2), .q(note_done2_piped));
    dffr nd3_pipe (.clk(clk), .r(reset), .d(note_done3), .q(note_done3_piped));

    wire [1:0] active_voices;
    assign active_voices = (!note_done1_piped ? 2'd1 : 2'd0) + (!note_done2_piped ? 2'd1 : 2'd0) + (!note_done3_piped ? 2'd1 : 2'd0);
    
    wire signed [17:0] sum;
    assign sum = {{2{note_sample1[15]}}, note_sample1} + {{2{note_sample2[15]}}, note_sample2} + {{2{note_sample3[15]}}, note_sample3};
    
    wire signed [17:0] scaled;
    assign scaled = (active_voices == 2'd0) ? 18'd0 : (active_voices == 2'd1) ? sum : (active_voices == 2'd2) ? (sum >>> 1) : (sum >>> 2);
    
    wire signed [17:0] scaled_piped;   
    dffr #(.WIDTH(18)) scaled_pipe (.clk(clk), .r(reset), .d(scaled), .q(scaled_piped));
    assign final_sample = scaled_piped[15:0];
    assign note_done = note_done1_piped && note_done2_piped && note_done3_piped;
    assign sample_ready = (sample_ready1 || note_done1_piped) &&
                          (sample_ready2 || note_done2_piped) &&
                          (sample_ready3 || note_done3_piped);
endmodule
