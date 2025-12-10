module note_player(
    input clk,
    input reset,
    input play_enable,
    input [5:0] note_to_load,
    input [5:0] duration_to_load,
    input load_new_note,
    output done_with_note,
    input beat,
    input generate_next_sample,
    output [15:0] sample_out,
    output new_sample_ready
);
    wire [19:0] step_size;
    wire [5:0] current_note;
    wire [5:0] time_remaining;
    wire [5:0] next_time_remaining_val;
    wire [15:0] sine_sample;
    wire sine_sample_ready;
    
    dffre #(6) note_reg (.clk(clk), .r(reset), .en(load_new_note), .d(note_to_load), .q(current_note));
    
    assign next_time_remaining_val = (time_remaining == 6'd0) ? 6'd0 : (time_remaining - 6'd1);
    wire [5:0] counter_data_in = load_new_note ? duration_to_load : next_time_remaining_val;
    wire counter_enable = beat & play_enable & (time_remaining > 6'd0);
    
    dffre #(6) duration_counter (.clk(clk), .r(reset), .en(counter_enable | load_new_note), .d(counter_data_in), .q(time_remaining));
    
    frequency_rom freq_rom (.clk(clk), .addr(current_note), .dout(step_size));
    sine_reader sine_gen (.clk(clk), .reset(reset), .step_size(step_size), .generate_next(generate_next_sample & play_enable), .sample_ready(sine_sample_ready), .sample(sine_sample));
    
    wire [15:0] gated_sample = (time_remaining != 6'd0) ? sine_sample : 16'd0;
    wire [15:0] held_sample;
    dffre #(16) sample_hold (.clk(clk), .r(reset), .en(generate_next_sample & play_enable), .d(gated_sample), .q(held_sample));
    
    assign sample_out = play_enable ? gated_sample : held_sample;
    assign new_sample_ready = sine_sample_ready;
    assign done_with_note = (time_remaining == 6'd0);
endmodule
