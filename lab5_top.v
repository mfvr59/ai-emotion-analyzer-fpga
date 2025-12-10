module lab5_top(
    input sysclk,
    output  AC_ADR0,
    output  AC_ADR1,
    output  AC_DOUT,
    input   AC_DIN,
    input   AC_BCLK,
    input   AC_WCLK,
    output  AC_MCLK,
    output  AC_SCK,
    inout   AC_SDA,
    output wire [3:0] led,
    output wire [2:0] leds_rgb_0,
    output wire [2:0] leds_rgb_1,
    input  [3:0] btn, 
    input  [1:0] sw,
    output TMDS_Clk_p,
    output TMDS_Clk_n,
    output [2:0] TMDS_Data_p,
    output [2:0] TMDS_Data_n
);  
    wire reset, play_button, next_button;
    assign reset = btn[2];
    assign play_button = btn[1];
    assign next_button = btn[0];
    wire reverse_button_raw = btn[3];

    wire sw_ai_mode = sw[0];
    wire sw_fast_forward = sw[1];

    wire clk_100, display_clk, serial_clk;
    wire LED0;
 
    clk_wiz_0 U2 (
        .clk_out1(clk_100),
        .clk_out2(display_clk),
        .clk_out3(serial_clk),
        .reset(reset),
        .locked(LED0),
        .clk_in1(sysclk)
    );

    parameter BPU_WIDTH  = 20;
    parameter BEAT_COUNT = 1000;

    wire [11:0] x;
    wire [11:0] y;
    wire [31:0] pix_data;
    wire [3:0] r, g, b;
    wire [7:0] r_1, g_1, b_1;
    wire [3:0] VGA_R, VGA_G, VGA_B;
    wire VGA_HS, VGA_VS;

    wire play;
    button_press_unit #(.WIDTH(BPU_WIDTH)) play_button_press_unit(.clk(clk_100), .reset(reset), .in(play_button), .out(play));
    wire next;
    button_press_unit #(.WIDTH(BPU_WIDTH)) next_button_press_unit(.clk(clk_100), .reset(reset), .in(next_button), .out(next));
    wire reverse_pulse;
    button_press_unit #(.WIDTH(BPU_WIDTH)) reverse_button_press_unit(.clk(clk_100), .reset(reset), .in(reverse_button_raw), .out(reverse_pulse));

    wire new_frame;
    wire [15:0] codec_sample, flopped_sample;
    wire new_sample, flopped_new_sample;
    wire [1:0] display_song;
    wire display_playing;
    wire [1:0] emotion_out;
    wire [7:0] emotion_conf_out;
    wire emotion_valid;
    wire ai_buffer_full;
    wire note_advance;
    wire note_reverse;

    music_player #(.BEAT_COUNT(BEAT_COUNT)) music_player(
        .clk(clk_100),
        .b0(reverse_pulse),
        .reset(reset),
        .play_button(play),
        .next_button(next),
        .sw0(sw_ai_mode),
        .sw1(sw_fast_forward),
        .new_frame(new_frame), 
        .sample_out(codec_sample),
        .new_sample_generated(new_sample),
        .display_song(display_song),
        .display_playing(display_playing),
        .emotion_out(emotion_out),
        .emotion_conf_out(emotion_conf_out),
        .emotion_valid(emotion_valid),
        .ai_buffer_full(ai_buffer_full),
        .note_advance(note_advance),
        .note_reverse(note_reverse)
        
    );

    dff #(.WIDTH(17)) sample_reg (
        .clk(clk_100),
        .d({new_sample, codec_sample}),
        .q({flopped_new_sample, flopped_sample})
    );

    wire [23:0] hphone_r  = 0;
    wire [23:0] line_in_l = 0;  
    wire [23:0] line_in_r = 0; 

    assign led[0] = display_playing;
    assign led[1] = sw_ai_mode;
    assign led[2] = ai_buffer_full;
    assign led[3] = sw_fast_forward;

    reg [2:0] emotion_color;
    always @(*) begin
        if (!sw_ai_mode) begin
            emotion_color = 3'b000;  // AI OFF = LED OFF
        end else if (!ai_buffer_full) begin
            emotion_color = 3'b111;  // Waiting for notes = WHITE
        end else begin
            case (emotion_out)
                2'b01: emotion_color = 3'b010;  // happy = green
                2'b10: emotion_color = 3'b001;  // sad = blue
                2'b11: emotion_color = 3'b100;  // tense = red
                default: emotion_color = 3'b110; //neutral
            endcase
        end
    end
    assign leds_rgb_0 = emotion_color;
    
    adau1761_codec adau1761_codec(
        .clk_100(clk_100),
        .reset(reset),
        .AC_ADR0(AC_ADR0),
        .AC_ADR1(AC_ADR1),
        .I2S_MISO(AC_DOUT),
        .I2S_MOSI(AC_DIN),
        .I2S_bclk(AC_BCLK),
        .I2S_LR(AC_WCLK),
        .AC_MCLK(AC_MCLK),
        .AC_SCK(AC_SCK),
        .AC_SDA(AC_SDA),
        .hphone_l({codec_sample, 8'h00}),
        .hphone_r(hphone_r),
        .line_in_l(line_in_l),
        .line_in_r(line_in_r),
        .new_sample(new_frame)
    );  

    wire vde, hsync, vsync, blank;
    vga_controller_800x480_60 vga_control (
        .pixel_clk(display_clk),
        .rst(reset),
        .HS(hsync),
        .VS(vsync),
        .VDE(vde),
        .hcount(x),
        .vcount(y),
        .blank(blank)
    );
    
    wave_display_top wd_top (
		.clk (clk_100),
		.reset (reset),
		.new_sample (new_sample),
		.sample (flopped_sample),
        .x(x[10:0]),
        .y(y[9:0]),
        //.valid(valid),
		.valid(vde),
		.vsync(vsync),

        .song_sel(display_song),
        .note_advance(note_advance),
        .note_reverse(note_reverse),

		.r(r_1),
		.g(g_1),
		.b(b_1)
    );
    
    assign r = r_1[7:4];
    assign g = g_1[7:4];
    assign b = b_1[7:4];
    assign pix_data = {
        8'b0, 
        r[3], r[3], r[2], r[2], r[1], r[1], r[0], r[0],
        g[3], g[3], g[2], g[2], g[1], g[1], g[0], g[0],
        b[3], b[3], b[2], b[2], b[1], b[1], b[0], b[0]
    }; 
                  
    hdmi_tx_0 U3 (
        .pix_clk(display_clk),
        .pix_clkx5(serial_clk),
        .pix_clk_locked(LED0),
        .rst(reset),
        .pix_data(pix_data),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        .TMDS_CLK_P(TMDS_Clk_p),
        .TMDS_CLK_N(TMDS_Clk_n),
        .TMDS_DATA_P(TMDS_Data_p),
        .TMDS_DATA_N(TMDS_Data_n)
    );

endmodule