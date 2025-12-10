module harmonic_note_player(
    input clk,
    input reset,
    input play_enable,
    input [5:0] note_to_load,
    input [5:0] duration_to_load,
    input load_new_note,
    output done_with_note,
    input beat,
    input generate_next_sample,
    input [1:0] instrument,
    output [15:0] sample_out,
    output new_sample_ready
);
    wire [5:0] current_note;
    wire [5:0] time_remaining;
    wire [5:0] next_time_remaining_val;

    //store current note
    dffre #(6) note_reg (.clk(clk), .r(reset), .en(load_new_note), .d(note_to_load), .q(current_note));

    //duration counter
    wire [5:0] counter_data_in = load_new_note ? duration_to_load : time_remaining - 6'd1;
    wire counter_enable = beat & play_enable & (time_remaining > 6'd0);

    dffre #(6) duration_counter (.clk(clk), .r(reset), .en(counter_enable | load_new_note), .d(counter_data_in), .q(time_remaining));

    assign done_with_note = (time_remaining == 6'd0);

    //freq lookup
    wire [19:0] step_size;
    frequency_rom freq_rom (.clk(clk), .addr(current_note), .dout(step_size));

    //harmonics instance
    wire [15:0] harm_sample;
    wire harm_ready;
    harmonics harm_inst (.clk(clk), .reset(reset | load_new_note), .play_enable(play_enable), .generate_next_sample(generate_next_sample), .step_size(step_size), .instrument(instrument), .note_done(done_with_note), .sample_out(harm_sample), .sample_ready(harm_ready));

    assign sample_out = play_enable ? harm_sample : 16'd0;
    assign new_sample_ready = harm_ready;
endmodule
