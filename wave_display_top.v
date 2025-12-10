module wave_display_top(
    input clk,
    input reset,
    input new_sample,
    input [15:0] sample,
    input [10:0] x,  // [0..1279]
    input [9:0] y,  // [0..1023]    
    input valid,
    input vsync,

    // new inputs for note_display
    input note_advance,
    input note_reverse,
    input [1:0] song_sel,

    output [7:0] r,
    output [7:0] g,
    output [7:0] b
);


    wire [7:0] read_sample, write_sample;
    wire [8:0] read_address, write_address;
    wire read_index;
    wire write_en;
    wire wave_display_idle = ~vsync;


    wave_capture wc(
        .clk(clk),
        .reset(reset),
        .new_sample_ready(new_sample),
        .new_sample_in(sample),
        .write_address(write_address),
        .write_enable(write_en),
        .write_sample(write_sample),
        .wave_display_idle(wave_display_idle),
        .read_index(read_index)
    );
   
    ram_1w2r #(.WIDTH(8), .DEPTH(9)) sample_ram(
        .clka(clk),
        .clkb(clk),
        .wea(write_en),
        .addra(write_address),
        .dina(write_sample),
        .douta(),
        .addrb(read_address),
        .doutb(read_sample)
    );
 
    wire wave_valid;
    wire [7:0] wd_r, wd_g, wd_b;
    wave_display wd(
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .valid(valid),
        .read_address(read_address),
        .read_value(read_sample),
        .read_index(read_index),
        .valid_pixel(wave_valid),
        .r(wd_r), .g(wd_g), .b(wd_b)
    );


    wire note_valid;
    wire [7:0] note_r, note_g, note_b;


   
    note_display nd(
        .clk(clk),
        .reset(reset),


        .vga_x(x),
        .vga_y(y),
        .vga_valid(valid),


        .note_advance(note_advance),
        .note_reverse(note_reverse),
        .song_sel(song_sel),


        .red(note_r),
        .green(note_g),
        .blue(note_b),


        .pixel_valid(note_valid)
    );






    wire [7:0] r_mix = (wave_valid ? wd_r : 8'd0) |
                       (note_valid ? note_r : 8'd0);


    wire [7:0] g_mix = (wave_valid ? wd_g : 8'd0) |
                       (note_valid ? note_g : 8'd0);


    wire [7:0] b_mix = (wave_valid ? wd_b : 8'd0) |
                       (note_valid ? note_b : 8'd0);




    assign {r, g, b} = {r_mix, g_mix, b_mix};


endmodule
