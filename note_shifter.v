`timescale 1ns/1ps
module note_shifter(
    input  wire clk,
    input  wire rst,
    input  wire note_advance,
    input  wire note_reverse,
    input  wire [1:0] song_sel,

    // lvl0 = top row, lvl1 = middle, lvl2 = bottom
    // columns: 4=prev2, 3=prev1, 2=curr, 1=next1, 0=next2
    output wire [15:0] lvl0_note_0, lvl0_note_1, lvl0_note_2, lvl0_note_3, lvl0_note_4,
    output wire [15:0] lvl1_note_0, lvl1_note_1, lvl1_note_2, lvl1_note_3, lvl1_note_4,
    output wire [15:0] lvl2_note_0, lvl2_note_1, lvl2_note_2, lvl2_note_3, lvl2_note_4,

    // [4]=prev2, [3]=prev1, [2]=curr, [1]=next1, [0]=next2
    output wire [4:0] valid
);

    localparam [15:0] BLANK = 16'h0000;

    //---------------------------------------------------------
    // per-song block ranges
    //---------------------------------------------------------
    reg [8:0] song_start_block_idx;
    reg [8:0] song_end_block_idx;

    always @(*) begin
        case(song_sel)
            2'd0: begin song_start_block_idx = 9'd0;   song_end_block_idx = 9'd15;  end
            2'd1: begin song_start_block_idx = 9'd16;   song_end_block_idx = 9'd47; end
            2'd2: begin song_start_block_idx = 9'd48;  song_end_block_idx = 9'd63; end
            default: begin song_start_block_idx = 9'd64; song_end_block_idx = 9'd95; end
        endcase
    end
    //---------------------------------------------------------
    // song change detection
    //---------------------------------------------------------
    wire [1:0] prev_song_sel;
    wire       song_changed = (prev_song_sel != song_sel);

    dffr #(.WIDTH(2)) ff_song_sel (
        .clk(clk), .r(rst),
        .d(song_sel),
        .q(prev_song_sel)
    );

    //---------------------------------------------------------
    // CURRENT block index register
    //---------------------------------------------------------
    wire [8:0] curr_block_idx_q;
    wire [8:0] curr_block_idx_d;

    dffr #(.WIDTH(9)) ff_curr_block_idx (
        .clk(clk), .r(rst),
        .d(curr_block_idx_d),
        .q(curr_block_idx_q)
    );

    //---------------------------------------------------------
    // derive raw neighbor block indexes
    //---------------------------------------------------------
    wire [8:0] prev1_raw = curr_block_idx_q - 9'd1;
    wire [8:0] prev2_raw = curr_block_idx_q - 9'd2;
    wire [8:0] next1_raw = curr_block_idx_q + 9'd1;
    wire [8:0] next2_raw = curr_block_idx_q + 9'd2;

    //---------------------------------------------------------
    // clamp to song range
    //---------------------------------------------------------
    wire [8:0] prev1_block_idx =
        (prev1_raw < song_start_block_idx) ? song_start_block_idx : prev1_raw;

    wire [8:0] prev2_block_idx =
        (prev2_raw < song_start_block_idx) ? song_start_block_idx : prev2_raw;

    wire [8:0] next1_block_idx =
        (next1_raw > song_end_block_idx) ? song_end_block_idx : next1_raw;

    wire [8:0] next2_block_idx =
        (next2_raw > song_end_block_idx) ? song_end_block_idx : next2_raw;

    //---------------------------------------------------------
    // read blocks (now the inspector just reads, no navigation)
    //---------------------------------------------------------
    wire [15:0] curr_n0, curr_n1, curr_n2, curr_n3;
    wire [2:0]  curr_block_size;

    top_block_reader R_CURR(
        .clk(clk), .rst(rst),
        .block_idx_in(curr_block_idx_q),
        .song_sel(song_sel),
        .note0(curr_n0), .note1(curr_n1), .note2(curr_n2), .note3(curr_n3),
        .block_size(curr_block_size)
    );

    wire curr_valid = (curr_block_size != 3'd0);
    wire [2:0] curr_real_notes = curr_block_size ? (curr_block_size - 1) : 3'd0;

    // PREV1
    wire [15:0] prev1_n0, prev1_n1, prev1_n2, prev1_n3;
    wire [2:0]  prev1_block_size;

    top_block_reader R_PREV1(
        .clk(clk), .rst(rst),
        .block_idx_in(prev1_block_idx),
        .song_sel(song_sel),
        .note0(prev1_n0), .note1(prev1_n1),
        .note2(prev1_n2), .note3(prev1_n3),
        .block_size(prev1_block_size)
    );

    wire prev1_valid = (prev1_block_size != 3'd0) && !song_changed;
    wire [2:0] prev1_real_notes = prev1_block_size ? (prev1_block_size - 1) : 3'd0;

    // PREV2
    wire [15:0] prev2_n0, prev2_n1, prev2_n2, prev2_n3;
    wire [2:0]  prev2_block_size;

    top_block_reader R_PREV2(
        .clk(clk), .rst(rst),
        .block_idx_in(prev2_block_idx),
        .song_sel(song_sel),
        .note0(prev2_n0), .note1(prev2_n1),
        .note2(prev2_n2), .note3(prev2_n3),
        .block_size(prev2_block_size)
    );

    wire prev2_valid = prev1_valid && (prev2_block_size != 3'd0) && !song_changed;
    wire [2:0] prev2_real_notes = prev2_block_size ? (prev2_block_size - 1) : 3'd0;

    // NEXT1
    wire [15:0] next1_n0, next1_n1, next1_n2, next1_n3;
    wire [2:0]  next1_block_size;

    top_block_reader R_NEXT1(
        .clk(clk), .rst(rst),
        .block_idx_in(next1_block_idx),
        .song_sel(song_sel),
        .note0(next1_n0), .note1(next1_n1),
        .note2(next1_n2), .note3(next1_n3),
        .block_size(next1_block_size)
    );

    wire next1_valid = (next1_block_size != 3'd0) && !song_changed;
    wire [2:0] next1_real_notes = next1_block_size ? (next1_block_size - 1) : 3'd0;

    // NEXT2
    wire [15:0] next2_n0, next2_n1, next2_n2, next2_n3;
    wire [2:0]  next2_block_size;

    top_block_reader R_NEXT2(
        .clk(clk), .rst(rst),
        .block_idx_in(next2_block_idx),
        .song_sel(song_sel),
        .note0(next2_n0), .note1(next2_n1),
        .note2(next2_n2), .note3(next2_n3),
        .block_size(next2_block_size)
    );

    wire next2_valid = next1_valid && (next2_block_size != 3'd0) && !song_changed;
    wire [2:0] next2_real_notes = next2_block_size ? (next2_block_size - 1) : 3'd0;

    //---------------------------------------------------------
    // audio index
    //---------------------------------------------------------
    wire [2:0] audio_idx_q;
    wire [2:0] audio_idx_d;

    dffr #(.WIDTH(3)) ff_audio_idx (
        .clk(clk), .r(rst | song_changed),
        .d(audio_idx_d),
        .q(audio_idx_q)
    );

    wire last_note_of_block  = (curr_real_notes!=0) && (audio_idx_q==curr_real_notes-1);
    wire first_note_of_block = (audio_idx_q==0);

    wire block_advance =
        note_advance && !note_reverse && next1_valid && last_note_of_block;

    wire block_reverse =
        note_reverse && !note_advance && prev1_valid && first_note_of_block;

    wire [2:0] audio_idx_on_block_reverse =
        (prev1_real_notes==0)? 3'd0 : (prev1_real_notes-1);

    wire signed [3:0] audio_delta =
    (note_advance && !note_reverse)                      ? 4'sd1  :
    (note_reverse && !note_advance && audio_idx_q > 0)   ? -4'sd1 :
                                                            4'sd0;

    assign audio_idx_d =
    (block_advance || rst || song_changed) ? 3'd0 :
    (block_reverse)                        ? audio_idx_on_block_reverse :
                                             audio_idx_q + audio_delta;

    //---------------------------------------------------------
    // block index update
    //---------------------------------------------------------
    reg [8:0] next_idx;
    always @(*) begin
        case({rst, song_changed, block_advance, block_reverse})
            4'b1000: next_idx = song_start_block_idx;
            4'b0100: next_idx = song_start_block_idx;
            4'b0010: next_idx = next1_block_idx;
            4'b0001: next_idx = prev1_block_idx;
            default: next_idx = curr_block_idx_q;
        endcase
    end
    
    assign curr_block_idx_d = next_idx;

    //---------------------------------------------------------
    // valid bits
    //---------------------------------------------------------
    wire [4:0] valid_d;
    wire [4:0] valid_q;

    assign valid_d = { prev2_valid, prev1_valid, curr_valid, next1_valid, next2_valid};

    dffr #(.WIDTH(5)) ff_valid (.clk(clk), .r(rst), .d(valid_d), .q(valid_q));

    assign valid = valid_q;

    //---------------------------------------------------------
    // map into display grid
    //---------------------------------------------------------

    wire [15:0] lvl0_0_d, lvl0_1_d, lvl0_2_d, lvl0_3_d, lvl0_4_d;
    wire [15:0] lvl1_0_d, lvl1_1_d, lvl1_2_d, lvl1_3_d, lvl1_4_d;
    wire [15:0] lvl2_0_d, lvl2_1_d, lvl2_2_d, lvl2_3_d, lvl2_4_d;

    // PREV2
    assign lvl0_0_d = (prev2_valid && prev2_real_notes>=1)? prev2_n0:BLANK;
    assign lvl1_0_d = (prev2_valid && prev2_real_notes>=2)? prev2_n1:BLANK;
    assign lvl2_0_d = (prev2_valid && prev2_real_notes>=3)? prev2_n2:BLANK;
    // PREV1
    assign lvl0_1_d = (prev1_valid && prev1_real_notes>=1)? prev1_n0:BLANK;
    assign lvl1_1_d = (prev1_valid && prev1_real_notes>=2)? prev1_n1:BLANK;
    assign lvl2_1_d = (prev1_valid && prev1_real_notes>=3)? prev1_n2:BLANK;
    // CURR
    assign lvl0_2_d = (curr_valid && curr_real_notes>=1)? curr_n0:BLANK;
    assign lvl1_2_d = (curr_valid && curr_real_notes>=2)? curr_n1:BLANK;
    assign lvl2_2_d = (curr_valid && curr_real_notes>=3)? curr_n2:BLANK;
    // NEXT1
    assign lvl0_3_d = (next1_valid && next1_real_notes>=1)? next1_n0:BLANK;
    assign lvl1_3_d = (next1_valid && next1_real_notes>=2)? next1_n1:BLANK;
    assign lvl2_3_d = (next1_valid && next1_real_notes>=3)? next1_n2:BLANK;
    // NEXT2
    assign lvl0_4_d = (next2_valid && next2_real_notes>=1)? next2_n0:BLANK;
    assign lvl1_4_d = (next2_valid && next2_real_notes>=2)? next2_n1:BLANK;
    assign lvl2_4_d = (next2_valid && next2_real_notes>=3)? next2_n2:BLANK;

    // Row 0
    dffr #(.WIDTH(16)) f_l00 (.clk(clk), .r(rst), .d(lvl0_0_d), .q(lvl0_note_0));
    dffr #(.WIDTH(16)) f_l01 (.clk(clk), .r(rst), .d(lvl0_1_d), .q(lvl0_note_1));
    dffr #(.WIDTH(16)) f_l02 (.clk(clk), .r(rst), .d(lvl0_2_d), .q(lvl0_note_2));
    dffr #(.WIDTH(16)) f_l03 (.clk(clk), .r(rst), .d(lvl0_3_d), .q(lvl0_note_3));
    dffr #(.WIDTH(16)) f_l04 (.clk(clk), .r(rst), .d(lvl0_4_d), .q(lvl0_note_4));

    // Row 1
    dffr #(.WIDTH(16)) f_l10 (.clk(clk), .r(rst), .d(lvl1_0_d), .q(lvl1_note_0));
    dffr #(.WIDTH(16)) f_l11 (.clk(clk), .r(rst), .d(lvl1_1_d), .q(lvl1_note_1));
    dffr #(.WIDTH(16)) f_l12 (.clk(clk), .r(rst), .d(lvl1_2_d), .q(lvl1_note_2));
    dffr #(.WIDTH(16)) f_l13 (.clk(clk), .r(rst), .d(lvl1_3_d), .q(lvl1_note_3));
    dffr #(.WIDTH(16)) f_l14 (.clk(clk), .r(rst), .d(lvl1_4_d), .q(lvl1_note_4));

    // Row 2
    dffr #(.WIDTH(16)) f_l20 (.clk(clk), .r(rst), .d(lvl2_0_d), .q(lvl2_note_0));
    dffr #(.WIDTH(16)) f_l21 (.clk(clk), .r(rst), .d(lvl2_1_d), .q(lvl2_note_1));
    dffr #(.WIDTH(16)) f_l22 (.clk(clk), .r(rst), .d(lvl2_2_d), .q(lvl2_note_2));
    dffr #(.WIDTH(16)) f_l23 (.clk(clk), .r(rst), .d(lvl2_3_d), .q(lvl2_note_3));
    dffr #(.WIDTH(16)) f_l24 (.clk(clk), .r(rst), .d(lvl2_4_d), .q(lvl2_note_4));

endmodule
