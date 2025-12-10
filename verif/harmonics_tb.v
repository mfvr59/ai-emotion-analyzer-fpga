`timescale 1ns/1ps
module harmonics_tb();
    reg clk;
    reg reset;
    reg play_enable;
    reg generate_next_sample;
    reg note_done;
    reg [1:0] instrument;
    reg [19:0] step_size;
    wire signed [15:0] sample_out;
    wire sample_ready;
    reg signed [15:0] inst0_a, inst0_b;
    reg signed [15:0] inst1_a, inst2_a, inst3_a;
    reg signed [15:0] mute_sample;
    reg [1:0] cap_count;
    reg failed_mute;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        generate_next_sample = 0;
        #40;
        forever #20 generate_next_sample = ~generate_next_sample;
    end

    harmonics dut (.clk(clk), .reset(reset), .play_enable(play_enable), .generate_next_sample(generate_next_sample), .step_size(step_size), .instrument(instrument), .note_done(note_done), .sample_out(sample_out), .sample_ready(sample_ready));

    initial begin
        reset = 1;
        play_enable = 0;
        note_done = 0;
        instrument = 0;
        step_size = 5000;

        inst0_a = 0;
        inst0_b = 0;
        inst1_a = 0;
        inst2_a = 0;
        inst3_a = 0;
        mute_sample = 0;

        cap_count = 0;
        failed_mute = 0;

        #100;
        reset = 0;
        play_enable = 1;
        
        //test 0
        $display("Testing instrument 0");
        instrument = 0;
        cap_count = 0;
        inst0_a = 0;
        inst0_b = 0;

        repeat (400) begin
            #10;
            if (sample_ready) begin
                if (cap_count == 0) begin
                    inst0_a = sample_out;
                    cap_count = 1;
                end else if (cap_count == 1) begin
                    inst0_b = sample_out;
                    cap_count = 2;
                end
            end
        end

        if (inst0_a != 0 && inst0_b != 0 && inst0_a != inst0_b)
            $display("PASS");
        else
            $display("FAIL");
        
        //test 0
        $display("Testing instrument 1");
        instrument = 1;
        inst1_a = 0;
        repeat (400) begin
            #10;
            if (sample_ready && inst1_a == 0)
                inst1_a = sample_out;
        end
        if (inst1_a != 0)
            $display("PASS");
        else
            $display("FAIL");
        
        //test 2
        $display("Testing instrument 2");
        instrument = 2;
        inst2_a = 0;
        repeat (400) begin
            #10;
            if (sample_ready && inst2_a == 0)
                inst2_a = sample_out;
        end
        if (inst2_a != 0)
            $display("PASS");
        else
            $display("FAIL");
        
        //test 3
        $display("Testing instrument 3");
        instrument = 3;
        inst3_a = 0;
        repeat (400) begin
            #10;
            if (sample_ready && inst3_a == 0)
                inst3_a = sample_out;
        end
        if (inst3_a != 0)
            $display("PASS");
        else
            $display("FAIL");
    
        //test 4
        $display("Cross-check instruments");
        if (inst0_a != inst1_a || inst0_a != inst2_a || inst0_a != inst3_a)
            $display("PASS");
        else
            $display("FAIL");
        
        //test 5
        $display("Testing mute");
        note_done = 1;
        failed_mute = 0;
        #100;
        repeat (400) begin
            #10;
            if (sample_ready) begin
                mute_sample = sample_out;
                if (mute_sample != 0)
                    failed_mute = 1;
            end
        end
        if (!failed_mute)
            $display("PASS");
        else
            $display("FAIL");


        $display("All harmonics tests completed");
        #200;
    end

endmodule
