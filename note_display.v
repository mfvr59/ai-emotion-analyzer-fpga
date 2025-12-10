module note_display (
    input wire clk,
    input wire reset,

    // From VGA driver
    input wire [10:0] vga_x,
    input wire [9:0] vga_y,
    input wire vga_valid,

    // From audio player (controls note advance / reverse and song)
    input wire note_advance,   // pulse when next note should load
    input wire note_reverse,   // pulse when previous note should load
    input wire [1:0] song_sel,      // current song being played

    // Output to VGA
    output wire [7:0] red,
    output wire [7:0] green,
    output wire [7:0] blue,

    // High when this module is actively driving a visible pixel
    output wire pixel_valid
);

    //-------------------------------------------------------------
    // Register VGA inputs (pipeline stage on pixel-domain signals)
    //-------------------------------------------------------------
    wire [10:0] vga_x_r;
    wire [9:0] vga_y_r;
    wire vga_valid_r;

    dffr #(.WIDTH(11)) ff_vx (.clk(clk), .r(reset), .d(vga_x), .q(vga_x_r));
    dffr #(.WIDTH(10)) ff_vy (.clk(clk), .r(reset), .d(vga_y), .q(vga_y_r));
    dffr #(.WIDTH(1)) ff_vvalid (.clk(clk), .r(reset), .d(vga_valid), .q(vga_valid_r));


    //-------------------------------------------------------------
    // Instantiate note_shifter to get 5×3 = 15 note values
    //-------------------------------------------------------------
    wire [15:0] lvl0_note_0, lvl0_note_1, lvl0_note_2, lvl0_note_3, lvl0_note_4;
    wire [15:0] lvl1_note_0, lvl1_note_1, lvl1_note_2, lvl1_note_3, lvl1_note_4;
    wire [15:0] lvl2_note_0, lvl2_note_1, lvl2_note_2, lvl2_note_3, lvl2_note_4;
    wire [4:0]  col_valid;  // [4]=prev2, [3]=prev1, [2]=curr, [1]=next1, [0]=next2 (column-level)

    note_shifter u_shifter (
        .clk          (clk),
        .rst          (reset),
        .note_advance (note_advance),
        .note_reverse (note_reverse),
        .song_sel     (song_sel),

        .lvl0_note_0  (lvl0_note_0),
        .lvl0_note_1  (lvl0_note_1),
        .lvl0_note_2  (lvl0_note_2),
        .lvl0_note_3  (lvl0_note_3),
        .lvl0_note_4  (lvl0_note_4),

        .lvl1_note_0  (lvl1_note_0),
        .lvl1_note_1  (lvl1_note_1),
        .lvl1_note_2  (lvl1_note_2),
        .lvl1_note_3  (lvl1_note_3),
        .lvl1_note_4  (lvl1_note_4),

        .lvl2_note_0  (lvl2_note_0),
        .lvl2_note_1  (lvl2_note_1),
        .lvl2_note_2  (lvl2_note_2),
        .lvl2_note_3  (lvl2_note_3),
        .lvl2_note_4  (lvl2_note_4),

        .valid        (col_valid)
    );

    //-------------------------------------------------------------
    // Extracting 15 note_idx values [14:9] from 15 note positions
    // BLANK is 16'h0000; disable rendering when the note word is 0. 
    //-------------------------------------------------------------

    // Row 0 (top): prev2, prev1, curr, next1, next2
    wire [15:0] n_r0c0 = lvl0_note_0;
    wire [15:0] n_r0c1 = lvl0_note_1;
    wire [15:0] n_r0c2 = lvl0_note_2;
    wire [15:0] n_r0c3 = lvl0_note_3;
    wire [15:0] n_r0c4 = lvl0_note_4;

    // Row 1 (middle)
    wire [15:0] n_r1c0 = lvl1_note_0;
    wire [15:0] n_r1c1 = lvl1_note_1;
    wire [15:0] n_r1c2 = lvl1_note_2;
    wire [15:0] n_r1c3 = lvl1_note_3;
    wire [15:0] n_r1c4 = lvl1_note_4;

    // Row 2 (bottom)
    wire [15:0] n_r2c0 = lvl2_note_0;
    wire [15:0] n_r2c1 = lvl2_note_1;
    wire [15:0] n_r2c2 = lvl2_note_2;
    wire [15:0] n_r2c3 = lvl2_note_3;
    wire [15:0] n_r2c4 = lvl2_note_4;

    // Per-note "non-blank" enables
    wire en_r0c0 = (n_r0c0 != 16'h0000);
    wire en_r0c1 = (n_r0c1 != 16'h0000);
    wire en_r0c2 = (n_r0c2 != 16'h0000);
    wire en_r0c3 = (n_r0c3 != 16'h0000);
    wire en_r0c4 = (n_r0c4 != 16'h0000);

    wire en_r1c0 = (n_r1c0 != 16'h0000);
    wire en_r1c1 = (n_r1c1 != 16'h0000);
    wire en_r1c2 = (n_r1c2 != 16'h0000);
    wire en_r1c3 = (n_r1c3 != 16'h0000);
    wire en_r1c4 = (n_r1c4 != 16'h0000);

    wire en_r2c0 = (n_r2c0 != 16'h0000);
    wire en_r2c1 = (n_r2c1 != 16'h0000);
    wire en_r2c2 = (n_r2c2 != 16'h0000);
    wire en_r2c3 = (n_r2c3 != 16'h0000);
    wire en_r2c4 = (n_r2c4 != 16'h0000);

    // Note indices from bits [14:9]
    wire [5:0] idx_r0c0 = n_r0c0[14:9];
    wire [5:0] idx_r0c1 = n_r0c1[14:9];
    wire [5:0] idx_r0c2 = n_r0c2[14:9];
    wire [5:0] idx_r0c3 = n_r0c3[14:9];
    wire [5:0] idx_r0c4 = n_r0c4[14:9];

    wire [5:0] idx_r1c0 = n_r1c0[14:9];
    wire [5:0] idx_r1c1 = n_r1c1[14:9];
    wire [5:0] idx_r1c2 = n_r1c2[14:9];
    wire [5:0] idx_r1c3 = n_r1c3[14:9];
    wire [5:0] idx_r1c4 = n_r1c4[14:9];

    wire [5:0] idx_r2c0 = n_r2c0[14:9];
    wire [5:0] idx_r2c1 = n_r2c1[14:9];
    wire [5:0] idx_r2c2 = n_r2c2[14:9];
    wire [5:0] idx_r2c3 = n_r2c3[14:9];
    wire [5:0] idx_r2c4 = n_r2c4[14:9];

    //-------------------------------------------------------------
    // 15 x map_rom: note_idx -> left_char, right_char
    //-------------------------------------------------------------
    
    wire [8:0] chL_r0c0_d, chR_r0c0_d;
    wire [8:0] chL_r0c1_d, chR_r0c1_d;
    wire [8:0] chL_r0c2_d, chR_r0c2_d;
    wire [8:0] chL_r0c3_d, chR_r0c3_d;
    wire [8:0] chL_r0c4_d, chR_r0c4_d;

    wire [8:0] chL_r0c0, chR_r0c0;
    wire [8:0] chL_r0c1, chR_r0c1;
    wire [8:0] chL_r0c2, chR_r0c2;
    wire [8:0] chL_r0c3, chR_r0c3;
    wire [8:0] chL_r0c4, chR_r0c4;

    wire [8:0] chL_r1c0_d, chR_r1c0_d;
    wire [8:0] chL_r1c1_d, chR_r1c1_d;
    wire [8:0] chL_r1c2_d, chR_r1c2_d;
    wire [8:0] chL_r1c3_d, chR_r1c3_d;
    wire [8:0] chL_r1c4_d, chR_r1c4_d;

    wire [8:0] chL_r1c0, chR_r1c0;
    wire [8:0] chL_r1c1, chR_r1c1;
    wire [8:0] chL_r1c2, chR_r1c2;
    wire [8:0] chL_r1c3, chR_r1c3;
    wire [8:0] chL_r1c4, chR_r1c4;

    wire [8:0] chL_r2c0_d, chR_r2c0_d;
    wire [8:0] chL_r2c1_d, chR_r2c1_d;
    wire [8:0] chL_r2c2_d, chR_r2c2_d;
    wire [8:0] chL_r2c3_d, chR_r2c3_d;
    wire [8:0] chL_r2c4_d, chR_r2c4_d;

    wire [8:0] chL_r2c0, chR_r2c0;
    wire [8:0] chL_r2c1, chR_r2c1;
    wire [8:0] chL_r2c2, chR_r2c2;
    wire [8:0] chL_r2c3, chR_r2c3;
    wire [8:0] chL_r2c4, chR_r2c4;

    // Row 0
    map_rom mr_r0c0 (.note_idx(idx_r0c0), .left_char(chL_r0c0_d), .right_char(chR_r0c0_d));

    dffr #(.WIDTH(9)) ff_chL_r0c0 (.clk(clk), .r(reset), .d(chL_r0c0_d), .q(chL_r0c0));
    dffr #(.WIDTH(9)) ff_chR_r0c0 (.clk(clk), .r(reset), .d(chR_r0c0_d), .q(chR_r0c0));

    map_rom mr_r0c1 (.note_idx(idx_r0c1), .left_char(chL_r0c1_d), .right_char(chR_r0c1_d));

    dffr #(.WIDTH(9)) ff_chL_r0c1 (.clk(clk), .r(reset), .d(chL_r0c1_d), .q(chL_r0c1));
    dffr #(.WIDTH(9)) ff_chR_r0c1 (.clk(clk), .r(reset), .d(chR_r0c1_d), .q(chR_r0c1));

    map_rom mr_r0c2 (.note_idx(idx_r0c2), .left_char(chL_r0c2_d), .right_char(chR_r0c2_d));

    dffr #(.WIDTH(9)) ff_chL_r0c2 (.clk(clk), .r(reset), .d(chL_r0c2_d), .q(chL_r0c2));
    dffr #(.WIDTH(9)) ff_chR_r0c2 (.clk(clk), .r(reset), .d(chR_r0c2_d), .q(chR_r0c2));

    map_rom mr_r0c3 (.note_idx(idx_r0c3), .left_char(chL_r0c3_d), .right_char(chR_r0c3_d));

    dffr #(.WIDTH(9)) ff_chL_r0c3 (.clk(clk), .r(reset), .d(chL_r0c3_d), .q(chL_r0c3));
    dffr #(.WIDTH(9)) ff_chR_r0c3 (.clk(clk), .r(reset), .d(chR_r0c3_d), .q(chR_r0c3));

    map_rom mr_r0c4 (.note_idx(idx_r0c4), .left_char(chL_r0c4_d), .right_char(chR_r0c4_d));

    dffr #(.WIDTH(9)) ff_chL_r0c4 (.clk(clk), .r(reset), .d(chL_r0c4_d), .q(chL_r0c4));
    dffr #(.WIDTH(9)) ff_chR_r0c4 (.clk(clk), .r(reset), .d(chR_r0c4_d), .q(chR_r0c4));

    // Row 1
    map_rom mr_r1c0 (.note_idx(idx_r1c0), .left_char(chL_r1c0_d), .right_char(chR_r1c0_d));

    dffr #(.WIDTH(9)) ff_chL_r1c0 (.clk(clk), .r(reset), .d(chL_r1c0_d), .q(chL_r1c0));
    dffr #(.WIDTH(9)) ff_chR_r1c0 (.clk(clk), .r(reset), .d(chR_r1c0_d), .q(chR_r1c0));

    map_rom mr_r1c1 (.note_idx(idx_r1c1), .left_char(chL_r1c1_d), .right_char(chR_r1c1_d));

    dffr #(.WIDTH(9)) ff_chL_r1c1 (.clk(clk), .r(reset), .d(chL_r1c1_d), .q(chL_r1c1));
    dffr #(.WIDTH(9)) ff_chR_r1c1 (.clk(clk), .r(reset), .d(chR_r1c1_d), .q(chR_r1c1));

    map_rom mr_r1c2 (.note_idx(idx_r1c2), .left_char(chL_r1c2_d), .right_char(chR_r1c2_d));

    dffr #(.WIDTH(9)) ff_chL_r1c2 (.clk(clk), .r(reset), .d(chL_r1c2_d), .q(chL_r1c2));
    dffr #(.WIDTH(9)) ff_chR_r1c2 (.clk(clk), .r(reset), .d(chR_r1c2_d), .q(chR_r1c2));

    map_rom mr_r1c3 (.note_idx(idx_r1c3), .left_char(chL_r1c3_d), .right_char(chR_r1c3_d));

    dffr #(.WIDTH(9)) ff_chL_r1c3 (.clk(clk), .r(reset), .d(chL_r1c3_d), .q(chL_r1c3));
    dffr #(.WIDTH(9)) ff_chR_r1c3 (.clk(clk), .r(reset), .d(chR_r1c3_d), .q(chR_r1c3));

    map_rom mr_r1c4 (.note_idx(idx_r1c4), .left_char(chL_r1c4_d), .right_char(chR_r1c4_d));

    dffr #(.WIDTH(9)) ff_chL_r1c4 (.clk(clk), .r(reset), .d(chL_r1c4_d), .q(chL_r1c4));
    dffr #(.WIDTH(9)) ff_chR_r1c4 (.clk(clk), .r(reset), .d(chR_r1c4_d), .q(chR_r1c4));

    // Row 2
    map_rom mr_r2c0 (.note_idx(idx_r2c0), .left_char(chL_r2c0_d), .right_char(chR_r2c0_d));

    dffr #(.WIDTH(9)) ff_chL_r2c0 (.clk(clk), .r(reset), .d(chL_r2c0_d), .q(chL_r2c0));
    dffr #(.WIDTH(9)) ff_chR_r2c0 (.clk(clk), .r(reset), .d(chR_r2c0_d), .q(chR_r2c0));

    map_rom mr_r2c1 (.note_idx(idx_r2c1), .left_char(chL_r2c1_d), .right_char(chR_r2c1_d));

    dffr #(.WIDTH(9)) ff_chL_r2c1 (.clk(clk), .r(reset), .d(chL_r2c1_d), .q(chL_r2c1));
    dffr #(.WIDTH(9)) ff_chR_r2c1 (.clk(clk), .r(reset), .d(chR_r2c1_d), .q(chR_r2c1));

    map_rom mr_r2c2 (.note_idx(idx_r2c2), .left_char(chL_r2c2_d), .right_char(chR_r2c2_d));

    dffr #(.WIDTH(9)) ff_chL_r2c2 (.clk(clk), .r(reset), .d(chL_r2c2_d), .q(chL_r2c2));
    dffr #(.WIDTH(9)) ff_chR_r2c2 (.clk(clk), .r(reset), .d(chR_r2c2_d), .q(chR_r2c2));

    map_rom mr_r2c3 (.note_idx(idx_r2c3), .left_char(chL_r2c3_d), .right_char(chR_r2c3_d));

    dffr #(.WIDTH(9)) ff_chL_r2c3 (.clk(clk), .r(reset), .d(chL_r2c3_d), .q(chL_r2c3));
    dffr #(.WIDTH(9)) ff_chR_r2c3 (.clk(clk), .r(reset), .d(chR_r2c3_d), .q(chR_r2c3));

    map_rom mr_r2c4 (.note_idx(idx_r2c4), .left_char(chL_r2c4_d), .right_char(chR_r2c4_d));

    dffr #(.WIDTH(9)) ff_chL_r2c4 (.clk(clk), .r(reset), .d(chL_r2c4_d), .q(chL_r2c4));
    dffr #(.WIDTH(9)) ff_chR_r2c4 (.clk(clk), .r(reset), .d(chR_r2c4_d), .q(chR_r2c4));

    //-------------------------------------------------------------
    //    Placement constants (bottom half of visible region)
    //    Visible region: X = 88..888, Y = 32..512
    //    Note grid placement around X=120, Y=300
    //-------------------------------------------------------------
    localparam [10:0] BASE_X     = 11'd120; // left edge of prev2 column
    localparam [9:0]  BASE_Y     = 10'd300; // top of top row (bottom half of visible)
    localparam [10:0] COL_STEP   = 11'd64;  // distance between columns (2 chars @ 32px)
    localparam [9:0]  ROW_STEP   = 10'd32;  // distance between rows (char height @ scale=4)
    localparam [3:0]  SCALE_X    = 4'd4;    // char horizontal scale
    localparam [3:0]  SCALE_Y    = 4'd4;    // char vertical scale
    localparam [10:0] GLYPH_W    = 11'd32;  // one char width: 8 * scale_x = 32

    // Column base X positions
    localparam [10:0] COL0_X = BASE_X;
    localparam [10:0] COL1_X = BASE_X + COL_STEP;
    localparam [10:0] COL2_X = BASE_X + (COL_STEP << 1); // *2
    localparam [10:0] COL3_X = BASE_X + (COL_STEP + (COL_STEP << 1)); // *3
    localparam [10:0] COL4_X = BASE_X + (COL_STEP << 2); // *4

    // Row base Y positions
    localparam [9:0] ROW0_Y = BASE_Y;
    localparam [9:0] ROW1_Y = BASE_Y + ROW_STEP;
    localparam [9:0] ROW2_Y = BASE_Y + (ROW_STEP << 1); // *2

    //-------------------------------------------------------------
    // 30 char_renderer instances (2 per note position)
    //-------------------------------------------------------------

    // Wires for each char_renderer RGB
    // Naming: r_<row><col>L / r_<row><col>R 
    wire [7:0] r_r0c0L, g_r0c0L, b_r0c0L;
    wire [7:0] r_r0c0R, g_r0c0R, b_r0c0R;
    wire [7:0] r_r0c1L, g_r0c1L, b_r0c1L;
    wire [7:0] r_r0c1R, g_r0c1R, b_r0c1R;
    wire [7:0] r_r0c2L, g_r0c2L, b_r0c2L;
    wire [7:0] r_r0c2R, g_r0c2R, b_r0c2R;
    wire [7:0] r_r0c3L, g_r0c3L, b_r0c3L;
    wire [7:0] r_r0c3R, g_r0c3R, b_r0c3R;
    wire [7:0] r_r0c4L, g_r0c4L, b_r0c4L;
    wire [7:0] r_r0c4R, g_r0c4R, b_r0c4R;

    wire [7:0] r_r1c0L, g_r1c0L, b_r1c0L;
    wire [7:0] r_r1c0R, g_r1c0R, b_r1c0R;
    wire [7:0] r_r1c1L, g_r1c1L, b_r1c1L;
    wire [7:0] r_r1c1R, g_r1c1R, b_r1c1R;
    wire [7:0] r_r1c2L, g_r1c2L, b_r1c2L;
    wire [7:0] r_r1c2R, g_r1c2R, b_r1c2R;
    wire [7:0] r_r1c3L, g_r1c3L, b_r1c3L;
    wire [7:0] r_r1c3R, g_r1c3R, b_r1c3R;
    wire [7:0] r_r1c4L, g_r1c4L, b_r1c4L;
    wire [7:0] r_r1c4R, g_r1c4R, b_r1c4R;

    wire [7:0] r_r2c0L, g_r2c0L, b_r2c0L;
    wire [7:0] r_r2c0R, g_r2c0R, b_r2c0R;
    wire [7:0] r_r2c1L, g_r2c1L, b_r2c1L;
    wire [7:0] r_r2c1R, g_r2c1R, b_r2c1R;
    wire [7:0] r_r2c2L, g_r2c2L, b_r2c2L;
    wire [7:0] r_r2c2R, g_r2c2R, b_r2c2R;
    wire [7:0] r_r2c3L, g_r2c3L, b_r2c3L;
    wire [7:0] r_r2c3R, g_r2c3R, b_r2c3R;
    wire [7:0] r_r2c4L, g_r2c4L, b_r2c4L;
    wire [7:0] r_r2c4R, g_r2c4R, b_r2c4R;

    // ---------------- Row 0, Col 0 ----------------
    char_renderer cr_r0c0L (
        .clk            (clk),
        .enable         (en_r0c0),
        .char_addr_offset(chL_r0c0),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL0_X),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c0L),
        .g              (g_r0c0L),
        .b              (b_r0c0L)
    );

    char_renderer cr_r0c0R (
        .clk            (clk),
        .enable         (en_r0c0),
        .char_addr_offset(chR_r0c0),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL0_X + GLYPH_W),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c0R),
        .g              (g_r0c0R),
        .b              (b_r0c0R)
    );

    // ---------------- Row 0, Col 1 ----------------
    char_renderer cr_r0c1L (
        .clk            (clk),
        .enable         (en_r0c1),
        .char_addr_offset(chL_r0c1),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL1_X),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c1L),
        .g              (g_r0c1L),
        .b              (b_r0c1L)
    );

    char_renderer cr_r0c1R (
        .clk            (clk),
        .enable         (en_r0c1),
        .char_addr_offset(chR_r0c1),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL1_X + GLYPH_W),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c1R),
        .g              (g_r0c1R),
        .b              (b_r0c1R)
    );

    // ---------------- Row 0, Col 2 ----------------
    char_renderer cr_r0c2L (
        .clk            (clk),
        .enable         (en_r0c2),
        .char_addr_offset(chL_r0c2),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL2_X),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c2L),
        .g              (g_r0c2L),
        .b              (b_r0c2L)
    );

    char_renderer cr_r0c2R (
        .clk            (clk),
        .enable         (en_r0c2),
        .char_addr_offset(chR_r0c2),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL2_X + GLYPH_W),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c2R),
        .g              (g_r0c2R),
        .b              (b_r0c2R)
    );

    // ---------------- Row 0, Col 3 ----------------
    char_renderer cr_r0c3L (
        .clk            (clk),
        .enable         (en_r0c3),
        .char_addr_offset(chL_r0c3),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL3_X),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c3L),
        .g              (g_r0c3L),
        .b              (b_r0c3L)
    );

    char_renderer cr_r0c3R (
        .clk            (clk),
        .enable         (en_r0c3),
        .char_addr_offset(chR_r0c3),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL3_X + GLYPH_W),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c3R),
        .g              (g_r0c3R),
        .b              (b_r0c3R)
    );

    // ---------------- Row 0, Col 4 ----------------
    char_renderer cr_r0c4L (
        .clk            (clk),
        .enable         (en_r0c4),
        .char_addr_offset(chL_r0c4),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL4_X),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c4L),
        .g              (g_r0c4L),
        .b              (b_r0c4L)
    );

    char_renderer cr_r0c4R (
        .clk            (clk),
        .enable         (en_r0c4),
        .char_addr_offset(chR_r0c4),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL4_X + GLYPH_W),
        .top_left_y     (ROW0_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r0c4R),
        .g              (g_r0c4R),
        .b              (b_r0c4R)
    );

    // ---------------- Row 1, Col 0 ----------------
    char_renderer cr_r1c0L (
        .clk            (clk),
        .enable         (en_r1c0),
        .char_addr_offset(chL_r1c0),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL0_X),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c0L),
        .g              (g_r1c0L),
        .b              (b_r1c0L)
    );

    char_renderer cr_r1c0R (
        .clk            (clk),
        .enable         (en_r1c0),
        .char_addr_offset(chR_r1c0),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL0_X + GLYPH_W),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c0R),
        .g              (g_r1c0R),
        .b              (b_r1c0R)
    );

    // ---------------- Row 1, Col 1 ----------------
    char_renderer cr_r1c1L (
        .clk            (clk),
        .enable         (en_r1c1),
        .char_addr_offset(chL_r1c1),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL1_X),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c1L),
        .g              (g_r1c1L),
        .b              (b_r1c1L)
    );

    char_renderer cr_r1c1R (
        .clk            (clk),
        .enable         (en_r1c1),
        .char_addr_offset(chR_r1c1),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL1_X + GLYPH_W),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c1R),
        .g              (g_r1c1R),
        .b              (b_r1c1R)
    );

    // ---------------- Row 1, Col 2 ----------------
    char_renderer cr_r1c2L (
        .clk            (clk),
        .enable         (en_r1c2),
        .char_addr_offset(chL_r1c2),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL2_X),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c2L),
        .g              (g_r1c2L),
        .b              (b_r1c2L)
    );

    char_renderer cr_r1c2R (
        .clk            (clk),
        .enable         (en_r1c2),
        .char_addr_offset(chR_r1c2),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL2_X + GLYPH_W),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c2R),
        .g              (g_r1c2R),
        .b              (b_r1c2R)
    );

    // ---------------- Row 1, Col 3 ----------------
    char_renderer cr_r1c3L (
        .clk            (clk),
        .enable         (en_r1c3),
        .char_addr_offset(chL_r1c3),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL3_X),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c3L),
        .g              (g_r1c3L),
        .b              (b_r1c3L)
    );

    char_renderer cr_r1c3R (
        .clk            (clk),
        .enable         (en_r1c3),
        .char_addr_offset(chR_r1c3),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL3_X + GLYPH_W),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c3R),
        .g              (g_r1c3R),
        .b              (b_r1c3R)
    );

    // ---------------- Row 1, Col 4 ----------------
    char_renderer cr_r1c4L (
        .clk            (clk),
        .enable         (en_r1c4),
        .char_addr_offset(chL_r1c4),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL4_X),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c4L),
        .g              (g_r1c4L),
        .b              (b_r1c4L)
    );

    char_renderer cr_r1c4R (
        .clk            (clk),
        .enable         (en_r1c4),
        .char_addr_offset(chR_r1c4),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL4_X + GLYPH_W),
        .top_left_y     (ROW1_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r1c4R),
        .g              (g_r1c4R),
        .b              (b_r1c4R)
    );

    // ---------------- Row 2, Col 0 ----------------
    char_renderer cr_r2c0L (
        .clk            (clk),
        .enable         (en_r2c0),
        .char_addr_offset(chL_r2c0),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL0_X),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c0L),
        .g              (g_r2c0L),
        .b              (b_r2c0L)
    );

    char_renderer cr_r2c0R (
        .clk            (clk),
        .enable         (en_r2c0),
        .char_addr_offset(chR_r2c0),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL0_X + GLYPH_W),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c0R),
        .g              (g_r2c0R),
        .b              (b_r2c0R)
    );

    // ---------------- Row 2, Col 1 ----------------
    char_renderer cr_r2c1L (
        .clk            (clk),
        .enable         (en_r2c1),
        .char_addr_offset(chL_r2c1),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL1_X),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c1L),
        .g              (g_r2c1L),
        .b              (b_r2c1L)
    );

    char_renderer cr_r2c1R (
        .clk            (clk),
        .enable         (en_r2c1),
        .char_addr_offset(chR_r2c1),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL1_X + GLYPH_W),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c1R),
        .g              (g_r2c1R),
        .b              (b_r2c1R)
    );

    // ---------------- Row 2, Col 2 ----------------
    char_renderer cr_r2c2L (
        .clk            (clk),
        .enable         (en_r2c2),
        .char_addr_offset(chL_r2c2),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL2_X),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c2L),
        .g              (g_r2c2L),
        .b              (b_r2c2L)
    );

    char_renderer cr_r2c2R (
        .clk            (clk),
        .enable         (en_r2c2),
        .char_addr_offset(chR_r2c2),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL2_X + GLYPH_W),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c2R),
        .g              (g_r2c2R),
        .b              (b_r2c2R)
    );

    // ---------------- Row 2, Col 3 ----------------
    char_renderer cr_r2c3L (
        .clk            (clk),
        .enable         (en_r2c3),
        .char_addr_offset(chL_r2c3),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL3_X),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c3L),
        .g              (g_r2c3L),
        .b              (b_r2c3L)
    );

    char_renderer cr_r2c3R (
        .clk            (clk),
        .enable         (en_r2c3),
        .char_addr_offset(chR_r2c3),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL3_X + GLYPH_W),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c3R),
        .g              (g_r2c3R),
        .b              (b_r2c3R)
    );

    // ---------------- Row 2, Col 4 ----------------
    char_renderer cr_r2c4L (
        .clk            (clk),
        .enable         (en_r2c4),
        .char_addr_offset(chL_r2c4),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL4_X),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c4L),
        .g              (g_r2c4L),
        .b              (b_r2c4L)
    );

    char_renderer cr_r2c4R (
        .clk            (clk),
        .enable         (en_r2c4),
        .char_addr_offset(chR_r2c4),
        .vga_x          (vga_x_r),
        .vga_y          (vga_y_r),
        .vga_valid      (vga_valid_r),
        .top_left_x     (COL4_X + GLYPH_W),
        .top_left_y     (ROW2_Y),
        .scale_x        (SCALE_X),
        .scale_y        (SCALE_Y),
        .r              (r_r2c4R),
        .g              (g_r2c4R),
        .b              (b_r2c4R)
    );

    //-------------------------------------------------------------
    //   Combine all char_renderer outputs (OR, since they don't overlap)
    //-------------------------------------------------------------
    wire [7:0] r_all = r_r0c0L | r_r0c0R | r_r0c1L | r_r0c1R |
                       r_r0c2L | r_r0c2R | r_r0c3L | r_r0c3R |
                       r_r0c4L | r_r0c4R |
                       r_r1c0L | r_r1c0R | r_r1c1L | r_r1c1R |
                       r_r1c2L | r_r1c2R | r_r1c3L | r_r1c3R |
                       r_r1c4L | r_r1c4R |
                       r_r2c0L | r_r2c0R | r_r2c1L | r_r2c1R |
                       r_r2c2L | r_r2c2R | r_r2c3L | r_r2c3R |
                       r_r2c4L | r_r2c4R;

    wire [7:0] g_all = g_r0c0L | g_r0c0R | g_r0c1L | g_r0c1R |
                       g_r0c2L | g_r0c2R | g_r0c3L | g_r0c3R |
                       g_r0c4L | g_r0c4R |
                       g_r1c0L | g_r1c0R | g_r1c1L | g_r1c1R |
                       g_r1c2L | g_r1c2R | g_r1c3L | g_r1c3R |
                       g_r1c4L | g_r1c4R |
                       g_r2c0L | g_r2c0R | g_r2c1L | g_r2c1R |
                       g_r2c2L | g_r2c2R | g_r2c3L | g_r2c3R |
                       g_r2c4L | g_r2c4R;

    wire [7:0] b_all = b_r0c0L | b_r0c0R | b_r0c1L | b_r0c1R |
                       b_r0c2L | b_r0c2R | b_r0c3L | b_r0c3R |
                       b_r0c4L | b_r0c4R |
                       b_r1c0L | b_r1c0R | b_r1c1L | b_r1c1R |
                       b_r1c2L | b_r1c2R | b_r1c3L | b_r1c3R |
                       b_r1c4L | b_r1c4R |
                       b_r2c0L | b_r2c0R | b_r2c1L | b_r2c1R |
                       b_r2c2L | b_r2c2R | b_r2c3L | b_r2c3R |
                       b_r2c4L | b_r2c4R;

    // pixel_valid is high if any of the characters is lit
    wire pixel_valid_d = (|r_all) | (|g_all) | (|b_all);
    wire pixel_valid_q;

    dffr #(.WIDTH(1)) ff_pixvalid (.clk(clk), .r(reset),
        .d(pixel_valid_d), .q(pixel_valid_q)
    );

    assign pixel_valid = pixel_valid_q;


    // Final RGB selection
    wire [7:0] red_d   = pixel_valid ? r_all : 8'd0;
    wire [7:0] green_d = pixel_valid ? g_all : 8'd0;
    wire [7:0] blue_d  = pixel_valid ? b_all : 8'd0;

    dffr #(.WIDTH(8)) ff_red   (.clk(clk), .r(reset), .d(red_d),   .q(red));
    dffr #(.WIDTH(8)) ff_green (.clk(clk), .r(reset), .d(green_d), .q(green));
    dffr #(.WIDTH(8)) ff_blue  (.clk(clk), .r(reset), .d(blue_d),  .q(blue));


endmodule
