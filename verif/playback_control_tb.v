`timescale 1ns/1ps
module song_reader_reverse_tb();
    reg clk;
    reg reset;
    reg play;
    reg [1:0] song;
    wire beat;
    reg reverse_play;
    reg fast_forward;
    wire song_done;
    wire [5:0] note;
    wire [5:0] duration;
    wire new_note;
    reg [7:0] tests_passed;
    reg [7:0] tests_failed;
    reg [5:0] forward_notes [0:127];
    reg [5:0] reverse_notes [0:127];
    reg [6:0] forward_count;
    reg [6:0] reverse_count;
    reg [6:0] idx;
    reg mismatch;

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    beat_generator #(.WIDTH(10), .STOP(100)) bg (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .beat(beat)
    );

    song_reader_reverse dut (
        .clk(clk),
        .reset(reset),
        .play(play),
        .song(song),
        .beat(beat),
        .reverse_play(reverse_play),
        .fast_forward(fast_forward),
        .song_done(song_done),
        .note(note),
        .duration(duration),
        .new_note(new_note)
    );

    initial begin
        tests_passed = 0;
        tests_failed = 0;
        reset = 1'b1;
        play = 1'b0;
        song = 2'd0;
        reverse_play = 1'b0;
        fast_forward = 1'b0;
        forward_count = 0;
        reverse_count = 0;
        #100;
        reset = 1'b0;
        #50;

        // Test 1: Forward playback
        $display("Test 1: Forward playback - capturing notes");
        song = 2'd0;
        reverse_play = 1'b0;
        fast_forward = 1'b0;
        play = 1'b1;
        forward_count = 0;

        while (!song_done) begin
            if (new_note && note != 6'd0) begin
                forward_notes[forward_count] = note;
                forward_count = forward_count + 1;
            end
            #10;
        end

        $display("Captured %0d notes:", forward_count);
        idx = 0;
        while (idx < forward_count) begin
            idx = idx + 1;
        end

        if (song_done) begin
            $display("PASS");
            tests_passed = tests_passed + 1;
        end else begin
            $display("FAIL");
        end

        play = 1'b0;
        #200;

        // Test 2: Reverse playback
        $display("Test 2: Reverse playback - capturing notes");
        reset = 1'b1; 
        #50; 
        reset = 1'b0; 
        #50;

        song = 2'd0;
        reverse_play = 1'b1;
        fast_forward = 1'b0;
        play = 1'b1;
        reverse_count = 0;

        while (!song_done) begin
            if (new_note && note != 6'd0) begin
                reverse_notes[reverse_count] = note;
                reverse_count = reverse_count + 1;
            end
            #10;
        end

        $display("Captured %0d notes:", reverse_count);
        idx = 0;
        while (idx < reverse_count) begin
            idx = idx + 1;
        end

        if (song_done) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end

        play = 1'b0;
        #200;

        // Test 3: Verify exact reverse order
        $display("Test 3: Verify exact reverse order");

        if (forward_count != reverse_count) begin
            $display("FAIL");
        end else begin
            mismatch = 1'b0;
            idx = 0;
            while (idx < forward_count) begin
                if (forward_notes[idx] != reverse_notes[forward_count - 1 - idx]) begin
                    $display("FAIL: forward[%0d]=%0d != reverse[%0d]=%0d", idx, forward_notes[idx], forward_count-1-idx, reverse_notes[forward_count-1-idx]);
                    mismatch = 1'b1;
                end
                idx = idx + 1;
            end

            if (!mismatch) begin
                $display("PASS");
            end else begin
                $display("FAIL");
            end
        end

        // Test 4: Verify first/last note swap
        $display("Test 4: First/last note verification");
        $display("Forward first: %0d, Reverse last: %0d", forward_notes[0], reverse_notes[reverse_count-1]);
        $display("Forward last: %0d, Reverse first: %0d", forward_notes[forward_count-1], reverse_notes[0]);

        if (forward_notes[0] == reverse_notes[reverse_count-1] && forward_notes[forward_count-1] == reverse_notes[0]) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end

        // Test 5: Fast forward
        $display("Test 5: Fast forward playback");
        reset = 1'b1; #50; reset = 1'b0; #50;

        song = 2'd1;
        reverse_play = 1'b0;
        fast_forward = 1'b1;
        play = 1'b1;

        repeat(3500) #10;

        if (song_done) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end

        play = 1'b0;
        #200;

        // Test 6
        $display("Test 6: Reverse + fast forward");
        reset = 1'b1; #50; reset = 1'b0; #50;

        song = 2'd0;
        reverse_play = 1'b1;
        fast_forward = 1'b1;
        play = 1'b1;

        repeat(3500) #10;

        if (song_done) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        play = 1'b0;
        #700;
    end
endmodule
