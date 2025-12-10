module music_player(
    input clk,
    input b0,
    input reset,
    input play_button,
    input next_button,
    input sw0,
    input sw1,
    input new_frame,
    output wire new_sample_generated,
    output wire [15:0] sample_out,
    output wire [1:0] display_song,
    output wire display_playing,
    output wire [1:0] emotion_out,
    output wire [7:0] emotion_conf_out,
    output wire emotion_valid,
    output wire ai_buffer_full,

    // for note display
    output wire note_advance,
    output wire note_reverse
);
    parameter BEAT_COUNT = 1000;

    wire play;
    wire reset_player;
    wire [1:0] song_num;
    wire song_done;
    
    //MCU INSTANCE
    mcu mcu_inst (
        .clk(clk),
        .reset(reset),
        .play_button(play_button),
        .next_button(next_button),
        .play(play),
        .reset_player(reset_player),
        .song(song_num),
        .song_done(song_done)
    );

    wire ai_mode = sw0;
    wire fast_forward = sw1;
    assign display_song = song_num;
    assign display_playing = play;
    wire chords_enabled = (song_num == 2'd0);
    wire adsr_enabled = (song_num == 2'd2);
    wire reverse_mode;
    wire reverse_mode_d;
    
    //REVERSE INSTANCE
    assign reverse_mode_d = b0 ? ~reverse_mode : reverse_mode;

    dffr #(.WIDTH(1)) reverse_mode_ff (
        .clk(clk),
        .r(reset | reset_player),
        .d(reverse_mode_d),
        .q(reverse_mode)
    );

    wire b0_delayed;
    dffr #(.WIDTH(1)) b0_delay_ff (
        .clk(clk),
        .r(reset),
        .d(b0),
        .q(b0_delayed)
    );

    //SONG READER INSTANCE
    wire song_reader_reset = reset | reset_player | b0_delayed;

    wire generate_next_sample;
    wire generate_next_sample0;
    wire beat;

    beat_generator #(.WIDTH(10), .STOP(BEAT_COUNT)) beat_gen_inst (
        .clk(clk),
        .reset(reset | reset_player),
        .en(generate_next_sample),
        .beat(beat)
    );
    
    wire [5:0] rom_note;
    wire [5:0] rom_duration;
    wire rom_new_note;

    song_reader_reverse song_reader_inst (
        .clk(clk),
        .reset(song_reader_reset),
        .play(play),
        .song(song_num),
        .beat(beat),
        .reverse_play(reverse_mode),
        .fast_forward(fast_forward),
        .song_done(song_done),
        .note(rom_note),
        .duration(rom_duration),
        .new_note(rom_new_note)
    );

    // for note display
    assign note_advance = rom_new_note & ~reverse_mode;
    assign note_reverse = rom_new_note & reverse_mode;
    
    // CHORDS
    wire [5:0] note_to_play = rom_note;
    wire [5:0] duration_raw = rom_duration;
    wire load_new_note = rom_new_note;
    wire [5:0] duration_for_note = fast_forward ? ((duration_raw > 6'd1) ? (duration_raw >> 1) : 6'd1) : duration_raw;
    wire note_done_chords;
    
    wire [15:0] sample_chords;
    wire ready_chords;

    chords chords_inst (
        .clk(clk),
        .reset(reset | reset_player),
        .play_enable(play),
        .note_to_load(note_to_play),
        .duration(duration_for_note),
        .load_new_note(load_new_note),
        .beat(beat),
        .generate_next_sample(generate_next_sample),
        .note_done(note_done_chords),
        .final_sample(sample_chords),
        .sample_ready(ready_chords)
    );
    
    //HARMONICS
    wire note_done_harm;
    wire [1:0] instrument_sel = (song_num == 2'd1) ? 2'd0 : (song_num == 2'd2) ? 2'd1 : (song_num == 2'd3) ? 2'd3 : 2'd0;
    
    wire [15:0] sample_harm;
    wire ready_harm;

    harmonic_note_player harmonic_inst (
        .clk(clk),
        .reset(reset | reset_player),
        .play_enable(play),
        .note_to_load(note_to_play),
        .duration_to_load(duration_for_note),
        .load_new_note(load_new_note),
        .done_with_note(note_done_harm),
        .beat(beat),
        .generate_next_sample(generate_next_sample),
        .instrument(instrument_sel),
        .sample_out(sample_harm),
        .new_sample_ready(ready_harm)
    );
    
    //ADSR
    wire [15:0] envelope_out;
    wire adsr_play_enable = play && adsr_enabled && !note_done_harm;

    adsr_envelope adsr_inst (
        .clk(clk),
        .reset(reset | reset_player | load_new_note),
        .play_enable(adsr_play_enable),
        .beat(beat),
        .attack(8'd20),
        .decay(8'd15),
        .sustain(8'd160),
        .released(8'd25),
        .envelope_out(envelope_out)
    );

    wire signed [15:0] harm_p1;
    wire signed [15:0] env_p1;
    wire ready_harm_p1;

    dffr #(.WIDTH(16)) adsr_harm_ff1(.clk(clk),.r(reset | reset_player),.d(sample_harm), .q(harm_p1));
    dffr #(.WIDTH(16)) adsr_env_ff1 (.clk(clk),.r(reset | reset_player),.d(envelope_out), .q(env_p1));
    dffr adsr_rdy_ff1 (.clk(clk),.r(reset | reset_player),.d(ready_harm), .q(ready_harm_p1));

    wire signed [31:0] adsr_product_raw = harm_p1 * env_p1;
    wire signed [31:0] adsr_product_p2;
    wire ready_harm_p2;

    dffr #(.WIDTH(32)) adsr_prod_ff(.clk(clk),.r(reset | reset_player),.d(adsr_product_raw),.q(adsr_product_p2));
    dffr adsr_rdy_ff2 (.clk(clk),.r(reset | reset_player),.d(ready_harm_p1), .q(ready_harm_p2));

    wire signed [15:0] sample_with_adsr = adsr_product_p2[30:15];
    wire ready_harm_adsr  = ready_harm_p2;

    wire [15:0] note_sample0 = chords_enabled ? sample_chords : adsr_enabled ? sample_with_adsr : sample_harm;

    wire sample_ready0 = chords_enabled ? ready_chords : adsr_enabled ? ready_harm_adsr : ready_harm;
    wire note_done_for_ai = chords_enabled ? note_done_chords : note_done_harm;
    
    //EXTENSION - AI EMOTION ANALYZER
    wire [1:0] emotion_code;
    wire [7:0] emotion_conf;
    wire emotion_ready;
    wire buffer_full;

    ai_emotion_analyzer ai_emo_inst (
        .clk(clk),
        .reset(reset | reset_player),
        .enable_ai(ai_mode),
        .note_played(note_to_play),
        .load_new_note(load_new_note),
        .emotion_code(emotion_code),
        .emotion_confidence(emotion_conf),
        .emotion_ready(emotion_ready),
        .buffer_full(buffer_full)
    );

    wire [1:0] emotion_latched;
    wire [7:0] conf_latched;
    
    dffre #(2) emo_latch (
        .clk(clk),
        .r(reset | reset_player),
        .en(emotion_ready),
        .d(emotion_code),
        .q(emotion_latched)
    );
    dffre #(8) conf_latch (
        .clk(clk),
        .r(reset | reset_player),
        .en(emotion_ready),
        .d(emotion_conf),
        .q(conf_latched)
    );

    assign emotion_out = emotion_latched;
    assign emotion_conf_out = conf_latched;
    assign emotion_valid = emotion_ready;
    assign ai_buffer_full = buffer_full;

    wire [15:0] note_sample;
    wire note_sample_ready;

    dffr #(.WIDTH(16)) sample_pipe (.clk(clk), .r(reset), .d(note_sample0), .q(note_sample));
    dffr ready_pipe (.clk(clk), .r(reset), .d(sample_ready0), .q(note_sample_ready));
    dffr gen_next_pipe(.clk(clk), .r(reset), .d(generate_next_sample0), .q(generate_next_sample));

    wire [15:0] sample_out0;

    codec_conditioner codec_inst (
        .clk(clk),
        .reset(reset),
        .new_sample_in(note_sample),
        .latch_new_sample_in(note_sample_ready),
        .generate_next_sample(generate_next_sample0),
        .new_frame(new_frame),
        .valid_sample(sample_out0)
    );

    dffr nsg_pipe (.clk(clk), .r(reset), .d(generate_next_sample0), .q(new_sample_generated));
    assign sample_out = sample_out0;

endmodule
