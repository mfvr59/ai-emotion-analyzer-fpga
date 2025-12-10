`timescale 1ns/1ps
module note_display_tb;

    reg clk;
    reg reset;

    reg [10:0] vga_x;
    reg [9:0] vga_y;
    reg vga_valid;

    reg note_advance;
    reg note_reverse;
    reg [1:0] song_sel;

    wire [7:0] red, green, blue;
    wire pixel_valid;

    note_display dut (
        .clk(clk),
        .reset(reset),

        .vga_x(vga_x),
        .vga_y(vga_y),
        .vga_valid(vga_valid),

        .note_advance(note_advance),
        .note_reverse(note_reverse),
        .song_sel(song_sel),

        .red(red),
        .green(green),
        .blue(blue),
        .pixel_valid(pixel_valid)
    );

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task pulse_next;
        begin
            note_advance = 1; #10; note_advance = 0;
        end
    endtask

    task pulse_prev;
        begin
            note_reverse = 1; #10; note_reverse = 0;
        end
    endtask


    // Probe one pixel and print its color
    task probe_pixel(input integer px, input integer py);
        begin
            vga_x = px;
            vga_y = py;
            #40;
            $display("PIX(%0d,%0d): R=%02h G=%02h B=%02h  valid=%0d",
                      px, py, red, green, blue, pixel_valid);
            print_top_block_reader_current_notes;
        end
    endtask
    
    task print_top_block_reader_current_notes;
        begin
            $display("Note shifter curr_n0=%h curr_n1=%h curr_n2=%h curr_n3=%h",
                     dut.u_shifter.curr_n0,
                     dut.u_shifter.curr_n1,
                     dut.u_shifter.curr_n2,
                     dut.u_shifter.curr_n3);
        end
    endtask
    

    integer x;
    integer y;
    initial begin
        $display("=== NOTE DISPLAY TESTBENCH START ===");
        reset = 1;
        vga_valid = 1;

        note_advance = 0;
        note_reverse = 0;
        song_sel = 2'b00;

        #20;
        reset = 0;
  
        // Sweep a few frames of VGA
        repeat (3) begin
            $display("\n=== VGA FRAME START ===");
            
            for (y = 290; y < 400; y = y + 10)
                for (x = 110; x < 400; x = x + 10) begin
                    probe_pixel(x, y);
                end

            $display("=== VGA FRAME END ===");
        end

       
        $display("\n=== TEST COMPLETE ===");
        $finish;
    end

endmodule
