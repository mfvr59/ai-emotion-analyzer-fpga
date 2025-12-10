`timescale 1ns/1ps
module note_shifter_tb();

    reg clk, rst;
    reg note_advance;
    reg note_reverse;
    reg [1:0] song_sel;

    // DUT outputs
    wire [15:0] lvl0_note_0, lvl0_note_1, lvl0_note_2, lvl0_note_3, lvl0_note_4;
    wire [15:0] lvl1_note_0, lvl1_note_1, lvl1_note_2, lvl1_note_3, lvl1_note_4;
    wire [15:0] lvl2_note_0, lvl2_note_1, lvl2_note_2, lvl2_note_3, lvl2_note_4;
    wire [4:0] valid;

    // Instantiate DUT
    note_shifter dut (
        .clk(clk),
        .rst(rst),
        .note_advance(note_advance),
        .note_reverse(note_reverse),
        .song_sel(song_sel),

        .lvl0_note_0(lvl0_note_0), .lvl0_note_1(lvl0_note_1),
        .lvl0_note_2(lvl0_note_2), .lvl0_note_3(lvl0_note_3),
        .lvl0_note_4(lvl0_note_4),

        .lvl1_note_0(lvl1_note_0), .lvl1_note_1(lvl1_note_1),
        .lvl1_note_2(lvl1_note_2), .lvl1_note_3(lvl1_note_3),
        .lvl1_note_4(lvl1_note_4),

        .lvl2_note_0(lvl2_note_0), .lvl2_note_1(lvl2_note_1),
        .lvl2_note_2(lvl2_note_2), .lvl2_note_3(lvl2_note_3),
        .lvl2_note_4(lvl2_note_4),

        .valid(valid)
    );

    // Actual rom (for printing)
    reg  [8:0] rom_addr;
    wire [15:0] rom_out;

    song_rom the_actual_rom(.clk(clk), .addr(rom_addr), .dout(rom_out));

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //-------------------------------------------------------
    // Print Window
    //-------------------------------------------------------
    task show_window;
        integer i;
        reg [8:0] start_addr;
        begin
            $display("----------------------------------------------------");

            $display("BLOCK INFO:");
            $display(" curr_block_idx = %0d", dut.curr_block_idx_q);
            $display(" curr_block_size= %0d", dut.curr_block_size);
            $display(" curr_real_notes= %0d", dut.curr_real_notes);
            $display(" audio_idx      = %0d / %0d", dut.audio_idx_q,
                                               dut.curr_real_notes-1);
            $display(" valid bits     = %b  (prev2 prev1 curr next1 next2)",
                        valid);

            // Get note start-address for this block
            start_addr = dut.R_CURR.inspect.start_addr;

            $display("");
            $display("DISPLAY WINDOW:");
            $display(" lvl0: %h %h %h %h %h",
                        lvl0_note_0, lvl0_note_1, lvl0_note_2,
                        lvl0_note_3, lvl0_note_4);
            $display(" lvl1: %h %h %h %h %h",
                        lvl1_note_0, lvl1_note_1, lvl1_note_2,
                        lvl1_note_3, lvl1_note_4);
            $display(" lvl2: %h %h %h %h %h",
                        lvl2_note_0, lvl2_note_1, lvl2_note_2,
                        lvl2_note_3, lvl2_note_4);

            $display("");

            // Print actual ROM contents for current block
            $display("CURRENT BLOCK SONG DATA:");
            for (i = 0; i < dut.curr_real_notes; i = i + 1) begin
                rom_addr = start_addr + i;
                #1;
                $display("  note_addr=%0d  note=%h", rom_addr, rom_out);
            end

            $display("----------------------------------------------------\n");
        end
    endtask

    //-------------------------------------------------------
    // Stimulus helpers
    //-------------------------------------------------------
    task pulse_advance;
        begin
            $display("\n[ NOTE ADVANCE ]");
            note_advance = 1; #10; note_advance = 0;
        end
    endtask

    task pulse_reverse;
        begin
            $display("\n[ NOTE REVERSE ]");
            note_reverse = 1; #10; note_reverse = 0;
        end
    endtask

    //-------------------------------------------------------
    // Test Sequence
    //-------------------------------------------------------
    initial begin

        $display("\n=== START SIM ===");

        rst = 1;
        song_sel = 0;
        note_advance = 0;
        note_reverse = 0;
        rom_addr = 0;

        #20;
        rst = 0;

        show_window();

        repeat (4) begin
            pulse_advance;
            show_window();
        end

        repeat (5) begin
            pulse_reverse;
            show_window();
        end
        
        song_sel = 2;
        
        $display("\nSong 2 Selected\n");
        
        show_window();

        repeat (4) begin
            pulse_advance;
            show_window();
        end

        repeat (5) begin
            pulse_reverse;
            show_window();
        end

        $display("=== END SIM ===");
        $finish;
    end

endmodule
