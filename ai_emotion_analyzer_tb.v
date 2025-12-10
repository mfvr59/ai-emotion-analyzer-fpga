`timescale 1ns/1ps
module ai_emotion_test_songs();
    reg clk;
    reg reset;
    reg enable_ai;
    reg [5:0] note_played;
    reg load_new_note;

    wire [1:0] emotion_code;
    wire [7:0] emotion_confidence;
    wire emotion_ready;
    wire buffer_full;

    reg [4:0] idx;

    reg [5:0] song0_notes[0:15];
    reg [5:0] song1_notes[0:15];
    reg [5:0] song2_notes[0:15];
    reg [5:0] song3_notes[0:15];

    ai_emotion_analyzer dut(
        .clk(clk), .reset(reset), .enable_ai(enable_ai),
        .note_played(note_played), .load_new_note(load_new_note),
        .emotion_code(emotion_code), .emotion_confidence(emotion_confidence),
        .emotion_ready(emotion_ready), .buffer_full(buffer_full)
    );

    always #5 clk = ~clk;

    initial begin
        song0_notes[0]  = 6'd30;
        song0_notes[1]  = 6'd32;
        song0_notes[2]  = 6'd34;
        song0_notes[3]  = 6'd35;
        song0_notes[4]  = 6'd37;
        song0_notes[5]  = 6'd39;
        song0_notes[6]  = 6'd41;
        song0_notes[7]  = 6'd42;
        song0_notes[8]  = 6'd30;
        song0_notes[9]  = 6'd32;
        song0_notes[10] = 6'd34;
        song0_notes[11] = 6'd35;
        song0_notes[12] = 6'd37;
        song0_notes[13] = 6'd39;
        song0_notes[14] = 6'd41;
        song0_notes[15] = 6'd42;

        song1_notes[0]  = 6'd59;
        song1_notes[1]  = 6'd57;
        song1_notes[2]  = 6'd56;
        song1_notes[3]  = 6'd54;
        song1_notes[4]  = 6'd52;
        song1_notes[5]  = 6'd51;
        song1_notes[6]  = 6'd49;
        song1_notes[7]  = 6'd47;
        song1_notes[8]  = 6'd59;
        song1_notes[9]  = 6'd57;
        song1_notes[10] = 6'd56;
        song1_notes[11] = 6'd54;
        song1_notes[12] = 6'd52;
        song1_notes[13] = 6'd51;
        song1_notes[14] = 6'd49;
        song1_notes[15] = 6'd47;

        song2_notes[0]  = 6'd59;
        song2_notes[1]  = 6'd58;
        song2_notes[2]  = 6'd57;
        song2_notes[3]  = 6'd56;
        song2_notes[4]  = 6'd55;
        song2_notes[5]  = 6'd54;
        song2_notes[6]  = 6'd53;
        song2_notes[7]  = 6'd52;
        song2_notes[8]  = 6'd51;
        song2_notes[9]  = 6'd50;
        song2_notes[10] = 6'd49;
        song2_notes[11] = 6'd48;
        song2_notes[12] = 6'd47;
        song2_notes[13] = 6'd46;
        song2_notes[14] = 6'd45;
        song2_notes[15] = 6'd44;

        song3_notes[0]  = 6'd48;
        song3_notes[1]  = 6'd52;
        song3_notes[2]  = 6'd55;
        song3_notes[3]  = 6'd45;
        song3_notes[4]  = 6'd48;
        song3_notes[5]  = 6'd52;
        song3_notes[6]  = 6'd41;
        song3_notes[7]  = 6'd45;
        song3_notes[8]  = 6'd48;
        song3_notes[9]  = 6'd43;
        song3_notes[10] = 6'd47;
        song3_notes[11] = 6'd50;
        song3_notes[12] = 6'd48;
        song3_notes[13] = 6'd52;
        song3_notes[14] = 6'd55;
        song3_notes[15] = 6'd45;
    end

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        enable_ai = 1'b0;
        note_played = 6'd0;
        load_new_note = 1'b0;

        #50;
        reset = 1'b0;
        #20;

        $display("Song 0 : happy");

        for (idx = 0; idx < 16; idx = idx + 1) begin
            note_played   = song0_notes[idx];
            load_new_note = 1'b1;
            #10;
            load_new_note = 1'b0;
            #10;
        end

        enable_ai = 1'b1;
        wait (emotion_ready == 1'b1);
        #20;
        $display("Results for song 0");
        $display("emotion_code = %b", emotion_code);
        $display("emotion_confidence = %0d", emotion_confidence);
        if (emotion_code == 2'b01)
            $display("PASS");
        else
            $display("FAIL");

        enable_ai = 1'b0;
        #50;
        reset = 1'b1;
        #50;
        reset = 1'b0;
        #20;

        $display("Song1: sad");

        for (idx = 0; idx < 16; idx = idx + 1) begin
            note_played   = song1_notes[idx];
            load_new_note = 1'b1;
            #10;
            load_new_note = 1'b0;
            #10;
        end

        enable_ai = 1'b1;
        wait (emotion_ready == 1'b1);
        #20;
        $display("Results for song 1");
        $display("emotion_code = %b", emotion_code);
        $display("emotion_confidence = %0d", emotion_confidence);
        if (emotion_code == 2'b10)
            $display("PASS");
        else
            $display("FAIL");

        enable_ai = 1'b0;
        #50;
        reset = 1'b1;
        #50;
        reset = 1'b0;
        #20;

        $display("Song2: neutral");

        for (idx = 0; idx < 16; idx = idx + 1) begin
            note_played   = song2_notes[idx];
            load_new_note = 1'b1;
            #10;
            load_new_note = 1'b0;
            #10;
        end

        enable_ai = 1'b1;
        wait (emotion_ready == 1'b1);
        #20;
        $display("emotion_code = %b", emotion_code);
        $display("emotion_confidence = %0d", emotion_confidence);
        if (emotion_code == 2'b00)
            $display("PASS");
        else
            $display("FAIL");

        enable_ai = 1'b0;
        #50;
        reset = 1'b1;
        #50;
        reset = 1'b0;
        #20;

        $display("SONG 3: expect HAPPY (01)");

        for (idx = 0; idx < 16; idx = idx + 1) begin
            note_played   = song3_notes[idx];
            load_new_note = 1'b1;
            #10;
            load_new_note = 1'b0;
            #10;
        end

        enable_ai = 1'b1;
        wait (emotion_ready == 1'b1);
        #20;
        $display("Results for song3");
        $display("emotion_code = %b", emotion_code);
        $display("emotion_confidence = %0d", emotion_confidence);
        if (emotion_code == 2'b01)
            $display("PASS");
        else
            $display("FAIL");

        $display("All song tests finished.");
        #100;
    end
endmodule
