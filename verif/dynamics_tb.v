`timescale 1ns/1ps

module dynamics_tb();
    reg clk;
    reg reset;
    reg play_enable;
    reg [7:0] attack, decay, sustain, released;
    wire [15:0] envelope_out;
    wire beat;

    // Clock generation: 10ns period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // beat generator
    beat_generator #(.WIDTH(10), .STOP(100)) bg (
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .beat(beat)
    );

    // ADSR module
    adsr_envelope dut (
        .clk(clk),
        .reset(reset),
        .play_enable(play_enable),
        .beat(beat),
        .attack(attack),
        .decay(decay),
        .sustain(sustain),
        .released(released),
        .envelope_out(envelope_out)
    );

    // Test sequence
    initial begin
        // Initialize
        reset = 1'b1;
        play_enable = 1'b0;
        attack = 8'd10;
        decay = 8'd10;
        sustain = 8'd128;
        released = 8'd20;
        #50;
        reset = 1'b0;

        // Test 1: Trigger note
        $display("Test 1: Trigger note");
        play_enable = 1'b1;
        repeat(50) begin #10; $display("t=%0t envelope_out=%0d", $time, envelope_out); end

        // Test 2: Release note
        $display("Test 2: Release note (testing release phase)");
        play_enable = 1'b0;
        repeat(50) begin #10; $display("t=%0t envelope_out=%0d", $time, envelope_out); end

        // Test 3: Retrigger note
        $display("Test 3: Retrigger note quickly");
        play_enable = 1'b1;
        repeat(20) begin #10; $display("t=%0t envelope_out=%0d", $time, envelope_out); end
        play_enable = 1'b0;
        repeat(20) begin #10; $display("t=%0t envelope_out=%0d", $time, envelope_out); end

        // Test 4: Changing ADSR parameters
        $display("Test 4: Change ADSR parameters mid-run");
        play_enable = 1'b1;
        attack = 8'd5;
        decay = 8'd5;
        sustain = 8'd200;
        released = 8'd10;
        repeat(50) begin #10; $display("t=%0t envelope_out=%0d", $time, envelope_out); end

        // Test 5: Change attack mid-attack
        $display("Test 5: Change attack during attack");
        play_enable = 1'b1;
        attack = 8'd40;
        decay = 8'd10;
        sustain = 8'd100;
        released = 8'd20;
        repeat(10) begin #10; $display("t=%0t envelope_out=%0d attack=%0d", $time, envelope_out, attack); end
        attack = 8'd5;
        $display("Attack changed to 5");
        repeat(20) begin #10; $display("t=%0t envelope_out=%0d attack=%0d", $time, envelope_out, attack); end

        // Test 6: Change decay and sustain during decay
        $display("Test 6: Change decay and sustain during decay");
        play_enable = 1'b1;
        attack = 8'd5;
        decay = 8'd40;
        sustain = 8'd50;
        released = 8'd20;
        repeat(10) begin #10; $display("t=%0t envelope_out=%0d decay=%0d sustain=%0d", $time, envelope_out, decay, sustain); end
        decay = 8'd2;
        sustain = 8'd200;
        $display("Decay changed to 2, sustain changed to 200");
        repeat(20) begin #10; $display("t=%0t envelope_out=%0d decay=%0d sustain=%0d", $time, envelope_out, decay, sustain); end

        // Test 7: Change release during release phase
        $display("Test 7: Change release during release phase");
        play_enable = 1'b1;
        attack = 8'd5;
        decay = 8'd5;
        sustain = 8'd128;
        released = 8'd40;
        repeat(20) begin #10; $display("t=%0t envelope_out=%0d release=%0d", $time, envelope_out, released); end
        play_enable = 1'b0;
        repeat(10) begin #10; $display("t=%0t envelope_out=%0d release=%0d", $time, envelope_out, released); end
        released = 8'd5;
        $display("Release changed to 5");
        repeat(20) begin #10; $display("t=%0t envelope_out=%0d release=%0d", $time, envelope_out, released); end

        $display("All tests completed");
        #500;
    end

endmodule

endmodule
