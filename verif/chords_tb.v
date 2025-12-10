`timescale 1ns/1ps
module chords_tb();
    reg clk;
    reg reset;
    reg play_enable;
    reg [5:0] note_to_load;
    reg [5:0] duration;
    reg load_new_note;
    reg generate_next_sample;
    wire note_done;
    wire signed [15:0] final_sample;
    wire sample_ready;
    wire beat;

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    beat_generator #(.WIDTH(10), .STOP(100)) bg (.clk(clk), .reset(reset), .en(1'b1), .beat(beat));
    chords dut (.clk(clk), .reset(reset), .play_enable(play_enable), .note_to_load(note_to_load), .duration(duration), .load_new_note(load_new_note), .beat(beat), .generate_next_sample(generate_next_sample), .note_done(note_done), .final_sample(final_sample), .sample_ready(sample_ready));

    initial begin
        generate_next_sample = 1'b0;
        #40;
        forever #20 generate_next_sample = ~generate_next_sample;
    end

    initial begin
        reset = 1'b1;
        play_enable = 1'b0;
        note_to_load = 6'd0;
        duration = 6'd0;
        load_new_note = 1'b0;
        #100;
        reset = 1'b0;
        play_enable = 1'b1;
        #100;

        $display("Test 1: Single note of duration 1");
        duration = 6'd1;
        note_to_load = 6'd28;
        load_new_note = 1'b1;  
        #20;
        load_new_note = 1'b0;
        repeat(50) #10;
        $display("Test 1 at middle: note_done=%b sample_ready=%b final_sample=%0d", note_done, sample_ready, final_sample);
        repeat(1000) #10;
        $display("note_done=%b sample_ready=%b final_sample=%0d", note_done, sample_ready, final_sample);

        $display("Test 2: Load note 0 (should be ignored)");
        duration = 6'd8;
        note_to_load = 6'd0;  //ignore
        load_new_note = 1'b1;  
        #20;
        load_new_note = 1'b0;
        repeat(500) #10;
        $display("After zero-note, note_done=%b final_sample=%0d", note_done, final_sample);

        $display("Test 3: Staggered chord");
        reset = 1'b1; 
        #50;
        reset = 1'b0; 
        #50;
        play_enable = 1'b1;

        duration = 6'd20;
        note_to_load = 6'd25;
        load_new_note = 1'b1;  
        #20;
        load_new_note = 1'b0;
        repeat(200) #10;
        duration = 6'd12;
        note_to_load = 6'd30;
        load_new_note = 1'b1;  
        #20;
        load_new_note = 1'b0;
        repeat(200) #10;
        duration = 6'd6;
        note_to_load = 6'd34;
        load_new_note = 1'b1;  
        #20;
        load_new_note = 1'b0;
        repeat(1500) #10;
        $display("End staggered chord: note_done=%b final_sample=%0d",note_done, final_sample);

        $display("Test 4: 3 voices full, attempt 4th load");
        reset = 1'b1; 
        #50;
        reset = 1'b0; 
        #50;
        play_enable = 1'b1;
        duration = 6'd16;
        note_to_load = 6'd20;
        load_new_note = 1'b1;  
        #20;
        load_new_note = 1'b0;
        duration = 6'd16;
        note_to_load = 6'd24;
        load_new_note = 1'b1;  
        #20;
        load_new_note = 1'b0;
        duration = 6'd16;
        note_to_load = 6'd27;
        load_new_note = 1'b1;  
        #20;
        load_new_note = 1'b0;
        repeat(500) #10;
        duration = 6'd10;
        note_to_load = 6'd32;
        load_new_note = 1'b1;  
        #20;
        load_new_note = 1'b0;
        repeat(1500) #10;
        $display("After extra load: note_done=%b final_sample=%0d", note_done, final_sample);

        $display("Test 5: Reset mid-chord");
        reset = 1'b1; #50;
        reset = 1'b0; #50;
        play_enable = 1'b1;
        duration = 6'd18; note_to_load = 6'd40; load_new_note = 1'b1; #20; load_new_note = 1'b0;
        duration = 6'd18; note_to_load = 6'd44; load_new_note = 1'b1; #20; load_new_note = 1'b0;
        duration = 6'd18; note_to_load = 6'd47; load_new_note = 1'b1; #20; load_new_note = 1'b0;
        repeat(800) #10;
        reset = 1'b1;
        #100;
        reset = 1'b0;
        repeat(800) #10;
        $display("After reset: note_done=%b final_sample=%0d", note_done, final_sample);

        $display("All tests completed");
        #500;
    end

endmodule

endmodule
